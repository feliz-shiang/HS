//
//  GYDBCenter.m
//  IMXMPPPro
//
//  Created by liangzm on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#define kImDirPrefix @"in" //im目录前缀，
#define kImDBName   @"data.db"   //im数据库文件

#define kDefaultTableName_tb_list_person @"tb_list_person"
#define kDefaultTableName_tb_list_shops  @"tb_list_shops"
#define kDefaultTableName_tb_list_goods  @"tb_list_goods"
#define kDefaultTableName_tb_msg         @"tb_msg"

// add by songjk
#define kDefaultTableName_tb_remark       @"tb_remark"

#import "GYDBCenter.h"
#import "GYChatItem.h"

@interface GYDBCenter()
{
}
@end

@implementation GYDBCenter

/////+ methods//////
+ (FMDatabase *)getDBFromDBFullName:(NSString *)fullName
{
    if (![self fileIsExists:fullName]) return nil;
    FMDatabase *db = [[FMDatabase alloc] initWithPath:fullName];
    if (![db open])
    {
        NSLog(@"数据库打开失败");
        return nil;
    };
    return db;
}

+ (BOOL)fileIsExists:(NSString *)fileFullName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileFullName];
}

+ (BOOL)createFile:(NSString *)fileFullName;
{
    NSString *directoriesPath = [self getDirectoriesPathFromFileFullName:fileFullName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![self fileIsExists:directoriesPath])//判断目录是否存在 没有就创建
    {
        if (![fileManager createDirectoryAtPath:directoriesPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error])
        {
            DDLogInfo(@"创建目录出错:%@ directoriesPath:%@", error, directoriesPath);
            return NO;

        }else
        {
            DDLogInfo(@"创建目录成功：%@", directoriesPath);
        }
    }
    
    //创建文件
    if (![fileManager createFileAtPath:fileFullName contents:nil attributes:nil])
    {
        DDLogInfo(@"创建数据库出错:%@", fileFullName);
        return NO;
    }else
    {
        DDLogInfo(@"创建数据库成功：%@", fileFullName);
    }
    return YES;
}

//从文件路径取得文件的目录
+ (NSString *)getDirectoriesPathFromFileFullName:(NSString *)fileFullName
{
    NSString *fileName = [fileFullName lastPathComponent];//文件名
    NSRange range = [fileFullName rangeOfString:fileName options:NSBackwardsSearch];
    NSString *directoriesPath = [fileFullName substringToIndex:range.location];
    return directoriesPath;
}

+ (NSString *)getUserDBNameInDirectory:(NSString *)userName
{
    //在cache目录下创建
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString *dbName = [NSString stringWithFormat:@"%@_%@",version, kImDBName];
    NSString *dbName = kImDBName;
    NSString *dbFullName = [NSString pathWithComponents:@[kAppCachesDirectoryPath, [kImDirPrefix stringByAppendingString:userName], dbName]];
//    DDLogInfo(@"get dbFullName:%@ for user:%@", dbFullName, userName);
    return dbFullName;
}

+ (BOOL)setDefaultTablesForImDB:(FMDatabase *)db
{
    NSString *tb_list_person_sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('user_jid' VARCHAR(50) PRIMARY KEY NOT NULL,'msg_type' VARCHAR(10),'msg_code' VARCHAR(10),'sub_msg_code' VARCHAR(10),'displayname' VARCHAR(50),'msg_icon' TEXT,'last_msg' TEXT,'datetimeSend' DATETIME, 'unread_msg_cnt' INTEGER DEFAULT 1)",
                                    kDefaultTableName_tb_list_person];
    
    NSString *tb_list_shops_sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('user_jid' VARCHAR(50) PRIMARY KEY NOT NULL,'msg_type' VARCHAR(10),'msg_code' VARCHAR(10),'sub_msg_code' VARCHAR(10), 'displayname' VARCHAR(50), 'fromUserId' VARCHAR(50),'msg_icon' TEXT,'last_msg' TEXT,'shop_id' TEXT,'datetimeSend' DATETIME,'unread_msg_cnt' INTEGER DEFAULT 1)",
                                                             kDefaultTableName_tb_list_shops];
    NSString *tb_list_goods_sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('user_jid' VARCHAR(50) PRIMARY KEY NOT NULL,'msg_type' VARCHAR(10),'res_no' VARCHAR(50),'msg_code' VARCHAR(10),'item_name' VARCHAR(50),'sel_info' TEXT,'vshop_name' VARCHAR(50),'msg_icon' TEXT,'last_msg' TEXT,'datetimeSend' DATETIME,'unread_msg_cnt' INTEGER DEFAULT 1)",
                                                              kDefaultTableName_tb_list_goods];
    // add by songj
    NSString *tb_list_remark_sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('friend_id' VARCHAR(50) PRIMARY KEY NOT NULL,'my_id' VARCHAR(50),'msg_type' VARCHAR(10),'res_no' VARCHAR(50),'friend_remark' VARCHAR(100))",
                                   kDefaultTableName_tb_remark];
    
    
    NSString *tb_msg_sql = [GYChatItem createMsgTableSqlString:kDefaultTableName_tb_msg];
    
    NSArray *arrSql = @[tb_list_person_sql, tb_list_shops_sql, tb_list_goods_sql, tb_list_remark_sql,tb_msg_sql];
    
    //执行事务
    [db open];
    [db beginTransaction];
    BOOL isRollBack = NO;
    for (int i = 0; i < arrSql.count; i++)
    {
        NSString *sql = arrSql[i];
//        DDLogInfo(@"执行SQL:%@", sql);
        BOOL r = [db executeUpdate:sql];
        if (!r)
        {
            isRollBack = YES;
            break;
        }
    }
    if (!isRollBack)
    {
        return [db commit];
    }else
    {
        [db rollback];
        return NO;
    }
}

+ (NSString *)getDefaultTableNameForMessageRecord
{
    return kDefaultTableName_tb_msg;
}

+ (NSString *)getTableNameFroMsgType:(NSInteger)msgType
{
    NSString *str;
    switch (msgType) {
        case 1:
        {
            str = kDefaultTableName_tb_list_person;
        }
            break;
        case 2:
        {
            str = kDefaultTableName_tb_list_shops;
        }
            break;
        case 3:
        {
            str = kDefaultTableName_tb_list_goods;
        }
            break;
        case 4:
        {
            str = kDefaultTableName_tb_remark;
        }
        default:
            break;
            break;
    }
    return str;
}

+ (BOOL)deleteUserAllMessageWithUserAccount:(NSString *)user
{
    NSString *userId = user;
    if (![userId hasPrefix:@"m_"])
    {
        userId = [@"m_" stringByAppendingString:userId];
    }
    userId = [NSString stringWithFormat:@"%@@%@", userId, [GlobalData shareInstance].hdDomain];
    NSString *delSql1 = [NSString stringWithFormat:@"delete from tb_msg where fromUserId='%@' or toUserId='%@'", userId, userId];
    NSString *delSql2 = [NSString stringWithFormat:@"delete from tb_list_person where user_jid='%@'", userId];
    DDLogInfo(@"清除用户数据tb_msg：%@", delSql1);
    DDLogInfo(@"清除用户数据tb_list_person：%@", delSql2);
    return [[GYXMPP sharedInstance].imFMDB executeUpdate:delSql1] && [[GYXMPP sharedInstance].imFMDB executeUpdate:delSql2];
}

@end

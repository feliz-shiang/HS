//
//  GYUserInfoTool.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYUserInfoTool.h"
#define KuserInfoTable @"tb_login_user"

@interface GYUserInfoTool()
@property (nonatomic,strong)FMDatabase * db;

@end

@implementation GYUserInfoTool
+(instancetype)shareInstance
{
    static GYUserInfoTool * tool =nil;
    static dispatch_once_t DDASLLoggerOnceToken;
    dispatch_once(&DDASLLoggerOnceToken, ^{
        tool = [[GYUserInfoTool alloc] init];
    });
    return tool;
}
-(FMDatabase *)db
{
    if (_db == nil) {
        NSString * strDb = @"userinfo.db";
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:strDb];
        NSLog(@"path = %@",path);
        _db = [[FMDatabase alloc] initWithPath:path];
    }
    return _db;
}
// 保存登录用户信息
-(void)setUserLoginInfoWithdictData:(NSDictionary *)dictData
{
    if (![self.db open])
    {
        NSLog(@"打开数据库失败");
        return;
    };
    NSString *tb_login_user_sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('userid' text PRIMARY KEY NOT NULL,'username' text,'headpic' text,'usertype' text,'logintime' DATETIME)",
                                  KuserInfoTable ];
    [self.db executeUpdate:tb_login_user_sql];
    NSDictionary *dicInsert;
    
    dicInsert = @{@"userid": [dictData objectForKey:@"userid"],
                  @"username": [dictData objectForKey:@"username"],
                  @"headpic": [dictData objectForKey:@"headpic"],
                  @"usertype": [dictData objectForKey:@"usertype"],
                  @"logintime":[dictData objectForKey:@"logintime"]
                  };
    
    NSString * tableName = KuserInfoTable;
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
    
    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    
    if ([self.db executeUpdate:sql3])
    {
        DDLogInfo(@"设置登录信息成功。");
        
    }else
    {
        NSString * strHeadPic = [dictData objectForKey:@"headpic"];
        if (!strHeadPic || ![strHeadPic hasPrefix:@"http"]) {
            [self.db close];
            return;
        }
        NSString *upSetSql = [NSString stringWithFormat:@"update %@ set headpic='%@' , usertype = '%@' , username = '%@' , logintime = '%@' where userid ='%@' ",tableName,[dictData objectForKey:@"headpic"],[dictData objectForKey:@"usertype"],[dictData objectForKey:@"username"],[dictData objectForKey:@"logintime"],[dictData objectForKey:@"userid"]];
        DDLogInfo(@"updateSql:%@", upSetSql);
        
        if ([self.db executeUpdate:upSetSql])
        {
            DDLogInfo(@"修改登录信息成功。");
            
        }else{
            DDLogInfo(@"修改登录信息失败。");
        }
    }
    [self.db close];
}

-(void)updataUserHeadPic:(NSString *)headPic userID:(NSString *)userID
{
    if(!headPic || ![headPic hasPrefix:@"http"])
    {
        return;
    }
    if (![self.db open]) {
        NSLog(@"打开数据库失败");
        return;
    };
    NSString *upSetSql = [NSString stringWithFormat:@"update %@ set headpic='%@' where userid ='%@' ",KuserInfoTable,headPic,userID];
    DDLogInfo(@"updateSql:%@", upSetSql);
    
    if ([self.db executeUpdate:upSetSql])
    {
        DDLogInfo(@"修改登录信息头像成功。");
    }
    [self.db close];
}

-(NSArray *)getUserLoginIfnoWithType:(NSString *)type
{
    NSMutableArray *marrData = [NSMutableArray array];
    if (![self.db open]) {
        NSLog(@"打开数据库失败");
        return marrData;
    };
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where usertype = '%@' order by logintime desc",KuserInfoTable,type];
    FMResultSet * set = [self.db executeQuery:sql];
    while ([set next])
    {
        NSString * strName  = [set stringForColumn:@"username"];
        NSString * strID = [set stringForColumn:@"userid"];
        NSString * strHeadPic = [set stringForColumn:@"headpic"];
        NSDate * loginDate = [set dateForColumn:@"logintime"];
        //        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:strName,@"username",strID,@"userid",strHeadPic,@"headpic" ,loginDate,@"logintime",nil] ;
        [marrData addObject:dict];
    }
    [self.db close];
    return marrData;
}
@end

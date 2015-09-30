//
//  GYDBEPSimple.m
//  HSConsumer
//
//  Created by 00 on 14-12-8.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYDBEPSimple.h"
// 非线程安全
#import "FMDatabase.h"
// 线程安全
#import "FMDatabaseQueue.h"

@implementation GYDBEPSimple

{
    FMDatabase * _dataBase;
    
    FMDatabaseQueue * _dbQueue;
}

// 静态数据区 只有程序退出时 才会被系统回收

 +(GYDBEPSimple *)shareInstance
 {
 static GYDBEPSimple * simple = nil;
 if (simple == nil) {
 simple = [[GYDBEPSimple alloc] init];
 //        simple = [DataBaseSimple alloc] initWithTableName:<#(NSString *)#>
 }
 return simple;
 }
 

/*
 id 既可以当参数 又能当返回值
 instancetype 只能当返回值  动态匹配对象的数据类型
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HSEP.db"];
        NSLog(@"DB path is %@",dbPath);
#if 0
        _dataBase = [FMDatabase databaseWithPath:dbPath];
        if (![_dataBase open]) {
            NSLog(@"open db error!");
        }
        if (![_dataBase executeUpdate:@"create table if not exists HSEP (ID integer primary key autoincrement,Name text,Price text,Nick text,Image text)"]) {
            NSLog(@"create table error!");
        }
#endif
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        // inDatabase方法中已经打开了数据库 形参传递至block中
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:@"create table if not exists HSEP (ID integer primary key autoincrement,Name text,Price text,Nick text,Image text)"]) {
                NSLog(@"create table error!");
            }
        }];
    }
    return self;
}
/*
 -(void)insertIntoDB:(Model *)model
 {
 #if 0
 if (![_dataBase executeUpdate:@"insert into HSEP (ID,Name,Price,Nick,Image) values (?,?,?,?,?)",model.ID,model.name,model.price,model.nick,model.img]) {
 NSLog(@"insert db error");
 }
 #endif
 [_dbQueue inDatabase:^(FMDatabase *db) {
 if (![db executeUpdate:@"insert into HSEP (ID,Name,Price,Nick,Image) values (?,?,?,?,?)",model.ID,model.name,model.price,model.nick,model.img]) {
 NSLog(@"insert db error");
 }
 }];
 }
 
 
 */
-(void)deleteDBWithKey:(NSString *)key
{
#if 0
    if (![_dataBase executeUpdate:@"delete from HSEP where ID=?",[NSNumber numberWithInt:key.intValue]]) {
        NSLog(@"delete %@ error",key);
    }
#endif
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:@"delete from HSEP where ID=?",[NSNumber numberWithInt:key.intValue]]) {
            NSLog(@"delete %@ error",key);
        }
    }];
}

/*
 
 -(void)updateDBWithKey:(NSString *)key modify:(Model *)model
 {
 #if 0
 if (![_dataBase executeUpdate:@"update HSEP set ID=?,Name=?,Price=?,Nick=?,Image=? where ID=?",[NSNumber numberWithInt:model.ID.intValue],model.name,model.price,model.nick,model.img,[NSNumber numberWithInt:key.intValue]]) {
 NSLog(@"update db error");
 }
 #endif
 [_dbQueue inDatabase:^(FMDatabase *db) {
 if (![db executeUpdate:@"update HSEP set ID=?,Name=?,Price=?,Nick=?,Image=? where ID=?",[NSNumber numberWithInt:model.ID.intValue],model.name,model.price,model.nick,model.img,[NSNumber numberWithInt:key.intValue]]) {
 NSLog(@"update db error");
 }
 }];
 }
 -(Model *)selectWithKey:(NSString *)key
 {
 #if 0
 FMResultSet * set = [_dataBase executeQuery:@"select * from HSEP where ID=?",[NSNumber numberWithInt:key.intValue]];
 Model * m = [[Model alloc] init];
 while ([set next]) {
 m.ID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ID"]];
 m.name = [set stringForColumn:@"Name"];
 m.nick = [set stringForColumn:@"Nick"];
 m.price = [set stringForColumn:@"Price"];
 m.img = [set stringForColumn:@"Image"];
 }
 return m;
 #endif
 // 需要在block中访问对象的属性 在对象前加关键字 __block
 __block Model * m = [[Model alloc] init];
 [_dbQueue inDatabase:^(FMDatabase *db) {
 FMResultSet * set = [db executeQuery:@"select * from HSEP where ID=?",[NSNumber numberWithInt:key.intValue]];
 while ([set next]) {
 m.ID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ID"]];
 m.name = [set stringForColumn:@"Name"];
 m.nick = [set stringForColumn:@"Nick"];
 m.price = [set stringForColumn:@"Price"];
 m.img = [set stringForColumn:@"Image"];
 }
 }];
 return m;
 }
 
 
 */
-(NSMutableArray *)selectFromDB
{
#if 0
    FMResultSet * set = [_dataBase executeQuery:@"select * from HSEP"];
    NSMutableArray * arr = [NSMutableArray array];
    while ([set next]) {
        Model * m = [[Model alloc] init];
        m.ID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ID"]];
        m.name = [set stringForColumn:@"Name"];
        m.nick = [set stringForColumn:@"Nick"];
        m.price = [set stringForColumn:@"Price"];
        m.img = [set stringForColumn:@"Image"];
        [arr addObject:m];
    }
    return arr;
#endif
    

    __block NSMutableArray * arr = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:@"select * from HSEP"];
        while ([set next]) {
//            Model * m = [[Model alloc] init];
//            m.ID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ID"]];
//            m.name = [set stringForColumn:@"Name"];
//            m.nick = [set stringForColumn:@"Nick"];
//            m.price = [set stringForColumn:@"Price"];
//            m.img = [set stringForColumn:@"Image"];
//            [arr addObject:m];
        }
    }];
    return arr;
}

-(void)cleanDB
{
#if 0
    if (![_dataBase executeUpdate:@"delete from HSEP"]) {
        NSLog(@"cleanDB error!");
    }
#endif
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:@"delete from HSEP"]) {
            NSLog(@"cleanDB error!");
        }
    }];
    
}

// 事务 数据库操作 要么同时成功 要么同时失败
- (void)inTransaction
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL ret = YES;
        ret &= [db executeUpdate:@"update Account set Money=Money-100 where Name=A"];
        ret &= [db executeUpdate:@"update Account set Money=Money+100 where Name=B"];
        if (ret) {
            // 同时成功
        }else{
            // 回滚 账户回到没有执行SQL前的状态
            *rollback = YES;
        }
    }];
    
    [_dataBase beginTransaction];
    BOOL ret = YES;
    ret &= [_dataBase executeUpdate:@"update Account set Money=Money-100 where Name=A"];
    ret &= [_dataBase executeUpdate:@"update Account set Money=Money+100 where Name=B"];
    if (ret) {
        // 执行SQL
        [_dataBase commit];
    }else{
        // 回滚
        [_dataBase rollback];
    }
}

@end

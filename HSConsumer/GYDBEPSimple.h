//
//  GYDBEPSimple.h
//  HSConsumer
//
//  Created by 00 on 14-12-8.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDBEPSimple : NSObject


+(GYDBEPSimple *)shareInstance;

//-(void)insertIntoDB:(Model *)model;
-(void)deleteDBWithKey:(NSString *)key;
//-(void)updateDBWithKey:(NSString *)key modify:(Model *)model;
//-(Model *)selectWithKey:(NSString *)key;
-(NSMutableArray *)selectFromDB;
-(void)cleanDB;


@end

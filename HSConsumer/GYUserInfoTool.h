//
//  GYUserInfoTool.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYUserInfoTool : NSObject
+(instancetype)shareInstance;
// 保存登录用户信息
-(void)setUserLoginInfoWithdictData:(NSDictionary *)dictData;
// 获取登录用户信息
-(NSArray *)getUserLoginIfnoWithType:(NSString *)type;
// 更新用户头像
-(void)updataUserHeadPic:(NSString *)headPic userID:(NSString *)userID;
@end

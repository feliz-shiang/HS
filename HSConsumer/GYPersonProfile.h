//
//  GYPersonProfile.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYPersonProfile : NSObject
@property (nonatomic,copy)NSString * strIconUrl;//用户图片URL
@property (nonatomic,copy)NSString * strMessage;
@property (nonatomic,copy)NSString * strIdstring;
@property (nonatomic,copy)NSString * strNickname;//用户昵称
@property (nonatomic,copy)NSString * strName;//用户名称
@property (nonatomic,copy)NSString * strHomeAddress;//原籍地址
@property (nonatomic,copy)NSString * strPresentAddress;//当前地址
@property (nonatomic,copy)NSString * strEmail;//邮箱
@property (nonatomic,copy)NSString * strTelNo;//固定电话
@property (nonatomic,copy)NSString * strMobileNo;//手机号码
@property (nonatomic,copy)NSString * strProfession;//职业。
@end

//
//  LoginEn.h
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

// add by songjk 登录密码key
#define kUserPasswordKey @"UserPasswordKey"
#define kUserNameKey @"userNameKey"
typedef NS_ENUM(NSInteger, EMLoginEn) {
    kLoginEn_dev_with_default_user_pwd = 0,
    kLoginEn_test_with_default_user_pwd,
    kLoginEn_demo_with_default_user_pwd,
    kLoginEn_dev_no_default_user_pwd,
    kLoginEn_test_no_default_user_pwd,
    kLoginEn_demo_no_default_user_pwd,
    kLoginEn_pre_release,
    kLoginEn_is_release
};

#import <Foundation/Foundation.h>

@interface LoginEn : NSObject

@property (nonatomic, assign) EMLoginEn loginLine;
+ (LoginEn *)sharedInstance;
- (NSString *)getLoginUrl;
- (NSString *)getDefaultEcDm;
- (NSString *)getDefaultHsDm;
- (NSString *)getDefaultUpdateDm;
- (NSArray *)getDefaultUserPwdIsCardUser:(BOOL)iscardUser;

+ (EMLoginEn)getInitLoginLine;
+ (BOOL)isReleaseEn;//是否为生产发布环境 否：NO 是：YES
+ (NSInteger)isReleaseTo;//1:发布到appstore 2:企业级发布  主要用于更新检测；
+ (EMLoginEn)needToHideSettingLine;//一般用于演示环境

@end

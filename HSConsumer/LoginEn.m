//
//  LoginEn.m
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "LoginEn.h"

@implementation LoginEn

+ (LoginEn *)sharedInstance
{
    static LoginEn *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[self alloc] init];
    });
    return _s;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.loginLine = [[self class] getInitLoginLine];
    }
    return self;
}

- (void) setLoginLine:(EMLoginEn)l
{
    _loginLine = l;
    [GlobalData shareInstance].ecDomain = [self getDefaultEcDm];
}

- (NSString *)getLoginUrl
{
    switch (self.loginLine)
    {
        case kLoginEn_dev_with_default_user_pwd:
        case kLoginEn_dev_no_default_user_pwd:
            return @"http://192.168.229.80:9999/login-service";
            
            break;
        case kLoginEn_test_with_default_user_pwd:
        case kLoginEn_test_no_default_user_pwd:
            return @"http://192.168.228.83:8080/login-service";
            
            break;
        case kLoginEn_demo_no_default_user_pwd:
        case kLoginEn_demo_with_default_user_pwd:
            return @"http://u.aahv.net:8880/webclientservice";
            
            break;
            
        case kLoginEn_pre_release:
        case kLoginEn_is_release://发布环境 登录url
            return @"http://u.hsxt.cn:9002/login-service";
            break;

        default:
            break;
    }
    return @"http://192.168.229.80:9999";
}

- (NSString *)getDefaultEcDm//默认电商的url
{
    switch (self.loginLine)
    {
        case kLoginEn_dev_with_default_user_pwd:
        case kLoginEn_dev_no_default_user_pwd:
            return @"http://192.168.229.72:8080/phapi";
            
            break;
        case kLoginEn_test_with_default_user_pwd:
        case kLoginEn_test_no_default_user_pwd:
            return @"http://192.168.228.86:8080/phapi";
            
            break;
        case kLoginEn_demo_no_default_user_pwd:
        case kLoginEn_demo_with_default_user_pwd:
            return @"http://phapi.aahv.net:8887/phapi";
            
            break;
            
        case kLoginEn_pre_release:
        case kLoginEn_is_release://发布环境 电商url
            return @"http://phapi.hsxt.mobi:8885/phapi";
            break;

        default:
            break;
    }
    return @"/";
}

- (NSString *)getDefaultHsDm//没登录默认互生的url
{
    switch (self.loginLine)
    {
        case kLoginEn_dev_with_default_user_pwd:
        case kLoginEn_dev_no_default_user_pwd:
            return @"http://192.168.229.21:9092";
            
            break;
        case kLoginEn_test_with_default_user_pwd:
        case kLoginEn_test_no_default_user_pwd:
            return @"http://192.168.228.202:9092";
            
            break;
        case kLoginEn_demo_no_default_user_pwd:
        case kLoginEn_demo_with_default_user_pwd:
            return @"http://hbs.aadv.net:8885";
            break;
            
        case kLoginEn_pre_release:
        case kLoginEn_is_release:
            return @"http://hbs.hsxt.net:9092";

            break;
        default:
            break;
    }
    return @"/";
}

- (NSString *)getDefaultUpdateDm//检测更新
{
    switch (self.loginLine)
    {
        case kLoginEn_pre_release:
        case kLoginEn_is_release:
            return @"http://hdhiz.hsxt.mobi:8884/upgrade/app/checkUpgrade";
            break;
            
        default:
            return @"http://192.168.229.39:17002/upgrade/app/checkUpgrade";
            break;
    }
    return @"/";
}

- (NSArray *)getDefaultUserPwdIsCardUser:(BOOL)iscardUser
{
    NSString * strUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    if (!strUserName || strUserName.length == 0) {
        strUserName = @"";
    }
    switch (self.loginLine)
    {
        case kLoginEn_dev_with_default_user_pwd:
            if (iscardUser)
            {
//              return @[@"06186010001", @"111111"];
//              return @[@"06186010054", @"111111"];
                return @[@"06186010055", @"333222"];
//                return @[@"06186010068", @"222222"];
//              return @[@"06186010039", @"073379"];
//              return @[@"06186010087", @"111111"];
//              return @[@"06186010063", @"111111"];
//              return @[@"06186010031", @"111111"];
            }
            else
                return @[@"13631592868", @"222222"];
//            return @[@"18929305133", @"999999"];
            
            break;
        case kLoginEn_test_with_default_user_pwd:
            if (iscardUser)
            {
//                return @[@"06119110008", @"111111"];
               return @[@"06119110999", @"019766"];
            }
            else
                return @[strUserName, @""];
            
            break;
        case kLoginEn_demo_with_default_user_pwd:
            if (iscardUser)
                return @[strUserName, @""];
            else
                return @[@"15999594917", @"123456"];
            
            break;
            
        case kLoginEn_pre_release:
            if (iscardUser)
                return @[@"05001120006", @"111111"];
            else
                return @[strUserName, @""];
            
            break;
            
        case kLoginEn_dev_no_default_user_pwd:
        case kLoginEn_test_no_default_user_pwd:
        case kLoginEn_demo_no_default_user_pwd:
        case kLoginEn_is_release:
            return @[strUserName, @""];
            
            break;
        default:
            break;
    }
    return @[strUserName, @""];
}

+ (EMLoginEn)getInitLoginLine
{
    if (![self isReleaseEn])
    {
//        return kLoginEn_test_no_default_user_pwd;
        return kLoginEn_test_with_default_user_pwd;
//        return kLoginEn_dev_with_default_user_pwd;
//        return kLoginEn_dev_no_default_user_pwd;
//        return kLoginEn_demo_no_default_user_pwd;
//        return kLoginEn_demo_with_default_user_pwd;
    }else
    {
        return kLoginEn_is_release;
    }
}

#pragma mark - 设置发布时参数

//是否为生产发布环境 否：NO 是：YES
+ (BOOL)isReleaseEn
{
    return NO;
}

//1:发布到appstore 2:企业级发布  主要用于更新检测；
+ (NSInteger)isReleaseTo
{
    return 2;
}

//设置哪些环境下要隐藏环境切换页面
+ (EMLoginEn)needToHideSettingLine
{
    return kLoginEn_demo_no_default_user_pwd;
}

@end

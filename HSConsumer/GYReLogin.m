//
//  GYReLogin.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYReLogin.h"
#import "LoginEn.h"
#import "GYHDRemindLoginView.h"
#import "GYAppDelegate.h" 

static UIView * vBack;
@implementation GYReLogin
// add by song
#pragma makr 重新登录
// 登录
+(void)loginToSever
{
    GYAppDelegate * app  = (GYAppDelegate *)[UIApplication sharedApplication].delegate;
    vBack = app.window;
    NSLog(@"后台自动监测登录");
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPasswordKey];
    if (!userName || userName.length==0) {
        [self showLoginPage];
        return;
    }
    if (!pwd || pwd.length==0) {
        [self showLoginPage];
        return;
    }
    //加密密码
    //    pwd = [GYencryption l:pwd k:userName];
    [Utils showMBProgressHud:self SuperView:vBack Msg:@"加载数据..."];
    [Network loginCardUser:userName password:pwd requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            __block NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:kNilOptions
                                                                          error:&error];
            if (!error)
            {
                NSInteger rCode = kSaftToNSInteger(dic[@"retCode"]);
                if (rCode == 200)//登录成功
                {
                    [Utils hideHudViewWithSuperView:vBack];
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return ;
                }else if(rCode == 802)//存在相同终端登录类型
                {
                    [UIAlertView showWithTitle:@"提示" message:@"此用户已登录，是否强制踢出其他登录用户？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"踢出并登录")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex != 0)
                        {
                            dic = dic[@"data"];
                            DDLogDebug(@"账号已在其它设备登录，强制登录");
                            [self forceLogin:userName password:pwd ecKey:kSaftToNSString(dic[@"ecKey"])];
                        }
                    }];
                }
                else
                {
                    [Utils hideHudViewWithSuperView:vBack];
                    [self showLoginPage];
                }
            }
            else
            {
                [Utils hideHudViewWithSuperView:vBack];
                [self showLoginPage];
            }
        }
    }];
}

//强制登录
+(void)forceLogin:(NSString *)userName password:(NSString *)pwd ecKey:(NSString *)ecKey
{
    NSDictionary *allParas = @{@"ecKey": ecKey,
                               @"password" : pwd,
                               @"mac" : kIEMMac,
                               @"mid" : [Network getMidForUser:userName]
                               };
    
    
    NSString *baseUrl = [[LoginEn sharedInstance] getLoginUrl];
    NSString *logintURL = [baseUrl stringByAppendingString:@"/uias/updateSameType"];
    
    [Network HttpPostRequetURL:logintURL parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                NSInteger rCode = kSaftToNSInteger(dic[@"retCode"]);
                
                if (rCode == 200)
                {
                    [Utils hideHudViewWithSuperView:vBack];
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return ;
                }
                else
                {
                    [Utils hideHudViewWithSuperView:vBack];
                    [self showLoginPage];
                }
            }
            else
            {
                [Utils hideHudViewWithSuperView:vBack];
                [self showLoginPage];
            }
            
        }
        else
        {
            [Utils hideHudViewWithSuperView:vBack];
            [self showLoginPage];
        }
    }];
    
}

+(void)setLoginValue:(NSDictionary *)dic
{
    GlobalData * data =[GlobalData shareInstance];
    data.hsKey = kSaftToNSString(dic[@"hsKey"]);
    data.ecKey = kSaftToNSString(dic[@"ecKey"]);
    data.midKey = kSaftToNSString(dic[@"sign"]);
    data.cKey = kSaftToNSString(dic[@"cKey"]);
    
    data.tfsDomain = kSaftToNSString(dic[@"tfsDomain"]);
    data.hsDomain = kSaftToNSString(dic[@"hsDomain"]);
    data.ecDomain = kSaftToNSString(dic[@"ecDomain"]);
    data.hdImPersonInfoDomain = kSaftToNSString(dic[@"hdimPersonInfo"]);
    data.hdDomain = kSaftToNSString(dic[@"hdDomain"]);
    data.hsPayDomain = kSaftToNSString(dic[@"hsPayDomain"]);
    
    //解析互动主机相关信息
    NSString *hdHostURLString = kSaftToNSString(dic[@"hdDomain"]);
    if (![hdHostURLString hasPrefix:@"http"])
    {
        hdHostURLString = [@"http://" stringByAppendingString:hdHostURLString];
    }
    NSURL *hdHostURL = [NSURL URLWithString:hdHostURLString];
    data.hdhost = [hdHostURL host];
    data.hdPort = [[hdHostURL port] integerValue];
    data.hdbizDomain = kSaftToNSString(dic[@"hdbizDomain"]);
    data.hdDomain = kSaftToNSString(dic[@"hdimVhosts"]);//如im.gy.com
    data.user.currencyCode = kSaftToNSString(dic[@"userAccount"][@"currencyId"]);
    
    NSDictionary *userInfo = dic[@"userAccount"];
    data.user.cardNumber = kSaftToNSString(userInfo[@"accountId"]);
    //data.user.lastLoginTime = kSaftToNSString(userInfo[@"lastLoginTime"]);
    //修改上次登录时间
    data.user.lastLoginTime=dic[@"lastDate"];
    
    //设置初始化互动个人资料
    [data.IMUser setValuesFromDictionary:dic[@"userNetworkInfo"]];
    data.IMUser.strIMSubUser= [@"c_" stringByAppendingString:data.user.cardNumber];
//    dicLoginResponse = dic;
    data.isEcLogined = YES;
    data.isLogined = YES;
    data.isCardUser = YES;
    
    ///
    [self loginToHDServer];
    
}

//登录到互动服务器
+(void)loginToHDServer
{
    GlobalData * data =[GlobalData shareInstance];
    if (!data.hdDomain)
        data.hdDomain = @"im.gy.com";
    
    [[GYXMPP sharedInstance] Logout];//先停止之前的
    NSString *username = [@"m_c_" stringByAppendingString:data.user.cardNumber];
    GYXMPP *xmp = [GYXMPP sharedInstance];
    //设置主机参数
    [xmp setParameterUserName:username
                     password:data.midKey   //密码用鉴权后的mid
                       domain:data.hdDomain
                     resource:@"mobile_im"
                     hostName:data.hdhost
                     hostPort:data.hdPort];
    data.IMUser.strIMLoginUser = username;
    
    [xmp login:^(IMLoginState state, id error)
     {
         switch (state)
         {
             case kIMLoginStateAuthenticateSucced:
                 data.isHdLogined = YES;
                 //                 data.isLoginedEver = YES;
                 //用户登录通知 im那边的界面刷新
                 break;
             default:
             {
                 [self showLoginPage];
             }
                 break;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];
     }];
}
+(void)reLogin
{
    GlobalData * data = [GlobalData shareInstance];
    if (data.isLogined == NO || data.isHdLogined == NO) // 互动或者系统登录
    {
        [self loginToSever];
    }
}
+(void)showLoginPage
{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    GYHDRemindLoginView * vc = [[GYHDRemindLoginView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    vc.alpha =0;
    GYAppDelegate * app  = (GYAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:vc];
    [UIView animateWithDuration:0.3 animations:^{
        vc.alpha = 0.5;
        vc.alpha = 1;
        vc.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}
@end

//
//  GYLoginView.m
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kIMDomain    @"im.gy.com" //默认的后缀
#define kIMResource  @"mobile_im" //移动终端固定使用此resource //[Utils getRandomString:5]
#define kIMCardUserPrefix    @"m_c_"    //卡用户前缀


#import "GYLoginView.h"
#import "UIView+CustomBorder.h"
#import "GYGuestLoginViewController.h"
#import "GlobalData.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "GYencryption.h"
#import "GYForgotPasswdViewController.h"
#import "GYChangeLoginEN.h"
#import "GYNoCardForgotPasswdViewController.h"
#import "IQKeyboardManager.h"

@interface GYLoginView()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    UINavigationController *nc;
    GlobalData *data;
    MBProgressHUD *hud;
    NSDictionary *dicLoginResponse;
    IBOutlet UIButton *btnSetting;
}
@end


@implementation GYLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)btnLoginNowClick:(id)sender
{
    data.isLoing = YES;
    if (data.isNeedUpdateApp)
    {
        [UIAlertView showWithTitle:@"新版本提示" message:@"检测到新版本, 您必须升级为最新版本才可以使用！" cancelButtonTitle:@"更新" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSURL *url = [NSURL URLWithString:data.appURL];
            [[UIApplication sharedApplication] openURL:url];
        }];
        return;
    }
    NSString *userName = self.InputUserNameRow.tfRightTextField.text;
//    NSString *userName = [@"m_c_" stringByAppendingString:self.InputUserNameRow.tfRightTextField.text];
    NSString *pwd = self.InputPasswordRow.tfRightTextField.text;
    if (![Utils isHSCardNo:userName])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入11位合法的互生号." isPopVC:nil];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (pwd.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入登录密码." isPopVC:nil];
        return;
    }
    [Utils hideKeyboard];
    //加密密码
    pwd = [GYencryption l:pwd k:userName];
    
    hud = [[MBProgressHUD alloc] initWithView:self];
    hud.dimBackground = YES;
    [self addSubview:hud];
//    hud.labelText = nil;
    [hud show:YES];
    [Network loginCardUser:userName password:pwd requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            __block NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
//                企业登录返回码
                // 登录异常 201
                // 请求互生接口 获取企业信息为空 814
                // 请求互生接口 获取企业状态关闭 815
                // 成员企业网上商城停止积分活动 600
                // 账户密码不正确 601
                // 存在相同终端登录类型 802
                // 登录成功 200
                
//                消费者登录返回码
                // 登录异常 201
                //账户被锁 217
                // 账户密码不正确 601
                // 存在相同终端登录类型 802
                // 登录成功 200
                
                NSInteger rCode = kSaftToNSInteger(dic[@"retCode"]);
                NSDictionary *dicErrInfo = @{@"201": @"登录异常",
                                             @"217": @"账户被锁",
                                             @"601": @"账户密码不正确"
                                             };
                if (rCode == 200)//登录成功
                {
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return ;
                }else if(rCode == 802)//存在相同终端登录类型
                {
                    self.hidden = YES;
//                    [Utils showMessgeWithTitle:@"登录失败" message:@"你的账号已经在其它设备登录，是否强制登录." isPopVC:nil];
                     [UIAlertView showWithTitle:@"提示" message:@"此用户已登录，是否强制踢出其他登录用户？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"踢出并登录")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex != 0)
                        {
                            self.hidden = NO;
                            dic = dic[@"data"];
                            DDLogDebug(@"账号已在其它设备登录，强制登录");
                            [self forceLogin:userName password:pwd ecKey:kSaftToNSString(dic[@"ecKey"])];
                        }else
                        {
                            self.hidden = NO;
                        }
                    }];
                }else
                {
                    NSString *err = @"";
                    NSString *rCodeStr = [@(rCode) stringValue];
                    if (kSaftToNSString(dicErrInfo[rCodeStr]).length < 1)//不在错误列表里
                    {
                        err = @"请检查互生号和密码.";
                    }else
                    {
                        err = kSaftToNSString(dicErrInfo[rCodeStr]);
                    }
                    [Utils showMessgeWithTitle:@"登录失败" message:err isPopVC:nil];
                }
            }else
            {
                [Utils alertViewOKbuttonWithTitle:nil message:@"登录失败."];
            }
            
        }else
        {
            [Utils alertViewOKbuttonWithTitle:@"登录失败." message:[error localizedDescription]];
        }
        if (hud)
            [hud removeFromSuperview];
    }];
}

//强制登录
- (void)forceLogin:(NSString *)userName password:(NSString *)pwd ecKey:(NSString *)ecKey
{
    NSDictionary *allParas = @{@"ecKey": ecKey,
                               @"password" : pwd,
                               @"mac" : kIEMMac,
                               @"mid" : [Network getMidForUser:userName]
                               };
    
    hud = [[MBProgressHUD alloc] initWithView:self];
    hud.dimBackground = YES;
    [self addSubview:hud];
    //    hud.labelText = nil;
    [hud show:YES];
    
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
                NSDictionary *dicErrInfo = @{@"201": @"登录异常",
                                             @"217": @"账户被锁",
                                             @"601": @"账户密码不正确"
                                             };

                if (rCode == 200)
                {
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return ;
                }else
                {
                    NSString *err = @"";
                    NSString *rCodeStr = [@(rCode) stringValue];
                    if (kSaftToNSString(dicErrInfo[rCodeStr]).length < 1)//不在错误列表里
                    {
                        err = @"请检查互生号和密码.";
                    }else
                    {
                        err = kSaftToNSString(dicErrInfo[rCodeStr]);
                    }
                    [Utils showMessgeWithTitle:@"登录失败" message:nil isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"登录失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud)
            [hud removeFromSuperview];
    }];

}

- (void)setLoginValue:(NSDictionary *)dic
{
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
    DDLogInfo(@"登录返回互动的登录信息：host:%@, port:%@, path:%@, ",[hdHostURL host], [hdHostURL port], [hdHostURL path]);
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
    dicLoginResponse = dic;
    data.isEcLogined = YES;
    data.isLogined = YES;
    data.isCardUser = YES;
    
    ///
    [self loginToHDServer];

}

//登录到互动服务器
- (void)loginToHDServer
{
    if (!data.hdDomain)
        data.hdDomain = kIMDomain;
    
    [[GYXMPP sharedInstance] Logout];//先停止之前的
    NSString *username = [kIMCardUserPrefix stringByAppendingString:data.user.cardNumber];
    GYXMPP *xmp = [GYXMPP sharedInstance];
    //设置主机参数
    [xmp setParameterUserName:username
                     password:data.midKey   //密码用鉴权后的mid
                       domain:data.hdDomain
                     resource:kIMResource
                     hostName:data.hdhost
                     hostPort:data.hdPort];
    data.IMUser.strIMLoginUser = username;

    [xmp login:^(IMLoginState state, id error)
     {
         if (hud)
             [hud removeFromSuperview];
         switch (state)
         {
             case kIMLoginStateAuthenticateSucced:
                 data.isHdLogined = YES;
                 //用户登录通知 im那边的界面刷新
                 [self closeAndRemoveSelf:nil];
                 if (_delegate && [_delegate respondsToSelector:@selector(loginDidSuccess:sender:)])
                 {
                     [_delegate loginDidSuccess:dicLoginResponse sender:self];
                     _delegate = nil;
                 }
                 if (!self.isStay)//登录后跳到指定位置
                 {
//                     data.topTabBarVC.selectedIndex = 0;
                     [nc popToRootViewControllerAnimated:NO];
                 }
                 break;
             default:
                 data.isHdLogined = NO;
                 DDLogInfo(@"登录消息服务器失败(代码%d):%@", state, error);
//                 [Utils alertViewOKbuttonWithTitle:@"登录失败" message:[NSString stringWithFormat:@"登录消息服务器失败(代码%d):%@", state, error]];
                 if (_delegate && [_delegate respondsToSelector:@selector(loginDidSuccess:sender:)])
                 {
                     [_delegate loginDidSuccess:dicLoginResponse sender:self];
                     _delegate = nil;
                 }

                 break;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];
     }];
}

- (IBAction)btnGuestLogin:(id)sender
{
    GYGuestLoginViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYGuestLoginViewController class]));
    vc.isStay = self.isStay;
    [self setHidden:YES];
    [self pushVC:vc animated:YES];
}

- (IBAction)btnForgotPasswordClick:(id)sender
{
    GYForgotPasswdViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYForgotPasswdViewController class]));
    vc.navigationItem.title = kLocalized(@"登录密码找回方式");
    [self setHidden:YES];
    [self pushVC:vc animated:YES];
}

- (void)awakeFromNib
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    self.vBackground.layer.masksToBounds = YES;
    self.vBackground.layer.cornerRadius = 4;
    self.vBackground.center = self.center;
    
    [self.InputPasswordRow.tfRightTextField setSecureTextEntry:YES];
    self.alpha = 0;
    [self.vBackground addAllBorder];
    self.lbTitle.textColor=kNavigationBarColor;
    self.lbTitle.text=kLocalized(@"user_login");
    self.InputUserNameRow.tfRightTextField.placeholder=kLocalized(@"input_points_card_number");
    self.InputPasswordRow.tfRightTextField.placeholder=kLocalized(@"input_login_password");
    [self.InputUserNameRow removeAllBorder];
    [self.InputPasswordRow removeAllBorder];
    [self.InputUserNameRow addAllBorderWithBorderWidth:0.7 andBorderColor:kDefaultViewBorderColor];
    [self.InputPasswordRow addAllBorderWithBorderWidth:0.7 andBorderColor:kDefaultViewBorderColor];
    [self.InputUserNameRow setRightBorderInset:YES];
    [self.InputPasswordRow setRightBorderInset:YES];
    
    self.imgvUserNameFront.image=[UIImage imageNamed:@"img_login_user"];
    self.imgvPasswordFront.image =[UIImage imageNamed:@"img_login_password"];
    [self.btnLoginNow setTitle:kLocalized(@"login") forState:UIControlStateNormal];
    
    [self.btnLoginNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLoginNow addTarget:self action:@selector(btnLoginNowClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLoginNow.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.btnForgetPassword setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnForgetPassword setTitle:kLocalized(@"forgot_pwd") forState:UIControlStateNormal];
        
    [self.btnGuestLogin setTitle:kLocalized(@"visitor_login") forState:UIControlStateNormal];
    [self.btnGuestLogin setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
    [Utils setFontSizeToFitWidthWithLabel:self.btnForgetPassword.titleLabel labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:self.btnGuestLogin.titleLabel labelLines:1];


    UITapGestureRecognizer *closeAndRemoveSelfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAndRemoveSelf:)];
    [self addGestureRecognizer:closeAndRemoveSelfTap];

    UITapGestureRecognizer *closeKeyBoardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    [self.vBackground addGestureRecognizer:closeKeyBoardTap];
    if (kSystemVersionLessThan(@"6.0"))//解决 iOS5和iOS6+ 手势兼容问题
    {
        closeAndRemoveSelfTap.delegate = self;
        closeKeyBoardTap.delegate = self;
    }
    self.InputUserNameRow.tfRightTextField.delegate = self;
    [self.InputUserNameRow.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.InputPasswordRow.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.InputPasswordRow.tfRightTextField.delegate = self;
    data = [GlobalData shareInstance];
    self.InputUserNameRow.tfRightTextField.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:YES][0];
    self.InputPasswordRow.tfRightTextField.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:YES][1];
    // 测试
    if (!kisReleaseEn)
    {
        NSString * strName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
        if (strName && strName.length>0)
        {
            self.InputUserNameRow.tfRightTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
        }
    }
    btnSetting.hidden = (kisReleaseEn || [LoginEn sharedInstance].loginLine == [LoginEn needToHideSettingLine]);//生产环境不显示登录环境设置
}

- (void)closeAndRemoveSelf:(UITapGestureRecognizer *)tap
{
//    self.delegate = nil;
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

- (void)closeKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)showInView:(UIView *)view
{
    if (!view || ![view isKindOfClass:[UIView class]]) return;
    nc = (UINavigationController *)data.topTabBarVC.selectedViewController;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.2f;
        self.alpha = 0.8f;
        self.alpha = 0.6f;
        self.alpha = 1.0f;
    }];
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (!vc || !nc)
    {
        return;
    }
    
    UIViewController *topVc = [nc topViewController];
    [topVc setHidesBottomBarWhenPushed:YES];
    [nc pushViewController:vc animated:YES];
    
    if (nc.viewControllers.count <= 2)//主回到主界面时显示tabbar
    {
        [topVc setHidesBottomBarWhenPushed:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == self.InputUserNameRow.tfRightTextField)
    {
        if(len > 11) return NO;

    }else if (textField == self.InputPasswordRow.tfRightTextField)
    {
        if(len > 6) return NO;
    }
    return YES;
}

- (IBAction)btn_Setting:(id)sender
{
    GYChangeLoginEN *cen = kLoadVcFromClassStringName(NSStringFromClass([GYChangeLoginEN class]));
    cen.navigationItem.title = @"请选择环境";
    [self pushVC:cen animated:YES];
    [self closeAndRemoveSelf:nil];
}

//解决 iOS5和iOS6 手势兼容问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

@end

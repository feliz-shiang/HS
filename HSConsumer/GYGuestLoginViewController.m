//
//  GYGuestLoginViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kIMDomain    @"im.gy.com" //默认的后缀
#define kIMResource  @"mobile_im" //移动终端固定使用此resource //[Utils getRandomString:5]
#define kIMNoCardUserPrefix    @"m_nc_"    //无卡用户前缀

#import "GYGuestLoginViewController.h"
#import "InputCellStypeView.h"
#import "GYGuestRegesterViewController.h"
#import "GlobalData.h"
#import "GYLoginView.h"
#import "GYForgotPasswdViewController.h"
#import "GYEasyPurchaseMainViewController.h"
#import "GYChangeLoginEN.h"
#import "GYNoCardForgotPasswdViewController.h"
#import "GYencryption.h"
#import "UIAlertView+Blocks.h"
#import "GYLoginController.h"
// 修改登录  GYLoginViewDelegate
@interface GYGuestLoginViewController ()<UITextFieldDelegate>

@end

@implementation GYGuestLoginViewController
{
    GlobalData *data;
    MBProgressHUD *hud;
    NSDictionary *dicLoginResponse;

    __weak IBOutlet InputCellStypeView *InputUserNameRow;//输入用户名
    
    __weak IBOutlet UIImageView *imgvUserNameFront;//输入账户前面的图片

    __weak IBOutlet InputCellStypeView *InputPasswordRow;//输入密码

    __weak IBOutlet UIImageView *imgvPasswordFront;//输入密码前面的图片
    
    __weak IBOutlet UIButton *btnForgetPassowrd;//忘记密码 btn

    __weak IBOutlet UIButton *btnLoginNow;//立即登录btn

    __weak IBOutlet UIButton *btnRegister;//注册BTN
    
    __weak IBOutlet UIButton *btnApplyHScard;//申请互生卡BTN
    IBOutlet UIButton *btnSetting;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"visitor_login");
         self.view.backgroundColor=kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    data = [GlobalData shareInstance];
    [InputPasswordRow.tfRightTextField setSecureTextEntry:YES];
    [InputUserNameRow.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [InputPasswordRow.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    InputUserNameRow.tfRightTextField.delegate = self;
    InputPasswordRow.tfRightTextField.delegate = self;
    
    
    btnSetting.hidden = (kisReleaseEn  || [LoginEn sharedInstance].loginLine == [LoginEn needToHideSettingLine]);//生产环境不显示登录环境设置

    [self modifyName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//用于电商
    InputUserNameRow.tfRightTextField.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:NO][0];
    InputPasswordRow.tfRightTextField.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:NO][1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (IBAction)btnLoginNowClick:(id)sender
{
    if (data.isNeedUpdateApp)
    {
        [UIAlertView showWithTitle:@"新版本提示" message:@"检测到新版本, 您必须升级为最新版本才可以使用！" cancelButtonTitle:@"更新" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSURL *url = [NSURL URLWithString:data.appURL];
            [[UIApplication sharedApplication] openURL:url];
        }];
        return;
    }

    NSString *userName = InputUserNameRow.tfRightTextField.text;
    //    NSString *userName = [@"m_c_" stringByAppendingString:self.InputUserNameRow.tfRightTextField.text];
    NSString *pwd = InputPasswordRow.tfRightTextField.text;
    
    if (userName.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入手机号码." isPopVC:nil];
        return;
    }
    if (pwd.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入登录密码." isPopVC:nil];
        return;
    }
    
    //加密密码
    pwd = [GYencryption l:pwd k:userName];

    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = nil;
    [hud show:YES];
    [Network loginNoCardUser:userName password:pwd requetResult:^(NSData *jsonData, NSError *error) {
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
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return;
                }else if(rCode == 601)
                {
                    [Utils showMessgeWithTitle:@"登录失败" message:@"登录密码错误." isPopVC:nil];
                    
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
                    
                    
                }else
                {
                    [Utils showMessgeWithTitle:@"登录失败" message:@"请检查手机号和密码." isPopVC:nil];
                }
            }else
            {
                [Utils alertViewOKbuttonWithTitle:nil message:@"登录失败."];
            }
            
        }else
        {
            //            NSLog(@"network error：%@", error);
            [Utils alertViewOKbuttonWithTitle:@"登录失败." message:[error localizedDescription]];
        }
        if (hud)
            [hud removeFromSuperview];
    }];
}

- (void)forceLogin:(NSString *)userName password:(NSString *)pwd ecKey:(NSString *)ecKey
{
    NSDictionary *allParas = @{@"ecKey": ecKey,
                               @"password" : pwd,
                               @"mac" : kIEMMac,
                               @"mid" : [Network getMidForUser:userName]
                               };
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = YES;
    [self.view addSubview:hud];
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
                if (rCode == 200)//强制登录成功
                {
                    dic = dic[@"data"];
                    [self setLoginValue:dic];
                    return;
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                    });
                }else
                {
                    [Utils showMessgeWithTitle:nil message:@"登录失败." isPopVC:nil];
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
    data.user.currencyCode = kSaftToNSString(dic[@"userAccount"][@"currencyId"]);
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
    data.hdPort = [[hdHostURL port] intValue];
    data.hdbizDomain = kSaftToNSString(dic[@"hdbizDomain"]);
    data.hdDomain = kSaftToNSString(dic[@"hdimVhosts"]);//如im.gy.com
    
    NSDictionary *userInfo = dic[@"userAccount"];
    data.user.cardNumber = kSaftToNSString(userInfo[@"accountId"]);
    
    //设置初始化互动个人资料
    [data.IMUser setValuesFromDictionary:dic[@"userNetworkInfo"]];
    data.IMUser.strIMSubUser= [@"nc_" stringByAppendingString:data.user.cardNumber];
    
    dicLoginResponse = dic;
    data.isEcLogined = YES;
    data.isLogined = NO;
    data.isCardUser = NO;
    
    [self loginToHDServer];

}

- (IBAction)btnForgotPasswordClick:(id)sender
{
    GYNoCardForgotPasswdViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYNoCardForgotPasswdViewController class]));
    [self setHidesBottomBarWhenPushed:YES];
    if (data.loginView)
    {
        [data.loginView removeFromSuperview];
    }
    vc.navigationItem.title = kLocalized(@"登录密码找回方式");
    [self.navigationController pushViewController:vc animated:YES];
}

//登录到互动服务器
- (void)loginToHDServer
{
    if (!data.hdDomain)
        data.hdDomain = kIMDomain;
    
    [[GYXMPP sharedInstance] Logout];//先停止之前的

    NSString *username = [kIMNoCardUserPrefix stringByAppendingString:data.user.cardNumber];
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
                 //用户登录通知 im那边的界面刷新
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];

             case kIMLoginStateAuthenticateSucced:
                 data.isHdLogined = YES;


                 if (data.loginView)
                 {
                     [data.loginView closeAndRemoveSelf:nil];
                 }
                 
                 if (_delegate && [_delegate respondsToSelector:@selector(loginDidSuccess:sender:)])
                 {
                     [_delegate loginDidSuccess:dicLoginResponse sender:self];
                 }

                 if (!self.isStay)//登录后跳到指定位置
                 {
                     data.topTabBarVC.selectedIndex = 0;
                     [self.navigationController popViewControllerAnimated:NO];
                 }else
                 {
                     [self.navigationController popViewControllerAnimated:NO];
                 }
                 break;
             default:
             {
                 data.isHdLogined = NO;
                 DDLogInfo(@"登录消息服务器失败(代码%d):%@", state, error);
                 if (!self.isStay)//登录后跳到指定位置
                 {
                     data.topTabBarVC.selectedIndex = 0;
                     [self.navigationController popViewControllerAnimated:NO];
                 }else
                 {
                     
                 }
                 
                 if (_delegate && [_delegate respondsToSelector:@selector(loginDidSuccess:sender:)])
                 {
                     [_delegate loginDidSuccess:dicLoginResponse sender:self];
                 }
             }
                 break;
         }
     }];
}

-(void)modifyName
{
    [btnApplyHScard setTitle:kLocalized(@"apply_Hs_card") forState:UIControlStateNormal];
    [btnApplyHScard setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    [btnForgetPassowrd setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [btnForgetPassowrd setTitle:kLocalized(@"forgot_pwd") forState:UIControlStateNormal]; 
    [btnLoginNow setTitle:kLocalized(@"login") forState:UIControlStateNormal];
    [btnLoginNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLoginNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg"] forState:UIControlStateNormal];
    [btnLoginNow.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    
    [btnRegister setTitle:kLocalized(@"register_rightnow") forState:UIControlStateNormal];
    [btnRegister setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
    InputUserNameRow.tfRightTextField.placeholder=kLocalized(@"input_phone_number");
    InputPasswordRow.tfRightTextField.placeholder=kLocalized(@"input_login_password");
    
    imgvUserNameFront.image=[UIImage imageNamed:@"img_login_user"];
    imgvPasswordFront.image =[UIImage imageNamed:@"img_login_password"];
}


- (IBAction)btnRegister:(id)sender {
    GYGuestRegesterViewController * vcRegister =[[GYGuestRegesterViewController alloc]initWithNibName:@"GYGuestRegesterViewController" bundle:nil];
    [self setHidesBottomBarWhenPushed:YES];
    if (data.loginView)
    {
        [data.loginView removeFromSuperview];
    }
    vcRegister.navigationItem.title = kLocalized(@"非持卡用户注册");
    [self.navigationController pushViewController:vcRegister animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)btn_Setting:(id)sender
{
    GYChangeLoginEN *cen = kLoadVcFromClassStringName(NSStringFromClass([GYChangeLoginEN class]));
    cen.navigationItem.title = @"请选择环境";
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cen animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == InputUserNameRow.tfRightTextField)
    {
        if(len > 11) return NO;
        
    }else if (textField == InputPasswordRow.tfRightTextField)
    {
        if(len > 6) return NO;
    }
    return YES;
}

@end

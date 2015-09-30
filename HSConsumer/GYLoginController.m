//
//  GYLoginController.m
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/3.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import "GYLoginController.h"
#import "GYLoginNOCardController.h"
#import "GYBottomActionView.h"


#define kIMDomain    @"im.gy.com" //默认的后缀
#define kIMResource  @"mobile_im" //移动终端固定使用此resource //[Utils getRandomString:5]
#define kIMCardUserPrefix    @"m_c_"    //卡用户前缀
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
#import "GYUserInfoTool.h"
#import "UIImageView+WebCache.h"
#import "GYHSAccountViewController.h"


#define kBorder 16
#define kItemFont [UIFont systemFontOfSize:17]
#define kTitleFont [UIFont systemFontOfSize:25]

@interface GYLoginController ()<UITextFieldDelegate,GYBottomActionViewDelegate>
{
    UINavigationController *nc;
    GlobalData *data;
    MBProgressHUD *hud;
    NSDictionary *dicLoginResponse;
    UIButton *btnSetting;
}
@property (weak, nonatomic)  UIButton *btnCancel;
@property (weak, nonatomic)  UILabel *lbTitle;
@property (weak, nonatomic)  UIView *vHSCard;
@property (weak, nonatomic)  UILabel *lbHSCardTitle;
@property (weak, nonatomic)  UITextField *tfHSCardInput;
@property (weak, nonatomic)  UIView *vPassWorld;
@property (weak, nonatomic)  UILabel *lbPassWorldTitle;
@property (weak, nonatomic)  UITextField *tfPassWoldInput;
@property (weak, nonatomic)  UIButton *btnLogin;
@property (weak, nonatomic)  UIButton *btnMore;


@property (weak ,nonatomic)UIImageView *ivHead;
@property (assign,nonatomic) CGFloat fItemHeight;
@property (weak, nonatomic)  UILabel *lbCardNum;
@property (weak, nonatomic)  UIButton *btnForgetPossworld;
@property (strong,nonatomic) NSMutableArray * marrUserData;

@property (strong,nonatomic) NSArray * arrUsers;
@property (assign,nonatomic) BOOL isHistory;
@property (assign,nonatomic) GYUserInfoTool * tool;
@property (strong,nonatomic) UIScrollView * svBack;

@property (weak, nonatomic)  UIButton *btnSetting;

// add by songjk 保存加密之后的秘密 用来保持用户登录状态
@property (nonatomic,copy) NSString * strPwd;
// 用户名
@property (nonatomic,copy) NSString *strName;
@end

@implementation GYLoginController

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        if (kScreenWidth>480)
        {
            self.fItemHeight = 45;
        }
        else
        {
            self.fItemHeight = 35;
        }
        
        data = [GlobalData shareInstance];
        nc = (UINavigationController *)data.topTabBarVC.selectedViewController;
        self.tool = [GYUserInfoTool shareInstance];
        [[IQKeyboardManager sharedManager] setEnable:YES];
        self.lbTitle.textColor=kNavigationBarColor;
        self.lbTitle.text=kLocalized(@"user_login");
        btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kBorder -35, 30, 35, 35)];
        [btnSetting setImage:[UIImage imageNamed:@"btn_set_blue.png"] forState:UIControlStateNormal];
        [btnSetting setBackgroundColor:[UIColor redColor]];
        [btnSetting addTarget:self action:@selector(btn_Setting:) forControlEvents:UIControlEventTouchUpInside];
        btnSetting.hidden = (kisReleaseEn || [LoginEn sharedInstance].loginLine == [LoginEn needToHideSettingLine]);//生产环境不显示登录环境设置
        self.btnSetting = btnSetting;
        [self addSubview:btnSetting];
        // 判断有没有登录的信息
        self.arrUsers = [self.tool getUserLoginIfnoWithType:@"1"];
        if (self.arrUsers.count>0)
        {
            self.isHistory = YES;
            [self settingsWithHistory];
        }
        else
        {
            [self settingsWithoutHistory];
        }
        self.tfPassWoldInput.secureTextEntry = YES;
        self.tfHSCardInput.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:YES][0];
        self.tfPassWoldInput.text = [[LoginEn sharedInstance] getDefaultUserPwdIsCardUser:YES][1];
        // 测试
        if (!kisReleaseEn)
        {
            NSString * strName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
            if (strName && strName.length>0)
            {
                self.tfHSCardInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
            }
        }
    }
    return self;
}
-(void)settingsWithHistory
{
    UIScrollView * svBack = [[UIScrollView alloc] initWithFrame:self.bounds];
    svBack.backgroundColor = [UIColor  whiteColor];
    svBack.scrollEnabled = YES;
    svBack.contentSize = CGSizeMake(0, self.bounds.size.height);
    [self addSubview:svBack];
    self.svBack = svBack;
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, 30, 40, 25)];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = kItemFont;
    [btnCancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel = btnCancel;
    [self.svBack addSubview:self.btnCancel];
    
    UIImageView *ivHead = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    ivHead.center = CGPointMake(self.center.x, ivHead.center.y);
    ivHead.layer.cornerRadius = 10;
    ivHead.clipsToBounds = YES;
    NSDictionary * dict = self.arrUsers[0];
    [ivHead sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headpic"]] placeholderImage:[UIImage imageNamed:@"defaultheadimg.png"]];
    self.ivHead = ivHead;
    UITapGestureRecognizer * changeUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUser)];
    [self.ivHead addGestureRecognizer:changeUserTap];
    self.ivHead.userInteractionEnabled = YES;
    [self.svBack addSubview:self.ivHead];
    
    UILabel *lbCardNum = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ivHead.frame)+10, 200, self.fItemHeight)];
    lbCardNum.center = CGPointMake(self.center.x, lbCardNum.center.y);
    lbCardNum.backgroundColor = [UIColor clearColor];
    lbCardNum.text = [dict objectForKey:@"userid"];
    lbCardNum.textAlignment = NSTextAlignmentCenter;
    lbCardNum.font = kItemFont;
    self.lbCardNum = lbCardNum;
    [self.svBack addSubview:self.lbCardNum];
    
    UIView *vPassWorld = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.lbCardNum.frame)+20, kScreenWidth - kBorder*2, self.fItemHeight)];
    vPassWorld.backgroundColor = [UIColor clearColor];
    self.vPassWorld = vPassWorld;
    [self.svBack addSubview:self.vPassWorld];
    
    UILabel *lbPassWorldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vPassWorld.frame.size.width*0.15, self.fItemHeight)];
    lbPassWorldTitle.backgroundColor = [UIColor clearColor];
    lbPassWorldTitle.text = @"密码";
    lbPassWorldTitle.textAlignment = NSTextAlignmentLeft;
    lbPassWorldTitle.font = kItemFont;
    self.lbPassWorldTitle = lbPassWorldTitle;
    [self.vPassWorld addSubview:self.lbPassWorldTitle];
    
    UITextField *tfPassWoldInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbPassWorldTitle.frame)+20, 0, self.vPassWorld.frame.size.width - self.lbPassWorldTitle.frame.size.width-20, self.fItemHeight)];
    tfPassWoldInput.placeholder = @"输入登录密码";
    tfPassWoldInput.font = kItemFont;
    tfPassWoldInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassWoldInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfPassWoldInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    tfPassWoldInput.secureTextEntry = YES;
    [tfPassWoldInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfPassWoldInput = tfPassWoldInput;
    [self.vPassWorld addSubview:self.tfPassWoldInput];
    
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vPassWorld.frame)+35, kScreenWidth - kBorder *2, self.fItemHeight)];
    [btnLogin setBackgroundColor:[UIColor redColor]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.enabled = NO;
    btnLogin.titleLabel.font = kItemFont;
    btnLogin.layer.cornerRadius = 2;
    [btnLogin addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin = btnLogin;
    [self.svBack addSubview:self.btnLogin];
    
//    UIButton *btnForgetPossworld = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.btnLogin.frame)+20, 80, self.fItemHeight)];
//    btnForgetPossworld.center = CGPointMake(self.center.x, btnForgetPossworld.center.y);
//    [btnForgetPossworld setBackgroundColor:[UIColor clearColor]];
//    [btnForgetPossworld setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnForgetPossworld setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    btnForgetPossworld.titleLabel.font = kItemFont;
//    [btnForgetPossworld addTarget:self action:@selector(forgetPassworld) forControlEvents:UIControlEventTouchUpInside];
//    self.btnForgetPossworld = btnForgetPossworld;
//    [self addSubview:self.btnForgetPossworld];
    
    UIButton *btnMore = [[UIButton alloc] initWithFrame:CGRectMake(100, kScreenHeight - 40, 40, 25)];
    btnMore.center = CGPointMake(self.center.x, btnMore.center.y);
    [btnMore setBackgroundColor:[UIColor clearColor]];
    [btnMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMore setTitle:@"更多" forState:UIControlStateNormal];
    btnMore.titleLabel.font = kItemFont;
    [btnMore addTarget:self action:@selector(moreClickWithHistory:) forControlEvents:UIControlEventTouchUpInside];
    self.btnMore = btnMore;
    [self.svBack addSubview:self.btnMore];
    
    [self.vPassWorld addBottomBorder];
    [self.lbHSCardTitle addRightBorder];
    self.tfPassWoldInput.delegate = self;
    self.tfHSCardInput.delegate = self;
}
-(void)settingsWithoutHistory
{
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, 30, 40, 25)];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = kItemFont;
    [btnCancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel = btnCancel;
    [self addSubview:self.btnCancel];
    
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btnCancel.frame)+20, kScreenWidth, self.fItemHeight)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"持卡人登录";
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.font = kTitleFont;
    self.lbTitle = lbTitle;
    [self addSubview:self.lbTitle];
    
    UIView *vHSCard = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.lbTitle.frame)+50, kScreenWidth - kBorder*2, self.fItemHeight)];
    vHSCard.backgroundColor = [UIColor clearColor];
    self.vHSCard = vHSCard;
    [self addSubview:self.vHSCard];
    
    
    UILabel *lbHSCardTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vHSCard.frame.size.width*0.3, self.fItemHeight)];
    lbHSCardTitle.backgroundColor = [UIColor clearColor];
    lbHSCardTitle.text = @"互生号";
    lbHSCardTitle.textAlignment = NSTextAlignmentLeft;
    lbHSCardTitle.font = kItemFont;
    self.lbHSCardTitle = lbHSCardTitle;
    [self.vHSCard addSubview:self.lbHSCardTitle];
    
    UITextField *tfHSCardInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbHSCardTitle.frame)+20, 0, self.vHSCard.frame.size.width - self.lbHSCardTitle.frame.size.width-20, self.fItemHeight)];
    tfHSCardInput.placeholder = @"输入互生号";
    tfHSCardInput.font = kItemFont;
    tfHSCardInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfHSCardInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    tfHSCardInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [tfHSCardInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfHSCardInput = tfHSCardInput;
    self.tfHSCardInput.delegate = self;
    [self.vHSCard addSubview:self.tfHSCardInput];
    
    UIView *vPassWorld = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vHSCard.frame), kScreenWidth - kBorder*2, self.fItemHeight)];
    vPassWorld.backgroundColor = [UIColor clearColor];
    self.vPassWorld = vPassWorld;
    [self addSubview:self.vPassWorld];
    
    UILabel *lbPassWorldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vPassWorld.frame.size.width*0.3, self.fItemHeight)];
    lbPassWorldTitle.backgroundColor = [UIColor clearColor];
    lbPassWorldTitle.text = @"密码";
    lbPassWorldTitle.textAlignment = NSTextAlignmentLeft;
    lbPassWorldTitle.font = kItemFont;
    self.lbPassWorldTitle = lbPassWorldTitle;
    [self.vPassWorld addSubview:self.lbPassWorldTitle];
    
    UITextField *tfPassWoldInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbPassWorldTitle.frame)+20, 0, self.vPassWorld.frame.size.width - self.lbPassWorldTitle.frame.size.width-20, self.fItemHeight)];
    tfPassWoldInput.placeholder = @"输入登录密码";
    tfPassWoldInput.font = kItemFont;
    tfPassWoldInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassWoldInput.secureTextEntry = YES;
    tfPassWoldInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    [tfPassWoldInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    tfPassWoldInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.tfPassWoldInput = tfPassWoldInput;
    self.tfPassWoldInput.delegate = self;
    [self.vPassWorld addSubview:self.tfPassWoldInput];
    
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vPassWorld.frame)+35, kScreenWidth - kBorder *2, self.fItemHeight)];
    [btnLogin setBackgroundColor:[UIColor redColor]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = kItemFont;
    btnLogin.layer.cornerRadius = 2;
    btnLogin.enabled = NO;
    [btnLogin addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin = btnLogin;
    [self addSubview:self.btnLogin];
    
    UIButton *btnMore = [[UIButton alloc] initWithFrame:CGRectMake(100, kScreenHeight - 40, 40, 25)];
    btnMore.center = CGPointMake(self.center.x, btnMore.center.y);
    [btnMore setBackgroundColor:[UIColor clearColor]];
    [btnMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMore setTitle:@"更多" forState:UIControlStateNormal];
    btnMore.titleLabel.font = kItemFont;
    [btnMore addTarget:self action:@selector(moreClickWithOutHistory:) forControlEvents:UIControlEventTouchUpInside];
    self.btnMore = btnMore;
    [self addSubview:self.btnMore];
    
    [self.vHSCard addTopBorder];
    [self.vHSCard addBottomBorder];
    [self.vPassWorld addBottomBorder];
    [self.lbHSCardTitle addRightBorder];
    self.tfPassWoldInput.delegate = self;
    self.tfHSCardInput.delegate = self;
}
-(void)textChage
{
    if (self.isHistory)
    {
        self.btnLogin.enabled = self.tfPassWoldInput.text.length >0 ? YES : NO;
    }
    else
    {
        self.btnLogin.enabled = (self.tfPassWoldInput.text.length >0 ? YES : NO )&& (self.tfHSCardInput.text.length >0 ? YES : NO);
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.btnSetting];
    [self textChage];
}
// 取消
- (void)cancelClick:(UIButton *)sender
{
    if (self.ischang==YES) {/////修改密码页面
        GYHSAccountViewController  *vc=[[GYHSAccountViewController alloc]init];
        [self pushVC:vc animated:YES];
    }else{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
    }
    
}
// 登录
- (void)loginClick:(id)sender
{
    // add by songjk 清除本地数据
    [self clearLocalData];
    data.isLoing = YES;
    if (data.isNeedUpdateApp)
    {
        [UIAlertView showWithTitle:@"新版本提示" message:@"检测到新版本, 您必须升级为最新版本才可以使用！" cancelButtonTitle:@"更新" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSURL *url = [NSURL URLWithString:data.appURL];
            [[UIApplication sharedApplication] openURL:url];
        }];
        return;
    }
    NSString *userName = self.tfHSCardInput.text;
    
    if (self.isHistory)
    {
        userName = self.lbCardNum.text;
    }
    NSString *pwd = self.tfPassWoldInput.text;
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
                    self.strPwd = pwd;// add by songjk
                    self.strName = userName; // add by songjk
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
                    self.strPwd = pwd;// add by songjk
                    self.strName = userName; // add by songjk
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
             {
                 // add by songjk 记录密码, 账号在本地
                 [[NSUserDefaults standardUserDefaults] setObject:self.strPwd forKey:kUserPasswordKey];
                 [[NSUserDefaults standardUserDefaults] setObject:self.strName forKey:kUserNameKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 data.isHdLogined = YES;
                 // 保存用户信息
                 NSString *imgUrl = kSaftToNSString(data.IMUser.strHeadPic);
                 if (![imgUrl hasPrefix:@"http"]) {
                     imgUrl = [NSString stringWithFormat:@"%@%@", data.tfsDomain, imgUrl];
                 }
                 NSTimeZone * tz = [NSTimeZone defaultTimeZone];
                 NSDate * date = [NSDate date];
                 NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 [dateFormatter setTimeZone:tz];
                 NSString * strTime = [dateFormatter stringFromDate:date];
                 NSString * strUserId =self.tfHSCardInput.text;
                 if (self.isHistory)
                 {
                     strUserId= self.lbCardNum.text;
                 }
                 [self.tool setUserLoginInfoWithdictData:@{@"userid":strUserId,@"username":@"",@"headpic":imgUrl,@"usertype":@"1",@"logintime":strTime}];
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
             }
                 break;
             default:
                 data.isHdLogined = NO;
                 DDLogInfo(@"登录消息服务器失败(代码%zi):%@", state, error);
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
- (void)closeAndRemoveSelf:(UITapGestureRecognizer *)tap
{
    //    self.delegate = nil;
//    if (self.superview)
//    {
//        [self removeFromSuperview];
//    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (finished)
        {
            if (self.superview)
            {
                [self removeFromSuperview];
            }
            
        }
    }];
}
- (void)showInView:(UIView *)view
{
    if (!view || ![view isKindOfClass:[UIView class]]) return;
    if (!nc)
    {
        nc = (UINavigationController *)data.topTabBarVC.selectedViewController;
    }
//    self.alpha = 0;
    [view addSubview:self];
//    [UIView animateWithDuration:0.2f animations:^{
//        self.alpha = 0.2f;
//        self.alpha = 0.8f;
//        self.alpha = 0.6f;
//        self.alpha = 1.0f;
//    }];
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
// 更多 有历史登录
- (void)moreClickWithHistory:(id)sender
{
    NSArray * arrData = @[@"切换账号",@"非持卡人登录",@"忘记密码"];
    NSMutableArray * marrList = [NSMutableArray array];
    for (int i =0; i<arrData.count; i++)
    {
        GYBottomActionViewItemModel * model = [[GYBottomActionViewItemModel alloc] init];
        model.type =1;
        model.strTitle = arrData[i];
        [marrList addObject:model];
    }
    GYBottomActionView * bavView = [[GYBottomActionView alloc] initWithView:self arrayData:marrList];
    bavView.delegate = self;
    [bavView show];
}
// 无历史登录
- (void)moreClickWithOutHistory:(id)sender
{
    NSArray * arrData = @[@"非持卡人登录",@"忘记密码"];
    NSMutableArray * marrList = [NSMutableArray array];
    for (int i =0; i<arrData.count; i++)
    {
        GYBottomActionViewItemModel * model = [[GYBottomActionViewItemModel alloc] init];
        model.type =1;
        model.strTitle = arrData[i];
        [marrList addObject:model];
    }
    GYBottomActionView * bavView = [[GYBottomActionView alloc] initWithView:self arrayData:marrList];
    bavView.delegate = self;
    [bavView show];
}

#pragma mark GYBottomActionViewDelegate
-(void)BottomActionView:(GYBottomActionView *)BottomActionView model:(GYBottomActionViewItemModel *)model
{
    if (model.type == 1)
    {
        [self changeWithModel:model];
    }
    else
    {
        [self changeUserWithModel:model];
    }
}
// 点击相应事件
-(void)changeWithModel:(GYBottomActionViewItemModel*)model
{
    NSString * strAction = model.strTitle;
    if ([strAction isEqualToString:@"非持卡人登录"])
    {
        NSLog(@"非持卡人登录界面");
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        GYLoginNOCardController * vc = [[GYLoginNOCardController alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
        vc.alpha =0;
        vc.isStay = self.isStay;
//        [self pushVC:vc animated:YES];
        [self.superview addSubview:vc];
        [UIView animateWithDuration:0.5 animations:^{
            vc.alpha = 0.5;
            vc.alpha = 1;
            vc.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }
    else if ([strAction isEqualToString:@"切换账号"])
    {
        [self changeUser];
    }
    else if([strAction isEqualToString:@"忘记密码"])
    {
        [self forgetPassworld];
    }
}
// 切换用户
-(void)changeUserWithModel:(GYBottomActionViewItemModel*)model
{
    if ([model.strTitle isEqualToString:@"添加帐号"])
    {
        self.isHistory = NO;
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self settingsWithoutHistory];
    }
    else
    {
        self.lbCardNum.text = model.strTitle;
        [self.ivHead sd_setImageWithURL:[NSURL URLWithString:model.strImgName] placeholderImage:[UIImage imageNamed:@"defaultheadimg.png"]];
    }
}

// 忘记密码
-(void)forgetPassworld
{
    GYForgotPasswdViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYForgotPasswdViewController class]));
    vc.navigationItem.title = kLocalized(@"登录密码找回方式");
    [self setHidden:YES];
    [self pushVC:vc animated:YES];
}
// 弹出切换用户菜单
-(void)changeUser
{
    NSMutableArray * marrList = [NSMutableArray array];
    // 添加帐号一栏
    NSDictionary *dictAdd = @{@"userid":@"添加帐号",@"headpic":@"",@"usertype":@"2"};
    NSMutableArray * marrData = [NSMutableArray arrayWithArray:self.arrUsers];
    [marrData addObject:dictAdd];
    for (int i =0; i<marrData.count; i++)
    {
        NSDictionary * dict = marrData[i];
        GYBottomActionViewItemModel * model = [[GYBottomActionViewItemModel alloc] init];
        model.type =2;
        model.strTitle = [dict objectForKey:@"userid"];
        model.strImgName = [dict objectForKey:@"headpic"];
        if ([self.lbCardNum.text isEqualToString:model.strTitle])
        {
            model.isSelect = YES;
        }
        if ([model.strTitle isEqualToString:@"添加帐号"]) {
            model.isAdd = YES;
        }
        [marrList addObject:model];
    }
    GYBottomActionView * bavView = [[GYBottomActionView alloc] initWithView:self arrayData:marrList];
    bavView.delegate = self;
    [bavView show];
}

- (void)btn_Setting:(id)sender
{
    GYChangeLoginEN *cen = kLoadVcFromClassStringName(NSStringFromClass([GYChangeLoginEN class]));
    cen.navigationItem.title = @"请选择环境";
    [self pushVC:cen animated:YES];
    [self closeAndRemoveSelf:nil];
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    NSInteger length = 11;
    if (textField == self.tfHSCardInput)
    {
        length = 11;
    }
    else if(textField == self.tfPassWoldInput)
    {
        length = 6;
    }
    if (len>length)
    {
        return NO;
    }
    return YES;
}

// add by songjk 登录失败清除数据
-(void)clearLocalData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPasswordKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

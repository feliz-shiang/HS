//
//  GYGuestRegesterViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kGetCodeTimeout 120

#import "GYGuestRegesterViewController.h"
#import "InputCellStypeView.h"
#import "UIButton+enLargedRect.h"
#import "UIAlertView+Blocks.h"
#import "GYencryption.h"

@interface GYGuestRegesterViewController ()

@end

@implementation GYGuestRegesterViewController
{
    __weak IBOutlet InputCellStypeView *InputUsernameRow;
    __weak IBOutlet InputCellStypeView *InputPasswordRow;
    __weak IBOutlet InputCellStypeView *InputPasswordAgain;
    __weak IBOutlet InputCellStypeView *InputAuthCodeRow;
    
    IBOutlet UIButton *btnGetCode;
    IBOutlet UIButton *btnRegisterNow;
    
    NSTimer *timer;
    int timeout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
    [btnGetCode addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegisterNow addTarget:self action:@selector(btnRegisterNowClick:) forControlEvents:UIControlEventTouchUpInside];
    [Utils setFontSizeToFitWidthWithLabel:btnGetCode.titleLabel labelLines:1];
    [btnGetCode setBorderWithWidth:1.0f andRadius:4.0f andColor:kCorlorFromRGBA(250, 60, 40, 1)];
    [InputAuthCodeRow.tfRightTextField setEnabled:NO];
}

-(void)modifyName
{
    InputUsernameRow.lbLeftlabel.text=kLocalized(@"username");
    InputUsernameRow.tfRightTextField.placeholder=kLocalized(@"input_phone_number");
    InputPasswordRow.lbLeftlabel.text=kLocalized(@"pwd");
    InputPasswordRow.tfRightTextField.placeholder=kLocalized(@"input_password");
    InputPasswordAgain.lbLeftlabel.text=kLocalized(@"confirm_pwd");
    InputPasswordAgain.tfRightTextField.placeholder=kLocalized(@"input_password_repeat");
    [InputPasswordRow.tfRightTextField setSecureTextEntry:YES];
    [InputPasswordAgain.tfRightTextField setSecureTextEntry:YES];
    
    InputAuthCodeRow.lbLeftlabel.text=kLocalized(@"verification_code");
    InputAuthCodeRow.tfRightTextField.placeholder=kLocalized(@"input_validation_code");
    
    [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    [btnRegisterNow setTitle:kLocalized(@"register_rightnow") forState:UIControlStateNormal];
    [btnRegisterNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg"] forState:UIControlStateNormal];
    
}

- (void)ticke:(NSTimer *)t
{
    --timeout;
    NSString *title = [NSString stringWithFormat:@"%d s", timeout];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeout >= 0)
        {
            [btnGetCode setTitle:title forState:UIControlStateNormal];
        }else
        {
            [btnGetCode setTitle:kLocalized(@"re_get_verification_code") forState:UIControlStateNormal];
            [timer invalidate];
            timer = nil;
        }
    });
}

- (void)getCodeClick:(id)sender
{
    if (timer) return;//正在跑着呢
    
    if (InputUsernameRow.tfRightTextField.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入手机号码" isPopVC:nil];
        return;
    }
    
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"accountNo": InputUsernameRow.tfRightTextField.text,
                               @"isCheck": @"0"
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    [self.navigationController.view addSubview:hud];
    hud.labelText = @"正在获取验证码...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/user/sendShortMsg"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            DDLogInfo(@"GuestRegester getCodeClick dic:%@", dic);
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    [InputAuthCodeRow.tfRightTextField setEnabled:YES];
                    timeout = kGetCodeTimeout;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ticke:) userInfo:nil repeats:YES];
                    
                    [Utils showMessgeWithTitle:nil message:@"验证码已经发送，请注意查收。" isPopVC:nil];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取验证码失败，请重新获取。" isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取验证码失败，请重新获取。" isPopVC:nil];
            }
        }else
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (void)btnRegisterNowClick:(id)sender
{
    NSString *user = InputUsernameRow.tfRightTextField.text;
    NSString *pwd1 = InputPasswordRow.tfRightTextField.text;
    NSString *pwd2 = InputPasswordAgain.tfRightTextField.text;
    NSString *code = InputAuthCodeRow.tfRightTextField.text;
    
    if (user.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入手机号码。" isPopVC:nil];
        return;
    }
    if (user.length!=11||![Utils isValidMobileNumber:user]) {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入正确的手机号码" isPopVC:nil];
        return;
    }
    if (pwd1.length!=6||![Utils isValidMobileNumber:user])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入6位数字密码" isPopVC:nil];
        return;
    
    }
    if (pwd2.length!=6||![Utils isValidMobileNumber:user])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入6位确认数字密码" isPopVC:nil];
        return;
        
    }
    
//    if (![Utils isValidMobileNumber:user]) {
//        [Utils showMessgeWithTitle:@"提示" message:@"请输入6位确认数字密码" isPopVC:nil];
//        return;
//    }
    
    if (pwd1.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入密码。" isPopVC:nil];
        return;
    }
    
    if (![pwd1 isEqualToString:pwd2])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"两次输入的密码不一致。" isPopVC:nil];
        return;
    }
    
    if (code.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入验证码。" isPopVC:nil];
        return;
    }
    
    GlobalData *data = [GlobalData shareInstance];
    pwd1 = [GYencryption l:pwd1 k:InputUsernameRow.tfRightTextField.text];
    NSDictionary *allParas = @{@"account": InputUsernameRow.tfRightTextField.text,
                               @"pwd": pwd1,
                               @"checkCode": code
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    [self.navigationController.view addSubview:hud];
//    hud.labelText = @"";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/user/noCardRigister"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            DDLogInfo(@"btnRegisterNowClick dic:%@", dic);
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == 614)//注册成功
                {
                    [UIAlertView showWithTitle:nil message:@"恭喜，注册成功！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                }else if (kSaftToNSInteger(dic[@"retCode"]) == 617)//验证码不正确
                {
                    [Utils showMessgeWithTitle:@"提示" message:@"验证码不正确。" isPopVC:nil];

                }else if (kSaftToNSInteger(dic[@"retCode"]) == 657)//帐户已存在
                {
                    [Utils showMessgeWithTitle:@"提示" message:@"帐户已存在。" isPopVC:nil];
                }
                else// 615 或其它 注册失败
                {
                    [Utils showMessgeWithTitle:nil message:@"注册失败。" isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"注册失败。" isPopVC:nil];
            }
        }else
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField.tag==11||textField.tag==12)
    {
        if(len > 6) return NO;
        
    }
    if (textField.tag==10) {
        if(len > 11) return NO;
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end

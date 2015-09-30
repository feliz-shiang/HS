//
//  GYNOCardRegView.m
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/5.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import "GYNOCardRegView.h"
#import "UIView+CustomBorder.h"
#import "GYencryption.h"

#define kGetCodeTimeout 120
#define kBorder 16
#define kItemFont [UIFont systemFontOfSize:17]
#define kTitleFont [UIFont systemFontOfSize:25]
@interface GYNOCardRegView()<UITextFieldDelegate>
{
    NSTimer *timer;
    int timeout;
}
@property (weak, nonatomic)  UIButton *btnCancel;
@property (weak, nonatomic)  UILabel *lbTitle;

@property (weak, nonatomic)  UIView *vPhoneNumber;
@property (weak, nonatomic)  UILabel *lbPhoneTitle;
@property (weak, nonatomic)  UITextField *tfHSPhoneInput;

@property (weak, nonatomic)  UIView *vCheckCode;
@property (weak, nonatomic)  UILabel *lbCheckCodeTitle;
@property (weak, nonatomic)  UITextField *tfCheckCodeInput;
@property (weak, nonatomic)  UIButton *btnGetCheckCode;

@property (weak, nonatomic)  UIView *vPassWorld;
@property (weak, nonatomic)  UILabel *lbPassWorldTitle;
@property (weak, nonatomic)  UITextField *tfPassWoldInput;

@property (weak, nonatomic)  UIView *vConfrimPassWorld;
@property (weak, nonatomic)  UILabel *lbConfrimPassWorldTitle;
@property (weak, nonatomic)  UITextField *tfConfrimPassWoldInput;

@property (weak, nonatomic)  UIButton *btnReg;

@property (assign,nonatomic) CGFloat fItemHeight;
@end

@implementation GYNOCardRegView
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
            [self settingsWithoutHistory];
        }
    return self;
}

-(void)settingsWithoutHistory
{
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, 30, 40, 25)];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = kItemFont;
    [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel = btnCancel;
    [self addSubview:self.btnCancel];
    
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btnCancel.frame)+20, kScreenWidth, self.fItemHeight)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"请输入你的手机号";
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.font = kTitleFont;
    self.lbTitle = lbTitle;
    [self addSubview:self.lbTitle];
    
    UIView *vPhoneNumber = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.lbTitle.frame)+50, kScreenWidth - kBorder*2, self.fItemHeight)];
    vPhoneNumber.backgroundColor = [UIColor clearColor];
    self.vPhoneNumber = vPhoneNumber;
    [self addSubview:self.vPhoneNumber];
    
    
    UILabel *lbPhoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vPhoneNumber.frame.size.width*0.3, self.fItemHeight)];
    lbPhoneTitle.backgroundColor = [UIColor clearColor];
    lbPhoneTitle.text = @"手机号";
    lbPhoneTitle.textAlignment = NSTextAlignmentLeft;
    lbPhoneTitle.font = kItemFont;
    self.lbPhoneTitle = lbPhoneTitle;
    [self.vPhoneNumber addSubview:self.lbPhoneTitle];
    
    UITextField *tfHSPhoneInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbPhoneTitle.frame), 0, self.vPhoneNumber.frame.size.width - self.lbPhoneTitle.frame.size.width, self.fItemHeight)];
    tfHSPhoneInput.placeholder = @"输入手机号";
    tfHSPhoneInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    tfHSPhoneInput.delegate = self;
    tfHSPhoneInput.font = kItemFont;
    tfHSPhoneInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfHSPhoneInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfHSPhoneInput = tfHSPhoneInput;
    [self.vPhoneNumber addSubview:self.tfHSPhoneInput];
    
    UIView *vCheckCode = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vPhoneNumber.frame), kScreenWidth - kBorder*2, self.fItemHeight)];
    vCheckCode.backgroundColor = [UIColor clearColor];
    self.vCheckCode = vCheckCode;
    [self addSubview:self.vCheckCode];
    
    
    UILabel *lbCheckCodeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vCheckCode.frame.size.width*0.3, self.fItemHeight)];
    lbCheckCodeTitle.backgroundColor = [UIColor clearColor];
    lbCheckCodeTitle.text = @"验证码";// 修改为验证码
    lbCheckCodeTitle.textAlignment = NSTextAlignmentLeft;
    lbCheckCodeTitle.font = kItemFont;
    self.lbCheckCodeTitle = lbCheckCodeTitle;
    [self.vCheckCode addSubview:self.lbCheckCodeTitle];
    
    UITextField *tfCheckCodeInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbCheckCodeTitle.frame), 0, self.vCheckCode.frame.size.width*0.35, self.fItemHeight)];
    tfCheckCodeInput.placeholder = @"输入验证码";
    tfCheckCodeInput.delegate = self;
    tfCheckCodeInput.font = kItemFont;
    tfCheckCodeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfCheckCodeInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfCheckCodeInput = tfCheckCodeInput;
    [self.vCheckCode addSubview:self.tfCheckCodeInput];
    
    UIButton *btnGetCheckCode = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tfCheckCodeInput.frame),0, self.vCheckCode.frame.size.width*0.35, self.fItemHeight)];
    [btnGetCheckCode setBackgroundColor:[UIColor clearColor]];
    [btnGetCheckCode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnGetCheckCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnGetCheckCode.titleLabel.font = kItemFont;
    [btnGetCheckCode addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
    self.btnGetCheckCode = btnGetCheckCode;
    [self.vCheckCode addSubview:self.btnGetCheckCode];
    
    
    UIView *vPassWorld = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vCheckCode.frame), kScreenWidth - kBorder*2, self.fItemHeight)];
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
    
    UITextField *tfPassWoldInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbPassWorldTitle.frame), 0, self.vPassWorld.frame.size.width - self.lbPassWorldTitle.frame.size.width, self.fItemHeight)];
    tfPassWoldInput.placeholder = @"输入密码";
    tfPassWoldInput.secureTextEntry = YES;
    tfPassWoldInput.delegate = self;
    tfPassWoldInput.font = kItemFont;
    tfPassWoldInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassWoldInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    [tfPassWoldInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfPassWoldInput = tfPassWoldInput;
    [self.vPassWorld addSubview:self.tfPassWoldInput];
    
    UIView *vConfrimPassWorld = [[UIView alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vPassWorld.frame), kScreenWidth - kBorder*2, self.fItemHeight)];
    vConfrimPassWorld.backgroundColor = [UIColor clearColor];
    self.vConfrimPassWorld = vConfrimPassWorld;
    [self addSubview:self.vConfrimPassWorld];
    
    UILabel *lbConfrimPassWorldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.vConfrimPassWorld.frame.size.width*0.3, self.fItemHeight)];
    lbConfrimPassWorldTitle.backgroundColor = [UIColor clearColor];
    lbConfrimPassWorldTitle.text = @"确认密码";
    lbConfrimPassWorldTitle.textAlignment = NSTextAlignmentLeft;
    lbConfrimPassWorldTitle.font = kItemFont;
    self.lbConfrimPassWorldTitle = lbConfrimPassWorldTitle;
    [self.vConfrimPassWorld addSubview:self.lbConfrimPassWorldTitle];
    
    UITextField *tfConfrimPassWoldInput = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbConfrimPassWorldTitle.frame), 0, self.vPassWorld.frame.size.width - self.lbConfrimPassWorldTitle.frame.size.width, self.fItemHeight)];
    tfConfrimPassWoldInput.placeholder = @"重复输入密码";
    tfConfrimPassWoldInput.secureTextEntry = YES;
    tfConfrimPassWoldInput.delegate = self;
    tfConfrimPassWoldInput.font = kItemFont;
    tfConfrimPassWoldInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfConfrimPassWoldInput.keyboardType = UIKeyboardTypeNumberPad;// add by songjk 输入为数字
    [tfConfrimPassWoldInput addTarget:self action:@selector(textChage) forControlEvents:UIControlEventEditingChanged];
    self.tfConfrimPassWoldInput = tfConfrimPassWoldInput;
    [self.vConfrimPassWorld addSubview:self.tfConfrimPassWoldInput];
    
    UIButton *btnReg = [[UIButton alloc] initWithFrame:CGRectMake(kBorder, CGRectGetMaxY(self.vConfrimPassWorld.frame)+35, kScreenWidth - kBorder *2, self.fItemHeight)];
    [btnReg setBackgroundColor:[UIColor redColor]];
    [btnReg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReg setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btnReg setTitle:@"注册" forState:UIControlStateNormal];
    btnReg.titleLabel.font = kItemFont;
    [btnReg addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchUpInside];
    self.btnReg = btnReg;
    self.btnReg.enabled = NO;
    [self addSubview:self.btnReg];

    
    [self.vPhoneNumber addTopBorder];
    [self.vPhoneNumber addBottomBorder];
    [self.vCheckCode addBottomBorder];
    [self.vPassWorld addBottomBorder];
    [self.vConfrimPassWorld addBottomBorder];
}

- (void)textChage
{
    self.btnReg.enabled = [self.tfHSPhoneInput hasText] && [self.tfCheckCodeInput hasText] && [self.tfConfrimPassWoldInput hasText]  && [self.tfPassWoldInput hasText];
}
- (void)ticke:(NSTimer *)t
{
    --timeout;
    NSString *title = [NSString stringWithFormat:@"%d s", timeout];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeout >= 0)
        {
            [self.btnGetCheckCode setTitle:title forState:UIControlStateNormal];
        }else
        {
            [self.btnGetCheckCode  setTitle:kLocalized(@"re_get_verification_code") forState:UIControlStateNormal];
            [timer invalidate];
            timer = nil;
        }
    });
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    NSInteger maxLength = 0;
    if (textField == self.tfHSPhoneInput)
    {
        maxLength = 11;
    }
    else if (textField == self.tfCheckCodeInput)
    {
        maxLength = 6;
    }
    else if (textField == self.tfPassWoldInput)
    {
        maxLength = 6;
    }
    else if (textField == self.tfConfrimPassWoldInput)
    {
        maxLength = 6;
    }

    if (len>maxLength)
    {
        return NO;
    }
    return YES;
}
-(void)cancelClick
{
    [self closeAndRemoveSelf];
}
-(void)getCheckCode
{
    if (timer) return;//正在跑着呢
    
    if (self.tfHSPhoneInput.text.length < 11)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入手机号码" isPopVC:nil];
        return;
    }
    
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"accountNo": self.tfHSPhoneInput.text,
                               @"isCheck": @"0"
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    [self addSubview:hud];
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
                    [self.btnGetCheckCode setEnabled:YES];
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
-(void)reg
{
    NSLog(@"reg");
    NSString *user = self.tfHSPhoneInput.text;
    NSString *pwd1 = self.tfPassWoldInput.text;
    NSString *pwd2 = self.tfConfrimPassWoldInput.text;
    NSString *code = self.tfCheckCodeInput.text;
    
    if (user.length < 11)
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
    pwd1 = [GYencryption l:pwd1 k:self.tfHSPhoneInput.text];
    NSDictionary *allParas = @{@"account": self.tfHSPhoneInput.text,
                               @"pwd": pwd1,
                               @"checkCode": code
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    [self addSubview:hud];
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
                        [self  closeAndRemoveSelf];
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
- (void)closeAndRemoveSelf
{
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
@end

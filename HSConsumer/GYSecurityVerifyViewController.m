//
//  GYSecurityVerifyViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSecurityVerifyViewController.h"
#import "Utils.h"
#import "GYChangeLoginPwdViewController.h"

@interface GYSecurityVerifyViewController ()

@end

@implementation
GYSecurityVerifyViewController
{
    
    __weak IBOutlet UIView *vGetCodeBg;//背景view
    
    __strong IBOutlet UITextField *tfInputCode;//输入密码tf
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"safety_verification");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    //设置分割线
    [self modifyName];
    
    self.lbMessage.text=[NSString stringWithFormat:kLocalized(@"enter_received_message_authentication_code"),@"158*****371"];
    self.lbMessage.textColor=kCellItemTitleColor;
    
    
    //设置btn的背景图片
    [self.btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [self.btnNextStep setTitle:kLocalized(@"confirm_to_submit") forState:UIControlStateNormal];
    
    [self.btnGetCode  setBackgroundImage:[UIImage imageNamed:@"btn_while_bg.png"] forState:UIControlStateNormal];
    
    
    
    [self setTextFieldPlaceHoderText];
    
}

//设置国际化名称
-(void)modifyName
{
    tfInputCode.placeholder=kLocalized(@"input_received_authentication_code");
    [self.btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
}

//设置占位符
-(void)setTextFieldPlaceHoderText
{
    
    [self.btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    
    [Utils setBorderWithView:vGetCodeBg WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [Utils setBorderWithView:self.btnGetCode WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
    
    [Utils setPlaceholderAttributed:tfInputCode withSystemFontSize:17.0 withColor:nil];
    
    [self.btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
}

//获取验证码方法
- (IBAction)getCodeMethod:(id)sender {
    DDLogInfo(@"123456");
    
}

//下一步
- (IBAction)btnToNextPage:(id)sender {
    GYChangeLoginPwdViewController * vcChangeLogin =[[GYChangeLoginPwdViewController alloc]initWithNibName:@"GYChangeLoginPwdViewController" bundle:nil];
    
    [self.navigationController pushViewController:vcChangeLogin animated:YES];
}

@end

//
//  GYChangeLoginPwdViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYChangeLoginPwdViewController.h"
#import "GYSecurityVerifyViewController.h"
#import "Utils.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "GYencryption.h"
#import "NSData+Base64.h"
#import "GYLoginController.h"
@interface GYChangeLoginPwdViewController ()
{

    GlobalData *  data;
}
@end

@implementation GYChangeLoginPwdViewController
{
    
    __weak IBOutlet UIView *lbUpBackground;//背景view
    
    __weak IBOutlet UILabel *lbConfirmPasswd;//背景view
    
    __weak IBOutlet UILabel *lbOldPasswd;//背景view
    
    __weak IBOutlet UIView *vNewPasswordBg;//背景view
    
    __weak IBOutlet UILabel *lbNewPassword;//新密码
    
    __weak IBOutlet UIView *vNewPasswordAgainBg;//再次输入新密码
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    

         self.view.backgroundColor=kDefaultVCBackgroundColor;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [GlobalData shareInstance];
    self.title=kLocalized(@"pwd_change");
    
    _isCardUser = [GlobalData shareInstance].isCardUser;
    
    //修改国际化名称
    [self modifyName];
    //设置文本颜色
    [self setTextColor];
    //设置placeholder 文字大小和内容
    [self setTextFieldPlaceHoderText];
  
}



-(void)loadDataFromNetwork
{
    
    if ([Utils isBlankString:self.OldPassword.text]) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入旧密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:self.NewPassword.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
         return ;
    
    }else if ([Utils isBlankString:self.NewPasswordAgain.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入确认密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
         return ;
    }
    /////这段代码不知有何用！
 else if (![self.NewPassword.text isEqualToString:self.NewPasswordAgain.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入的登录密码不同！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        _NewPasswordAgain.clearsOnBeginEditing=YES;
        return ;
    }
   else if (self.OldPassword.text.length!=6||self.NewPassword.text.length!=6) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入6位登录密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
   else if ([self.OldPassword.text isEqualToString:self.NewPassword.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"旧密码与新密码不能相同，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    //判断是不是数字，不是数字就提示用户  
   else if (![Utils isValidMobileNumber:self.OldPassword.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的旧密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if (![Utils isValidMobileNumber:self.NewPassword.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的新密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    
    }else if (![Utils isValidMobileNumber:self.NewPasswordAgain.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的确认密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    NSString *url;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
   __block  NSString *responseValue=@"0";
    NSString *retCode=@"retCode";
    if (_isCardUser) {
        #pragma mark  用互生号登录修改密码
        NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
        
        [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
        
        [dictInside setValue:self.OldPassword.text forKey:@"old_pwd"];
        [dictInside setValue:self.NewPassword.text   forKey:@"new_pwd"];
        [dict setValue:dictInside forKey:@"params"];
        
        [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
        
        [dict setValue:@"person" forKey:@"system"];
        
        [dict setValue:kuType forKey:@"uType"];
        
        [dict setValue:kHSMac forKey:@"mac"];
        
        [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
        
        [dict setValue:@"change_login_password" forKeyPath:@"cmd"];
        url =[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"];
        responseValue = @"0";
        retCode = @"data";
    } else {
       #pragma mark 用手机登录修改密码
        NSString * str = [GYencryption l:self.NewPassword.text k:[GlobalData shareInstance].user.cardNumber];
        
        NSString * str2 = [GYencryption l:self.OldPassword.text k:[GlobalData shareInstance].user.cardNumber];
        
        dict = @{@"newPwd": str,
                 @"oldPwd": str2,
                 @"key": [GlobalData shareInstance].ecKey};
        
        NSString *urlString = [[GlobalData shareInstance]ecDomain];
        url= [urlString stringByAppendingString:@"/user/modifyPwd"];
        responseValue = @"200";
    }
    
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:url parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        if (error) {
            NSLog(@"%@----",error);
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改密码失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
        else
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view.window];
            NSMutableDictionary *retCodeValue =[[NSMutableDictionary alloc]init];
            NSString * message=@"密码修改失败！";
            NSString * retcodenum;
            if (![ResponseDic isKindOfClass:[NSNull class]]) {
                if([[ResponseDic objectForKey:@"data"] isKindOfClass:[NSNull class ]])/////手机修改密码
                {
                    retcodenum = [ResponseDic objectForKey:retCode ];/////返回的数字
                }
                else{/////互生卡 密码修改
                    retCodeValue = [ResponseDic objectForKey:retCode];
                    retcodenum = [retCodeValue objectForKey:@"resultCode"];////返回的数字
                }
                switch (retcodenum.integerValue) {
                        case 601:{
                            message =@"密码修改失败，旧密码错误！";
                            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [av show];
                        }break;
                          case 103006:
                        {
                            message =@"密码修改失败，旧密码错误！";
                            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [av show];
                        }break;
                        case 200:{
                            message =@"密码修改成功！";
                            [UIAlertView showWithTitle:nil message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                        [self.navigationController popViewControllerAnimated:YES]; }];
                           
                        }break;
                        case 0:
                        {
                            message =@"密码修改成功！";
                             [self logingout];
                            [UIAlertView showWithTitle:nil message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                    ///跳转页面
                                [self.navigationController popViewControllerAnimated:YES];
                               [[GlobalData shareInstance] showLoginInView:nil withDelegate:nil isStay:NO];
                            }];
                           
                        }break;
                        default:
                            break;
                    }
            }
            
        }
        
    }];

}


/////退出
-(void)logingout
{
//                    NSLog(@"确定");
//                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//                    hud.removeFromSuperViewOnHide = YES;
//                    hud.labelText = @"正在退出...";
//                    hud.dimBackground = YES;
//                    [self.view addSubview:hud];
//                    //    hud.labelText = nil;
//                    [hud show:YES];
                    [Network sharedInstance].httpClientTimeout = 5.0f;
                    [Network logoutWithParameters:@{@"userName": data.user.cardNumber, @"mid": data.midKey, @"ecKey": data.ecKey} requetResult:^(NSData *jsonData, NSError *error) {
                        if (!error)
                        {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                options:kNilOptions
                                                                                  error:&error];
                            if (!error)
                            {
                                if (kSaftToNSInteger(dic[@"retCode"]) == 805)//登出成功
                                {
//                                    hud.labelText = @"退出成功！";
                                }
                            }
                        }else
                        {
                            DDLogInfo(@"network error：%@", error);
                        }
                        //不管成不成功
                        [data clearLoginInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];//清空重新刷新聊天界面信息
                }];
}

//设置文本颜色
-(void)setTextColor
{
    [self setBorderWithView:lbUpBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:vNewPasswordBg WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:vNewPasswordAgainBg WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [vNewPasswordAgainBg addBottomBorder];
    self.WaringLabel.textColor=kCellItemTextColor;
    lbConfirmPasswd.textColor=kCellItemTitleColor;
    lbOldPasswd.textColor=kCellItemTitleColor;
    lbNewPassword.textColor=kCellItemTitleColor;
  
}

//设置占位符
-(void)setTextFieldPlaceHoderText
{
    [Utils setPlaceholderAttributed:self.OldPassword withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:self.NewPassword withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:self.NewPasswordAgain withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    
}


//修改国际化名称
-(void)modifyName
{
    lbConfirmPasswd.text=kLocalized(@"confirm_pwd");
    lbOldPasswd.text=kLocalized(@"old_pwd");
    lbNewPassword.text=kLocalized(@"new_pwd");
    self.WaringLabel.text=kLocalized(@"pwd_by_6-20_English_letters,_Numbers,_or_symbols");
    [self.BtnnextStep setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    self.WaringLabel.font=[UIFont systemFontOfSize:14];
    
    //下一步btn
    [self.BtnnextStep setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    self.OldPassword.placeholder=kLocalized(@"input_old_pwd");
    self.NewPassword.placeholder=kLocalized(@"input_new_pwd");
    self.NewPasswordAgain.placeholder=kLocalized(@"input_new_pwd_again");
}


//返回到上级控制器
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//push到下级控制器
- (IBAction)btnNextStep:(id)sender {
    [self loadDataFromNetwork];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    
    if (textField)
    {
       
        if(len > 6) return NO;
        
    }
    NSLog(@"%@",string);
    return [self validateNumber:string];
}

/**
 *  判断是否为数字
 *
 *  @param number 传递需要判断的数字
 *
 *  @return YES为数字，NO为非数字
 */
- (BOOL)validateNumber:(NSString*)number {
 
    NSString *num=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    NSString *string;
    for (int i = 0; i < number.length; i++) {
    string = [number substringWithRange:NSMakeRange(i, 1)];
        
        return [numberPre evaluateWithObject:string];
    }
    return YES;
}


//设置分割线方法。
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}
@end

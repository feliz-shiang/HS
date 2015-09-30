//
//  GYReSetPasswordViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYReSetPasswordViewController.h"
#import "InputCellStypeView.h"
#import "GYencryption.h"
#import "LoginEn.h"
#import "NSData+Base64.h"

@interface GYReSetPasswordViewController ()

@end

@implementation GYReSetPasswordViewController
{

    __weak IBOutlet InputCellStypeView *InputNewPassword;


    __weak IBOutlet InputCellStypeView *InputPasswordAgain;
    __weak IBOutlet UILabel *lbTips;
    
    __weak IBOutlet UIButton *btnConfirm;
    
    NSString * keyForGetPwd;
    
    NSString * cKey;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"重置登录密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
    
    [self getDefaultKey];
}

-(void)modifyName
{
    lbTips.textColor=kCellItemTextColor;
    InputNewPassword.lbLeftlabel.text=kLocalized(@"new_pwd");
    InputNewPassword.tfRightTextField.placeholder=kLocalized(@"input_new_pwd");
    InputPasswordAgain.lbLeftlabel.text=kLocalized(@"confirm_pwd");
    InputPasswordAgain.tfRightTextField.placeholder=kLocalized(@"input_new_pwd_again");
    lbTips.text=kLocalized(@"forget_password_tips");
    [btnConfirm setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"alert_btn_confirm_bg"] forState:UIControlStateNormal];

    [btnConfirm addTarget:self action:@selector(btnConfirm) forControlEvents:UIControlEventTouchUpInside];

}


-(void)getDefaultKey
{
    
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/hs/login"];

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:@"0000" forKey:@"loginId"];
    
    [dict setValue:@"0000" forKey:@"pwd"];
    
    [dict setValue:@"00000000000" forKey:@"acc"];
    
    [dict setValue:@"00000000000" forKey:@"custId"];

    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:@"4a3290d0-0a85-4c29-a62f-8009403e30c3" forKey:@"mId"];
    
    [dict setValue:@"check_password_hint_answer" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * code =ResponseDic[@"code"];
            if ([code isEqualToString:@"SVC0000"]) {
                keyForGetPwd = ResponseDic[@"data"];
                cKey = ResponseDic [@"cKey"];
            }
        
        }
        
    }];
    
}

-(void)btnConfirm
{
    
    if (self.fromNocard) {
        
       [self loadDataForNocard];
        
    }else
    {
       [self loadDataFromNetwork];
    
    }
    
 
    
    
}


//无卡找回密码的request
-(void)loadDataForNocard
{

    
    
    [self checkPassword];
    
    
     NSString *pwd = [GYencryption l:InputNewPassword.tfRightTextField.text k:_resourceNumber];
    NSDictionary *allParas = @{@"account": _resourceNumber,
                               @"newPwd": pwd
                               };
    NSString *urlString = [[GlobalData shareInstance]ecDomain];
    
    urlString = [urlString stringByAppendingString:@"/user/modifyPwdForFind"];

    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
            
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * retCode =kSaftToNSString(ResponseDic[@"retCode"]);
            if ([retCode isEqualToString:@"200"]) {
                
                [UIAlertView showWithTitle:nil message:@"成功重置密码！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex != 0)
                        
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }];
                
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }
       }
        
    }];



}



-(BOOL)checkPassword
{

    if ([Utils  isBlankString:InputNewPassword.tfRightTextField.text]) {
        [Utils showMessgeWithTitle:nil message:@"请输入新密码" isPopVC:nil];
        return NO ;
    }
    
    if ([Utils isBlankString:InputPasswordAgain.tfRightTextField.text]) {
        [Utils showMessgeWithTitle:nil message:@"请输入确认密码" isPopVC:nil];
        return  NO;
    }
    
    if (![InputNewPassword.tfRightTextField.text isEqualToString:InputPasswordAgain.tfRightTextField.text]) {
        [Utils showMessgeWithTitle:nil message:@"密码输入不一致！" isPopVC:nil];
        return NO ;
    }
    
    if (!(InputPasswordAgain.tfRightTextField.text.length==6)) {
        [Utils showMessgeWithTitle:nil message:@"请输入6位登录密码！" isPopVC:nil];
        return NO;
    }
    
    if (!(cKey.length>1)) {
        [Utils showMessgeWithTitle:nil message:@"获取数据失败，请重试！" isPopVC:nil];
        return NO;
    }
    

    return YES;
}

//有卡找回密码的request
-(void)loadDataFromNetwork
{
    
  
    if ([self checkPassword]) {

        //判断是不是数字，不是数字就提示用户
        if (![Utils isValidMobileNumber:_resourceNumber]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的资源号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return;
        }else if (![Utils isValidMobileNumber:InputNewPassword.tfRightTextField.text])
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的新密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return;
            
        }
        
    NSString *str = [NSString stringWithFormat:@"{resource_no=%@,new_pwd=%@}", _resourceNumber, InputNewPassword.tfRightTextField.text];
 
    str = [GYencryption h2:str k:cKey];
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    str = [strData base64EncodedString];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [Network urlEncoderParameter:str];
     

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];

    [dict setValue:str forKey:@"params"];
    
   
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];
    
    [dict setValue:keyForGetPwd forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [Utils getRandomString:6]}];
    
    [dict setValue:@"reset_password" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
                [UIAlertView showWithTitle:nil message:@"成功重置密码！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                   
                        [self.navigationController popToRootViewControllerAnimated:YES];
                   
                    
                }];
                
               
                
                
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }
            
        }
        
       }];
    
    }


}

#pragma mark 只能输入6位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField)
    {
        if(len > 6) return NO;
        
    }
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
    NSString *string ;
    for (int i = 0; i < number.length; i++) {
        string = [number substringWithRange:NSMakeRange(i, 1)];
        return [numberPre evaluateWithObject:string];
    }
    return YES;
}


@end

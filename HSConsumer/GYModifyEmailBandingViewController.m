//
//  GYQuitEmailBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYModifyEmailBandingViewController.h"
#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
@interface GYModifyEmailBandingViewController ()

@end

@implementation GYModifyEmailBandingViewController
{
    
    __weak IBOutlet UILabel *lbTips;
    
    __weak IBOutlet UIButton *btnNextStep;
    
    __weak IBOutlet InputCellStypeView *InputOldEmail;
    
    __weak IBOutlet InputCellStypeView *InputNewEmail;
    
    __weak IBOutlet InputCellStypeView *InputPasswordRow;
    
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
    //国际化修改名称
    [self modifyName];
    //设置分割线
    [self setSeprator];
    
}

-(void)setSeprator
{
//    [vDownBgView addAllBorder];
    
}

-(void)modifyName
{
    self.title=kLocalized(@"modify_email");
    
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnNextStep setTitle:@"立即修改"   forState:UIControlStateNormal];
    
    InputOldEmail.lbLeftlabel.text=@"新邮箱";
    InputOldEmail.tfRightTextField.placeholder=@"输入新邮箱";
    InputNewEmail.lbLeftlabel.text=@"确认邮箱";
    InputNewEmail.tfRightTextField.placeholder=@"再次输入新邮箱";
    InputPasswordRow.lbLeftlabel.text=@"密码验证";
    InputPasswordRow.tfRightTextField.placeholder=@"输入6位登录密码";
    
    //设置提示信息
    lbTips.textColor=kCellItemTextColor;
    lbTips.text=kLocalized(@"quit_email_banding_tips");
    
}

-(void)loadDataFromNetwork
{
    if ([Utils isBlankString:InputNewEmail.tfRightTextField.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入新邮箱！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if ([Utils isBlankString:InputOldEmail.tfRightTextField.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入旧邮箱！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else if ([Utils isBlankString:InputPasswordRow.tfRightTextField.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    
    
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:InputNewEmail.tfRightTextField.text forKey:@"email"];
    [dictInside setValue:InputPasswordRow.tfRightTextField.text   forKey:@"pwd"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    [dict setValue:@"change_bind_email" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"123578");
                
                [self PopAlertview];
            }
            
        }
        
    }];
    
}

- (IBAction)btnGotoNextPage:(id)sender
{
 
    [self loadDataFromNetwork];

    

    
}
-(void)PopAlertview
{

    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定",nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        [alertView close];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];




}
-(UIView *)createUI
{
    
    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 130)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;
    
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 50,50)];
    successImg.image=[UIImage imageNamed:@"img_email_banding.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 12, 200, 30)];
    lbTip.text=kLocalized(@"has_send_email");
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardNumberTmp =[[UILabel alloc]initWithFrame:CGRectMake(lbTip.frame.origin.x, lbTip.frame.origin.y+lbTip.frame.size.height+2, 160, 30)];
    lbCardNumberTmp.text=InputNewEmail.tfRightTextField.text;
    lbCardNumberTmp.textColor=kCellItemTitleColor;
    lbCardNumberTmp.font=[UIFont systemFontOfSize:17.0];
    lbCardNumberTmp.backgroundColor=[UIColor clearColor];
    UILabel *  lbBandLocation =[[UILabel alloc]initWithFrame:CGRectMake(lbCardNumberTmp.frame.origin.x,lbCardNumberTmp.frame.origin.y+lbCardNumberTmp.frame.size.height, 180, 30)];
    lbBandLocation.text=kLocalized(@"login_your_email_finishBanding");
    lbBandLocation.textColor=kCellItemTitleColor;
    lbBandLocation.font=[UIFont systemFontOfSize:14.0];
    lbBandLocation.backgroundColor=[UIColor clearColor];
    [popView addSubview:successImg];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardNumberTmp];
    [popView addSubview:lbBandLocation];
    
    return popView;
}


-(void)disappearPopView
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}
#pragma mark textfield Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag==10) {
        _strOldMail=textField.text;
    }else{
        _strNewMail=textField.text;
    
    }
       

}
@end

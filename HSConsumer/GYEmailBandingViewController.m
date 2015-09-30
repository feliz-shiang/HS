//
//  GYEmailBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEmailBandingViewController.h"
#import "CustomIOS7AlertView.h"
#import "Utils.h"
#import "UILabel+LineSpace.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "InputCellStypeView.h"

@interface GYEmailBandingViewController ()

@end

@implementation GYEmailBandingViewController

{
    
    
    __weak IBOutlet UIView *vTopBgView;//顶部的背景VIEW
    
    __weak IBOutlet UIImageView *imgMiddleSeprator;//分割线
    
    __weak IBOutlet UITextField *tfBandingEmail;//输入邮箱的文本框
    
    __weak IBOutlet UILabel *lbTips;//上面的提示信息
    
    __weak IBOutlet UIButton *btnGoNext;//到下一页的btn
    
    __weak IBOutlet UILabel *lbEmail;//邮箱的LABEL
    
    __weak IBOutlet InputCellStypeView *comfirmEmailRows;
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
 
}


- (IBAction)btnAction:(id)sender {
    [self.view endEditing:YES];
    
    DDLogInfo(@"发起网络请求");
    [self HttpRequestForBindEmail];

}

-(void)loadDataFromNetwork
{
    
    
    if ([Utils isBlankString:self.strEmail]) {
        
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入邮箱" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else if (![Utils isValidateEmail:self.strEmail])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入确认邮箱" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else{
        if (![self.strEmail isEqualToString:self.strConfirmEmail]) {
            
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"邮箱输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
        }
    
    }
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
 
    [dictInside setValue:self.strConfirmEmail forKey:@"email"];
  
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    [dict setValue:@"send_bind_email_mail" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"]
 parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                [self showCustomAlertView];
            }
            
        }
        
    }];
    
}

-(void)HttpRequestForBindEmail
{
    
    if ([Utils isBlankString:self.strEmail]) {
        
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入邮箱" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else if (![Utils isValidateEmail:self.strEmail])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确邮箱" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else{
        if (![self.strEmail isEqualToString:self.strConfirmEmail]) {
            
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"邮箱输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [av show];
            return ;
            
        }
        
    }
    
    
    
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:self.strConfirmEmail forKey:@"email"];
    
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    [dict setValue:@"bind_email" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"]
                      parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
                          
                          
                          if (error) {
                              NSLog(@"%@----",error);
                          }else{
                              
                              NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                      
                              [Utils hideHudViewWithSuperView:self.view];
                              if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
//                                  [GlobalData shareInstance].user.isEmailBinding=YES;
//                                  [GlobalData shareInstance].personInfo.emailFlag=@"Y";
                                  [self showCustomAlertView];
                              }
                              
                          }
                          
                      }];
    
}


-(void)showCustomAlertView
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
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
    lbCardNumberTmp.text=self.strConfirmEmail;
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

//点击弹出的确认按钮，删除弹出的视图，返回到上级控制器。
-(void)disappearPopView
{
    
    [self performSelector:@selector(backToRootVC) withObject:nil afterDelay:0.24];
    
    
}


-(void )backToRootVC
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"email_binding");
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    tfBandingEmail.placeholder=kLocalized(@"input_binding_email");
    tfBandingEmail.textColor=kCellItemTitleColor;
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    lbEmail.text=kLocalized(@"email");
    
    lbTips.text=kLocalized(@"email_banding_tips");
    [btnGoNext setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    comfirmEmailRows.lbLeftlabel.text=@"确认邮箱";
    comfirmEmailRows.tfRightTextField.placeholder=@"再次输入绑定邮箱";
    
    [self setSprator];
    [self setTextColor];
    [lbTips setLineSpace:4.0 WithLabel:lbTips WithText:kLocalized(@"email_banding_tips")
     ];
}


-(void)setTextColor
{
    lbEmail.textColor=kCellItemTitleColor;
    lbTips.textColor=kCellItemTextColor;
    [btnGoNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}


-(void)setSprator
{
   
    [self setBorderWithView:imgMiddleSeprator WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];

    [vTopBgView addAllBorder];

}


-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
  
}


#pragma mark  textfield代理方法
//textfield代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
           
                self.strEmail=textField.text;
        }
            break;
        case 2:
        {
                self.strConfirmEmail  =textField.text;
            
        }
            break;
        default:
            break;
    }
    
    
}


@end

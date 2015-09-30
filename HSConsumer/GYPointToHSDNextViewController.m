//
//  GYPointToCashViewNextController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分转现下一步页面

#import "GYPointToHSDNextViewController.h"
#import "InputCellStypeView.h"
#import "CustomIOS7AlertView.h"
#import "GYPointToHSDViewController.h"
#import "ResultDialog.h"
#import "GlobalData.h"

@interface GYPointToHSDNextViewController ()<UITextFieldDelegate>
{
    IBOutlet InputCellStypeView *viewRowPointToCashAmount;  //本次转现积分行
    IBOutlet InputCellStypeView *viewRowToAmount;   //转入账户
    IBOutlet InputCellStypeView *viewRowCurrency;           //币种行 //20150506隐藏
    IBOutlet InputCellStypeView *viewRowPointToCashRate;    //转现比例行
    IBOutlet InputCellStypeView *viewRowHSDAmount;         //转成现金数
    IBOutlet InputCellStypeView *viewPWD;   //交易密码
    IBOutlet UIButton *btnOK;   //确认按钮
    GlobalData *data;//全局单例
}

@end

@implementation GYPointToHSDNextViewController

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

    //设置背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //实例化单例
    data = [GlobalData shareInstance];

    //设置交易密码
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;

    viewRowPointToCashAmount.lbLeftlabel.text = kLocalized(@"number_of_point_to_hsd");
    [viewRowPointToCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
    [viewRowPointToCashAmount.tfRightTextField setFont:kCellTitleBoldFont];
    viewRowPointToCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue];

    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"HS_accounts");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency2");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;

    viewRowPointToCashRate.lbLeftlabel.text = kLocalized(@"proportion_of_points_to_cash");
    [viewRowPointToCashRate.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowPointToCashRate.tfRightTextField.text = [NSString stringWithFormat:@"%.4f", data.user.pointToHSDRate];
    
    viewRowHSDAmount.lbLeftlabel.text = kLocalized(@"converted_to_hsd_now");
    [viewRowHSDAmount.tfRightTextField setFont:kCellTitleBoldFont];
    [viewRowHSDAmount.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowHSDAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue * data.user.pointToHSDRate];
    
    //设置 确认按钮
    [btnOK setTitle:kLocalized(@"confirm_to_submit") forState:UIControlStateNormal];
    [btnOK.titleLabel setFont:kButtonTitleDefaultFont];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
}

//确认操作
- (void)btnOKClick:(id)sender
{
    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }
    [self integral_transfer_hsb];
}

- (void)showResultTitle:(NSString *)title isSucceed:(BOOL)isSucceed
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    ResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialog class]) owner:self options:nil] lastObject];
    [dialog showWithTitle:title isSucceed:isSucceed];
    
    [alertView setContainerView:dialog];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        for (UIViewController *aViewController in allViewControllers) {
//            if ([aViewController isKindOfClass:[GYPointToCashViewController class]]) {
//                [self.navigationController popToViewController:aViewController animated:YES];
//            }
//        }
        [self.navigationController popViewControllerAnimated:YES];
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
    alertView.lineView.hidden = YES;
    alertView.lineView1.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 网络数据交换
- (void)integral_transfer_hsb//转现数只可为整数，不可带数点
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"transfer_integral": [@((int)self.inputValue) stringValue],
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"integral_transfer_hsb",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
//    hud.labelText = @"初始化数据...";
    [hud show:YES];

    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            DDLogInfo(@"integral_transfer_hsb dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
//                    dic = dic[@"data"];
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:kLocalized(@"points_to_hsd_succeed") isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:kLocalized(@"points_to_hsd_failed") isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:kLocalized(@"points_to_hsd_failed") isSucceed:NO];
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
    if (textField == viewPWD.tfRightTextField)
    {
        if(len > 8) return NO;
        
    }
    return YES;
}

@end

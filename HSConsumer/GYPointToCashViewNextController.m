//
//  GYPointToCashViewNextController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分转现下一步页面

#import "GYPointToCashViewNextController.h"
#import "InputCellStypeView.h"
#import "CustomIOS7AlertView.h"
#import "GYPointToCashViewController.h"
#import "ResultDialog.h"
#import "GlobalData.h"

@interface GYPointToCashViewNextController ()<UITextFieldDelegate>
{
//    IBOutlet UILabel *lbLabelDetail;//详情标题
    IBOutlet InputCellStypeView *viewRowPointToCashAmount;  //本次转现积分行
    IBOutlet InputCellStypeView *viewRowToAmount;   //转入账户
    IBOutlet InputCellStypeView *viewRowCurrency;           //币种行
    IBOutlet InputCellStypeView *viewRowPointToCashRate;    //转现比例行
    IBOutlet InputCellStypeView *viewRowCashAmount;         //转成现金数
    IBOutlet InputCellStypeView *viewPWD;               //交易密码
    IBOutlet UIButton *btnOK;       //确认按钮
    GlobalData *data;//全局单例

}

@end

@implementation GYPointToCashViewNextController

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
    //清除下一级页面返回按钮的文字
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

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

    viewRowPointToCashAmount.lbLeftlabel.text = kLocalized(@"number_of_turn_to_cash");
    [viewRowPointToCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
    [viewRowPointToCashAmount.tfRightTextField setFont:kCellTitleBoldFont];
    viewRowPointToCashAmount.tfRightTextField.text = self.strPointToCashAmount;

    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"cash_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowCurrency.tfRightTextField.text = self.strCurrency;

    viewRowPointToCashRate.lbLeftlabel.text = kLocalized(@"proportion_of_points_to_cash");
    [viewRowPointToCashRate.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowPointToCashRate.tfRightTextField.text = self.strPointToCashRate;
    
    viewRowCashAmount.lbLeftlabel.text = kLocalized(@"converted_to_cash_now");
    [viewRowCashAmount.tfRightTextField setFont:kCellTitleBoldFont];
    [viewRowCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue * data.user.pointToCashRate];
    
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
    [self integral_transfer_cash];
//    DDLogDebug(@"OK");
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        [self showResultTitle:@"交订单" isSucceed:YES];
//		[hud removeFromSuperview];
//	}];

}

- (void)showResultTitle:(NSString *)title isSucceed:(BOOL)isSucceed
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    ResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialog class]) owner:self options:nil] lastObject];

//    ResultDialogRows5 *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialogRows5 class]) owner:self options:nil] lastObject];
//    dialog.lbTitle.text = kLocalized(@"order_transfer_successfully");
//    dialog.viewResultRow0.lbLeftlabel.text = kLocalized(@"trading_serial_number");
//    dialog.viewResultRow0.tfRightTextField.text = @"WJD12312789416";
//
//    dialog.viewResultRow1.lbLeftlabel.text = viewRowPointToCashAmount.lbLeftlabel.text;
//    dialog.viewResultRow1.tfRightTextField.text = viewRowPointToCashAmount.tfRightTextField.text;
//    dialog.viewResultRow1.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow1.tfRightTextField.font.pointSize];//设置粗体
//
//    
//    dialog.viewResultRow2.lbLeftlabel.text = viewRowPointToCashRate.lbLeftlabel.text;
//    dialog.viewResultRow2.tfRightTextField.text = viewRowPointToCashRate.tfRightTextField.text;
//    
//    dialog.viewResultRow3.lbLeftlabel.text = viewRowCurrency.lbLeftlabel.text;
//    dialog.viewResultRow3.tfRightTextField.text = viewRowCurrency.tfRightTextField.text;
//
//    dialog.viewResultRow4.lbLeftlabel.text = viewRowCashAmount.lbLeftlabel.text;
//    dialog.viewResultRow4.tfRightTextField.text = viewRowCashAmount.tfRightTextField.text;
//    dialog.viewResultRow4.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow4.tfRightTextField.font.pointSize];//设置粗体
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

//
////按钮代理回调事件设置
//- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
//{
//    NSLog(@"呵呵好: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
//    [alertView close];
//}

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
- (void)integral_transfer_cash//转现数只可为整数，不可带数点
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"transfer_integral": [@((int)self.inputValue) stringValue],
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"integral_transfer_cash",
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
            DDLogInfo(@"integral_transfer_cash dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
//                    dic = dic[@"data"];
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:kLocalized(@"points_to_cash_succeed") isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:kLocalized(@"points_to_cash_failed") isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:kLocalized(@"points_to_cash_failed") isSucceed:NO];
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

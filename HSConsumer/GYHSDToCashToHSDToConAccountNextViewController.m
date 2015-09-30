//
//  GYHSDToCashToHSDToConAccountNextViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分投资下一步页面

#import "GYHSDToCashToHSDToConAccountNextViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "CustomIOS7AlertView.h"
#import "ResultDialog.h"
#import "GYHSDToCashToHSDToConAccountViewController.h"

@interface GYHSDToCashToHSDToConAccountNextViewController ()<MBProgressHUDDelegate, UITextFieldDelegate>
{
    IBOutlet InputCellStypeView *viewRowInputPointInvestAmount;
    IBOutlet InputCellStypeView *viewPWD;               //交易密码
    IBOutlet UILabel *lbTipConfirm; //提示不可撤销

    GlobalData *data;             //全局单例
    IBOutlet UIButton *btnOK;     //确认按钮

}

@end

@implementation GYHSDToCashToHSDToConAccountNextViewController

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

    //实例化单例
    data = [GlobalData shareInstance];
    
//    fwefwefwe
    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    [lbTipConfirm setTextColor:kCellItemTextColor];
    lbTipConfirm.text = kLocalized(@"hsdtocash_to_hsdcont_tip");
    
    //设置交易密码
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;

    
//    viewRowInputPointInvestAmount.lbLeftlabel.text =  kLocalized(self.HSDToCashToAccountType == kHSDToCashToAccountTypeToHSDCon ? @"hsdtocash_to_hsdcon_amount_detail" : @"hsdtocash_to_cash_amount_detail");
    viewRowInputPointInvestAmount.lbLeftlabel.text =  kLocalized(@"hsdtocash_to_hsdcon_amount");
    [viewRowInputPointInvestAmount.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowInputPointInvestAmount.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", self.inputValue];
    
    //设置 确认按钮
    [btnOK setTitle:kLocalized(@"confirm_to_submit") forState:UIControlStateNormal];
    [btnOK.titleLabel setFont:kButtonTitleDefaultFont];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];

}

//确认操作
- (void)btnOKClick:(id)sender
{
    DDLogDebug(@"OK");
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.customView = [[UIImageView alloc] initWithImage:kLoadPng(@"img_succeed")];
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.delegate = self;
//        HUD.labelText = @"投资成功";
//        [HUD show:YES];
//        [HUD hide:YES afterDelay:1];
//        
//		[hud removeFromSuperview];
//	}];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }

    [self hsb_transfer_consume];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(0.5);
//	} completionBlock:^{
//        [self showResult];
//		[hud removeFromSuperview];
//	}];
}

//- (void)showResult
//{
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//    ResultDialogRows2 *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialogRows2 class]) owner:self options:nil] lastObject];
//    dialog.lbTitle.text = kLocalized(@"order_transfer_successfully");
//    
//    dialog.viewResultRow0.lbLeftlabel.text = kLocalized(@"trading_serial_number");
//    dialog.viewResultRow0.tfRightTextField.text = @"WJD12312789416";
//    
//    dialog.viewResultRow1.lbLeftlabel.text = viewRowInputPointInvestAmount.lbLeftlabel.text;
//    dialog.viewResultRow1.tfRightTextField.text = viewRowInputPointInvestAmount.tfRightTextField.text;
//    dialog.viewResultRow1.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow1.tfRightTextField.font.pointSize];//设置粗体
//    
//    [alertView setContainerView:dialog];
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
//    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        for (UIViewController *aViewController in allViewControllers) {
//            if ([aViewController isKindOfClass:[GYHSDToCashToHSDToConAccountViewController class]]) {
//                [self.navigationController popToViewController:aViewController animated:YES];
//            }
//        }        [alertView close];
//    }];
//    [alertView setUseMotionEffects:true];
//    [alertView show];
//}


#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 网络数据交换
- (void)hsb_transfer_consume//互生币转消费
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"amount": [@(self.inputValue) stringValue],
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"hsb_transfer_consume",
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
            DDLogInfo(@"hsb_transfer_consume dic:%@", dic);
            if (!error)
            {
                if ([dic[@"code"] isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    ([dic[@"data"][@"resultCode"] intValue] == kHSRequestSucceedSubCode))//返回成功数据
                {
                    //                    dic = dic[@"data"];
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:@"互生币转消费成功" isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:@"互生币转消费失败" isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:@"互生币转消费失败" isSucceed:NO];
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

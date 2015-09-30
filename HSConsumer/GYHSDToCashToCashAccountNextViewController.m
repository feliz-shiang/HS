//
//  GYHSDToCashToCashAccountNextViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYHSDToCashToCashAccountNextViewController.h"
#import "InputCellStypeView.h"
#import "CustomIOS7AlertView.h"
#import "GYPointToCashViewController.h"
#import "ResultDialog.h"
#import "GlobalData.h"

@interface GYHSDToCashToCashAccountNextViewController ()<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet InputCellStypeView *viewRowToCashAmount;   //本次转现行    
    
    IBOutlet InputCellStypeView *viewRowToAmount;  //转入账户
    IBOutlet InputCellStypeView *viewRowActualToAmount;//实际转入数量
    
    IBOutlet InputCellStypeView *viewRowToCashFeeAmount;//手续费行
    IBOutlet InputCellStypeView *viewRowCurrency;       //币种行
    IBOutlet InputCellStypeView *viewRowToCashRate;     //转现比例行
    IBOutlet InputCellStypeView *viewRowCashAmount;     //转成现金数
    IBOutlet InputCellStypeView *viewPWD;               //交易密码
    IBOutlet UIButton *btnOK;       //确认按钮
    
    GlobalData *data;             //全局单例
}

@end

@implementation GYHSDToCashToCashAccountNextViewController

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
    
    //实例化单例
    data = [GlobalData shareInstance];

    //设置背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnOK.frame) + 80)];

    //设置交易密码
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;

    viewRowToCashAmount.lbLeftlabel.text = kLocalized(@"input_hsdtocash_to_cash_amount");
    [viewRowToCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
    [viewRowToCashAmount.tfRightTextField setFont:kCellTitleBoldFont];
    viewRowToCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue];

    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"cash_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowActualToAmount.lbLeftlabel.text = kLocalized(@"hsd_to_cash_actual_amount");
    [viewRowActualToAmount.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowToCashFeeAmount.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_fee");
    [viewRowToCashFeeAmount.tfRightTextField setTextColor:kValueRedCorlor];
//    viewRowToCashFeeAmount.tfRightTextField.text = @"待接口";
    
    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;

    viewRowToCashRate.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_rate");
    [viewRowToCashRate.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowToCashRate.tfRightTextField.text = [NSString stringWithFormat:@"%.4f", data.user.hsdToCashRate];
    
    viewRowCashAmount.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_amount");
    [viewRowCashAmount.tfRightTextField setFont:kCellTitleBoldFont];
    [viewRowCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
//    viewRowCashAmount.tfRightTextField.text = self.strCashAmount;
    
    //设置 确认按钮
    [btnOK setTitle:kLocalized(@"confirm_to_submit") forState:UIControlStateNormal];
    [btnOK.titleLabel setFont:kButtonTitleDefaultFont];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self hsb_transfer_cash_confirm_data];
}

//确认操作
- (void)btnOKClick:(id)sender
{
    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }
    [self hsb_transfer_cash];
//    DDLogDebug(@"OK");
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        [self showResult];
//		[hud removeFromSuperview];
//	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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

#pragma mark - 网络数据交换
- (void)hsb_transfer_cash_confirm_data//获取转换
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"amount": [@(self.inputValue) stringValue]
                               };
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"hsb_transfer_cash_confirm_data",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            DDLogInfo(@"hsb_transfer_cash_confirm_data dic:%@", dic);
            if (!error)
            {
                if ([dic[@"code"] isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    ([dic[@"data"][@"resultCode"] intValue] == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    viewRowToCashFeeAmount.tfRightTextField.text = [Utils formatCurrencyStyle:[dic[@"toCashFee"] doubleValue]];;
                    double v = [dic[@"toActAmount"] doubleValue];
                    viewRowActualToAmount.tfRightTextField.text = [Utils formatCurrencyStyle:v];
                    viewRowCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:v * data.user.hsdToCashRate];
                    
                }else   //返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取转换费失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取转换费失败." isPopVC:self.navigationController];
            }
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:self.navigationController];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - 网络数据交换
- (void)hsb_transfer_cash//互生币转货币
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"amount": [@(self.inputValue) stringValue],
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"hsb_transfer_cash",
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
            DDLogInfo(@"hsb_transfer_cash dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    //                    dic = dic[@"data"];
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:kLocalized(@"hsd_to_cask_succeed") isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:kLocalized(@"hsd_to_cask_failed") isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:kLocalized(@"hsd_to_cask_failed") isSucceed:NO];
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

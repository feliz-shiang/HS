//
//  GYConfirmTransferInfoViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "Utils.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "GYCashBuyHSBNextViewController.h"
#import "ViewTransferResultDialog.h"
#import "ResultDialog.h"

@interface GYCashBuyHSBNextViewController ()<MBProgressHUDDelegate, UITextFieldDelegate>
{
    GlobalData *data;   //全局单例
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet InputCellStypeView *viewPWD;//交易密码
    IBOutlet UIButton *btnConfirm;//确认汇款 按钮
    
    IBOutlet InputCellStypeView *viewRowBuyHSDAmount;//输入金额行
    IBOutlet InputCellStypeView *viewRowChangeConvertCash;  //折合货币金额
    IBOutlet InputCellStypeView *viewRowToAmount;   //支付账户
    IBOutlet InputCellStypeView *viewRowShouldPaymentAmount;//应支付金额
}
@end

@implementation GYCashBuyHSBNextViewController

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
    
    //实例化单例
    data = [GlobalData shareInstance];
    
    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnConfirm.frame) + 80)];
    
    //添加点击隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];

    InputCellStypeView *vTmp = nil;
    for (id v in scvContainer.subviews)
    {
        if ([v isKindOfClass:[InputCellStypeView class]] && v != viewPWD)
        {
            vTmp = v;
            vTmp.tfRightTextField.textColor = kValueRedCorlor;
            if (vTmp == viewRowShouldPaymentAmount)//设置粗体
            {
                vTmp.tfRightTextField.font = kCellTitleBoldFont;
            }
        }
    }
    
    viewRowBuyHSDAmount.lbLeftlabel.text = kLocalized(@"buy_hsb_amount");
    viewRowBuyHSDAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue];
    
    viewRowToAmount.lbLeftlabel.text = kLocalized(@"pay_use_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"cash_account");

    viewRowChangeConvertCash.lbLeftlabel.text = kLocalized(@"buy_hsd_change_convert_cash");
    viewRowShouldPaymentAmount.lbLeftlabel.text = kLocalized(@"buy_hsd_should_payment_amount");
    double v1 = data.user.hsdToCashRate * self.inputValue;
    double v2 = data.user.hsdToCashRate * self.inputValue;
    [viewRowChangeConvertCash.tfRightTextField setText:[Utils formatCurrencyStyle:v1]];
    [viewRowShouldPaymentAmount.tfRightTextField setText:[Utils formatCurrencyStyle:v2]];
    
    //交易密码
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;
    
    [btnConfirm setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:kButtonTitleDefaultFont];
    [btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
}

//确认汇款按钮点击事件
- (void)btnConfirmClick:(id)sender
{
    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }
    [self person_buying_hsb];
}

- (void)showResultTitle:(NSString *)title isSucceed:(BOOL)isSucceed
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    ResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialog class]) owner:self options:nil] lastObject];
    [dialog showWithTitle:title isSucceed:isSucceed];
    [alertView setContainerView:dialog];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
    alertView.lineView.hidden = YES;
    alertView.lineView1.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 网络数据交换
- (void)person_buying_hsb//购互生币-货币支付
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"amount": [@((int)self.inputValue) stringValue],
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"person_buying_hsb",
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
            DDLogInfo(@"person_buying_hsb dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:kLocalized(@"cash_buy_hsd_succeed") isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:kLocalized(@"cash_buy_hsd_failed") isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:kLocalized(@"cash_buy_hsd_failed") isSucceed:NO];
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

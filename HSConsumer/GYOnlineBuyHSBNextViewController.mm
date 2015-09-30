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
#import "GYOnlineBuyHSBNextViewController.h"
#import "ViewTransferResultDialog.h"
#import "ResultDialog.h"
#import "UPPayPlugin.h"

@interface GYOnlineBuyHSBNextViewController ()<MBProgressHUDDelegate, UPPayPluginDelegate>
{
    GlobalData *data;   //全局单例
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet UIButton *btnConfirm;//确认汇款 按钮
    
    IBOutlet InputCellStypeView *viewRowOrderNo; //订单号
    IBOutlet InputCellStypeView *viewRowBuyHSDAmount;//输入金额行
    IBOutlet InputCellStypeView *viewRowToHSDRate; //转换比例行
    IBOutlet InputCellStypeView *viewRowCurrency;   //币种行
    
    IBOutlet InputCellStypeView *viewRowChangeConvertCash;  //折合货币金额
    IBOutlet InputCellStypeView *viewRowUseAmount;   //支付账户
    
    IBOutlet InputCellStypeView *viewRowActual;     //到账金额
    NSDictionary *payDic;
    NSString *tnCode;//银联支付code
}
@end

@implementation GYOnlineBuyHSBNextViewController

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
    tnCode = @"";
    
    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(btnConfirm.frame) + 80)];
    
    //添加点击隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];

    InputCellStypeView *vTmp = nil;
    for (id v in scvContainer.subviews)
    {
        if ([v isKindOfClass:[InputCellStypeView class]])
        {
            vTmp = v;
            vTmp.tfRightTextField.textColor = kValueRedCorlor;
            if (vTmp == viewRowBuyHSDAmount || vTmp == viewRowActual)//设置粗体
            {
                vTmp.tfRightTextField.font = kCellTitleBoldFont;
            }
        }
    }
    
    viewRowOrderNo.lbLeftlabel.text = kLocalized(@"online_buy_hsd_order_no");
    viewRowOrderNo.tfRightTextField.text = @"--";
    [Utils setFontSizeToFitWidthWithLabel:viewRowOrderNo.tfRightTextField labelLines:1];
    
    viewRowBuyHSDAmount.lbLeftlabel.text = kLocalized(@"buy_hsb_amount");
    viewRowBuyHSDAmount.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue];
    
    viewRowToHSDRate.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_rate");
//    viewRowToHSDRate.tfRightTextField.text =  @"你猜";
    viewRowToHSDRate.tfRightTextField.text = [NSString stringWithFormat:@"%.4f", data.user.hsdToCashRate];

    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;
    
    viewRowChangeConvertCash.lbLeftlabel.text = kLocalized(@"buy_hsd_change_convert_cash");
    double v1 = data.user.hsdToCashRate * self.inputValue;
    [viewRowChangeConvertCash.tfRightTextField setText:[Utils formatCurrencyStyle:v1]];

    viewRowUseAmount.lbLeftlabel.text = kLocalized(@"pay_use_account");
    viewRowUseAmount.tfRightTextField.text = kLocalized(@"uppay_bank_account");
    
    //到账金额
    viewRowActual.lbLeftlabel.text = kLocalized(@"buy_hsd_should_payment_amount");
//    viewRowActual.tfRightTextField.text = @"你再猜";
    viewRowActual.tfRightTextField.text = [Utils formatCurrencyStyle:data.user.hsdToCashRate * self.inputValue];

    [btnConfirm setTitle:kLocalized(@"online_buy_hsd_go_to_pay") forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:kButtonTitleDefaultFont];
    [btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self get_person_buying_hsb_ebank_pay_params];
}

//确认汇款按钮点击事件
- (void)btnConfirmClick:(id)sender
{
    if (tnCode.length < 1)
    {
        DDLogInfo(@"不存在tn code。");
        [Utils showMessgeWithTitle:nil message:kLocalized(@"提交失败(无法获取支付流水号)。") isPopVC:self.navigationController];
        return;
    }
    NSLog(@"kUPPayPluginMode:%@", kUPPayPluginMode);
    [UPPayPlugin startPay:tnCode mode:kUPPayPluginMode viewController:self delegate:self];
}

- (void)showResultSucceedTitle:(NSString *)title
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    ViewTransferResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewTransferResultDialog class]) owner:self options:nil] lastObject];
    
    dialog.lbTitle.text = title;
    dialog.viTitle.image = kLoadPng(@"img_succeed");
    
    [alertView setContainerView:dialog];
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [self.navigationController popViewControllerAnimated:YES];
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
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
- (void)get_person_buying_hsb_ebank_pay_params//购互生币-网银支付
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"channel_code": @"MOBILE",
                               @"amount": [@((int)self.inputValue) stringValue]
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_person_buying_hsb_ebank_pay_params",
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
            DDLogInfo(@"get_person_buying_hsb_ebank_pay_params dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    payDic = dic;
                    viewRowOrderNo.tfRightTextField.text = kSaftToNSString(dic[@"orderNo"]);
                    tnCode = kSaftToNSString(dic[@"tnCode"]);
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:kLocalized(@"获取订单信息失败。") isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:kLocalized(@"获取订单信息失败。") isPopVC:self.navigationController];
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

////取得支付流水号
//- (void)getOrderTNAndPay
//{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"订单初始化";
//    [hud show:YES];
//    
//    [UPPayPluginTest UPPayTest:^(NSString *tn, NSError *error) {
//        if (!error)
//        {
//            [hud removeFromSuperview];
//            DDLogDebug(@"tn:%@", tn);
//            [UPPayPlugin startPay:tn mode:kUPPayPluginMode viewController:self delegate:self];
//        }else
//        {
//            hud.labelText = error.localizedDescription;
//            [hud hide:YES afterDelay:2.0];
//        }
//    }];
//}


#pragma mark - getOrderTNAndPay
- (void)getOrderTNAndPay
{
    if (!payDic) return;
    NSDictionary *allParameters = payDic[@"ebankPayParams"][@"allParameters"];
    NSDictionary *passDic = @{@"partnerId": kSaftToNSString(allParameters[@"partnerId"]),
                               @"reqOrderNo": kSaftToNSString(allParameters[@"reqOrderNo"]),
                               @"currency": kSaftToNSString(allParameters[@"currency"]),
                               @"transDate": kSaftToNSString(allParameters[@"transDate"]),
                               @"outResNo": kSaftToNSString(allParameters[@"outResNo"]),
                               @"amount": kSaftToNSString(allParameters[@"amount"]),
                               @"fee": kSaftToNSString(allParameters[@"fee"]),
                               @"flag": kSaftToNSString(allParameters[@"flag"]),
                               @"remark": kSaftToNSString(allParameters[@"remark"]),
                               @"signType": kSaftToNSString(allParameters[@"signType"]),
                               @"returnUrl": kSaftToNSString(allParameters[@"returnUrl"]),
                               @"notifyUrl": kSaftToNSString(allParameters[@"notifyUrl"]),
                               @"sign": kSaftToNSString(allParameters[@"sign"])
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    [Network HttpPostRequetURL:data.hsPayDomain parameters:passDic requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSString *tn = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            DDLogInfo(@"网银兑换互生币 tn:%@", tn);
            if (tn.length > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UPPayPlugin startPay:tn mode:kUPPayPluginMode viewController:self delegate:self];
                });
            }else
            {
                [Utils showMessgeWithTitle:nil message:kLocalized(@"获取订单支付信息失败。") isPopVC:nil];
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

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
//    支付状态返回值:success、fail、cancel
    DDLogInfo(@"网银兑换互生币,支付结果:%@", result);
    if ([result isEqualToString:@"success"])
    {
        data.user.isNeedRefresh = YES;
        [self showResultTitle:kLocalized(@"online_buy_hsd_succeed") isSucceed:YES];
    }else
    {
        [self showResultTitle:kLocalized(@"online_buy_hsd_failed") isSucceed:NO];
    }
}

@end

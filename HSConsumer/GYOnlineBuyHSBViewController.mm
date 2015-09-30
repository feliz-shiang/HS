//
//  GYOnlineBuyHSBViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYOnlineBuyHSBViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "UPPayPluginDelegate.h"
#import "UPPayPlugin.h"

#import "UPPayPluginTest.h"

//#import "PointToCashOrderDetail.h"

@interface GYOnlineBuyHSBViewController ()<UITextFieldDelegate, UPPayPluginDelegate>
{
    
    IBOutlet ViewCellStyle *viewRowAvailable;
    IBOutlet UILabel *lbAccBal;
    
    IBOutlet InputCellStypeView *viewRowInputAmount;   //输入行
    IBOutlet InputCellStypeView *viewRowCurrency;   //币种行
    IBOutlet InputCellStypeView *viewRowRechargeModel; //支付方式行
    IBOutlet UIButton *btnNext;//下一步按钮
    
    GlobalData *data;//全局单例
    double  inputValue;//转现的积分数
}
@end

@implementation GYOnlineBuyHSBViewController

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

    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //实例化单例
    data = [GlobalData shareInstance];
    
    viewRowAvailable.ivTitle.image = kLoadPng(@"cell_img_HSC_to_cash_acc");//设置图标
    viewRowAvailable.lbActionName.text = kLocalized(@"HS_coins_to_cash_account_balance_confirm");
    [lbAccBal setTextColor:kValueRedCorlor];
    
    viewRowInputAmount.lbLeftlabel.text = kLocalized(@"online_buy_hsb_amount");
    [viewRowInputAmount.tfRightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [viewRowInputAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputAmount.tfRightTextField.placeholder = kLocalized(@"placeholder_online_buy_hsb_amount");
    viewRowInputAmount.tfRightTextField.delegate = self;
    
    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowRechargeModel.lbLeftlabel.text = kLocalized(@"HS_wallet_recharge_model");
    viewRowRechargeModel.tfRightTextField.text = kLocalized(@"HS_wallet_recharge_model_uppay");
    [viewRowRechargeModel.tfRightTextField setTextColor:kValueRedCorlor];
    
    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置初始值
    inputValue = 0.0;
    lbAccBal.text = [Utils formatCurrencyStyle:data.user.HSWalletAccBal];
    viewRowInputAmount.tfRightTextField.text = @"";
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;
}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    inputValue = [viewRowInputAmount.tfRightTextField.text doubleValue];

    if (viewRowInputAmount.tfRightTextField &&
        viewRowInputAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0)//输入合法
    {
//        if (inputValue > data.user.availablePointAmount)//输入大于可用积分
//        {
//            DDLogDebug(@"输入的转现的积分大于可用积分:%f", data.user.availablePointAmount);
//            DDLogDebug(@"inputValue:%f", inputValue);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的积分数大于可用积分，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//
//            return;
//        }
        
        
        //格式化值
//        viewRowInputAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

        //进入下一步
//        GYHSDToCashToHSDToCashAccountNextViewController *nextVC = kLoadVcFromClassStringName(NSStringFromClass([GYHSDToCashToHSDToCashAccountNextViewController class]));
//        nextVC.navigationItem.title = kLocalized(@"hsdtocash_to_cash_confirm");        
//        nextVC.inputValue = inputValue;
//        nextVC.strToCashAmount = viewRowInputAmount.tfRightTextField.text;
//        nextVC.strCurrency = viewRowCurrency.tfRightTextField.text;
//        nextVC.strToCashRate = viewRowToCashRate.tfRightTextField.text;
//        nextVC.strCashAmount = viewRowCashAmount.tfRightTextField.text;
//        
//        [self.navigationController pushViewController:nextVC animated:YES];
        [self getOrderTNAndPay];
    }else//输入不合法
    {
        DDLogDebug(@"请输入充值金额");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入充值金额。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
//取得支付流水号
- (void)getOrderTNAndPay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"订单初始化";
    [hud show:YES];
    
    [UPPayPluginTest UPPayTest:^(NSString *tn, NSError *error) {
        if (!error)
        {
            [hud removeFromSuperview];
            DDLogDebug(@"tn:%@", tn);
            [UPPayPlugin startPay:tn mode:kUPPayPluginMode viewController:self delegate:self];
        }else
        {
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:2.0];
        }
    }];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付结果" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

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

@end

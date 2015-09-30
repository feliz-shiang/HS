//
//  GYOnlineBuyHSBViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYBuyHSBViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "UIActionSheet+Blocks.h"
#import "GYCashBuyHSBNextViewController.h"
#import "GYOnlineBuyHSBNextViewController.h"

@interface GYBuyHSBViewController ()<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet ViewCellStyle *viewRowAvailable;
    IBOutlet UILabel *lbAccBal;
    
    IBOutlet InputCellStypeView *viewRowInputAmount;    //输入行
    IBOutlet InputCellStypeView *viewRowCurrency;       //币种行
    
    IBOutlet InputCellStypeView *viewRowToHSDRate;          //转换比例行
    IBOutlet InputCellStypeView *viewRowChangeConvertCash;  //折合货币金额
    IBOutlet InputCellStypeView *viewRowShouldPaymentAmount;//应支付金额
    
    IBOutlet InputCellStypeView *viewRowRechargeModel;  //支付方式行
    
    IBOutlet UILabel *lbTipMin0;
    IBOutlet UILabel *lbTipMin1;
    IBOutlet UILabel *lbTipMin2;
    IBOutlet UILabel *lbTipMin3;
    
    IBOutlet UIImageView *ivItem1;//说明各项前面的小图标
    IBOutlet UIImageView *ivItem2;
    IBOutlet UIImageView *ivItem3;

    IBOutlet UIButton *btnNext;     //下一步按钮
    IBOutlet UIButton *btnSelectPayMethod;//选择支付方式
    NSArray *arrMethods;            //支付方式
    NSInteger selectIndexMethod;    //当前选中的支付方式 0：网银  1：货币
    GlobalData *data;               //全局单例
    double  inputValue;             //购互生币数
    double  todayCanBuyHSBAmount;        //今日还可以购互生币数
}
@end

@implementation GYBuyHSBViewController

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
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnNext.frame) + 80)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];

    //实例化单例
    data = [GlobalData shareInstance];
    
    viewRowAvailable.ivTitle.image = kLoadPng(@"cell_img_HSC_to_cash_acc");//设置图标
    viewRowAvailable.lbActionName.text = kLocalized(@"HS_coins_to_cash_account_balance");
    [lbAccBal setTextColor:kValueRedCorlor];
    [Utils setFontSizeToFitWidthWithLabel:lbAccBal labelLines:1];
    
    viewRowInputAmount.lbLeftlabel.text = kLocalized(@"buy_hsb_amount");
    [viewRowInputAmount.tfRightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [viewRowInputAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputAmount.tfRightTextField.placeholder = kLocalized(@"placeholder_buy_hsb_amount");
    viewRowInputAmount.tfRightTextField.delegate = self;
    
    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowToHSDRate.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_rate");
    viewRowToHSDRate.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", data.user.hsdToCashRate];
    [viewRowToHSDRate.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowChangeConvertCash.lbLeftlabel.text = kLocalized(@"buy_hsd_change_convert_cash");
    [viewRowChangeConvertCash.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowShouldPaymentAmount.lbLeftlabel.text = kLocalized(@"buy_hsd_should_payment_amount");
    [viewRowShouldPaymentAmount.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowRechargeModel.lbLeftlabel.text = kLocalized(@"pay_methods");
//    viewRowRechargeModel.tfRightTextField.text = kLocalized(@"HS_wallet_recharge_model_uppay");
    [viewRowRechargeModel.tfRightTextField setTextColor:kValueRedCorlor];
    arrMethods = @[kLocalized(@"pay_method_uppay"), kLocalized(@"pay_method_cash")];
    
    [lbTipMin0 setTextColor:kCellItemTextColor];
    [lbTipMin1 setTextColor:kCellItemTextColor];
    [lbTipMin2 setTextColor:kCellItemTextColor];
    [lbTipMin3 setTextColor:kCellItemTextColor];
    
    //设置说明项前图标颜色
    ivItem1.image = nil;
    [ivItem1 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem2.image = nil;
    [ivItem2 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem3.image = nil;
    [ivItem3 setBackgroundColor:kCorlorFromHexcode(0xef4136)];

    [Utils setFontSizeToFitWidthWithLabel:lbTipMin0 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin1 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin2 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin3 labelLines:1];
    
    lbTipMin0.text = [NSString stringWithFormat:@"%@:", kLocalized(@"well_tip")];
    lbTipMin1.text = [NSString stringWithFormat:kLocalized(@"buy_hsd_tip1"), [Utils formatCurrencyStyle:data.user.registeredBuyHsbMinimum], [Utils formatCurrencyStyle:data.user.registeredBuyHsbMaxmum]];
    lbTipMin2.text = [NSString stringWithFormat:kLocalized(@"buy_hsd_tip2"), [Utils formatCurrencyStyle:data.user.notRegisteredBuyHsbMinimum], [Utils formatCurrencyStyle:data.user.notRegisteredBuyHsbMaxmum]];
    lbTipMin3.text = [NSString stringWithFormat:kLocalized(@"buy_hsd_tip3"), [Utils formatCurrencyStyle:data.user.dailyBuyHsbMaxmum]];
    
    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnSelectPayMethod addTarget:self action:@selector(btnSelectPayMethodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self get_hsb_transfer_cash];
}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    inputValue = [viewRowInputAmount.tfRightTextField.text doubleValue];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (todayCanBuyHSBAmount <= 0 || inputValue > todayCanBuyHSBAmount)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"兑换互生币的额度超过每日上限！" isPopVC:self.navigationController];
        return;
    }

    if (viewRowInputAmount.tfRightTextField &&
        viewRowInputAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0)//输入合法
    {
        if (data.user.isRealNameRegistration)//实名注册的
        {
            if (!((inputValue >= data.user.registeredBuyHsbMinimum) && (inputValue <= data.user.registeredBuyHsbMaxmum)))
            {
                [Utils showMessgeWithTitle:@"提示" message:lbTipMin1.text isPopVC:nil];
//                [Utils showMessgeWithTitle:@"提示" message:@"已实名注册用户单笔购买数量为500-5000。" isPopVC:nil];
                return;
            }
            
        }else
        {
            if (!((inputValue >= data.user.notRegisteredBuyHsbMinimum) && (inputValue <= data.user.notRegisteredBuyHsbMaxmum)))//款实名注册的
            {
                [Utils showMessgeWithTitle:@"提示" message:lbTipMin2.text isPopVC:nil];
//                [Utils showMessgeWithTitle:@"提示" message:@"未实名注册用户单笔购买数量为500-1000。" isPopVC:nil];
                return;
            }
        }
        
        UIViewController *vc = nil;
        if (selectIndexMethod == 0)
        {
            GYOnlineBuyHSBNextViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYOnlineBuyHSBNextViewController class]));
            _vc.inputValue = inputValue;
            vc = _vc;
        }else
        {
            GYCashBuyHSBNextViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYCashBuyHSBNextViewController class]));
            _vc.inputValue = inputValue;
            vc = _vc;
        }
        if (vc)
        {
            vc.navigationItem.title = kLocalized(@"buy_hsd_confirm");
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else//输入不合法
    {
        DDLogDebug(@"请输入购买数量");
        [Utils showMessgeWithTitle:@"提示" message:@"请输入兑换数量。" isPopVC:nil];
    }
}

- (void)btnSelectPayMethodClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    [UIActionSheet presentOnView:self.view withTitle:kLocalized(@"请选择支付方式") otherButtons:arrMethods onCancel:^(UIActionSheet *sheet) {
        
    } onClickedButton:^(UIActionSheet *sheet, NSUInteger index) {
        selectIndexMethod = index;
        viewRowRechargeModel.tfRightTextField.text = arrMethods[selectIndexMethod];
    }];
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

#pragma mark - UITextFieldDelegate
//输入积分数，同步显示将转成现金数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if(len > 12) return NO;
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    inputValue = [str doubleValue];
    
    if(inputValue < 0 ) return NO;
    
    double v1 = data.user.hsdToCashRate * inputValue;
    double v2 = data.user.hsdToCashRate * inputValue;
    
    [viewRowChangeConvertCash.tfRightTextField setText:[Utils formatCurrencyStyle:v1]];
    [viewRowShouldPaymentAmount.tfRightTextField setText:[Utils formatCurrencyStyle:v2]];
    
    //    double sum = input / theAppDelegate.userData.pointsCashRate - 0.005;//不进行四舍五入
    return YES;
}

#pragma mark - 网络数据交换
- (void)get_hsb_transfer_cash//账户信息
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_hsb_transfer_cash",
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
            DDLogInfo(@"get_hsb_transfer_cash dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.HSDToCashAccBal = kSaftToCGFloat(dic[@"hsbTransferCash"]);
                    data.user.todayBuyHsbTotalAmount = kSaftToCGFloat(dic[@"totalAmount"]);
                    [self setValues];
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"同步账户信息失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"同步账户信息失败." isPopVC:self.navigationController];
            }
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置初始值
    todayCanBuyHSBAmount = 0;
    inputValue = 0.0;
    selectIndexMethod = 0;
    viewRowRechargeModel.tfRightTextField.text = arrMethods[selectIndexMethod];
    viewRowInputAmount.tfRightTextField.text = @"";

    [viewRowChangeConvertCash.tfRightTextField setText:@"0.00"];
    [viewRowShouldPaymentAmount.tfRightTextField setText:@"0.00"];

    [self setValues];
    if (data.user.isNeedRefresh)
    {
        [self get_hsb_transfer_cash];
        data.user.isNeedRefresh = NO;
    }
}

- (void)setValues
{
    //设置值
    todayCanBuyHSBAmount = data.user.dailyBuyHsbMaxmum - data.user.todayBuyHsbTotalAmount;
    lbAccBal.text = [Utils formatCurrencyStyle:data.user.HSDToCashAccBal];
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;
    lbTipMin3.text = [NSString stringWithFormat:kLocalized(@"buy_hsd_tip4"),
                      [Utils formatCurrencyStyle:data.user.dailyBuyHsbMaxmum],
                      [Utils formatCurrencyStyle:todayCanBuyHSBAmount]
                      ];
}


@end

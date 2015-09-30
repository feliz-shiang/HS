//
//  GYHSDToCashToCashAccountViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//



#import "GYHSDToCashToCashAccountViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "GYHSDToCashToCashAccountNextViewController.h"
#import "ViewCellStyle.h"
#import "RTLabel.h"

//#import "PointToCashOrderDetail.h"

@interface GYHSDToCashToCashAccountViewController ()<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet ViewCellStyle *viewRowAvailable;
    IBOutlet UILabel *lbAvailablePoint;
    IBOutlet InputCellStypeView *viewRowInputPointAmount;   //输入积分行
    
    IBOutlet InputCellStypeView *viewRowActualToAmount;//实际转入数量
    IBOutlet InputCellStypeView *viewRowToAmount;  //转入账户
    IBOutlet InputCellStypeView *viewRowToCashFee; //货币转换费
    IBOutlet UIButton *btnNext;//下一步按钮
    
    IBOutlet UILabel *lbTipMin0;
    IBOutlet UILabel *lbTipMin1;
    IBOutlet UILabel *lbTipMin2;
    
    IBOutlet UIImageView *ivItem1;//说明各项前面的小图标
    IBOutlet UIImageView *ivItem2;
    
    GlobalData *data;//全局单例
    double  inputValue;
}
@end

@implementation GYHSDToCashToCashAccountViewController

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];

    //实例化单例
    data = [GlobalData shareInstance];
    
    
    viewRowAvailable.ivTitle.image = kLoadPng(@"cell_img_HSC_to_cash_acc");//设置图标
    viewRowAvailable.lbActionName.text = kLocalized(@"HS_coins_to_cash_account_available_balance");
    [lbAvailablePoint setTextColor:kValueRedCorlor];
    [Utils setFontSizeToFitWidthWithLabel:viewRowAvailable.lbActionName labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAvailablePoint labelLines:1];
    
    viewRowInputPointAmount.lbLeftlabel.text = kLocalized(@"input_hsdtocash_to_cash_amount");
    [viewRowInputPointAmount.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [viewRowInputPointAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputPointAmount.tfRightTextField.placeholder = kLocalized(@"hsdtocash_tipinput");
    viewRowInputPointAmount.tfRightTextField.delegate = self;
    
    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"cash_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

    viewRowToCashFee.lbLeftlabel.text = kLocalized(@"hsdtocash_to_cash_fee");
    [viewRowToCashFee.tfRightTextField setTextColor:kValueRedCorlor];

    viewRowActualToAmount.lbLeftlabel.text = kLocalized(@"hsd_to_cash_actual_amount");
    [viewRowActualToAmount.tfRightTextField setTextColor:kValueRedCorlor];
    
    [lbTipMin0 setTextColor:kCellItemTextColor];
    [lbTipMin1 setTextColor:kCellItemTextColor];
    [lbTipMin2 setTextColor:kCellItemTextColor];
    
    //设置说明项前图标颜色
    ivItem1.image = nil;
    [ivItem1 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem2.image = nil;
    [ivItem2 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin0 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin1 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTipMin2 labelLines:1];

    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnNext.frame) + 80)];

    [self get_hsb_transfer_cash];

    // Do any additional setup after loading the view from its nib.
}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (viewRowInputPointAmount.tfRightTextField &&
        viewRowInputPointAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0)//输入合法
    {
        if (inputValue > data.user.HSDToCashAccBal)//输入大于可用积分
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"输入金额大于账户余额，请重新输入."];
            return;
        }

        if (inputValue < data.user.minHSDTransferToCash)
        {
            NSString *message = [NSString stringWithFormat:@"互生币转货币账户金额为不小于%@的整数", [Utils formatCurrencyStyle:data.user.minHSDTransferToCash]];
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        
        if (inputValue > (int)inputValue)//必须为整数
        {
            NSString *message = @"互生币转货币账户金额必须为整数.";
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        
        //进入下一步
        GYHSDToCashToCashAccountNextViewController *nextVC = kLoadVcFromClassStringName(NSStringFromClass([GYHSDToCashToCashAccountNextViewController class]));
        nextVC.navigationItem.title = kLocalized(@"hsdtocash_to_cash_confirm");        
        nextVC.inputValue = inputValue;
//        nextVC.strToCashAmount = viewRowInputPointAmount.tfRightTextField.text;
//        nextVC.strCurrency = viewRowCurrency.tfRightTextField.text;
//        nextVC.strToCashRate = viewRowToCashRate.tfRightTextField.text;
//        nextVC.strCashAmount = viewRowActualToAmount.tfRightTextField.text;
        
        [self.navigationController pushViewController:nextVC animated:YES];
    }else
    {
        [Utils alertViewOKbuttonWithTitle:@"提示" message:@"请输入金额."];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    double fee = inputValue * data.user.hsdToCashCurrencyConversionFee;
    viewRowToCashFee.tfRightTextField.text = [Utils formatCurrencyStyle:fee];
    viewRowActualToAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue - fee];
    
//    double sum = input / theAppDelegate.userData.pointsCashRate - 0.005;//不进行四舍五入
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    viewRowInputPointAmount.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", inputValue];
//    return YES;
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
            DDLogInfo(@"get_hsb_transfer_cash dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.HSDToCashAccBal = [kSaftToNSString(dic[@"hsbTransferCash"]) doubleValue];
                    [self setValues];
                }else//返回失败数据
                {
                    [self showErrWithTitle:nil message:@"同步账户信息失败." isPopVC:YES];
                }
            }else
            {
                [self showErrWithTitle:nil message:@"同步账户信息失败." isPopVC:YES];
            }
            
        }else
        {
            [self showErrWithTitle:@"提示" message:[error localizedDescription] isPopVC:YES];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (void)showErrWithTitle:(NSString *)title message:(NSString *)message isPopVC:(BOOL)pop
{
    UIAlertView *alert = [UIAlertView showWithTitle:title message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (pop)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置初始值
    inputValue = 0.0;
    viewRowInputPointAmount.tfRightTextField.text = @"";
    viewRowActualToAmount.tfRightTextField.text = @"0.00";
    viewRowToCashFee.tfRightTextField.text = @"0.00";
//    viewRowActualToAmount.tfRightTextField.text = @"待返回的参数进行计算";
//    viewRowToCashFee.tfRightTextField.text = @"待返回的参数进行计算";

    if (data.user.isNeedRefresh)
    {
        [self get_hsb_transfer_cash];
        data.user.isNeedRefresh = NO;
    }
}

- (void)setValues
{
    //设置值
    lbAvailablePoint.text = [Utils formatCurrencyStyle:data.user.HSDToCashAccBal];
    lbTipMin0.text = [NSString stringWithFormat:@"%@:", kLocalized(@"well_tip")];
    lbTipMin1.text = [NSString stringWithFormat:kLocalized(@"hsd_to_cash_tip1")
                      , [Utils formatCurrencyStyle:data.user.minHSDTransferToCash]];
    lbTipMin2.text = [NSString stringWithFormat:kLocalized(@"hsd_to_cash_tip2")
                      ,[NSString stringWithFormat:@"%d%%", (int)(data.user.hsdToCashCurrencyConversionFee * 100)]];
}

@end

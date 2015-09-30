//
//  GYCashTransfersViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCashTransfersViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "GYConfirmTransferInfoViewController.h"
#import "GYSelAccountViewController.h"
#import "UIView+CustomBorder.h"
#import "GYCardBandingViewController3.h"
#import "RTLabel.h"

@interface GYCashTransfersViewController ()<UITextFieldDelegate,GYSelAccDelegate, sendSelectBankModel>
{
    GlobalData *data;   //全局单例
    double  inputValue; //转现的金额
    IBOutlet UIButton *btnMenu; //银行选择菜单
    IBOutlet UIButton *btnNext; //下一步按钮
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet InputCellStypeView *viewRowAccountBalance; //现金账户余额
    IBOutlet UIImageView *imgAccountBalance;            //现金账户余额图片
    
    IBOutlet InputCellStypeView *viewRowInputTransferAmount;//输入金额行
    IBOutlet InputCellStypeView *viewRowAccountNum; //银行账号卡行
    IBOutlet InputCellStypeView *viewRowCurrency;   //币种行
    IBOutlet InputCellStypeView *viewBankAccounName;//银行账户行
    IBOutlet InputCellStypeView *viewBankName;      //开户银行行
    IBOutlet InputCellStypeView *viewBankAccountArea;//开户地区行
    
    IBOutlet RTLabel *rtlbTip;
    NSString *bankID;
}

@end

@implementation GYCashTransfersViewController


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
    
    //添加点击隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];
    
    //设置属性
    
    //现金余额
    viewRowAccountBalance.lbLeftlabel.text = kLocalized(@"cash_account_balance_confirm");
    viewRowAccountBalance.tfRightTextField.textColor = kValueRedCorlor;
    [Utils setFontSizeToFitWidthWithLabel:viewRowAccountBalance.lbLeftlabel labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:viewRowAccountBalance.tfRightTextField labelLines:1];

    //输入金额行
    viewRowInputTransferAmount.lbLeftlabel.text = kLocalized(@"apply_transfer_amount");
    [viewRowInputTransferAmount.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [viewRowInputTransferAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputTransferAmount.tfRightTextField.placeholder = kLocalized(@"input_transfer_amount");
    viewRowInputTransferAmount.tfRightTextField.delegate = self;
    
    //选择银行卡行
    viewRowAccountNum.lbLeftlabel.text = kLocalized(@"bank_account");
    viewRowAccountNum.tfRightTextField.placeholder = kLocalized(@"sel_card_number");
    viewRowAccountNum.tfRightTextField.textColor = kCorlorFromRGBA(90, 90, 90, 1.0);

    //银行账户行
    viewBankAccounName.lbLeftlabel.text = kLocalized(@"cash_tra_bank_acc_name");
    viewBankAccounName.tfRightTextField.placeholder = @"";
    viewBankAccounName.tfRightTextField.text = @"";
    viewBankAccounName.tfRightTextField.textColor = kCellItemTextColor;
    
    //开户银行行
    viewBankName.lbLeftlabel.text = kLocalized(@"cash_tra_bank_name");
    viewBankName.tfRightTextField.placeholder = @"";
    viewBankName.tfRightTextField.text = @"";
    viewBankName.tfRightTextField.textColor = kCellItemTextColor;

    //开户地区
    viewBankAccountArea.lbLeftlabel.text = kLocalized(@"cash_tra_bank_account_area");
    viewBankAccountArea.tfRightTextField.placeholder = @"";
    viewBankAccountArea.tfRightTextField.text = @"";
    viewBankAccountArea.tfRightTextField.textColor = kCellItemTextColor;
    
    //币种行
    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    viewRowCurrency.tfRightTextField.textColor = kValueRedCorlor;
    
    //设置提示信息
    [rtlbTip setFont:[UIFont systemFontOfSize:13]];
    NSString *strTips = [NSString stringWithFormat:kLocalized(@"cash_to_bank_tip"), @"000.00"];
    [rtlbTip setTextColor:kCellItemTextColor];
    rtlbTip.text = strTips;
    CGRect rtlbTipFrame = rtlbTip.frame;
    CGSize optimumSize = [rtlbTip optimumSize];
    rtlbTipFrame.size.height = optimumSize.height;
    rtlbTip.frame = rtlbTipFrame;
    
    //重设btn的y
    CGRect btnNextFrame = btnNext.frame;
    btnNextFrame.origin.y = CGRectGetMaxY(rtlbTip.frame) + kDefaultMarginToBounds;
    btnNext.frame = btnNextFrame;
    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnNext.frame) + 80)];

    bankID = nil;
    [self get_cash_act_info];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //设置初始值
    //inputValue = 0.0;
    if (data.user.isNeedRefresh)
    {
        [self get_cash_act_info];
        viewRowInputTransferAmount.tfRightTextField.text = @"";
        inputValue = 0.0;
        data.user.isNeedRefresh = NO;
    }
}

//银行选择菜单 点击事件
- (IBAction)btnMenuClick:(id)sender
{
    //加载菜单控件
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //    GYSelAccountViewController *vcSelAcc = [[GYSelAccountViewController alloc] init];
    GYCardBandingViewController3 *vcSelAcc = kLoadVcFromClassStringName(NSStringFromClass([GYCardBandingViewController3 class]));
    vcSelAcc.isSelectBankList = YES;
    vcSelAcc.delegate = self;
    
    [self.navigationController pushViewController:vcSelAcc animated:YES];
}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    
    if (viewRowInputTransferAmount.tfRightTextField &&
        viewRowInputTransferAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0 &&
        bankID &&
        viewRowAccountNum.tfRightTextField.text.length > 0)//输入合法
    {
        if (inputValue > data.user.cashAccBal)//输入大于账号余额
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"输入的金额数大于货币账户余额，请重新输入"];
            return;
        }
        
        if (inputValue < data.user.minCashTransferToBank)//个人积分转现最少
        {
            NSString *message = [NSString stringWithFormat:@"货币转银行金额为不小于%@的整数.", [Utils formatCurrencyStyle:data.user.minCashTransferToBank]];
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        
        if (inputValue > (int)inputValue)//必须为整数
        {
            NSString *message = @"货币转银行金额必须为整数.";
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }

        //格式化值
        viewRowInputTransferAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue];
        
        [self hideKeyboard:nil];
        
        //进入下一步
        GYConfirmTransferInfoViewController *nextVC = [[GYConfirmTransferInfoViewController alloc] initWithNibName:@"GYConfirmTransferInfoViewController" bundle:kDefaultBundle];
        nextVC.navigationItem.title = kLocalized(@"cash_account_transfer_confirm");
        nextVC.bankID = bankID;
        nextVC.inputValue = inputValue;
//        nextVC.actualAccAmount = 999.00;
        NSMutableArray *arrPassStrings = [NSMutableArray array];
        [arrPassStrings addObject:@[viewRowInputTransferAmount.lbLeftlabel.text, viewRowInputTransferAmount.tfRightTextField.text]];
        [arrPassStrings addObject:@[viewBankAccounName.lbLeftlabel.text, viewBankAccounName.tfRightTextField.text]];
        [arrPassStrings addObject:@[viewRowAccountNum.lbLeftlabel.text, viewRowAccountNum.tfRightTextField.text]];
        [arrPassStrings addObject:@[viewBankName.lbLeftlabel.text, viewBankName.tfRightTextField.text]];
        [arrPassStrings addObject:@[viewBankAccountArea.lbLeftlabel.text, viewBankAccountArea.tfRightTextField.text]];
        [arrPassStrings addObject:@[viewRowCurrency.lbLeftlabel.text, viewRowCurrency.tfRightTextField.text]];
        nextVC.arrStrings = arrPassStrings;
        
        [self.navigationController pushViewController:nextVC animated:YES];
        
    }else//输入不合法
    {
        UIAlertView * avCode = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"please_enter_the_complete_information") delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [avCode show];
        DDLogDebug(@"请输入..");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
    
    //    double sum = input / theAppDelegate.userData.pointsCashRate - 0.005;//不进行四舍五入
    return YES;
}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    viewRowInputTransferAmount.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", inputValue];
//    return YES;
//}

#pragma mark - GYSelAccDelegate
-(void)returnAccNum:(NSString *)AccNum
{
    viewRowAccountNum.tfRightTextField.text = AccNum;
    viewBankAccounName.tfRightTextField.text = @"王五";
    viewBankName.tfRightTextField.text = @"中国xx银行";
    viewBankAccountArea.tfRightTextField.text = @"中国xx省xx市";
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
- (void)get_cash_act_info//现金账户信息
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_cash_act_info",
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
            DDLogInfo(@"get_cash_act_info dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.cashAccBal = [dic[@"cash"] doubleValue];
                    [self setValues];
                }else   //返回失败数据
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

- (void)setValues
{
    viewRowAccountBalance.tfRightTextField.text = [Utils formatCurrencyStyle:data.user.cashAccBal];
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;
    NSString *strTips = [NSString stringWithFormat:kLocalized(@"cash_to_bank_tip"), [Utils formatCurrencyStyle:data.user.minCashTransferToBank]];
    rtlbTip.text = strTips;
}

#pragma mark - 选择银行账户列表 代理
- (void)sendSelectBankModel:(GYCardBandModel *)model
{
    viewRowAccountNum.tfRightTextField.text = model.strBankAccount;
    viewBankAccounName.tfRightTextField.text = model.strBankAcctName;
    viewBankName.tfRightTextField.text = model.strBankCode;
    viewBankAccountArea.tfRightTextField.text = model.strCityName;
    bankID = model.strBankAcctId;
    return;
}

@end

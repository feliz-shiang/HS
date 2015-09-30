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
#import "GYConfirmTransferInfoViewController.h"
#import "ViewTransferResultDialog.h"

@interface GYConfirmTransferInfoViewController ()<MBProgressHUDDelegate, UITextFieldDelegate>
{
    GlobalData *data;   //全局单例
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet InputCellStypeView *viewPWD;//交易密码
    IBOutlet UIButton *btnConfirm;//确认汇款 按钮
    
    IBOutlet InputCellStypeView *viewRowInputTransferAmount;//输入金额行
    IBOutlet InputCellStypeView *viewRowAccountNum; //银行账号卡行
    IBOutlet InputCellStypeView *viewRowCurrency;   //币种行
    IBOutlet InputCellStypeView *viewBankAccounName;//银行账户行
    IBOutlet InputCellStypeView *viewBankName;      //开户银行行
    IBOutlet InputCellStypeView *viewBankAccountArea;//支行地址行
    IBOutlet InputCellStypeView *viewRowPoundage;  //手续费行
    IBOutlet InputCellStypeView *viewRowActual;  //到账金额
}
@end

@implementation GYConfirmTransferInfoViewController

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
    [scvContainer setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(btnConfirm.frame) + 80)];
    
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
            if (vTmp == viewRowInputTransferAmount || vTmp == viewRowActual)//设置粗体
            {
                vTmp.tfRightTextField.font = kCellTitleBoldFont;
            }
            
        }
    }
    
    viewRowInputTransferAmount.lbLeftlabel.text = self.arrStrings[0][0];
    viewRowInputTransferAmount.tfRightTextField.text = self.arrStrings[0][1];
    
    viewBankAccounName.lbLeftlabel.text = self.arrStrings[1][0];
//    viewBankAccounName.tfRightTextField.text = self.arrStrings[1][1];
    
    viewRowAccountNum.lbLeftlabel.text = self.arrStrings[2][0];
//    viewRowAccountNum.tfRightTextField.text = self.arrStrings[2][1];
    
    viewBankName.lbLeftlabel.text = self.arrStrings[3][0];
//    viewBankName.tfRightTextField.text = self.arrStrings[3][1];
    
    viewBankAccountArea.lbLeftlabel.text = self.arrStrings[4][0];
//    viewBankAccountArea.tfRightTextField.text = self.arrStrings[4][1];
    
    viewRowCurrency.lbLeftlabel.text = self.arrStrings[5][0];
    viewRowCurrency.tfRightTextField.text = self.arrStrings[5][1];
    
    //手续费行
    viewRowPoundage.lbLeftlabel.text =  kLocalized(@"transfer_fee");
    viewRowPoundage.tfRightTextField.text =  @"";
    
    //到账金额
    viewRowActual.lbLeftlabel.text = kLocalized(@"actual_acc_amount");
    viewRowActual.tfRightTextField.text = @"";
    
    //交易密码
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;

    [btnConfirm setTitle:kLocalized(@"confirm_the_transfer") forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:kButtonTitleDefaultFont];
    [btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self get_transfer_cash_to_bank_fee];
}

//确认汇款按钮点击事件
- (void)btnConfirmClick:(id)sender
{
    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }
    [self transfer_cash_to_bank];
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

- (void)showResultSucceedTitle:(NSString *)title
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    ViewTransferResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewTransferResultDialog class]) owner:self options:nil] lastObject];
    
    dialog.lbTitle.text = title;
    dialog.viTitle.image = kLoadPng(@"img_succeed");
    
//    ResultDialogRows7 *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialogRows7 class]) owner:self options:nil] lastObject];
//    dialog.lbTitle.text = kLocalized(@"order_transfer_successfully");
//    
//    dialog.viewResultRow0.lbLeftlabel.text = kLocalized(@"trading_serial_number");
//    dialog.viewResultRow0.tfRightTextField.text = @"WJD12312789416";
//    
//    dialog.viewResultRow1.lbLeftlabel.text = viewRowInputTransferAmount.lbLeftlabel.text;
//    dialog.viewResultRow1.tfRightTextField.text = viewRowInputTransferAmount.tfRightTextField.text;//此处要根据回返的结果显示。
//    dialog.viewResultRow1.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow1.tfRightTextField.font.pointSize];//设置粗体
//    
//    dialog.viewResultRow2.lbLeftlabel.text = viewBankAccounName.lbLeftlabel.text;
//    dialog.viewResultRow2.tfRightTextField.text = viewBankAccounName.tfRightTextField.text;// 此处要根据回返的结果显示。
//
//    dialog.viewResultRow3.lbLeftlabel.text = viewRowAccountNum.lbLeftlabel.text;
//    dialog.viewResultRow3.tfRightTextField.text = viewRowAccountNum.tfRightTextField.text;
//    
//    dialog.viewResultRow4.lbLeftlabel.text = viewRowPoundage.lbLeftlabel.text;
//    dialog.viewResultRow4.tfRightTextField.text = viewRowPoundage.tfRightTextField.text;
//
//    dialog.viewResultRow5.lbLeftlabel.text = kLocalized(@"cash_tra_in_fact_credited_into_account");//实际到账
//    dialog.viewResultRow5.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow5.tfRightTextField.font.pointSize];//设置粗体
//    dialog.viewResultRow5.tfRightTextField.text = viewRowInputTransferAmount.tfRightTextField.text;
//
//    dialog.viewResultRow6.lbLeftlabel.text = viewRowCurrency.lbLeftlabel.text;
//    dialog.viewResultRow6.tfRightTextField.text = viewRowCurrency.tfRightTextField.text;

    [alertView setContainerView:dialog];
    
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [self.navigationController popViewControllerAnimated:YES];
        [alertView close];
    }];
    alertView.lineView1.hidden=YES;
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
- (void)get_transfer_cash_to_bank_fee//获取现金账户转账银行扣除手续费
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"transfer_cash_amount": [@(self.inputValue) stringValue],
                               @"bind_bank_id": self.bankID
                               };
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_transfer_cash_to_bank_fee",
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
            DDLogInfo(@"get_transfer_cash_to_bank_fee dic:%@", dic);
            if (!error)
            {
                if ([dic[@"code"] isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    ([dic[@"data"][@"resultCode"] intValue] == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    //返回货币代码：dic[@"currencyCode"]
                    double fee = [dic[@"fee"] doubleValue];
                    viewRowPoundage.tfRightTextField.text = [Utils formatCurrencyStyle:fee];
                    viewRowActual.tfRightTextField.text = [Utils formatCurrencyStyle:self.inputValue - fee];
                    
                    dic = dic[@"bank"];//银行信息
                    viewBankAccounName.tfRightTextField.text = kSaftToNSString(dic[@"bankAcctName"]);
                    viewRowAccountNum.tfRightTextField.text = kSaftToNSString(dic[@"bankAccount"]);
                    viewBankName.tfRightTextField.text = [self getBankNameWithCode:kSaftToNSString(dic[@"bankCode"])];// [@"代码：" stringByAppendingString:kSaftToNSString(dic[@"bankCode"])];
                    viewBankAccountArea.tfRightTextField.text = kSaftToNSString(dic[@"cityName"]);
                    
                }else   //返回失败数据
                {
                    
                    
                    [Utils showMessgeWithTitle:nil message:@"获取除手续费失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取除手续费失败." isPopVC:self.navigationController];
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

- (NSString *)getBankNameWithCode:(NSString *)code
{
    NSDictionary *dic = [data getDictionaryOfBank];
    NSString *bankName = @"unknow";
    if (dic && [dic isKindOfClass:[NSDictionary class]])
    {
        dic = dic[@"data"];
        NSArray *bList = dic[@"bankList"];
        for (NSDictionary *dicItem in bList)
        {
            if ([kSaftToNSString(dicItem[@"bankCode"]) isEqualToString:code])
            {
                bankName = kSaftToNSString(dicItem[@"bankName"]);
                break;
            }
        }
    }
    return bankName;
}

#pragma mark - 网络数据交换
- (void)transfer_cash_to_bank// 现金账户转账到银行卡
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"transfer_cash_amount": [@(self.inputValue) stringValue],
                               @"bind_bank_id": self.bankID,
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"transfer_cash_to_bank",
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
            DDLogInfo(@"transfer_cash_to_bank dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
//                    dic = dic[@"data"];
                    data.user.isNeedRefresh = YES;
                    [self showResultSucceedTitle:kLocalized(@"cash_to_bank_succeed")];

                }else//返回失败数据
                {
                    if (self.inputValue>1000) {
                          [Utils alertViewOKbuttonWithTitle:nil message:@"本次货币转银行已提交后台审批，敬请等待!"];
                    }else
                    {
                      [Utils alertViewOKbuttonWithTitle:@"货币转银行提交失败" message:kSaftToNSString(dic[@"data"][@"resultMsg"])];
                    }
                  

                }
            }else
            {
                [Utils alertViewOKbuttonWithTitle:nil message:kLocalized(@"cash_to_bank_failed")];
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

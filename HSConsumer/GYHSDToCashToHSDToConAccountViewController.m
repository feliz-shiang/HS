//
//  GYHSDToCashToHSDToConAccountViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//互生币转现账户转互生币消费账户,互生币转现金户页面

#import "GYHSDToCashToHSDToConAccountViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "GYHSDToCashToHSDToConAccountNextViewController.h"


@interface GYHSDToCashToHSDToConAccountViewController ()<UITextFieldDelegate, MBProgressHUDDelegate>
{
    IBOutlet ViewCellStyle *viewRowHSDToCashAccBal;//互生币转现账户余额
    IBOutlet UILabel *lbAvailable;                 //互生币转现账户余额
    
    IBOutlet UILabel *lbLabelHSDConAccBal;  //互生币消费账户余额文本
    IBOutlet UILabel *lbHSDConAccBal;       //互生币消费账户余额

    IBOutlet InputCellStypeView *viewRowInputAmount;  //输入行

    IBOutlet UIButton *btnNext;//下一步按钮
    GlobalData *data;   //全局单例
    double  inputValue; //输入数值
}
@end

@implementation GYHSDToCashToHSDToConAccountViewController

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
    
    //设置属性
    viewRowHSDToCashAccBal.ivTitle.image = kLoadPng(@"cell_img_HSC_to_cash_acc");//设置图标
    viewRowHSDToCashAccBal.lbActionName.text = kLocalized(@"HS_coins_to_cash_account_balance_confirm");
    [lbAvailable setTextColor:kValueRedCorlor];
    [Utils setFontSizeToFitWidthWithLabel:viewRowHSDToCashAccBal.lbActionName labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAvailable labelLines:1];

    [lbLabelHSDConAccBal setFont:viewRowHSDToCashAccBal.lbActionName.font];
    [lbLabelHSDConAccBal setTextColor:viewRowHSDToCashAccBal.lbActionName.textColor];
    lbLabelHSDConAccBal.text = kLocalized(@"HS_coins_consumer_account_balance");
    [lbHSDConAccBal setTextColor:kValueRedCorlor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelHSDConAccBal labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHSDConAccBal labelLines:1];

//    viewRowInputAmount.lbLeftlabel.text = kLocalized(self.HSDToCashToAccountType == kHSDToCashToAccountTypeToHSDCon ? @"hsdtocash_to_hsdcon_amount" : @"hsdtocash_to_cash_amount");
    
    viewRowInputAmount.lbLeftlabel.text = kLocalized(@"hsdtocash_to_hsdcon_amount");
    [viewRowInputAmount.tfRightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [viewRowInputAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputAmount.tfRightTextField.placeholder = kLocalized(@"hsdtocash_tipinput");
    viewRowInputAmount.tfRightTextField.delegate = self;

    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置初始值
    [self setValues];
    if (data.user.isNeedRefresh)
    {
        [self get_user_info];
        data.user.isNeedRefresh = NO;
    }
}

//next操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    
    if (viewRowInputAmount.tfRightTextField &&
        viewRowInputAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0)//输入合法
    {
        if (inputValue > data.user.HSDToCashAccBal)//输入大于余额
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"输入的金额大于账户金额，请重新输入"];
            return;
        }
        if (inputValue < data.user.minHSDTransferToConsume)//输入大于余额
        {
            NSString *message = [NSString stringWithFormat:@"互生币转消费最低数:%@", [Utils formatCurrencyStyle:data.user.minHSDTransferToConsume]];
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }

        //格式化值
        viewRowInputAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        //进入下一步
        GYHSDToCashToHSDToConAccountNextViewController *nextVC = kLoadVcFromClassStringName(NSStringFromClass([GYHSDToCashToHSDToConAccountNextViewController class]));
        nextVC.navigationItem.title = kLocalized(@"hsdtocash_to_hsdcon_confirm");

        nextVC.inputValue = inputValue;
        [self.navigationController pushViewController:nextVC animated:YES];

    }else//输入不合法
    {
        DDLogDebug(@"请输入");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

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
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    viewRowInputAmount.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", inputValue];
//    return YES;
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 获取互生币转现金账户余额 单独接口：get_hsb_transfer_cash  ， 或使用
#pragma mark - 获取个人的账户信息
- (void)get_user_info
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_user_info",
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
            DDLogInfo(@"get_user_info dic:%@", dic);
            if (!error)
            {
                if ([dic[@"code"] isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    ([dic[@"data"][@"resultCode"] intValue] == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.cardNumber = dic[@"resNo"];
                    data.user.custId = dic[@"custId"];
                    data.user.cashAccBal = [dic[@"cash"] doubleValue];
                    data.user.userName = dic[@"custName"];
                    data.user.HSDToCashAccBal = [dic[@"hsbTransferCash"] doubleValue];
                    data.user.HSDConAccBal = [dic[@"hsbTransferConsume"] doubleValue];
                    data.user.investAccTotal = [dic[@"invest"] doubleValue];
                    data.user.isRealName = ([[dic[@"isAuth"] lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isBankBinding = ([[dic[@"isBindBank"] lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isEmailBinding = ([[dic[@"isBindEmail"] lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isPhoneBinding = ([[dic[@"isBindMobile"] lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isRealNameRegistration = ([[dic[@"isReg"] lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.pointAccBal = [dic[@"residualIntegral"] doubleValue];
                    data.user.availablePointAmount = [dic[@"usableIntegral"] doubleValue];
                    data.user.todayPointAmount = [dic[@"todayNewIntegral"] doubleValue];
                    
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

- (void)setValues
{
    inputValue = 0.0;
    viewRowInputAmount.tfRightTextField.text = @"";
    lbAvailable.text = [Utils formatCurrencyStyle:data.user.HSDToCashAccBal];
    lbHSDConAccBal.text = [Utils formatCurrencyStyle:data.user.HSDConAccBal];
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

@end

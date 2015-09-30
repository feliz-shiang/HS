//
//  GYPointToCashViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分转现页面

#import "GYPointToCashViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "GYPointToCashViewNextController.h"
#import "ViewCellStyle.h"
//#import "PointToCashOrderDetail.h"

@interface GYPointToCashViewController ()<UITextFieldDelegate>
{
//    IBOutlet InputCellStypeView *viewRowAvailablePoint;     //可用积分行
    
    IBOutlet ViewCellStyle *viewRowAvailablePoint;
    IBOutlet UILabel *lbAvailablePoint;
    
    IBOutlet UILabel *lbTipMin0;
    IBOutlet UILabel *lbTipMin1;
    IBOutlet UILabel *lbTipMin2;
    
    IBOutlet UIImageView *ivItem1;//说明各项前面的小图标
    IBOutlet UIImageView *ivItem2;
    
    IBOutlet InputCellStypeView *viewRowInputPointAmount;   //输入积分行
    IBOutlet InputCellStypeView *viewRowToAmount;   //转入账户
    
    IBOutlet InputCellStypeView *viewRowCashAmount; //转成现金数
    IBOutlet InputCellStypeView *viewRowCurrency;   //币种行
    IBOutlet InputCellStypeView *viewRowPointToCashRate;//转现比例行
    IBOutlet UIButton *btnNext;//下一步按钮
    
    GlobalData *data;//全局单例
    double  inputValue;//转现的积分数
}
@end

@implementation GYPointToCashViewController

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

    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //实例化单例
    data = [GlobalData shareInstance];
    
    //设置属性
//    viewRowAvailablePoint.lbLeftlabel.text = kLocalized(@"available_Points");
//    [viewRowAvailablePoint.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowAvailablePoint.ivTitle.image = kLoadPng(@"cell_img_points_account");//设置图标
    viewRowAvailablePoint.lbActionName.text = kLocalized(@"available_Points");
    [lbAvailablePoint setTextColor:kValueRedCorlor];
    [Utils setFontSizeToFitWidthWithLabel:viewRowAvailablePoint.lbActionName labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAvailablePoint labelLines:1];
    
    viewRowInputPointAmount.lbLeftlabel.text = kLocalized(@"number_of_turn_to_cash");
    [viewRowInputPointAmount.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [viewRowInputPointAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputPointAmount.tfRightTextField.placeholder = kLocalized(@"input_points");
    viewRowInputPointAmount.tfRightTextField.delegate = self;
    
    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"cash_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

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
    
    viewRowCashAmount.lbLeftlabel.text = kLocalized(@"converted_to_cash");
    [viewRowCashAmount.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowCurrency.lbLeftlabel.text = kLocalized(@"settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    
    viewRowPointToCashRate.lbLeftlabel.text = kLocalized(@"proportion_of_points_to_cash");
    [viewRowPointToCashRate.tfRightTextField setTextColor:kValueRedCorlor];
    
    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];

    [self get_integral_act_info];
    // Do any additional setup after loading the view from its nib.
}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    
    if (viewRowInputPointAmount.tfRightTextField &&
        viewRowInputPointAmount.tfRightTextField.text.length > 0 &&
        inputValue > 0)//输入合法
    {
        if (inputValue > data.user.availablePointAmount)//输入大于可用积分
        {
            DDLogDebug(@"输入的转现的积分大于可用积分:%f", data.user.availablePointAmount);
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"输入的积分数大于可用积分，请重新输入"];
            return;
        }
        
        if (inputValue < data.user.minPointToCashAmount)//个人积分转现最少
        {
            NSString *message = [NSString stringWithFormat:@"积分转货币积分数为不小于%@的整数", [Utils formatCurrencyStyle:data.user.minPointToCashAmount]];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        if (inputValue > (int)inputValue)//必须为整数
        {
            NSString *message = @"积分转货币积分数必须为整数.";
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }

        //格式化值
        viewRowInputPointAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue];
        viewRowCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:inputValue * data.user.pointToCashRate];
        
        //进入下一步
        GYPointToCashViewNextController *nextVC = [[GYPointToCashViewNextController alloc] initWithNibName:@"GYPointToCashViewNextController" bundle:kDefaultBundle];
        nextVC.navigationItem.title = kLocalized(@"point_to_cash_confirm");
        
        nextVC.inputValue = inputValue;
        nextVC.strPointToCashAmount = viewRowInputPointAmount.tfRightTextField.text;
        nextVC.strCurrency = viewRowCurrency.tfRightTextField.text;
        nextVC.strPointToCashRate = viewRowPointToCashRate.tfRightTextField.text;
        
        [self.navigationController pushViewController:nextVC animated:YES];

    }else//输入不合法
    {
        [Utils alertViewOKbuttonWithTitle:@"提示" message:@"请输入积分数."];
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
    
    if(inputValue < 0) return NO;

    double cash = inputValue * data.user.pointToCashRate;
    viewRowCashAmount.tfRightTextField.text = [Utils formatCurrencyStyle:cash];
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 网络数据交换
- (void)get_integral_act_info//积分账户信息
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_integral_act_info",
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
            DDLogInfo(@"get_integral_act_info dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.pointAccBal = [dic[@"residualIntegral"] doubleValue];
                    data.user.availablePointAmount = [dic[@"usableIntegral"] doubleValue];
                    data.user.todayPointAmount = [dic[@"todayNewIntegral"] doubleValue];
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
    [self setValues];

    //设置初始值
    inputValue = 0.0;
    if (data.user.isNeedRefresh)
    {
        [self get_integral_act_info];
        data.user.isNeedRefresh = NO;
    }
}

- (void)setValues
{
    //设置值
    lbAvailablePoint.text = [Utils formatCurrencyStyle:data.user.availablePointAmount];
    viewRowInputPointAmount.tfRightTextField.text = @"";
    lbTipMin0.text = [NSString stringWithFormat:@"%@:", kLocalized(@"well_tip")];
    lbTipMin1.text = kLocalized(@"point_to_cash_tip1");
    lbTipMin2.text = [NSString stringWithFormat:kLocalized(@"point_to_cash_tip2")
                     , [Utils formatCurrencyStyle:data.user.minPointToCashAmount]];
    
    viewRowCashAmount.tfRightTextField.text = @"0.00";
    viewRowCurrency.tfRightTextField.text = data.user.settlementCurrencyName;
    viewRowPointToCashRate.tfRightTextField.text = [NSString stringWithFormat:@"%.4f", data.user.pointToCashRate];
}

@end

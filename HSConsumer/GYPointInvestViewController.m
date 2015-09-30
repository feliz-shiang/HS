//
//  GYPointInvestViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分投资页面

#import "GYPointInvestViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "GYPointInvestNextViewController.h"
#import "ViewCellStyle.h"

@interface GYPointInvestViewController ()
{
    GlobalData *data;   //全局单例
    double  inputValue; //积分投资数
    
    IBOutlet ViewCellStyle *viewRowAvailablePoint;
    IBOutlet UILabel *lbAvailablePoint;
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet InputCellStypeView *viewRowInputPointInvestAmount;//输入
    IBOutlet InputCellStypeView *viewRowToAmount;   //转入账户

    IBOutlet UIButton *btnNext;
    
    IBOutlet UILabel *lbNoteRow0;//投资说明
    IBOutlet UILabel *lbNoteRow1;//说明1
    IBOutlet UILabel *lbNoteRow2;//说明2
    IBOutlet UILabel *lbNoteRow3;//说明3
    
    IBOutlet UIImageView *ivItem1;//投资说明各项前面的小图标
    IBOutlet UIImageView *ivItem2;
    IBOutlet UIImageView *ivItem3;
    
}

@end

@implementation GYPointInvestViewController

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
    [scvContainer setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnNext.frame) + 80)];

    //设置投资说明项前图标颜色
    ivItem1.image = nil;
    [ivItem1 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem2.image = nil;
    [ivItem2 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem3.image = nil;
    [ivItem3 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    
    [lbNoteRow0 setTextColor:kCellItemTextColor];
    lbNoteRow0.text = kLocalized(@"investment_instructions");
    [lbNoteRow1 setTextColor:kCellItemTextColor];
    lbNoteRow1.text = kLocalized(@"investment_instructions_1");
    [lbNoteRow2 setTextColor:kCellItemTextColor];
    lbNoteRow2.text = kLocalized(@"investment_instructions_2");
    [lbNoteRow3 setTextColor:kCellItemTextColor];
    lbNoteRow3.text = kLocalized(@"investment_instructions_3");
    
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

    viewRowInputPointInvestAmount.lbLeftlabel.text = kLocalized(@"number_of_points_to_invest");
    [viewRowInputPointInvestAmount.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewRowInputPointInvestAmount.tfRightTextField.placeholder = kLocalized(@"input_number_of_points_to_invest");
    [viewRowInputPointInvestAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    
    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"investment_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

    [btnNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self get_integral_act_info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置初始值
    inputValue = 0.0;
    if (data.user.isNeedRefresh)
    {
        [self get_integral_act_info];
        data.user.isNeedRefresh = NO;
    }

}

//下一步操作
- (void)btnNextClick:(id)sender
{
    DDLogDebug(@"next");
    inputValue = [viewRowInputPointInvestAmount.tfRightTextField.text doubleValue];
    if (viewRowInputPointInvestAmount.tfRightTextField &&
        viewRowInputPointInvestAmount.tfRightTextField.text.length > 0 &&
        [viewRowInputPointInvestAmount.tfRightTextField.text doubleValue] > 0)//输入合法
    {
        viewRowInputPointInvestAmount.tfRightTextField.text = [@(inputValue) stringValue];
        if (inputValue > data.user.availablePointAmount)//输入大于可用积分
        {
            DDLogDebug(@"大于可用积分:%f", data.user.availablePointAmount);
            DDLogDebug(@"inputValue:%f", inputValue);
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"输入的积分数大于可用积分，请重新输入"];
            return;
        }
        
        if (inputValue < data.user.minPointToInvest)//个人积分投资最低值
        {
            NSString *message = [NSString stringWithFormat:@"最小积分投资金额值：%@", [Utils formatCurrencyStyle:data.user.minPointToInvest]];
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        
        if (inputValue > (int)inputValue)//必须为整数
        {
            NSString *message = @"积分投资数必须为整数.";
            [Utils alertViewOKbuttonWithTitle:@"提示" message:message];
            return;
        }
        
        if ((int)inputValue % 100 > 0)//100的整数倍
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:@"积分投资金额为100的整数倍."];
            return;
        }

        //进入下一步
        GYPointInvestNextViewController *nextVC = [[GYPointInvestNextViewController alloc] initWithNibName:@"GYPointInvestNextViewController" bundle:kDefaultBundle];
        nextVC.navigationItem.title = kLocalized(@"point_to_invest_confirm");
        
        nextVC.inputValue = inputValue;
        [self.navigationController pushViewController:nextVC animated:YES];
        
    }else//输入不合法
    {
        [Utils alertViewOKbuttonWithTitle:@"提示" message:@"请输入投资积分数."];
    }
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

- (void)setValues
{
    lbAvailablePoint.text = [Utils formatCurrencyStyle:data.user.availablePointAmount];
    viewRowInputPointInvestAmount.tfRightTextField.text = @"";
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

@end

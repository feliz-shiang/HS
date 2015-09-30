//
//  GYHSDToCashAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//互生币转现账户主页面

#import "GYHSDToCashAccoutViewController.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "GYHSDToCashToHSDToConAccountViewController.h"
#import "GYHSDToCashToCashAccountViewController.h"
#import "GYOnlineBuyHSBViewController.h"
#import "GYBuyHSBViewController.h"
#import "UIView+CustomBorder.h"
#import "GYBaseQueryListViewController.h"

@interface GYHSDToCashAccoutViewController ()
{
    IBOutlet UIView *vParentView; //第一栏，账户余额，用于设置其边框
    GlobalData *data;   //全局单例
    
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet UILabel *lbLabelHSDToCashAccBal;  //互生币账户流通币余额文本
    IBOutlet UILabel *lbHSDToCashAccBal;       //互生币账户流通币余额
    
    IBOutlet UIView *viewLine;
    IBOutlet UILabel *lbLabelHSDConAccBal;  //互生币账户消费币余额文本
    IBOutlet UILabel *lbHSDConAccBal;       //互生币账户消费币余额

    IBOutlet ViewCellStyle *viewToCashAccount;  //转货币账户栏
    IBOutlet ViewCellStyle *viewBuyHSB;         //购互生币

    IBOutlet ViewCellStyle *viewToCashDetailQuery;    //互生币流通账户明细查询栏
    IBOutlet ViewCellStyle *viewToHSDConDetailQuery;    //互生币消费账户明细查询栏
}

@end

@implementation GYHSDToCashAccoutViewController

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
    
    data = [GlobalData shareInstance];
    
    //设置边框
    [vParentView addTopBorder];
    [vParentView addBottomBorder];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //初始化
    [lbLabelHSDToCashAccBal setTextColor:kCellItemTitleColor];//积分总数字体颜色
    lbLabelHSDToCashAccBal.text = kLocalized(@"HS_coins_to_cash_account_balance2");
    [lbHSDToCashAccBal setTextColor:kCorlorFromRGBA(250, 175, 70, 1)];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelHSDToCashAccBal labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHSDToCashAccBal labelLines:1];
    
    [viewLine setBackgroundColor:lbHSDToCashAccBal.textColor];
    [lbLabelHSDConAccBal setTextColor:kCellItemTitleColor];//总数字体颜色
    lbLabelHSDConAccBal.text = kLocalized(@"HS_coins_consumer_account_balance");
    [lbHSDConAccBal setTextColor:lbHSDToCashAccBal.textColor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelHSDConAccBal labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHSDConAccBal labelLines:1];

    //实例化功能列表
    //购互生币
    viewBuyHSB.ivTitle.image = kLoadPng(@"online_shopping_hsb");//设置图标
    viewBuyHSB.lbActionName.text = kLocalized(@"buy_hsb");//设置功能名称
    [viewBuyHSB addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //互生币转货币账户栏
    viewToCashAccount.ivTitle.image = kLoadPng(@"hsb_to_cash");
    viewToCashAccount.lbActionName.text = kLocalized(@"HS_coins_to_cash_toCash_account");
    [viewToCashAccount addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    //互生币流通账户明细查询栏
    viewToCashDetailQuery.ivTitle.image = kLoadPng(@"points_account_details_query");
    viewToCashDetailQuery.lbActionName.text = kLocalized(@"HSDToCash_acc_details_query");
    [viewToCashDetailQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //互生币消费账户明细查询栏
    viewToHSDConDetailQuery.ivTitle.image = kLoadPng(@"hsb_directional_con_account_details_query");
    viewToHSDConDetailQuery.lbActionName.text = kLocalized(@"HSDToCon_acc_details_query");
    [viewToHSDConDetailQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    [scvContainer setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(viewToHSDConDetailQuery.frame) + 50)];

    [self get_user_info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setValues];
    //设置值
//    lbLabelHSDToCashAccBal.text = kLocalized(@"HS_coins_to_cash_account_balance");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
    UIViewController *vc = nil;
    
    if (viewBuyHSB == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYBuyHSBViewController class]));
        vc.navigationItem.title = viewBuyHSB.lbActionName.text;
    }else if (viewToCashAccount == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYHSDToCashToCashAccountViewController class]));
        vc.navigationItem.title = viewToCashAccount.lbActionName.text;
    }else if (viewToCashDetailQuery == sender)
    {
        GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_HSDToCash;
        vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29],//最近1月 要减1天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:30 * 3 - 1]//最近3月 要减1天
                                   ];
        vcDetail.navigationItem.title = viewToCashDetailQuery.lbActionName.text;
        vc = vcDetail;
        
//        vc = kLoadVcFromClassStringName(NSStringFromClass([TestViewController class]));

//        GYHSDToCashAccountsDetailViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYHSDToCashAccountsDetailViewController class]));
//        vcDetail.arrLeftDropMenu = @[@"全部", @"互生币转消费账户", @"互生币转现金账户"];
//        vcDetail.arrRightDropMenu = @[@"全部", @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
//        vc = vcDetail;
//        vc.navigationItem.title = kLocalized(@"HSDToCash_acc_details");
    }else if (viewToHSDConDetailQuery == sender)
    {
        GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_HSDToCon;
        vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29]//最近1月 要减1天
                                   ];
        vcDetail.navigationItem.title = viewToHSDConDetailQuery.lbActionName.text;
        vc = vcDetail;

//        vc = kLoadVcFromClassStringName(NSStringFromClass([TestViewController class]));

//        GYHSDConAccountDetailViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYHSDConAccountDetailViewController class]));
//        vcDetail.arrLeftDropMenu = @[@"全部"];
//        vcDetail.arrRightDropMenu = @[@"全部", @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
//        vc = vcDetail;
//        vc.navigationItem.title = kLocalized(@"HSDCon_acc_details");
    }
    
    if (!vc) return;
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
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
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.cardNumber = kSaftToNSString(dic[@"resNo"]);
                    data.user.custId = kSaftToNSString(dic[@"custId"]);
                    data.user.cashAccBal = [kSaftToNSString(dic[@"cash"]) doubleValue];
                    NSString *userName = dic[@"custName"];//该键值是动态返回，已经实名绑定就有返回
                    if (userName)
                    {
                        data.user.userName = kSaftToNSString(dic[@"custName"]);
                    }else
                    {
                        data.user.userName = userName;
                    }
                    data.user.HSDToCashAccBal = [kSaftToNSString(dic[@"hsbTransferCash"]) doubleValue];
                    data.user.HSDConAccBal = [kSaftToNSString(dic[@"hsbTransferConsume"]) doubleValue];
                    data.user.investAccTotal = [kSaftToNSString(dic[@"invest"]) doubleValue];
                    data.user.isRealName = ([[kSaftToNSString(dic[@"isAuth"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isBankBinding = ([[kSaftToNSString(dic[@"isBindBank"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isEmailBinding = ([[kSaftToNSString(dic[@"isBindEmail"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isPhoneBinding = ([[kSaftToNSString(dic[@"isBindMobile"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isRealNameRegistration = ([[kSaftToNSString(dic[@"isReg"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.pointAccBal = [kSaftToNSString(dic[@"residualIntegral"]) doubleValue];
                    data.user.availablePointAmount = [kSaftToNSString(dic[@"usableIntegral"]) doubleValue];
                    data.user.todayPointAmount = [kSaftToNSString(dic[@"todayNewIntegral"]) doubleValue];
                    
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

- (void)setValues
{
    lbHSDToCashAccBal.text = [Utils formatCurrencyStyle:data.user.HSDToCashAccBal];
    lbHSDConAccBal.text = [Utils formatCurrencyStyle:data.user.HSDConAccBal];
}

@end

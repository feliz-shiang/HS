//
//  GYCashAccountViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCashAccountViewController.h"
#import "GlobalData.h"
#import "GYCashTransfersViewController.h"
#import "GYBaseQueryListViewController.h"
#import "UIView+CustomBorder.h"

@interface GYCashAccountViewController ()
{
    IBOutlet UIView *vParentView; //第一栏，账户余额，用于设置其边框
    GlobalData *data;//单例
    IBOutlet UILabel *lbAccountBalance;    //现金账户余额
    IBOutlet UILabel *lbLabelAvailableCash;//现金账户余额标签   
    
    IBOutlet ViewCellStyle *viewTransfer;  //现金转账
    IBOutlet ViewCellStyle *viewCashQuery; //账户明细查询
}

@end

@implementation GYCashAccountViewController

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
    
    //清除下一级页面返回按钮的文字
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //设置边框
    [vParentView addTopBorder];
    [vParentView addBottomBorder];
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //初始化
    [lbLabelAvailableCash setTextColor:kCellItemTitleColor];//总数字体颜色
    lbLabelAvailableCash.text = kLocalized(@"cash_account_balance");
    [lbAccountBalance setTextColor:kCorlorFromRGBA(0, 210, 150, 1)];
    [Utils setFontSizeToFitWidthWithLabel:lbAccountBalance labelLines:1];

    //现金账户转账
    viewTransfer.ivTitle.image = kLoadPng(@"cell_img_cash_account_transfer");//设置图标
    viewTransfer.lbActionName.text = kLocalized(@"cash_transfers");//设置功能名称
    [viewTransfer addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //明细查询
    viewCashQuery.ivTitle.image = kLoadPng(@"cash_account_details_query");
    viewCashQuery.lbActionName.text = kLocalized(@"check_details");
    [viewCashQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self get_cash_act_info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置值
    [self setValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
    UIViewController *vc = nil;

    if (viewTransfer == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYCashTransfersViewController class]));
        vc.navigationItem.title = viewTransfer.lbActionName.text;
    }else if (viewCashQuery == sender)
    {
        GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_Cash;
        vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29]//最近1月 要减1天
                                   ];
        vc = vcDetail;
        vc.navigationItem.title = kLocalized(@"cash_acc_details");
    }
    
    if (!vc) return;
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
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
    lbAccountBalance.text = [Utils formatCurrencyStyle:data.user.cashAccBal];
}

@end

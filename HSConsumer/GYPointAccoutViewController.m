//
//  GYPointAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分账户主页面

#import "GYPointAccoutViewController.h"
#import "TestViewController.h"
#import "GYPointToCashViewController.h"
#import "GYPointInvestViewController.h"
#import "GYBaseQueryListViewController.h"
#import "ViewCellStyle.h"
#import "UIView+CustomBorder.h"
#import "RTLabel.h"
#import "UIAlertView+Blocks.h"
#import "GYPointToHSDViewController.h"

@interface GYPointAccoutViewController ()
{
    IBOutlet UIView *vParentView; //第一栏，账户余额，用于设置其边框
    GlobalData *data;   //全局单例
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet UILabel *lbLabelAccountTotal;  //积分账户余数标签
    IBOutlet UILabel *lbAccountTotalAmount;       //积分账户余数
    
    IBOutlet UILabel *lbLabelAvailablePoint;//可用积分标签
    IBOutlet UILabel *lbAvailablePointAmount;//可用积分数
    
    IBOutlet UILabel *lbLabelTodayPoint;    //今日积分标签
    IBOutlet UILabel *lbTodayPointAmount;   //今日积分数
    
    IBOutlet RTLabel *lbLabelAccidentInsurance;//意外保障提醒
    
    IBOutlet ViewCellStyle *viewPointToCash;//积分转现栏
    IBOutlet ViewCellStyle *viewPointInvest;//积分投资栏
    IBOutlet ViewCellStyle *viewPointToHSD;//积分转互生币栏
    IBOutlet ViewCellStyle *viewDetailQuery;//明细查询栏

}

@end

@implementation GYPointAccoutViewController

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
    [scvContainer setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(viewDetailQuery.frame) + 80)];

    //初始化
    [lbLabelAccountTotal setTextColor:kCorlorFromRGBA(0, 90, 168, 1)];
    [lbLabelAccountTotal setText:kLocalized(@"point_account_bal")];
    [lbAccountTotalAmount setTextColor:lbLabelAccountTotal.textColor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelAccountTotal labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAccountTotalAmount labelLines:1];
    
    [lbLabelAvailablePoint setTextColor:kCellItemTitleColor];
    [lbLabelAvailablePoint setText:kLocalized(@"available_Points")];
    [lbAvailablePointAmount setTextColor:kCellItemTitleColor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelAvailablePoint labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAvailablePointAmount labelLines:1];

    [lbLabelTodayPoint setTextColor:kCellItemTitleColor];
    [lbLabelTodayPoint setText:kLocalized(@"today_point")];
    [lbTodayPointAmount setTextColor:lbLabelTodayPoint.textColor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelTodayPoint labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbTodayPointAmount labelLines:1];

    //实例化功能列表
    //积分转现
    viewPointToCash.ivTitle.image = kLoadPng(@"cell_img_points_to_cash");//设置图标
    viewPointToCash.lbActionName.text = kLocalized(@"points_to_cash");//设置功能名称
    [viewPointToCash addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //积分投资
    viewPointInvest.ivTitle.image = kLoadPng(@"cell_img_points_to_invest");
    viewPointInvest.lbActionName.text = kLocalized(@"points_of_investment");
    [viewPointInvest addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //积分转互生币栏
    viewPointToHSD.ivTitle.image = kLoadPng(@"cell_img_points_to_hsd");
    viewPointToHSD.lbActionName.text = kLocalized(@"points_to_hsd");
    [viewPointToHSD addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    //积分明细查询
    viewDetailQuery.ivTitle.image = kLoadPng(@"points_account_details_query");
    viewDetailQuery.lbActionName.text = kLocalized(@"check_details");
    [viewDetailQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    [self get_integral_act_info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setValues];
}

- (void)setValues
{
    //设置值
    lbAccountTotalAmount.text = [Utils formatCurrencyStyle:data.user.pointAccBal];
    lbAvailablePointAmount.text = [Utils formatCurrencyStyle:data.user.availablePointAmount];
    lbTodayPointAmount.text = [Utils formatCurrencyStyle:data.user.todayPointAmount];
    
#if 0
#warning 屏蔽掉 设置福利提示显示

    //设置福利提示显示
    double lpoint = -1;
    double reachPoint = 0;
    
    NSMutableString *strFormat = [NSMutableString stringWithString:@""];
    [strFormat appendString:@"<font size=14 color='#8C8C8C'>"];
    
    //互生意外伤害保障
    if (data.user.grandTotalPointAmount < data.user.pointForReachAccidentalInjuriesSafeguard)
    {
        lpoint = data.user.pointForReachAccidentalInjuriesSafeguard - data.user.grandTotalPointAmount;
        reachPoint = data.user.pointForReachAccidentalInjuriesSafeguard;
        
        [strFormat appendString:kLocalized(@"points_worse_accident_protection_for_free")];
        
    }else if (data.user.investAccTotal < data.user.pointForReachFreeMedicalSubsidy)//医疗补贴
    {
        lpoint = data.user.pointForReachFreeMedicalSubsidy - data.user.investAccTotal;
        reachPoint = data.user.pointForReachFreeMedicalSubsidy;
        
        [strFormat appendString:kLocalized(@"points_free_medical_subsidy")];
    }
    [strFormat appendString:@"</font>"];
    
    if (lpoint > 0)
    {
        //格式化积分数值
        NSString *strLpoint = [NSString stringWithFormat:@"<font size=14 color='#1FAF6D'>%@</font>", [Utils formatCurrencyStyle:lpoint]];
        lbLabelAccidentInsurance.text = [NSString stringWithFormat:strFormat,
                                         [Utils formatCurrencyStyle:reachPoint],
                                         strLpoint];
        
    }else
    {
        lbLabelAccidentInsurance.text = @"";
    }
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
    UIViewController *vc = nil;
    
    //积分转现
    if (viewPointToCash == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYPointToCashViewController class]));
        vc.navigationItem.title = viewPointToCash.lbActionName.text;
    }else if (viewPointInvest == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYPointInvestViewController class]));
        vc.navigationItem.title = viewPointInvest.lbActionName.text;
    }else if (viewPointToHSD == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYPointToHSDViewController class]));
        vc.navigationItem.title = viewPointToHSD.lbActionName.text;
    }else if (viewDetailQuery == sender)
    {
        GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_Point;
        vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29]//最近1月 要减1天
                                   ];
//        vcDetail.arrLeftDropMenu = @[@"全部", @"消费积分", @"消费积分撤单", @"积分转现", @"积分投资"];
//        vcDetail.arrRightDropMenu = @[@"全部", @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
        vc = vcDetail;
        vc.navigationItem.title = kLocalized(@"point_acc_details");
    }
    
    if (!vc) return;
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
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

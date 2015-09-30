//
//  GYInvestAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//投资账户主页面

#import "GYInvestAccoutViewController.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "UIView+CustomBorder.h"
#import "GYBaseQueryListViewController.h"
#import "InputCellStypeView.h"

@interface GYInvestAccoutViewController ()
{
    GlobalData *data;   //全局单例
    IBOutlet InputCellStypeView *rowViewLastInvestShare;//上年度分红回报率
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet UIView *vParentView0;        //第一栏 用于设置其边框
    IBOutlet UIView *vParentView1;        //第二栏 用于设置其边框
    
    IBOutlet UILabel *lbLabelAccountTotal;   //投资账户总数label
    IBOutlet UILabel *lbAccountTotal;   //总数

    IBOutlet UILabel *lbLabelInvestmentDividendsTotal;//投资分红总额label
    IBOutlet UILabel *lbInvestmentDividendsTotal;//投资分红总额
    
    IBOutlet UILabel *lbLabelAvailableToHSD;//转入流通币label
    IBOutlet UILabel *lbAvailableToHSD;     //转入流通币

    IBOutlet UILabel *lbLabelHSDConAccBal;  //转入定向消费币label
    IBOutlet UILabel *lbHSDConAccBal;       //转入定向消费币

    IBOutlet ViewCellStyle *viewRowPointInvestDetailsQuery;//积分投资明细查询栏
    IBOutlet ViewCellStyle *viewRowInvestmentDividendsDetailsQuery;//投资分红总明细查询栏
    IBOutlet UIView *viewLine;//账户分隔线

}

@end

@implementation GYInvestAccoutViewController

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
    
    //设置边框
    [vParentView0 addTopBorderAndBottomBorder];
    [vParentView1 addTopBorderAndBottomBorder];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [viewLine setBackgroundColor:kCorlorFromRGBA(250, 175, 50, 1)];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(viewRowInvestmentDividendsDetailsQuery.frame) + 80)];

    //初始化
    [lbLabelAccountTotal setTextColor:kCellItemTitleColor];//总数字体颜色
    [lbAccountTotal setTextColor:kCorlorFromRGBA(230, 33, 40, 1)];
    lbLabelAccountTotal.text = kLocalized(@"point_invest_total_amount");
    
//    上年度分红回报率
    rowViewLastInvestShare.lbLeftlabel.text = [NSString stringWithFormat:kLocalized(@"last_invest_share"), @""];
    rowViewLastInvestShare.tfRightTextField.text = @"";
    [rowViewLastInvestShare.tfRightTextField setTextColor:kCorlorFromRGBA(230, 33, 40, 1)];
    
    [lbLabelInvestmentDividendsTotal setTextColor:kCellItemTitleColor];
    [lbLabelAvailableToHSD setTextColor:kCellItemTextColor];
    [lbLabelHSDConAccBal setTextColor:kCellItemTextColor];

    [lbInvestmentDividendsTotal setTextColor:viewLine.backgroundColor];
    [lbAvailableToHSD setTextColor:kCellItemTextColor];
    [lbHSDConAccBal setTextColor:kCellItemTextColor];
    
    lbLabelInvestmentDividendsTotal.text = kLocalized(@"investment_dividends_total");
    lbLabelAvailableToHSD.text = kLocalized(@"investment_available_to_HSD");
    lbLabelHSDConAccBal.text = kLocalized(@"investment_HSDCon");

    [Utils setFontSizeToFitWidthWithLabel:lbAccountTotal labelLines:2];
    [Utils setFontSizeToFitWidthWithLabel:lbInvestmentDividendsTotal labelLines:2];

    [Utils setFontSizeToFitWidthWithLabel:lbLabelAvailableToHSD labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbAvailableToHSD labelLines:1];
    
    [Utils setFontSizeToFitWidthWithLabel:lbLabelHSDConAccBal labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHSDConAccBal labelLines:1];
    
    //积分投资明细查询
    viewRowPointInvestDetailsQuery.ivTitle.image = kLoadPng(@"cash_account_details_query");
    viewRowPointInvestDetailsQuery.lbActionName.text = kLocalized(@"point_invest_details_query");
    [viewRowPointInvestDetailsQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //投资分红总明细查询
    viewRowInvestmentDividendsDetailsQuery.ivTitle.image = kLoadPng(@"cash_account_details_query");
    viewRowInvestmentDividendsDetailsQuery.lbActionName.text = kLocalized(@"investment_dividends_details_query");
    [viewRowInvestmentDividendsDetailsQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [self get_invest_act_info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置值
    lbAccountTotal.text = [Utils formatCurrencyStyle:data.user.investAccTotal];
    lbInvestmentDividendsTotal.text = [Utils formatCurrencyStyle:data.user.investmentDividendsTotal];
    lbAvailableToHSD.text = [Utils formatCurrencyStyle:data.user.investAccToHSDToConAccTotal];
    lbHSDConAccBal.text = [Utils formatCurrencyStyle:data.user.investAccToHSDToCashAccTotal];
//    investAccToHSDToCashAccTotal;//*投资账户转入流通币总数
//    @property (assign, nonatomic) double investAccToHSDToConAccTotal;//*投资账户转入消费币总数
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
    UIViewController *vc = nil;
    //////以前每个里面都要实例化一次 代码重复  现在直接拿出来  by  liss
    GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    // modify by songjk 积分投资分红明细查询 无显示查询条件修改
    vcDetail.isShowBtnDetail = YES;
    vcDetail.arrLeftParas = @[@"0"];
    vc = vcDetail;
    //积分转现
    if (viewRowPointInvestDetailsQuery == sender)
    {
        vcDetail.detailsCode = kDetailsCode_InvestPoint;
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29]//最近1月 要减1天
                                   ];
        vcDetail.navigationItem.title = viewRowPointInvestDetailsQuery.lbActionName.text;
       
//        kLocalized(@"invest_acc_details");
    }else if (viewRowInvestmentDividendsDetailsQuery == sender)
    {
//        GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
//        vcDetail.isShowBtnDetail = NO;
        vcDetail.detailsCode = kDetailsCode_InvestDividends;
//        vcDetail.arrLeftParas = @[@"0"];
        vcDetail.arrRightParas = @[
                                   [GYBaseQueryListViewController getDateRangeFromTodayWithDays: 365 * 3 - 1]//最近3年 要减1天
                                   ];
        vcDetail.navigationItem.title = viewRowInvestmentDividendsDetailsQuery.lbActionName.text;
//        vc = vcDetail;

//        vc = kLoadVcFromClassStringName(NSStringFromClass([TestViewController class]));

//        GYInvestDetailViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYInvestDetailViewController class]));
//        vcDetail.arrLeftDropMenu = @[@"全部", @"积分投资"];
//        vcDetail.arrRightDropMenu = @[@"全部", @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
//        vc = vcDetail;
//        vc.navigationItem.title = viewRowInvestmentDividendsDetailsQuery.lbActionName.text;//kLocalized(@"invest_acc_details");
    }
    
    if (!vc) return;
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 网络数据交换
- (void)get_invest_act_info//同步账户信息
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_invest_act_info",
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
            DDLogInfo(@"get_invest_act_info dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    
                    data.user.investAccTotal = [dic[@"investIntegralTotal"] doubleValue];
                    data.user.investmentDividendsTotal = [dic[@"dividentsTotal"] doubleValue];
                    data.user.investAccToHSDToCashAccTotal = [dic[@"dcHsbTotal"] doubleValue];
                    data.user.investAccToHSDToConAccTotal = [dic[@"ccyHsbTotal"] doubleValue];
                    
                    //刷新显示
                    lbAccountTotal.text = [Utils formatCurrencyStyle:data.user.investAccTotal];
                    lbInvestmentDividendsTotal.text = [Utils formatCurrencyStyle:data.user.investmentDividendsTotal];
                    lbAvailableToHSD.text = [Utils formatCurrencyStyle:data.user.investAccToHSDToConAccTotal];
                    lbHSDConAccBal.text = [Utils formatCurrencyStyle:data.user.investAccToHSDToCashAccTotal];
                    
                    rowViewLastInvestShare.lbLeftlabel.text = [NSString stringWithFormat:kLocalized(@"last_invest_share"), kSaftToNSString(dic[@"investYear"])];
                    rowViewLastInvestShare.tfRightTextField.text = kSaftToNSString(dic[@"lastInvestShareRatio"]);;
                    
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

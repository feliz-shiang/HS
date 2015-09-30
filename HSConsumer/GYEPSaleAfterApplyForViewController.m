//
//  GYEPSaleAfterApplyForViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEPSaleAfterApplyForViewController.h"
#import "ViewCellStyle.h"
#import "TestViewController.h"
#import "GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h"
#import "GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController.h"
#import "GYEPSaleAfterApplyForChangeGoodsViewController1.h"

@interface GYEPSaleAfterApplyForViewController ()
{
    IBOutlet ViewCellStyle *viewRow0;
    IBOutlet ViewCellStyle *viewRow1;
    IBOutlet ViewCellStyle *viewRow2;
    IBOutlet UILabel *lbCaption0;
    IBOutlet UILabel *lbCaption1;
}
@end

@implementation GYEPSaleAfterApplyForViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    viewRow0.ivTitle.image = nil;//设置图标
    viewRow0.lbActionName.text = kLocalized(@"ep_after_sales_service_apply_for_only_return_money");//设置功能名称
    viewRow0.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForOnlyReturnMoneyViewController class]);
    [lbCaption0 setTextColor:kCellItemTextColor];
    lbCaption0.text = kLocalized(@"ep_after_sales_service_apply_for_only_return_money_caption");
    [viewRow0 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    
    viewRow1.ivTitle.image = nil;//设置图标
    viewRow1.lbActionName.text = kLocalized(@"ep_after_sales_service_apply_for_return_goods_money");//设置功能名称
    viewRow1.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController class]);
    [lbCaption1 setTextColor:kCellItemTextColor];
    lbCaption1.text = kLocalized(@"ep_after_sales_service_apply_for_return_goods_money_caption");
    [viewRow1 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    viewRow2.ivTitle.image = nil;//设置图标
    viewRow2.lbActionName.text = kLocalized(@"ep_after_sales_service_apply_for_change_goods");//设置功能名称
    viewRow2.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForChangeGoodsViewController1 class]);
    [viewRow2 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
//    1 退货，2 仅退款， 3换货
//    传ID下去
    if (!sender) return;
    ViewCellStyle *viewSender = sender;
    UIViewController *vc = nil;// = kLoadVcFromClassStringName(viewSender.nextVcName);
    
    if (viewRow0 == viewSender)
    {
//        if (kSaftToNSInteger(self.dicDataSource[@"isRefund"]) == 1)//不可以重复申请
//        {
//            [Utils showMessgeWithTitle:nil message:kLocalized(@"您已经提交过此项申请.") isPopVC:nil];
//            return;
//        }
        
        GYEPSaleAfterApplyForOnlyReturnMoneyViewController *vc_ = kLoadVcFromClassStringName(viewSender.nextVcName);
        vc_.dicDataSource = self.dicDataSource;
        vc = vc_;
    }else if (viewRow1 == viewSender)
    {
//        if (kSaftToNSInteger(self.dicDataSource[@"isRefund"]) == 1)
//        {
//            NSArray *arrItems = self.dicDataSource[@"items"];
//            BOOL isCanRefund = NO;
//            for (NSDictionary *dic in arrItems)
//            {
//                if (kSaftToNSInteger(dic[@"refundStatus"]) == -1 || kSaftToNSInteger(dic[@"refundStatus"]) == -2)
//                {
//                    isCanRefund = YES;
//                    break;
//                }
//            }
//            if (!isCanRefund)
//            {
//                [Utils showMessgeWithTitle:nil message:kLocalized(@"该订单没有可以进行退货退款的商品.") isPopVC:nil];
//                return;
//            }
//            
//            [Utils showMessgeWithTitle:nil message:kLocalized(@"您已经提交过此项申请.") isPopVC:nil];
//            return;
//        }
        
        GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController *vc_ = kLoadVcFromClassStringName(viewSender.nextVcName);
        vc_.dicDataSource = self.dicDataSource;
        vc = vc_;
    }else if (viewRow2 == viewSender)
    {
//        if (kSaftToNSInteger(self.dicDataSource[@"isRefund"]) == 1)//不可以重复申请
//        {
//            [Utils showMessgeWithTitle:nil message:kLocalized(@"您已经提交过此项申请.") isPopVC:nil];
//            return;
//        }
        
        GYEPSaleAfterApplyForChangeGoodsViewController1 *vc_ = kLoadVcFromClassStringName(viewSender.nextVcName);
        vc_.dicDataSource = self.dicDataSource;
        vc = vc_;
    }
    
    vc.navigationItem.title = viewSender.lbActionName.text;
    
    if (!vc) return;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

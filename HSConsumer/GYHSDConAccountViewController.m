//
//  GYHSDConAccountViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//互生币消费账户主页面

#import "GYHSDConAccountViewController.h"
#import "GlobalData.h"
#import "ViewCellStyle.h"
#import "UIView+CustomBorder.h"
#import "TestViewController.h"

@interface GYHSDConAccountViewController ()
{
    GlobalData *data;   //全局单例
    IBOutlet UIView *vParentView; //第一栏，账户余额，用于设置其边框
    
    IBOutlet UILabel *lbLabelHSDConAccBal;  //互生币消费账户余额文本
    IBOutlet UILabel *lbHSDConAccBal;       //互生币消费账户余额
    
    IBOutlet ViewCellStyle *viewDetailQuery;//明细查询栏
}

@end

@implementation GYHSDConAccountViewController

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
    [vParentView addTopBorder];
    [vParentView addBottomBorder];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //初始化
    [lbLabelHSDConAccBal setTextColor:kCellItemTitleColor];//总数字体颜色
    [lbHSDConAccBal setTextColor:kCorlorFromRGBA(172, 98, 73, 1)];

    //明细查询
    viewDetailQuery.ivTitle.image = kLoadPng(@"cell_img_detail_check");
    viewDetailQuery.lbActionName.text = kLocalized(@"check_details");
    [viewDetailQuery addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置值
    lbLabelHSDConAccBal.text = kLocalized(@"HS_coins_consumer_account_balance");
    lbHSDConAccBal.text = [Utils formatCurrencyStyle:data.user.HSDConAccBal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushNextVC:(id)sender
{
    UIViewController *vc = nil;
    
    if (viewDetailQuery == sender)
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([TestViewController class]));

//        GYHSDConAccountDetailViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYHSDConAccountDetailViewController class]));
//        vcDetail.arrLeftDropMenu = @[@"全部"];
//        vcDetail.arrRightDropMenu = @[@"全部", @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
//        vc = vcDetail;
        vc.navigationItem.title = kLocalized(@"HSDCon_acc_details");
    }
    
    if (!vc) return;
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}

@end

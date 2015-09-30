//
//  GYAccountOperatingViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kKeyCellName @"keyName"
#define kKeyCellIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYAccountOperatingViewController.h"
#import "GlobalData.h"
#import "CellTypeImagelabel.h"
#import "GYPointToCashViewController.h"
#import "GYPointInvestViewController.h"
#import "GYHSDToCashToCashAccountViewController.h"
#import "GYCashTransfersViewController.h"
#import "GYPointToHSDViewController.h"
#import "GYBuyHSBViewController.h"

@interface GYAccountOperatingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    GlobalData *data;   //全局单例
    NSMutableArray *arrPowers; //功能列表数组
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GYAccountOperatingViewController

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
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    data = [GlobalData shareInstance];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"CellTypeImagelabel_35" : @"CellTypeImagelabel" bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellTypeImagelabelIdentifier];
    
    arrPowers = [NSMutableArray array];
    [arrPowers addObject: @[@{kKeyCellIcon: @"cell_img_points_to_cash",
                             kKeyCellName: kLocalized(@"points_to_cash"),
                             kKeyNextVcName: NSStringFromClass([GYPointToCashViewController class])//积分转货币
                             },
                           @{kKeyCellIcon: @"cell_img_points_to_invest",
                             kKeyCellName: kLocalized(@"points_of_investment"),
                             kKeyNextVcName: NSStringFromClass([GYPointInvestViewController class])//积分投资
                             },
                            @{kKeyCellIcon: @"cell_img_points_to_hsd",
                              kKeyCellName: kLocalized(@"points_to_hsd"),
                              kKeyNextVcName: NSStringFromClass([GYPointToHSDViewController class])//积分转互生币
                              }]];
    
    [arrPowers addObject: @[@{kKeyCellIcon: @"cell_img_cash_account_transfer",
                              kKeyCellName: kLocalized(@"cash_transfers"),
                              kKeyNextVcName: NSStringFromClass([GYCashTransfersViewController class])//货币转银行
                              }]];
    
    [arrPowers addObject: @[@{kKeyCellIcon: @"hsb_to_cash",
                              kKeyCellName: kLocalized(@"HS_coins_to_cash_toCash_account"),
                              kKeyNextVcName: NSStringFromClass([GYHSDToCashToCashAccountViewController class])//互生币转货币账户
                              },
                            @{kKeyCellIcon: @"online_shopping_hsb",
                              kKeyCellName: kLocalized(@"buy_hsb"),
                              kKeyNextVcName: NSStringFromClass([GYBuyHSBViewController class])//购互生币
                              }]];
    
//    [arrPowers addObject: @[@{kKeyCellIcon: @"cell_img_HS_wallet_acc",
//                              kKeyCellName: kLocalized(@"HS_wallet_recharge"),
//                              kKeyNextVcName: NSStringFromClass([GYHSWalletRechargeViewController class])//互生钱包充值
//                              },
//                            @{kKeyCellIcon: @"cell_img_HS_wallet_acc",
//                              kKeyCellName: kLocalized(@"HS_wallet_balance_return"),
//                              kKeyNextVcName: NSStringFromClass([GYHSWalletBalanceReturnViewController class])//互生钱包余款退回
//                              }]];
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrPowers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPowers[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTypeImagelabel *cell = [tableView dequeueReusableCellWithIdentifier:kCellTypeImagelabelIdentifier];
    if (!cell)
    {
        cell = [[CellTypeImagelabel alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTypeImagelabelIdentifier];
    }
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    UIImage * img = kLoadPng([arrPowers[section][row] valueForKey:kKeyCellIcon]);
    cell.lbCellLabel.text = [arrPowers[section][row] valueForKey:kKeyCellName];
    CGRect imgFrame = cell.ivCellImage.frame;
    
    imgFrame.size = kDefaultIconSize;
    if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5)
    {
        imgFrame.size = kDefaultIconSize3_5inch;
    }
    
    imgFrame.origin.x = kDefaultMarginToBounds;
    imgFrame.origin.y = (cell.contentView.frame.size.height - imgFrame.size.height) / 2;
    
    cell.ivCellImage.frame = imgFrame;
    cell.ivCellImage.image = img;
//    if (kSystemVersionLessThan(@"7.0"))
//        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cllh = kDefaultCellHeight;
    if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5)
        cllh = kDefaultCellHeight3_5inch;
    else
        cllh = kDefaultCellHeight;

    return cllh;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return kDefaultMarginToBounds;
    }else{
        return 1.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == arrPowers.count - 1)
    {
        return 30.0f;
    }else{
        return kDefaultMarginToBounds - 1.0f;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    UIViewController *vc = nil;
    vc = kLoadVcFromClassStringName([arrPowers[section][row] valueForKey:kKeyNextVcName]);
    vc.navigationItem.title = [arrPowers[section][row] valueForKey:kKeyCellName];
    
    if (vc && [_delegate respondsToSelector:@selector(pushVC:animated:)])
    {
        [vc setHidesBottomBarWhenPushed:YES];//隐藏tabar
        [_delegate pushVC:vc animated:YES];
    }
}
@end

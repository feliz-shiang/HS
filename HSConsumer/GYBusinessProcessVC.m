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

#import "GYBusinessProcessVC.h"
#import "GlobalData.h"
#import "CellTypeImagelabel.h"

#import "GYReportLossViewController.h"
#import "GYUnlockViewController.h"
#import "GYAgainViewController.h"
#import "GYSMSViewController.h"
//#import "GYBusinessDetailViewController.h"
#import "GYBusinessDetailViewVC.h"
#import "GYHealthViewController.h"
#import "GYAccidentViewController.h"
#import "GYWealCheckViewController.h"

@interface GYBusinessProcessVC ()<UITableViewDataSource, UITableViewDelegate>
{
    GlobalData *data;   //全局单例
    NSMutableArray *arrPowers; //功能列表数组
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GYBusinessProcessVC

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
    [arrPowers addObject: @[@{kKeyCellIcon: @"cell_img_points_card_report_loss",
                             kKeyCellName: kLocalized(@"report_the_loss_of_points_card"),
                             kKeyNextVcName: NSStringFromClass([GYReportLossViewController class])//
                              },
                            @{kKeyCellIcon: @"cell_img_points_card_unlock",
                              kKeyCellName: kLocalized(@"unlock_points_card"),
                              kKeyNextVcName: NSStringFromClass([GYUnlockViewController class])//
                              },
                            @{kKeyCellIcon: @"cell_img_points_card_rehandle",
                              kKeyCellName: kLocalized(@"points_card_rehandle"),
                              kKeyNextVcName: NSStringFromClass([GYAgainViewController class])//
                              },
//                            @{kKeyCellIcon: @"cell_img_email_binding",
//                              kKeyCellName: kLocalized(@"SMS_notification_to_open"),
//                              kKeyNextVcName: NSStringFromClass([GYSMSViewController class])//
//                              },
                            @{kKeyCellIcon: @"cell_img_progress_check",
                              kKeyCellName: kLocalized(@"check_operation"),
                              kKeyNextVcName: NSStringFromClass([GYBusinessDetailViewVC class])//
                              }]];
    
    [arrPowers addObject: @[@{kKeyCellIcon: @"cell_img_medical",
                              kKeyCellName: kLocalized(@"health_benefits"),
                              kKeyNextVcName: NSStringFromClass([GYHealthViewController class])//
                              },
                            @{kKeyCellIcon: @"cell_img_security",
                              kKeyCellName: kLocalized(@"accident_harm_security"),
                              kKeyNextVcName: NSStringFromClass([GYAccidentViewController class])//
                              },
                            @{kKeyCellIcon: @"cell_img_welfare",
                              kKeyCellName: kLocalized(@"weal_check"),
                              kKeyNextVcName: NSStringFromClass([GYWealCheckViewController class])//
                              }]];

    
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

    NSString *className = [arrPowers[section][row] valueForKey:kKeyNextVcName];
    
    UIViewController *vc = nil;
    if ([className isEqualToString:NSStringFromClass([GYBusinessDetailViewVC class])])
    {
        GYBusinessDetailViewVC *vcDetail = kLoadVcFromClassStringName(className);
        vcDetail.arrLeftParas = @[@"3", @"4", @"5"];
        vcDetail.arrRightParas = @[
                                   [GYBusinessDetailViewVC getDateRangeFromTodayWithDays:30-1],// 要减1天
                                   [GYBusinessDetailViewVC getDateRangeFromTodayWithDays:3*30-1],
                                   [GYBusinessDetailViewVC getDateRangeFromTodayWithDays:366/2-1],
                                   [GYBusinessDetailViewVC getDateRangeFromTodayWithDays:365-1]
                                   ];
        vc = vcDetail;
        
    }else
        vc = kLoadVcFromClassStringName(className);
    
    vc.navigationItem.title = [arrPowers[section][row] valueForKey:kKeyCellName];
    
    if (vc && _delegate && [_delegate respondsToSelector:@selector(pushVC:animated:)])
    {
        [vc setHidesBottomBarWhenPushed:YES];//隐藏tabar
        [_delegate pushVC:vc animated:YES];
    }
}
@end

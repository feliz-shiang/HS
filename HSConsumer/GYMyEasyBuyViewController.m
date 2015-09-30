//
//  GYMyEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMyEasyBuyViewController.h"
#import "GYMyInfoTableViewCell.h"
#import "GlobalData.h"
#import "TestViewController.h"
//个人详细资料

#import "GYPersonalFileViewController.h"


#define kKeyCellIcon @"keyIcon"
#define kKeyCellName @"keyName"
#define kKeyNextVcName @"keyNextVcName"
#define kCellTypeImagelabelIdentifier @"CellTypeImagelabelIdentifier"
//意见反馈
#import "GYFeedbackViewController.h"
//评价商品
#import "GYEvaluationGoodsViewController.h"

//逛商铺
#import "GYFindShopViewController.h"
//商铺详情
#import "GYShopDetailViewController.h"
//商品详情
#import "GYGoodDetailViewController.h"
//游客登录
#import "GYGuestLoginViewController.h"

//#import "GYForgetPasswdViewController.h"


//#import "GYForgotPasswdViewController.h"
@interface GYMyEasyBuyViewController ()

@end

@implementation GYMyEasyBuyViewController
{
    
    __weak IBOutlet UITableView *tvMyEasyBuy;
    
    
    GlobalData *data;   //全局单例

    NSArray *arrPowers; //功能列表数组

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [GlobalData shareInstance];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
  
  
    
    //注册cell以复用
    [tvMyEasyBuy registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"GYMyInfoTableViewCell_35" : @"GYMyInfoTableViewCell" bundle:kDefaultBundle]
            forCellReuseIdentifier:kCellTypeImagelabelIdentifier];


    arrPowers = @[@{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"my_order"),
                    kKeyNextVcName: NSStringFromClass([TestViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"my_group_purchase"),
                    kKeyNextVcName: NSStringFromClass([GYGuestLoginViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"my_comments"),
                    kKeyNextVcName: NSStringFromClass([GYEvaluationGoodsViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"my_receive_addresss"),
                    kKeyNextVcName: NSStringFromClass([GYPersonalFileViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"GYPersonalInfoViewController"),
                    kKeyNextVcName: NSStringFromClass([TestViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"feedback"),
                    kKeyNextVcName: NSStringFromClass([TestViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"account_security"),
                    kKeyNextVcName: NSStringFromClass([TestViewController class])
                    },
                  @{kKeyCellIcon: @"ep_mine_cell_myorder",
                    kKeyCellName: kLocalized(@"my_application_seting"),
                    kKeyNextVcName: NSStringFromClass([GYGuestLoginViewController class])
                    }
                  ];
    
    //兼容IOS6设置背景色
    tvMyEasyBuy.backgroundView = [[UIView alloc]init];
    tvMyEasyBuy.backgroundColor = [UIColor clearColor];

    //设置header
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    header.backgroundColor=kDefaultVCBackgroundColor;
    tvMyEasyBuy.tableFooterView=footer;

 
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger rows = 0;
    switch (section)
    {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 4;
            break;
        case 2:
            rows = 2;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYMyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellTypeImagelabelIdentifier];
    if (!cell)
    {
        cell = [[GYMyInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTypeImagelabelIdentifier];
    }
    
    NSString *labelStr = nil;
    UIImage *img = nil;
    
    NSInteger row = indexPath.row;
    
    

    
    switch (indexPath.section) {
        case 0:
        {
            labelStr = [arrPowers[row] valueForKey:kKeyCellName];
            img = kLoadPng([arrPowers[row] valueForKey:kKeyCellIcon]);
         [cell refreshWithImg:[arrPowers[row] valueForKey:kKeyCellIcon] WithTitle:labelStr];
        
        
        }
            break;
        case 1:
        {
            labelStr = [arrPowers[row+2] valueForKey:kKeyCellName];
            img = kLoadPng([arrPowers[row+2] valueForKey:kKeyCellIcon]);
            [cell refreshWithImg:[arrPowers[4+row] valueForKey:kKeyCellIcon] WithTitle:labelStr];
            
            
        }
            break;
        case 2:
        {
            labelStr = [arrPowers[row+6] valueForKey:kKeyCellName];
            img = kLoadPng([arrPowers[row+6] valueForKey:kKeyCellIcon]);
            [cell refreshWithImg:[arrPowers[6+row] valueForKey:kKeyCellIcon] WithTitle:labelStr];
            
            
        }
            break;
        default:
            break;
    }
    
   // [cell refreshWithImg:[arrPowers[row] valueForKey:kKeyCellIcon] WithTitle:labelStr];
    
    
   // cell.lbCellLabel.text = labelStr;
    
//    CGRect imgFrame = cell.ivCellImage.frame;
//    imgFrame.size = kDefaultIconSize;
    
//    if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5) {
//        imgFrame.size = kDefaultIconSize3_5inch;
//    }
    
//    imgFrame.origin.x = 16;
//    imgFrame.origin.y = (cell.contentView.frame.size.height - imgFrame.size.height) / 2;
//    
//    cell.ivCellImage.frame = imgFrame;
//    cell.ivCellImage.image = img;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (data.currentDeviceScreenInch)
    {
        case kDeviceScreenInch_3_5:
            return kDefaultCellHeight3_5inch;
            break;
            
        case kDeviceScreenInch_4_0:
        default:
            return kDefaultCellHeight;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16;
    }else
    {
        return 6;//加上页脚＝16
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 10;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tvMyEasyBuy deselectRowAtIndexPath:indexPath animated:YES];
    
    
//   if (indexPath.row==0) {
//       GYCompanyLoginViewController * vcLogin =[[GYCompanyLoginViewController alloc]initWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5?@"GYCompanyLoginViewController_35":@"GYCompanyLoginViewController" bundle:[NSBundle mainBundle]];
//       [self setHidesBottomBarWhenPushed:YES];
//       [self.navigationController pushViewController:vcLogin animated:YES];
//       
//   }else{
    
       UIViewController *vc = nil;
       vc = kLoadVcFromClassStringName([arrPowers[indexPath.row] valueForKey:kKeyNextVcName]);
       vc.navigationItem.title = [arrPowers[indexPath.row] valueForKey:kKeyCellName];
        [self pushVC:vc animated:YES];
 //  }
}

//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sender animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

@end

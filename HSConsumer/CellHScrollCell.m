//
//  CellHScrollCell.m
//  company
//
//  Created by apple on 14-11-13.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellHScrollCell.h"
#import "GYEasyBuyModel.h"
#import "GYBrowsingHistoryViewController.h"
#import "GYConcernsCollectViewController.h"
#import "GYEPMyHEViewController.h"
#import "GYEPMyCouponsMainViewController.h"
#import "UIView+CustomBorder.h"
#import "GYEPMyCouponsViewController.h"
#import "GYConcernsCollectGoodsViewController.h"

@implementation CellHScrollCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setTitlesAndImages:(NSArray *)arr
{
    UIButton *btn = nil;
    UILabel *label = nil;
    GYEasyBuyModel *data = nil;
    for (int i = 0; i < arr.count ; i++)
    {
        if (i>3) break;//只有4个图标
        btn = (UIButton *)[self viewWithTag:100+i];
        label = (UILabel *)[self viewWithTag:200+i];
        data = (GYEasyBuyModel *)arr[i];
        [btn setBackgroundImage:kLoadPng(data.strGoodPictureURL) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
        [label setTextColor:kCellItemTitleColor];
        [label setText:data.strGoodName];

    }
}

- (void)pushVC:(UIButton *)btn
{
    GlobalData *data = [GlobalData shareInstance];
    BOOL tipLogin = NO;
    if (!self.vcPrarentVC)return;
    UILabel *label = nil;
    UIViewController *vc = nil;
    switch (btn.tag)
    {
        case 100:
            vc = kLoadVcFromClassStringName(NSStringFromClass([GYBrowsingHistoryViewController class]));
            label = (UILabel *)[self viewWithTag:200];
            vc.navigationItem.title = label.text;
            
            break;
        case 101:
            vc = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectViewController class]));
            label = (UILabel *)[self viewWithTag:201];
            vc.navigationItem.title = label.text;
            
            tipLogin = YES;
            break;
        case 102:
            vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsMainViewController class]));
            label = (UILabel *)[self viewWithTag:202];
            vc.navigationItem.title = label.text;
            tipLogin = YES;
            
            break;
        case 103:
            vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
            label = (UILabel *)[self viewWithTag:203];
            vc.navigationItem.title = label.text;
            
            tipLogin = YES;
            break;
        default:
            break;
    }
    if (!vc) return;
    
    if (tipLogin)
    {
        if (!data.isEcLogined)
        {
            [data showLoginInView:self.vcPrarentVC.view withDelegate:nil isStay:NO];
            return;
        }
    }
    
    [self.vcPrarentVC setHidesBottomBarWhenPushed:YES];
    [self.vcPrarentVC.navigationController pushViewController:vc animated:YES];
    [self.vcPrarentVC setHidesBottomBarWhenPushed:NO];
}

@end

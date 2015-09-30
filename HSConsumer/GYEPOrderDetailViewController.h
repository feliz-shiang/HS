//
//  GYEPOrderDetailViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GYEPMyOrderViewController.h"
@interface GYEPOrderDetailViewController : UIViewController

@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSDictionary *dicDataSource;//仅用于售后申请、立即支付、判断是否货到付款
//zhangqy  延时收货同同步刷新
@property (weak, nonatomic)GYEPMyOrderViewController *delegate;
// songji 商品详情用到数据
@property (strong, nonatomic) NSString *vShopId;
@property (strong, nonatomic) NSString *itemId;
@end

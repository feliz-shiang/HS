//
//  GYEPMyOrderViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EasyPurchaseData.h"

@interface GYEPMyOrderViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrResult;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, assign) EMOrderState orderState;
@property (nonatomic, assign) BOOL firstTipsErr;//查询及结果错误首次提示提示
@property (nonatomic, assign) int startPageNo;  //从第几开始 这里默认从第1页开始传

@property (nonatomic, assign) BOOL isQueryRefundRecord;//YES:查询售后申请记录列表，NO：查询订单列表

@end

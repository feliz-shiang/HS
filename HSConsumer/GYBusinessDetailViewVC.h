//
//  GYBaseQueryListViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询类

//typedef NS_ENUM(NSUInteger, EMDetailsCode) {
//    kDetailsCode_Point = 0, //积分账户明细
//    kDetailsCode_Cash = 1,  //货币账户明细
//    kDetailsCode_HSDToCash = 2,  //流通币明细
//    kDetailsCode_HSDToCon = 3,  //消费币明细
//    kDetailsCode_InvestPoint = 4,  //投资账户-积分投资明细
//    kDetailsCode_InvestDividends = 5  //投资账户-投资分红明细
//};

/*********************一般调用方法*********************
 GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
 vcDetail.isShowBtnDetail = YES;//显示查询详情字样
 vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
 vcDetail.arrRightParas = @[[GYBaseQueryListViewController getDateRangeFromTodayWithDays:-1],
 [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
 [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
 [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29],//最近1月 要减1天
 [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29 * 3]//最近3个月 要减1天
 ];
 vcDetail.navigationItem.title = kLocalized(@"point_acc_details");
 */

#import <UIKit/UIKit.h>
#import "GYDetailsNextViewController.h"

@interface GYBusinessDetailViewVC : UIViewController

@property (nonatomic, assign) BOOL isShowBtnDetail; //是否显示查看明细提示行 默认为YES;
@property (nonatomic, assign) EMDetailsCode detailsCode;//账户类型
@property (nonatomic, assign) int startPageNo;  //从第几开始

@property (nonatomic, strong) NSArray *arrLeftParas;//左边的字符串参数
@property (nonatomic, strong) NSArray *arrRightParas;//右边的字符串参数

/**
 *	按输入的天数拼合查询日期区间：daysAgo<0,返回 全部 0000-00-00~今天日期; daysAgo=0,返回 当天~当天，其它返回如:2015-01-04~2015-02-04
 *
 *	@param 	daysAgo  至今多少天之前
 *
 *	@return	拼合后的字符串，daysAgo<0,返回 全部 0000-00-00~今天日期; daysAgo=0,返回 当天~当天，其它返回如:2015-01-04~2015-02-04
 */
+ (NSString *)getDateRangeFromTodayWithDays:(NSInteger)daysAgo;

@end

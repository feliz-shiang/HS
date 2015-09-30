//
//  GYPointToCashViewNextController.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分转现下一步页面

#import <UIKit/UIKit.h>

@interface GYPointToCashViewNextController : UIViewController

//用于上一步传递过来的详情信息
@property (nonatomic, assign) double inputValue;
@property (nonatomic, strong) NSString *strPointToCashAmount;
@property (nonatomic, strong) NSString *strCurrency;
@property (nonatomic, strong) NSString *strPointToCashRate;

@end

//
//  GYSelectPayWayViewController.h
//  HSConsumer
//
//  Created by 00 on 14-11-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择支付方式代理
@protocol GYSelectPayWayDelegate <NSObject>

//-(void)getBackPayWay:(NSString *)str;
-(void)getBackPayWay:(int)payType;
@end

@interface GYSelectPayWayViewController : UIViewController
@property (assign , nonatomic) id <GYSelectPayWayDelegate> delegate;
@property (strong , nonatomic) NSArray *arrData;
@property (assign , nonatomic) int selectIndex;

@end

//
//  ViewOrderStateInfo.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOrderStateInfo : UIView

@property (strong, nonatomic) IBOutlet UIView *vLine;
@property (strong, nonatomic) IBOutlet UILabel *lbState;
@property (strong, nonatomic) IBOutlet UILabel *lbOrderNo;
@property (strong, nonatomic) IBOutlet UILabel *lbOrderDatetime;
//zhangqiyun 自提码
@property (weak, nonatomic) IBOutlet UILabel *lbOrderTakeCode;

+ (CGFloat)getHeight;
@end

//
//  ViewFooterForOrderDetail.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFooterForOrderDetail : UIView

@property (strong, nonatomic) IBOutlet UILabel *lbLabelRealisticAmount;//实付金额
@property (strong, nonatomic) IBOutlet UILabel *lbLabelPoint;//消费积分

@property (strong, nonatomic) IBOutlet UILabel *lbRealisticAmount;//实付金额
@property (strong, nonatomic) IBOutlet UILabel *lbPoint;//消费积分

+ (CGFloat)getHeight;

@end

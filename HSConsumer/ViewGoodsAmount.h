//
//  ViewGoodsAmount.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewGoodsAmount : UIView

@property (strong, nonatomic) IBOutlet UIView *vBkg0;
@property (strong, nonatomic) IBOutlet UILabel *lbLabelAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbLabelCourierFees;
@property (strong, nonatomic) IBOutlet UILabel *lbLabelPoint;

@property (strong, nonatomic) IBOutlet UILabel *lbAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbCourierFees;
@property (strong, nonatomic) IBOutlet UILabel *lbPoint;

+ (CGFloat)getHeight;

@end

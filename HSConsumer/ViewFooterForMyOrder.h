//
//  ViewFooterForMyOrder.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFooterForMyOrder : UIView

@property (strong, nonatomic) IBOutlet UILabel *lbLabelMoney;
@property (strong, nonatomic) IBOutlet UILabel *lbMoneyAmount;
@property (strong, nonatomic) IBOutlet UIImageView *ivPointFlag;
@property (strong, nonatomic) IBOutlet UILabel *lbPointAmount;

@property (strong, nonatomic) IBOutlet UIButton *btn0;
@property (strong, nonatomic) IBOutlet UIButton *btn1;

+ (CGFloat)getHeight;
@end

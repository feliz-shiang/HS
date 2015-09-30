//
//  ViewCellForOrders.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCellForOrders : UIView

@property (strong, nonatomic) UINavigationController *nav;

- (void)setNumber:(NSInteger)number index:(NSInteger)index;
+ (CGFloat)getHeight;

@end

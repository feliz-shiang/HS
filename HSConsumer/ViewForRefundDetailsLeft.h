//
//  ViewForRefundDetailsLeft.h
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewForRefundDetailsLeft : UIView

@property (strong, nonatomic) IBOutlet UIView *viewLine0;
@property (strong, nonatomic) IBOutlet UILabel *lbRow0;
@property (strong, nonatomic) IBOutlet UILabel *lbRow1;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3;
@property (strong, nonatomic) IBOutlet UILabel *lbRow4;
@property (strong, nonatomic) IBOutlet UILabel *lbRow5;

- (void)setValues:(NSArray *)arrValues;

@end


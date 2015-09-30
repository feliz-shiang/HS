//
//  ViewForRefundDetailsRight.h
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewForRefundDetailsRight : UIView

@property (strong, nonatomic) IBOutlet UIView *viewLine0;
@property (strong, nonatomic) IBOutlet UIView *viewLine1;

@property (strong, nonatomic) IBOutlet UIImageView *ivTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbRow0;
@property (strong, nonatomic) IBOutlet UILabel *lbRow1;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3;

- (void)setShowTypeIsResult:(BOOL)isResult;

- (void)setValues:(NSArray *)arrValues;

@end


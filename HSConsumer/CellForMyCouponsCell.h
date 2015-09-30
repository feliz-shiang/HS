//
//  CellForMyOrderSubCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellForMyCouponsCellIdentifier @"CellForMyCouponsCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellForMyCouponsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbRow0;
@property (strong, nonatomic) IBOutlet UILabel *lbRow1L;
@property (strong, nonatomic) IBOutlet UILabel *lbRow1R;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2L;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2R;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3L;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3R;
@property (strong, nonatomic) IBOutlet UILabel *lbRow4L;
@property (strong, nonatomic) IBOutlet UILabel *lbRow4R;
@property (strong, nonatomic) IBOutlet UIImageView *ivHsbLogo;

+ (CGFloat)getHeight;
@end

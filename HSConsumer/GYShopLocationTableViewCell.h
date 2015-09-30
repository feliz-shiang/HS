//
//  GYShopLocationTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShopLocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbShopName;
@property (weak, nonatomic) IBOutlet UILabel *lbShopAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbShopTel;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodName;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckMap;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSeproter;

@property (weak, nonatomic) IBOutlet UIImageView *imgvMapIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;

@end

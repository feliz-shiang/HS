//
//  GYShopInfoWithLocationCell.h
//  HSConsumer
//
//  Created by Apple03 on 15-5-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShopInfoWithLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbHsNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbShopAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneCall;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckMap;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSeproter;

@property (weak, nonatomic) IBOutlet UIImageView *imgvMapIcon;
@end

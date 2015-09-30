//
//  GYAllShopTableViewCell.h
//  HSConsumer
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAllShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbAddr;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UIImageView *imgDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;

@end

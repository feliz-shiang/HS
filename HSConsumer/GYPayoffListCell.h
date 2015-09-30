//
//  GYPayoffListCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPayoffListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbParameter;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbPV;

@property (weak, nonatomic) IBOutlet UILabel *lbNum;


@end

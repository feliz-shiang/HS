//
//  GYSMSTableViewCell.h
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYSMSTableViewCell;

@interface GYSMSTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgSMSCell;//图标

@property (weak, nonatomic) IBOutlet UILabel *lbSMSTitle;//标题

@property (weak, nonatomic) IBOutlet UIButton *btnSMSCell;//选择按钮tick


- (IBAction)btnTickClick:(UIButton *)sender;//选择按钮tick点击事件


@end

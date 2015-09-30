//
//  GYQuitPhoneBandingTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYQuitPhoneBandingModel.h"
#import "GYQuitEmailBanding.h"

@interface GYQuitPhoneBandingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnQuitBanding;
-(void)refreshUIWith:(GYQuitPhoneBandingModel *)model;
-(void)refreshUIWithEmail:(GYQuitEmailBanding *)model;
@end

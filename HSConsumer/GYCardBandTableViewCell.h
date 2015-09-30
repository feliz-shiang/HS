//
//  GYCardBandTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCardBandModel.h"

@interface GYCardBandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnQuitBanding;
-(void)refreshUIWith:(GYCardBandModel *)mod;
@end

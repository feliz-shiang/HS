//
//  GYPersonalWithpictureTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"
@interface GYPersonalWithpictureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet InputCellStypeView *inputPictureInfoRow;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvater;

@end

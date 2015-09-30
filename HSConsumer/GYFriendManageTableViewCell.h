//
//  GYFriendManageTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYNewFiendModel.h"

@interface GYFriendManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvRedPoint;

@property (weak, nonatomic) IBOutlet UIImageView *imgvShield;

-(void)refreshUIWithModel :(GYNewFiendModel *)mod index:(NSInteger)index withShowRedPoint :(BOOL)show;
@end

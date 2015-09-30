//
//  GYMyCommentTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGoodComments.h"
@interface GYMyCommentTableViewCell : UITableViewCell
-(void)refreshUIWithModel :(GYGoodComments *)model;
@end

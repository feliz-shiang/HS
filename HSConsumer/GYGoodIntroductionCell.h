//
//  GYGoodIntroductionCell.h
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYGoodIntroductionModel;
static NSString* strDetailIdent = @"goodDetail";

@interface GYGoodIntroductionCell : UITableViewCell
@property (nonatomic,strong) GYGoodIntroductionModel * model;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

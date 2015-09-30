//
//  GYGoodDetailListTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYGoodDetailListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDetailInfo;
-(void)refreshUIWith:(NSString *)title WithDetail :(NSString *)detail;
@end

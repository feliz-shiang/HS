//
//  GYGeneralTableViewCell.h
//  HSConsumer
//
//  Created by 00 on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYGeneralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;//标题
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;//箭头tup
@property (weak, nonatomic) IBOutlet UILabel *lbVersions;//版本号

@end

//
//  CellMyAccountCell.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//我的账户主面的cell

#define kCellMyAccountCellIdentifier @"myAccountCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellMyAccountCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivTitle;    //cell的图标
@property (strong, nonatomic) IBOutlet UILabel *lbAccounName;   //账户名称

@end

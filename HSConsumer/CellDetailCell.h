//
//  CellDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询基类的cell

#define kCellDetailCellIdentifier @"CellDetailCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbRow1Left;
@property (strong, nonatomic) IBOutlet UILabel *lbRow1Right;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2Left;
@property (strong, nonatomic) IBOutlet UILabel *lbRow2Right;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3Left;
@property (strong, nonatomic) IBOutlet UILabel *lbRow3Right;

@end

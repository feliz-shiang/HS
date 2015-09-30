//
//  CellDetailRow.h
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询基类的cell

#define kCellDetailRowIdentifier @"CellDetailRowIdentifier"

#import <UIKit/UIKit.h>

@interface CellDetailRow : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbValue;


@end

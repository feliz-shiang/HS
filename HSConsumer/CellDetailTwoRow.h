//
//  CellDetailTwoRow.h
//  HSConsumer
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellDetailTwoRowIdentifier @"CellDetailTwoRowIdentifier"
@interface CellDetailTwoRow : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;

@end

//
//  CellDetailCell.m
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellDetailCell.h"

@interface CellDetailCell()
{
//    IBOutlet UILabel *lbSubject;
//    IBOutlet UILabel *lbDate;
//    IBOutlet UILabel *lbLabelAmount;
//    IBOutlet UILabel *lbAmount;
//    IBOutlet UILabel *lbLabelState;
//    IBOutlet UILabel *lbState;
    
}


@end

@implementation CellDetailCell

- (void)awakeFromNib
{
    [_lbRow1Left setTextColor:kCellItemTitleColor];
    [_lbRow1Right setTextColor:kCellItemTextColor];
    [_lbRow2Left setTextColor:kCellItemTextColor];
    [_lbRow2Right setTextColor:kValueRedCorlor];
    [_lbRow3Left setTextColor:kCellItemTextColor];
    [_lbRow3Right setTextColor:kCellItemTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
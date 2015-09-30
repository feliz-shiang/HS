//
//  CellMyAccountCell.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellMyAccountCell.h"

@implementation CellMyAccountCell

- (void)awakeFromNib
{
    [self.lbAccounName setTextColor:kCellItemTitleColor];
    self.lbAccounName.font = kCellTitleFont;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

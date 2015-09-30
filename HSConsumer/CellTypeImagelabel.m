//
//  CellTypeImagelabel.m
//  company
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellTypeImagelabel.h"

@implementation CellTypeImagelabel

- (void)awakeFromNib
{
    // Initialization code
    //设置字体，颜色
    [self.lbCellLabel setTextColor:kCellItemTitleColor];
    self.lbCellLabel.font = kCellTitleFont;

}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end

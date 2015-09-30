//
//  CellGoodsNameAndPriceCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellGoodsNameAndPriceCell.h"

@implementation CellGoodsNameAndPriceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbPrice setTextColor:kValueRedCorlor];

    if (kSystemVersionLessThan(@"7.0"))
    {
        UIView *cellBk = [[UIView alloc] init];
        [cellBk setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:cellBk];
    }
}

@end

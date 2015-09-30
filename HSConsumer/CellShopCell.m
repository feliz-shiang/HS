//
//  CellShopCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellShopCell.h"

@implementation CellShopCell

- (void)awakeFromNib
{
// Initialization code
//    [self.lbShopName setTextColor:kCellItemTitleColor];
//    [self.lbShopAddress setTextColor:kCellItemTextColor];
//    [self.lbShopTel setTextColor:kCellItemTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [self.lbShopName setTextColor:kCellItemTitleColor];
    [self.lbShopScope setTextColor:kCellItemTextColor];
    [self.lbShopConcernTime setTextColor:kCellItemTextColor];
    [Utils setFontSizeToFitWidthWithLabel:self.lbShopName labelLines:1];
    self.lbShopScope.numberOfLines = 1;
    self.lbShopScope.minimumFontSize = 10;
    self.lbShopScope.adjustsFontSizeToFitWidth = YES;
    [Utils setFontSizeToFitWidthWithLabel:self.lbShopConcernTime labelLines:1];
    
    if (kSystemVersionLessThan(@"7.0"))
    {
        UIView *cellBk = [[UIView alloc] init];
        [cellBk setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:cellBk];
    }
}

@end

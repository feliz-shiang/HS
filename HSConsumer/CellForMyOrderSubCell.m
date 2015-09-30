//
//  CellForMyOrderSubCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellForMyOrderSubCell.h"
#import "UIView+CustomBorder.h"

@implementation CellForMyOrderSubCell

- (void)awakeFromNib
{
    // Initialization code
    [self.viewContentBkg addTopBorderAndBottomBorder];
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbGoodsPrice setTextColor:kCellItemTitleColor];
    [self.lbGoodsCnt setTextColor:kCellItemTextColor];
    [self.lbGoodsProperty setTextColor:kCellItemTextColor];
    [Utils setFontSizeToFitWidthWithLabel:self.lbGoodsPrice labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:self.lbGoodsCnt labelLines:1];

    self.lbGoodsName.numberOfLines = 2;
    self.lbGoodsName.minimumFontSize = 12;
    self.lbGoodsName.adjustsFontSizeToFitWidth = YES;

    self.lbGoodsProperty.numberOfLines = 2;
    self.lbGoodsProperty.minimumFontSize = 8;
    self.lbGoodsProperty.adjustsFontSizeToFitWidth = YES;
   
    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

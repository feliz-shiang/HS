//
//  CellForReturnGoodsCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellForReturnGoodsCell.h"
#import "UIView+CustomBorder.h"
@interface CellForReturnGoodsCell ()
{
    BOOL isSelected;
}

@end

@implementation CellForReturnGoodsCell

- (void)awakeFromNib
{
    // Initialization code
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbGoodsPrice setTextColor:kCellItemTitleColor];
    [Utils setFontSizeToFitWidthWithLabel:self.lbGoodsName labelLines:2];
    isSelected = NO;
    [self.btnSelect setImage:kLoadPng(@"ep_cart_unselected") forState:UIControlStateNormal];
    [self.btnSelect addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)selectClick:(id)sender
{
    isSelected = !isSelected;
    if (isSelected)
    {
        [sender setImage:kLoadPng(@"ep_cart_selected") forState:UIControlStateNormal];
    }else
    {
        [sender setImage:kLoadPng(@"ep_cart_unselected") forState:UIControlStateNormal];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectChange:)])
    {
        [_delegate selectChange:self];
    }
}

- (BOOL)isSelected
{
    return isSelected;
}

+ (CGFloat)getHeight
{
    return 80.0f;
}
@end

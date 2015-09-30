//
//  CellForOrderDetailCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellForOrderDetailCell.h"
#import "UIView+CustomBorder.h"

@implementation CellForOrderDetailCell

- (void)awakeFromNib
{
    // Initialization code
    [self.lbGoodsName setTextColor:kCellItemTitleColor];
    [self.lbGoodsCnt setTextColor:kCellItemTextColor];
    [self.lbGoodsProperty setTextColor:kCellItemTextColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// add by songjk
-(void)toGoodInfo
{
    NSLog(@"跳转商品详情");
    if ([self.delegate respondsToSelector:@selector(CellForOrderDetailCellDidCliciPictureWithCell:)]) {
        [self.delegate CellForOrderDetailCellDidCliciPictureWithCell:self];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // add by songjk
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toGoodInfo)];
    [self.ivGoodsPicture addGestureRecognizer:tap];
    self.ivGoodsPicture.userInteractionEnabled = YES;
    
    self.lbGoodsName.numberOfLines = 2;
    self.lbGoodsName.minimumFontSize = 12;
    self.lbGoodsName.adjustsFontSizeToFitWidth = YES;
    
    self.lbGoodsProperty.numberOfLines = 2;
    self.lbGoodsProperty.minimumFontSize = 8;
    self.lbGoodsProperty.adjustsFontSizeToFitWidth = YES;
    if (kSystemVersionLessThan(@"7.0"))
        [self setBackgroundColor:[UIColor whiteColor]];
    
    [_vLine addTopBorder];
}

@end

//
//  GYAllShopTableViewCell.m
//  HSConsumer
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYAllShopTableViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYAllShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lbDistance.textColor=kCellItemTextColor;
    self.lbAddr.textColor=kCellItemTextColor;
    
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnShopTel setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    self.btnShopTel.imageEdgeInsets=UIEdgeInsetsMake(1, 0, 1, 158);
    self.btnShopTel.titleEdgeInsets=UIEdgeInsetsMake(0, -60, 0, 0);
   
  

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//   [self.contentView addBottomBorder];
}

@end

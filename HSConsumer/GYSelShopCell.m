//
//  GYSelShopCell.m
//  HSConsumer
//
//  Created by 00 on 15-2-6.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYSelShopCell.h"
#import "UIView+CustomBorder.h"


@implementation GYSelShopCell

- (void)awakeFromNib {

//    [self addAllBorder];
    self.lbDistance.textColor=kCellItemTextColor;
    self.lbAdd.textColor=kCellItemTitleColor;
    [self.btnCall setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnCall setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 30)];
    [self.btnCall setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
//    self.btnCall.titleLabel.backgroundColor=[UIColor purpleColor];
    self.btnCall.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.btnCall setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 190)];
 


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

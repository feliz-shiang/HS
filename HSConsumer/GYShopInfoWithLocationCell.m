//
//  GYShopInfoWithLocationCell.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYShopInfoWithLocationCell.h"
#import "UIView+CustomBorder.h"

@implementation GYShopInfoWithLocationCell

- (void)awakeFromNib
{
    // Initialization code
    
    //添加上面的分割线
    CALayer * topLayer =[CALayer layer];
    topLayer.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
    topLayer.frame=CGRectMake(self.frame.origin.x+16, 0, CGRectGetWidth(self.frame)-32, 1);
    [self.layer addSublayer:topLayer];
    
    self.lbHsNumber.textColor=kCellItemTitleColor;
    self.lbHsNumber.backgroundColor=[UIColor clearColor];
    self.lbShopAddress.textColor=kCellItemTextColor;
    self.lbDistance.textColor=kCellItemTextColor;
    [self.btnPhoneCall setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnPhoneCall setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    self.btnPhoneCall.imageEdgeInsets=UIEdgeInsetsMake(1, 0, 1, 156);
    self.btnPhoneCall.titleEdgeInsets=UIEdgeInsetsMake(0, -60, 0, 0);
    
//    self.btnPhoneCall.titleLabel.backgroundColor=[UIColor purpleColor];
    [self.btnCheckMap setTitle:kLocalized(@"ar_check_in_map") forState:UIControlStateNormal];
    [self.btnCheckMap setTitleColor:kCorlorFromRGBA(0, 143, 215, 1) forState:UIControlStateNormal];
    self.imgvMapIcon.image =[UIImage imageNamed:@"image_shopdetail_map.png"];
    [self.imgvSeproter addRightBorder];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

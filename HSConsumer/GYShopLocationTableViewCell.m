//
//  GYShopLocationTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYShopLocationTableViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYShopLocationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //添加上面的分割线
    CALayer * topLayer =[CALayer layer];
    topLayer.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
    topLayer.frame=CGRectMake(self.frame.origin.x+16, 0, CGRectGetWidth(self.frame)-32, 1);
    [self.layer addSublayer:topLayer];
    
    [self.btnShopTel setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    self.btnShopTel.imageEdgeInsets=UIEdgeInsetsMake(1, 0, 1, 156);
    self.btnShopTel.titleEdgeInsets=UIEdgeInsetsMake(0, -60, 0, 0);
    self.lbGoodName.textColor = kCellItemTitleColor;
    self.lbShopName.textColor=kCellItemTextColor;
    self.lbShopAddress.textColor=kCellItemTextColor;
    self.lbShopTel.textColor=kCellItemTextColor;
    self.lbDistance.textColor=kCellItemTextColor;
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
    [self.btnCheckMap setTitle:kLocalized(@"ar_check_in_map") forState:UIControlStateNormal];
    [self.btnCheckMap setTitleColor:kCorlorFromRGBA(0, 143, 215, 1) forState:UIControlStateNormal];
    self.lbDistance.text=@"1.4Km";
    self.imgvMapIcon.image =[UIImage imageNamed:@"image_shopdetail_map.png"];
    [self.imgvSeproter addRightBorder];
    
    // add by songjk
    self.lbShopAddress.numberOfLines = 0;
    self.lbShopAddress.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.lbShopName.numberOfLines = 0;
    self.lbShopName.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    self.lbGoodName.numberOfLines = 0;
    self.lbGoodName .lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

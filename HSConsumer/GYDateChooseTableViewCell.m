//
//  GYDateChooseTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#import "GYDatePiker.h"
#import "GYDateChooseTableViewCell.h"
#import "UIButton+enLargedRect.h"
#import "UIView+CustomBorder.h"

@implementation GYDateChooseTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    [self.contentView addTopBorder];
    self.lbYear.text=kLocalized(@"ep_birthDay");
    self.lbYear.textColor=kCellItemTitleColor;
    self.lbYearDetail.textColor=kCellItemTextColor;
    self.lbYearDetail.text=@"选择日期";
    [self.btnChooseDate setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu3"] forState:UIControlStateNormal];
    [self.btnChooseDate  setEnlargEdgeWithTop:3 right:10 bottom:3 left:10];
    
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

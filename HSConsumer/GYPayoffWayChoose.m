//
//  ResultDialogRows7.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPayoffWayChoose.h"
#import "UIView+CustomBorder.h"

@implementation GYPayoffWayChoose


- (void)awakeFromNib
{
    [super awakeFromNib];
    
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.btnChangePayoffWay setTitle:@"支付方式" forState:UIControlStateNormal];
     self.viewResultRow2.lbLeftlabel.text=@"支付方式";

     [self setBackgroundColor:kDefaultVCBackgroundColor];
    
    //设置默认属性
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

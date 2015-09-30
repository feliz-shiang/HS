//
//  ResultDialog.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ResultDialog.h"

@implementation ResultDialog

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.lbTitle setTextColor:kCellItemTitleColor];
    [self.lbTitle setFont:kDefaultFont];
    [self setBackgroundColor:kClearColor];
}

- (void)showWithTitle:(NSString *)title isSucceed:(BOOL)s
{
    self.ivTitle.image = kLoadPng(s?@"img_succeed" : @"img_faild");
    self.lbTitle.text = title;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];   
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

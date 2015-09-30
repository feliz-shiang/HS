//
//  ViewCellStyle.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewCellStyle.h"
#import "UIView+CustomBorder.h"

@interface ViewCellStyle()
{
    UIColor *normalColor;
}
@end

@implementation ViewCellStyle

- (void)awakeFromNib
{
    [super awakeFromNib];
    normalColor = self.backgroundColor;
    //上下添加边框
    [self addTopBorder];
    [self addBottomBorder];

    [self.lbActionName setTextColor:kCellItemTitleColor];
    self.lbActionName.font = kCellTitleFont;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted: highlighted];
    self.backgroundColor = highlighted ? [UIColor lightGrayColor] : normalColor;
}

@end

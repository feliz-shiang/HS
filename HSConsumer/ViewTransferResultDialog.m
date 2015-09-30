//
//  ViewTransferResultDialog.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewTransferResultDialog.h"
#import "UIView+CustomBorder.h"

@implementation ViewTransferResultDialog

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:kClearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tvRow0 setTextColor:kCellItemTextColor];
    [self.tvRow1 setTextColor:kCellItemTextColor];
    
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

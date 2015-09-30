//
//  ViewOrderStateInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewOrderStateInfo.h"
#import "UIView+CustomBorder.h"

@interface ViewOrderStateInfo ()

@end

@implementation ViewOrderStateInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)init
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewOrderStateInfo *v = [subviewArray objectAtIndex:0];
    [v.lbState setTextColor:kValueRedCorlor];
    [v.lbOrderNo setTextColor:kCellItemTextColor];
    [v.lbOrderDatetime setTextColor:kCellItemTextColor];
    [v.lbOrderTakeCode setTextColor:kCellItemTextColor];
    v.clipsToBounds = YES;
    return v;
}

+ (CGFloat)getHeight
{
    return 90.0f;
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

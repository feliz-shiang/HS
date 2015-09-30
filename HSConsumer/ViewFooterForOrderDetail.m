//
//  ViewFooterForOrderDetail.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewFooterForOrderDetail.h"
#import "UIView+CustomBorder.h"

@interface ViewFooterForOrderDetail ()

@end

@implementation ViewFooterForOrderDetail

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
    ViewFooterForOrderDetail *v = [subviewArray objectAtIndex:0];
    [v.lbLabelRealisticAmount setTextColor:kCellItemTitleColor];
    [v.lbLabelPoint setTextColor:kCellItemTitleColor];

    [v.lbLabelRealisticAmount setText:@"实付金额："];
    [v.lbLabelPoint setText:@"消费积分："];
    
    [v.lbRealisticAmount setTextColor:kValueRedCorlor];
    [v.lbPoint setTextColor:kCorlorFromRGBA(0, 143, 215, 1)];
    [v.lbRealisticAmount setFont:[UIFont boldSystemFontOfSize:20.f]];
    
    [Utils setFontSizeToFitWidthWithLabel:v.lbRealisticAmount labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbPoint labelLines:1];
    return v;
}

+ (CGFloat)getHeight
{
    return 50.0f;
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

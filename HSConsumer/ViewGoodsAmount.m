//
//  ViewGoodsAmount.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewGoodsAmount.h"
#import "UIView+CustomBorder.h"

@interface ViewGoodsAmount ()

@end

@implementation ViewGoodsAmount

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
    ViewGoodsAmount *v = [subviewArray objectAtIndex:0];
    [v.lbLabelAmount setTextColor:kCellItemTitleColor];
    [v.lbLabelCourierFees setTextColor:kCellItemTitleColor];
    [v.lbLabelPoint setTextColor:kCellItemTitleColor];
    [v.lbLabelAmount setText:@"商品总额"];
    [v.lbLabelCourierFees setText:@"运费"];
    [v.lbLabelPoint setText:@"消费积分"];
    
    [v.lbAmount setTextColor:kValueRedCorlor];
    [v.lbCourierFees setTextColor:kValueRedCorlor];
    [v.lbPoint setTextColor:kCorlorFromRGBA(0, 143, 215, 1)];

    [Utils setFontSizeToFitWidthWithLabel:v.lbAmount labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbCourierFees labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbPoint labelLines:1];
    [v setBackgroundColor:kDefaultVCBackgroundColor];
    return v;
}

+ (CGFloat)getHeight
{
    return 86.f;
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

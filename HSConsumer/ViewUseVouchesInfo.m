//
//  ViewUseVouchesInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewUseVouchesInfo.h"
#import "UIView+CustomBorder.h"

@interface ViewUseVouchesInfo ()

@end

@implementation ViewUseVouchesInfo

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
    ViewUseVouchesInfo *v = [subviewArray objectAtIndex:0];

    [v.lbLabelHSConsumptionVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelHSGoldVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelTotalVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelHSConsumptionVouchers setText:kLocalized(@"互生消费券")];
    [v.lbLabelHSGoldVouchers setText:kLocalized(@"互生代金券")];
    [v.lbLabelTotalVouchers setText:kLocalized(@"抵扣合计: ")];

    [v.lbHSConsumptionVouchers setTextColor:kCellItemTextColor];
    [v.lbHSGoldConsumption setTextColor:kCellItemTextColor];
    [v.lbTotalVouchers setTextColor:kValueRedCorlor];
    
    [v.lbLabelDi0 setTextColor:kCellItemTextColor];
    [v.lbLabelDi1 setTextColor:kCellItemTextColor];
    [v.lbLabelDi0 setText:kLocalized(@"抵")];
    [v.lbLabelDi1 setText:kLocalized(@"抵")];

    [v.lbVouchersInfo0 setTextColor:kCellItemTextColor];
    [v.lbVouchersInfo1 setTextColor:kCellItemTextColor];
    
    for (UIView *view in v.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [Utils setFontSizeToFitWidthWithLabel:view labelLines:1];
        }
    }
    
    return v;
}

+ (CGFloat)getHeight
{
    return 55.0f;
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

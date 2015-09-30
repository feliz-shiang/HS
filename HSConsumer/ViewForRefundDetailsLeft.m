//
//  ViewForRefundDetailsLeft.m
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "ViewForRefundDetailsLeft.h"
#import "UIView+CustomBorder.h"

@implementation ViewForRefundDetailsLeft

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_viewLine0 setBackgroundColor:kClearColor];
    [_viewLine0 addTopBorderWithBorderWidth:1.f andBorderColor:kCellItemTitleColor];
//    [_viewLine0 addTopBorderWithBorderWidth:1.f andBorderColor:kDefaultViewBorderColor];
    
    UILabel *label;
    for (UIView *v in self.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            label = (UILabel *)v;
            [Utils setFontSizeToFitWidthWithLabel:label labelLines:1];
            [label setTextColor:kCellItemTitleColor];
        }
    }

//    [Utils setFontSizeToFitWidthWithLabel:_lbRow0 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:_lbRow1 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:_lbRow2 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:_lbRow3 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:_lbRow4 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:_lbRow5 labelLines:1];
//    
//    [_lbRow0 setTextColor:kCellItemTitleColor];
//    [_lbRow1 setTextColor:kCellItemTitleColor];
//    [_lbRow2 setTextColor:kCellItemTitleColor];
//    [_lbRow3 setTextColor:kCellItemTitleColor];
//    [_lbRow4 setTextColor:kCellItemTitleColor];
//    [_lbRow5 setTextColor:kCellItemTitleColor];
}

- (void)setValues:(NSArray *)arrValues
{
//    if (arrValues.count < 6)return;
    //arrValues[2] : 1 退货，2 仅退款， 3换货
    NSString *strRefundType = @"";
    if ([arrValues[2] isEqualToString:@"2"])
    {
        strRefundType = kLocalized(@"仅退款");
    }else if ([arrValues[2] isEqualToString:@"1"])
    {
        strRefundType = kLocalized(@"退货退款");
    }else if ([arrValues[2] isEqualToString:@"3"])
    {
        strRefundType = kLocalized(@"换货");
    }

    [_lbRow0 setText:[NSString stringWithFormat:@"%@%@申请",kLocalized(@"创建了"), strRefundType]];
    [_lbRow1 setText:[NSString stringWithFormat:@"%@: %@",kLocalized(@"买家要求"), strRefundType]];
    
    NSString *strGoodsStatus = kLocalized(@"买家未收到货");
    if ([arrValues[3] isEqualToString:@"1"])
    {
        strGoodsStatus = kLocalized(@"买家已收到货");
    }
    [_lbRow2 setText:[NSString stringWithFormat:@"%@: %@",kLocalized(@"货物状态"), strGoodsStatus]];
    
    [_lbRow3 setText:[NSString stringWithFormat:@"%@: %@",kLocalized(@"退款金额"), [Utils formatCurrencyStyle:[arrValues[4] doubleValue]]]];
    [_lbRow4 setText:[NSString stringWithFormat:@"%@: %@",kLocalized(@"退货积分"), [Utils formatCurrencyStyle:[arrValues[5] doubleValue]]]];
    [_lbRow5 setText:[NSString stringWithFormat:@"%@: %@",kLocalized(@"退货说明"), arrValues[6]]];
    
    if ([arrValues[2] isEqualToString:@"3"])//根据bug修改 换货不显示金额和积分
    {
        NSArray *arrTexts = @[_lbRow1.text, _lbRow2.text, _lbRow5.text];
        [_lbRow1 setHidden:YES];
        [_lbRow5 setHidden:YES];
        [_lbRow2 setText:arrTexts[0]];
        [_lbRow3 setText:arrTexts[1]];
        [_lbRow4 setText:arrTexts[2]];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, kDefaultVCBackgroundColor.CGColor);//填充色设置成灰色
    CGContextFillRect(context,self.bounds);//把整个空间用刚设置的颜色填充
    
    CGContextSetFillColorWithColor(context, kCorlorFromRGBA(145, 208, 243, 1).CGColor);//气泡的填充色设置为白色
    CGRect rrect = rect;
    rrect.origin.x = 10;
    rrect.size.width -= 10;

    CGFloat radius =6.0;//圆角的弧度
    
    CGFloat minx =CGRectGetMinX(rrect), midx =CGRectGetMidX(rrect), maxx =CGRectGetMaxX(rrect);
    CGFloat miny =CGRectGetMinY(rrect), midy =CGRectGetMidY(rrect), maxy =CGRectGetMaxY(rrect);
    CGFloat arrowY=midy;//设置箭头的位置

    // 画一下小箭头
    CGContextMoveToPoint(context, minx, arrowY-3);
    CGContextAddLineToPoint(context,minx-5, arrowY);
    CGContextAddLineToPoint(context,minx, arrowY+3);

    //添加四个角的圆角弧度
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    //结束绘制
    CGContextClosePath(context);//完成整个path
    CGContextFillPath(context);//把整个path内部填充
}

@end

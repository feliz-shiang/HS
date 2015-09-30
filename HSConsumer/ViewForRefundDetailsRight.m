//
//  ViewForRefundDetailsRight.m
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "ViewForRefundDetailsRight.h"
#import "UIView+CustomBorder.h"

@implementation ViewForRefundDetailsRight

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setShowTypeIsResult:(BOOL)isResult
{
    [_viewLine0 setBackgroundColor:kClearColor];
    [_viewLine0 addTopBorderWithBorderWidth:1.f andBorderColor:kDefaultViewBorderColor];
    [_viewLine1 setBackgroundColor:kClearColor];
    [_viewLine1 addTopBorderWithBorderWidth:1.f andBorderColor:kDefaultViewBorderColor];

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

    CGRect rect = self.frame;
    if (isResult)
    {
        _ivTitle.hidden = NO;
        _lbRow2.hidden = NO;
        _lbRow3.hidden = NO;
        _viewLine1.hidden = NO;
        
        
    }else
    {
        _ivTitle.hidden = YES;
        _lbRow2.hidden = YES;
        _lbRow3.hidden = YES;
        _viewLine1.hidden = YES;

        rect.size.height = 60.f;
    }
    self.frame = rect;
//    [self drawRect:rect];
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
    
    if (arrValues.count == 5)//确认
    {
        NSString *strConfirmResult = kLocalized(@"同意");
        if ([arrValues[3] isEqualToString:@"1"])
        {
            strConfirmResult = kLocalized(@"拒绝");
        }
        [_lbRow0 setText:[NSString stringWithFormat:@"商家已经%@%@申请",strConfirmResult, strRefundType]];
        [_lbRow1 setText:arrValues[4]];
        
        CGRect rect = _lbRow1.frame;
        rect.size.height += 6;//rect.size.height;
        _lbRow1.frame = rect;
        [Utils setFontSizeToFitWidthWithLabel:_lbRow1 labelLines:2];

    }else if (arrValues.count == 8)
    {
        NSString *strRefundResult = kLocalized(@"状态未知");
        if ([arrValues[3] isEqualToString:@"6"])//成功
        {
            strRefundResult = kLocalized(@"成功");
            _ivTitle.image = kLoadPng(@"");
            
            NSString *amount = [Utils formatCurrencyStyle:[arrValues[4] doubleValue]];
            NSString *pv = [Utils formatCurrencyStyle:[arrValues[5] doubleValue]];
            if ([arrValues[2] isEqualToString:@"3"])//换货不显示金额、积分
            {
                amount = @"--";
                pv = @"--";
            }
            [_lbRow1 setText:[NSString stringWithFormat:@"%@: %@", kLocalized(@"退款金额"), amount]];
            [_lbRow2 setText:[NSString stringWithFormat:@"%@: %@", kLocalized(@"退回商家积分"), pv]];
            
        }else if([arrValues[3] isEqualToString:@"7"])
        {
            strRefundResult = kLocalized(@"失败");
            _ivTitle.image = kLoadPng(@"");
            
            [_lbRow1 setText:arrValues[6]];
            CGRect rect = _lbRow1.frame;
            rect.size.height += rect.size.height;
            _lbRow1.frame = rect;
            [Utils setFontSizeToFitWidthWithLabel:_lbRow1 labelLines:2];
        }
        [_lbRow0 setText:[NSString stringWithFormat:@"%@%@", strRefundType, strRefundResult]];
        CGRect rect = _lbRow0.frame;
        rect.size.width = rect.size.width - CGRectGetMaxX(_ivTitle.frame) - 3;
        rect.origin.x = CGRectGetMaxX(_ivTitle.frame) + 3;
        _lbRow0.frame = rect;
        
        [_lbRow3 setText:[NSString stringWithFormat:@"%@编号: %@", @"退款", arrValues[7]]];
        
//        [_lbRow0 setText:[NSString stringWithFormat:@"%@%@申请",strConfirmResult, strRefundType]];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, kDefaultVCBackgroundColor.CGColor);//填充色设置成灰色
    CGContextFillRect(context,self.bounds);//把整个空间用刚设置的颜色填充
    
//    CGContextSetRGBStrokeColor(context, 100.0f/255.0, 100.0f/255.0, 100.0f/255.0, 1);//画线
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//气泡的填充色设置为白色
    CGRect rrect = rect;
    rrect.size.width -= 10;

    CGFloat radius =6.0;//圆角的弧度
    
    CGFloat minx =CGRectGetMinX(rrect), midx =CGRectGetMidX(rrect), maxx =CGRectGetMaxX(rrect);
    CGFloat miny =CGRectGetMinY(rrect), midy =CGRectGetMidY(rrect), maxy =CGRectGetMaxY(rrect);
    CGFloat arrowY=midy;//设置箭头的位置

    // 画一下小箭头
    CGContextMoveToPoint(context, maxx, arrowY-3);
    CGContextAddLineToPoint(context,maxx+5, arrowY);
    CGContextAddLineToPoint(context,maxx, arrowY+3);

    //添加四个角的圆角弧度
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    //结束绘制

    CGContextClosePath(context);//完成整个path
//    CGContextStrokePath(context);//画线
    CGContextFillPath(context);//把整个path内部填充
}


@end

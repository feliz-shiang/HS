//
//  ViewHeaderForOrderDetail.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewHeaderForOrderDetail.h"
#import "UIView+CustomBorder.h"

@interface ViewHeaderForOrderDetail ()

@end

@implementation ViewHeaderForOrderDetail

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
    ViewHeaderForOrderDetail *v = [subviewArray objectAtIndex:0];
    [v.lbLabelLogisticInfo setText:kLocalized(@"物流信息")];
    [v.lbLabelLogisticInfo setTextColor:kCellItemTitleColor];
    
    [v.lbLogisticName setText:kLocalized(@"快递公司：--")];
    [v.lbLogisticName setTextColor:kCellItemTextColor];
    
    [v.lbLogisticOrderNo setText:kLocalized(@"快递单号：--")];
    [v.lbLogisticOrderNo setTextColor:kCellItemTextColor];
    
    [v.btnCheckLogisticDetail setTitle:kLocalized(@"查看物流详情") forState:UIControlStateNormal];
    [v.btnCheckLogisticDetail setTitleColor:kValueRedCorlor forState:UIControlStateNormal];
    
    [v.lbConsignee setTextColor:kCellItemTitleColor];
    [v.lbConsigneeAddress setTextColor:kCellItemTitleColor];
    [v.lbLabelConsigneeAddress setTextColor:kCellItemTitleColor];
    [v.lbTel setTextColor:kCellItemTitleColor];
    [v.lbLabelConsigneeAddress setText:kLocalized(@"收货地址：")];
    [v.btnVshopName setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    
    [Utils setFontSizeToFitWidthWithLabel:v.lbLogisticName labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbLogisticOrderNo labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.btnVshopName.titleLabel labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbLabelConsigneeAddress labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbConsigneeAddress labelLines:2];
    [Utils setFontSizeToFitWidthWithLabel:v.lbConsignee labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v.lbTel labelLines:1];
    
//    [v setBackgroundColor:kValueRedCorlor];
    [v setBackgroundColor:kDefaultVCBackgroundColor];
    [v.viewBkg2 addTopBorderAndBottomBorder];
    [v->_viewBkg0 addTopBorderAndBottomBorder];
    [v->_viewBkg1 addTopBorder];
    [v.viewBkg3 addTopBorderAndBottomBorder];
//    [v setFrame:v.bounds];
    v.strCheckLogisticDetailUrl = nil;
    return v;
}

+ (CGFloat)getHeight
{
//    return 142.f;
    //return 238.f;
    return 310.f;
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

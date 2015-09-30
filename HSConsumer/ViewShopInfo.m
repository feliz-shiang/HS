//
//  ViewShopInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewShopInfo.h"
#import "UIView+CustomBorder.h"

@interface ViewShopInfo ()

@end

@implementation ViewShopInfo

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
    ViewShopInfo *v = [subviewArray objectAtIndex:0];
//    [v.lbShopName setTextColor:kCellItemTitleColor];
    [v.lbShopAddress setTextColor:kCellItemTextColor];
    [v.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [v.btnShopTel setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    v.btnShopTel.imageEdgeInsets=UIEdgeInsetsMake(1, 0, 1, 156);
    v.btnShopTel.titleEdgeInsets=UIEdgeInsetsMake(0, -60, 0, 0);
    
    [Utils setFontSizeToFitWidthWithLabel:v.lbShopAddress labelLines:2];
    return v;
}

+ (CGFloat)getHeight
{
    return 50.0f;
//    return 68.0f;
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

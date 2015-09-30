//
//  ViewGoodsType.m
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewGoodsType.h"
#import "UIView+CustomBorder.h"
@implementation ViewGoodsType

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted: highlighted];
//    self.alpha = highlighted ? 0.4f : 1.0f;
    self.backgroundColor = highlighted ? kCorlorFromRGBA(230, 230, 230, 1) : [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
    [self addTopBorder];
    [self addBottomBorder];
    [self addLeftBorder];
    [self addRightBorder];

//    [self.lbGoodsTypeDescription setUserInteractionEnabled:NO];
//    [self.lbGoodsTypeTitle setUserInteractionEnabled:NO];
}

- (void)setGoodsTypeTitleTextWithDefaultAttributes:(NSString *)text
{
    self.strTitleTextNoTags = text;
    [self.lbGoodsTypeTitle setTextColor:kCellItemTitleColor];
//    字间距kern=-1
    self.lbGoodsTypeTitle.text = [NSString stringWithFormat:@"<font size=16 kern=-2><b>%@</b></font>", text];

}

- (void)setGoodsTypeDescriptionTextWithDefaultAttributes:(NSString *)text
{
    self.strDescriptionTextNoTags = text;
    [self.lbGoodsTypeDescription setTextColor:kCellItemTextColor];
    self.lbGoodsTypeDescription.text = [NSString stringWithFormat:@"<font size=13 kern=-1>%@</font>", text];
}

@end

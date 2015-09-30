//
//  ViewHSMsgContentBkg.m
//  HSConsumer
//
//  Created by liangzm on 15-3-31.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "ViewHSMsgContentBkg.h"

@implementation ViewHSMsgContentBkg

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted: highlighted];
    //    self.alpha = highlighted ? 0.4f : 1.0f;
    self.backgroundColor = highlighted ? kCorlorFromRGBA(240, 240, 240, 1) : [UIColor whiteColor];
}

@end

//
//  
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewTipBkgView.h"

@implementation ViewTipBkgView

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
    ViewTipBkgView *v = [subviewArray objectAtIndex:0];
    [Utils setFontSizeToFitWidthWithLabel:v.lbTip labelLines:2];
    [v.lbTip setTextColor:kCellItemTextColor];
    [v setBackgroundColor:kClearColor];
    
    return v;
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

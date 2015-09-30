//
//  InputCellStypeView.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "InputCellStypeView.h"
#import "Utils.h"
#import "UIView+CustomBorder.h"

@implementation InputCellStypeView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSLog(@"int0");
    }
    return self;
}


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
    [self addTopBorder];
    [self addBottomBorder];
    
    [self.lbLeftlabel setTextColor:kCellItemTitleColor];
    [self.tfRightTextField setTextColor:kCellItemTitleColor];
    
    [self.lbLeftlabel setFont:kDefaultFont];
    [self.tfRightTextField setFont:kDefaultFont];
    [Utils setPlaceholderAttributed:self.tfRightTextField withSystemFontSize:17 withColor:nil];
}

@end

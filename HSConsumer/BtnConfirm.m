//
//  BtnConfirm.m
//  GYPOS
//
//  Created by 00 on 14-11-12.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "BtnConfirm.h"

@implementation BtnConfirm

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];

    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    

}


@end

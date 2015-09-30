//
//  GYSearchGoodsCell.m
//  ZBG
//
//  Created by 00 on 14-12-24.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYSearchGoodsCell.h"

@implementation GYSearchGoodsCell

- (void)awakeFromNib {
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.vBtn addGestureRecognizer:tap];
    
    
}

-(void)click
{
    NSLog(@"啦啦啦");

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

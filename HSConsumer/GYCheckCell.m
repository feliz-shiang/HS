//
//  GYCheckCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-5.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCheckCell.h"

@implementation GYCheckCell

- (IBAction)btnClick:(id)sender {

    [self.delegate pushPayViewWithURL:@"输入url"];
}

- (void)awakeFromNib
{
    
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

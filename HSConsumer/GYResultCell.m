//
//  GYResultCell.m
//  GYPOS
//
//  Created by 00 on 14-11-13.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYResultCell.h"

@implementation GYResultCell

- (void)awakeFromNib
{
    self.lbCellTitle.textColor = kCorlorFromRGBA(70, 70, 70, 1.0f);
    self.lbResult.textColor = kCorlorFromRGBA(70, 70, 70, 1.0f);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}












@end

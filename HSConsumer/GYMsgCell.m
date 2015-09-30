//
//  GYMsgCell.m
//  XFZHD
//
//  Created by 00 on 14-12-25.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYMsgCell.h"

@implementation GYMsgCell

- (void)awakeFromNib {

    self.lbRedPoint.layer.cornerRadius = 10.0f;
    self.imgRedPointBg.layer.cornerRadius = 10.0f;
    [Utils setFontSizeToFitWidthWithLabel:self.lbDate labelLines:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  GYPersonalInfoTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPersonalInfoTableViewCell.h"
#import "UIView+CustomBorder.h"


@implementation GYPersonalInfoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=[UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.InputCellInfo.tfRightTextField.delegate = self;

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(didEndEditing:inRow:object:)])
    {
        [self.delegate didEndEditing:self.section inRow:self.row object:self];
    }
}
@end

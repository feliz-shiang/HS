//
//  CellUserInfo.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//我的账户主界面的 个人信息cell

#import "CellUserInfo.h"

@implementation CellUserInfo

- (void)awakeFromNib
{
    // Initialization code
    [self.lbLabelCardNo setTextColor:kCellItemTitleColor];
    [self.lbLabelHello setTextColor:kCellItemTitleColor];
    [self.lbLastLoginInfo setTextColor:kCellItemTextColor];
    _btnUserPicture.layer.masksToBounds = YES;
    _btnUserPicture.layer.cornerRadius = 6;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

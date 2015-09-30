//
//  GYGoodDetailListTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGoodDetailListTableViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYGoodDetailListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=kDefaultVCBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}
-(void)refreshUIWith:(NSString *)title WithDetail :(NSString *)detail
{
    self.lbDetailTitle.text=[NSString stringWithFormat:@"%@:",title];

    self.lbDetailInfo.text=detail;


}
@end

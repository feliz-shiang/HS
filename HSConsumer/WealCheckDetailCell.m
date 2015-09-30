//
//  WealCheckDetailCell.m
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "WealCheckDetailCell.h"
#import "UIImageView+WebCache.h"
#import "GYImgVC.h"

@implementation WealCheckDetailCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(id)sender {
    
    GYImgVC *vc = [[GYImgVC alloc] init];
    vc.imgUrl = self.imgUrl;
    vc.navigationItem.title = self.lbTitle.text;
    [self.nc pushViewController:vc animated:YES];
}






@end

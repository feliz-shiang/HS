//
//  GYQuitPhoneBandingTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYQuitPhoneBandingTableViewCell.h"
#import "UIView+CustomBorder.h"
@implementation GYQuitPhoneBandingTableViewCell
{
    
    __weak IBOutlet UIView *vBgView;//背景View
    
    __weak IBOutlet UIImageView *imgIcon;//显示图片
    
    __weak IBOutlet UILabel *lbPhoneNumber;//电话号码
    
    __weak IBOutlet UIImageView *imgSeprator;//分割线
    
    __weak IBOutlet UILabel *lbBandingSuecces;//成功绑定Label
    
    
}

//初始化
- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=kDefaultVCBackgroundColor;
    
    [vBgView addAllBorder];
    [imgSeprator addLeftBorder];
    vBgView.backgroundColor=[UIColor whiteColor];
    lbPhoneNumber.textColor=kCellItemTitleColor;
    lbBandingSuecces.textColor=kCellItemTitleColor;
    [self.btnQuitBanding setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)refreshUIWith:(GYQuitPhoneBandingModel *)model
{
    imgIcon.image=[UIImage imageNamed:model.strIconUrl];
    lbBandingSuecces.text=model.strBandingSuccess;
    
    NSLog(@"%@------phone",model.strPhoneNo);
    NSString * phoneNumber =[NSString stringWithFormat:@"%@****%@",[model.strPhoneNo substringToIndex:3],[model.strPhoneNo substringFromIndex:7]];
    lbPhoneNumber.text=phoneNumber;
    [self.btnQuitBanding setTitle:model.strBtnTitle forState:UIControlStateNormal];
    
}


-(void)refreshUIWithEmail:(GYQuitEmailBanding *)model
{
    imgIcon.image=[UIImage imageNamed:model.strIconUrl];
    lbBandingSuecces.text=model.strBandingSuccess;
    
    NSString * mailFlag = @"@";
    NSString * emailString =[NSString stringWithFormat:@"%@****%@",[model.strEmail substringToIndex:2],[model.strEmail substringFromIndex:[model.strEmail rangeOfString:mailFlag ].location]];
    lbPhoneNumber.text=emailString;
    [self.btnQuitBanding setTitle:model.strBtnTitle forState:UIControlStateNormal];
    
    
}

@end

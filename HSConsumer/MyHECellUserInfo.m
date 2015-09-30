//
//  MyHECellUserInfo.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//我的账户主界面的 个人信息cell

#import "MyHECellUserInfo.h"
#import "GYConcernsCollectViewController.h"
#import "GYPersonDetailFileViewController.h"

@implementation MyHECellUserInfo

- (void)awakeFromNib
{
    // Initialization code
    
    [self.lbLabelUseHello setTextColor:kCellItemTitleColor];
    [self.lbLastLoginInfo setTextColor:kCellItemTextColor];
    [self.btnAttentionGoods setTitleColor:kValueRedCorlor forState:UIControlStateNormal];
    [self.btnAttentionShop setTitleColor:kValueRedCorlor forState:UIControlStateNormal];
    
    [Utils setFontSizeToFitWidthWithLabel:self.lbLabelUseHello labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:self.lbLastLoginInfo labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:self.btnAttentionGoods.titleLabel labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:self.btnAttentionShop.titleLabel labelLines:1];    
}

- (IBAction)btnsClick:(id)sender
{
    UIViewController *vc = nil;
    if (sender == self.btnUserPicture)//修改个资料
    {
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYPersonDetailFileViewController class]));
    }else if (sender == self.btnAttentionGoods)//商品关注收藏
    {
        GYConcernsCollectViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectViewController class]));
        [_vc setIndex:0];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"ep_usual_concerns_collect");
        
    }else if (sender == self.btnAttentionShop)//商铺关注收藏
    {
        GYConcernsCollectViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectViewController class]));
        [_vc setIndex:1];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"ep_usual_concerns_collect");
        
    }
    
    if (!vc || !self.nav) return;
    [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
    [self.nav pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

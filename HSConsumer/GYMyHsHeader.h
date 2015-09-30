//
//  GYMyHsHeader.h
//  HSConsumer
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMyHsHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnHeadPic;
@property (weak, nonatomic) IBOutlet UILabel *LbUserHello;
@property (weak, nonatomic) IBOutlet UILabel *lbLastLoginTime;
@property (nonatomic,strong) UIButton *btnBackToRoot;
@property (nonatomic,strong)UIImageView * imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *mvBack;

@end

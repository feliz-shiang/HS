//
//  MyHECellUserInfo.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface MyHECellUserInfo : UITableViewCell

@property (strong, nonatomic) UINavigationController *nav;
@property (weak, nonatomic) IBOutlet UIButton *btnBackToRoot;

@property (strong, nonatomic) IBOutlet UIButton *btnUserPicture;    //头像
@property (strong, nonatomic) IBOutlet UIButton *btnAttentionGoods; //关注商品
@property (strong, nonatomic) IBOutlet UIButton *btnAttentionShop;  //关注商铺
@property (strong, nonatomic) IBOutlet UILabel *lbLabelUseHello;    //问候语
@property (strong, nonatomic) IBOutlet UILabel *lbLastLoginInfo;    //登录信息

@end

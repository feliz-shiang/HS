//
//  GYMsgViewController.h
//  HSConsumer
//
//  Created by 00 on 14-12-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatItem.h"



@interface GYMsgViewController : UIViewController

@property (nonatomic , strong) UINavigationController *nc;


@property (nonatomic , assign) NSInteger msgType;
/*
 msgType = 1; 个人消息
 msgType = 2; 商铺消息
 msgType = 3; 商品消息
 */



@end

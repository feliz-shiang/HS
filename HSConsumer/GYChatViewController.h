//
//  Root.h
//  Chat
//
//  Created by 00 on 15-1-9.
//  Copyright (c) 2015年 00. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYNewFiendModel.h"
#import "GYChatItem.h"

@interface GYChatViewController : UIViewController

@property (nonatomic,assign) NSInteger msgType;

@property (nonatomic,strong)GYNewFiendModel * model;//接受 用户ID  用户图像 用户title
@property (nonatomic,strong)GYChatItem * chatItem;//
@property (nonatomic,strong) NSString *shopWelcomeMessage;//弃用字段
@property (nonatomic,strong) NSDictionary *dicShopInfo;//商铺信息
@property (nonatomic, assign) BOOL isFromShopDetails;//是否从商铺详情跳转过来

@property (weak, nonatomic) IBOutlet UITextView *tvChat;

@end

//
//  GYGoodsMsgVC.h
//  HSConsumer
//
//  Created by 00 on 15-2-28.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatItem.h"


@interface GYGoodsMsgVC : UIViewController

@property (nonatomic,assign) NSInteger msgType;//消息类型

@property (nonatomic,strong)GYChatItem * chatItem;//消息体



@end

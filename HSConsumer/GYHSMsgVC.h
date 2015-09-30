//
//  GYConcernsCollectShopsViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyPurchaseData.h"
#import "GYChatItem.h"

@interface GYHSMsgVC : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrResult;
@property (nonatomic,strong) GYChatItem * chatItem;//消息体
@property (nonatomic,assign) NSInteger msgType;//消息类型

@end

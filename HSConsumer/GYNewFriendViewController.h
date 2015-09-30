//
//  GYNewFriendViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "GYChatItem.h"


@interface GYNewFriendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * marrDatasource;

@property (nonatomic ,strong)GYChatItem *chatItem;

@end

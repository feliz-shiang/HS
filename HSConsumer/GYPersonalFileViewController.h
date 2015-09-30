//
//  GYPersonalFileViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPersonalFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray * arrDataSource;
@end

//
//  GYGetGoodViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "GYsenderButton.h"
#import "GYGetAddressDelegate.h"

@interface GYGetGoodViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GYsenderButton,GYGetAddressDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbvGetGood;//tableview
@property (nonatomic,strong)NSMutableArray * marrDataSoure;//数据源数组
@property (nonatomic,weak) id<GYGetAddressDelegate> deletage;

@end

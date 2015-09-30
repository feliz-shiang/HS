//
//  GYConcernsCollectShopsViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyPurchaseData.h"

//设置菜单角标的block
typedef void (^setMenu)(NSInteger index,NSString *title);

@interface GYConcernsCollectShopsViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrResult;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIButton *btnMenu;//对应哪个menu的btn

@property (nonatomic,strong) setMenu block;

@end

//
//  GYMyAccountViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewControllerDelegate.h"

@interface GYMyAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, GYViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

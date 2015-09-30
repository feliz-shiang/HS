//
//  GYMyInfoViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewControllerDelegate.h"


@interface GYMyInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, GYViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MyInfoTableView;
@property (nonatomic,retain) NSArray * arrSourceArrForSectionTitle;
@property (nonatomic,retain)NSArray * imgArr;
@property (nonatomic,retain)NSArray * titleArr;



@property (assign, nonatomic) id<GYViewControllerDelegate> delegate;

@end

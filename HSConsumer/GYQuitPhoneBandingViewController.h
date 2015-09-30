//
//  GYQuitPhoneBandingViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYQuitPhoneBandingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)BOOL FromWhere;
@property (nonatomic,strong)NSMutableArray * marrDataSoure;
@end

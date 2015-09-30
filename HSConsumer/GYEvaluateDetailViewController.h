//
//  GYEvaluateDetailViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-12.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYEvaluateDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy)NSString * strGoodId;
@property (nonatomic,strong)UINavigationController * nav;
@property (nonatomic,copy ) NSString * EvaluteStatus;
@property (nonatomic,strong)NSMutableArray * marrDatasource;
@end

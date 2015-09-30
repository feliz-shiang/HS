//
//  GYCityChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCityInfo.h"

@protocol selectCity <NSObject>

-(void)selectOneCity :(GYCityInfo *)model;

@end

@interface GYCityChooseViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * marrDatasource;
@property (nonatomic,copy)NSString * parentCode;
@property (nonatomic,weak) id <selectCity> delegate;
@end

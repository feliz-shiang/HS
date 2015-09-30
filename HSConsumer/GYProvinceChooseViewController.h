//
//  GYProvinceChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "GYCityInfo.h"
@protocol selectProvince <NSObject>

-(void)selectOneProvince :(GYCityInfo *)model;

@end


@interface GYProvinceChooseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * marrDatasource;
@property (nonatomic,weak)id <selectProvince>delegate;
@end

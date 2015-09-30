//
//  GYAreaChooseViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCityInfo.h"
@protocol selectArea <NSObject>

-(void)selectOneArea :(GYCityInfo *)model;

@end
@interface GYAreaChooseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)id <selectArea>delegate;
@property (nonatomic,strong)NSMutableArray * marrDatasource;
@property (nonatomic,copy)NSString * parentCode;
@end

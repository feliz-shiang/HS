//
//  GYCitySelectViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
@protocol selectCity <NSObject>

-(void)getCity:(NSString *)CityTitle WithType:(int)type;

@end


#import <UIKit/UIKit.h>

@interface GYCitySelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray * marrDatasource;

@property (nonatomic,strong) NSMutableArray *indexMarr;//索引

@property (nonatomic,strong) NSMutableArray *chineseString;

@property (nonatomic,weak)id <selectCity>delegate;

@end

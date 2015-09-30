//
//  GYChooseInfoViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
@protocol sendSelectSexDelegate <NSObject>

-(void)sendSelectSex:(NSString *)sex;

@end


#import <UIKit/UIKit.h>

@interface GYChooseInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * marrDatasource;
@property (nonatomic,weak) id <sendSelectSexDelegate>delegate;
@property (nonatomic,copy)NSString * strSex;

@end

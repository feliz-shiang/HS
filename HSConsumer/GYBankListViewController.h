//
//  GYBankListViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#import "GYBankListModel.h"
@protocol sendSelectBank <NSObject>

-(void)getSelectBank:(GYBankListModel *)model;

@end
#import <UIKit/UIKit.h>

@interface GYBankListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray * marrBankList;
@property (nonatomic,strong) NSMutableDictionary * filterDictionary;
@property (nonatomic,strong) NSMutableDictionary * nameDictionary;

@property (nonatomic,weak) id <sendSelectBank> delegate;
@end

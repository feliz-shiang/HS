//
//  GYhistoryView.h
//  HSConsumer
//
//  Created by appleliss on 15/8/20.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYseachhistoryModel.h"
@protocol historyViewDelegt <NSObject>
-(void)reloadDatatable:(NSArray *)historyArr;
-(void)didSelectOneRow:(NSString *)title;

@end
@interface GYhistoryView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *historyArry;////数据
@property (nonatomic,weak) id<historyViewDelegt>Hdelegate;

-(void)reloadDatatable:(NSArray *)hiArry; 

@end

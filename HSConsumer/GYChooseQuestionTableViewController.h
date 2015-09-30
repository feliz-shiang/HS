//
//  GYTestTableViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-6.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYQuestionModel.h"

@protocol selectQuestionDelegate <NSObject>

-(void)selectedOneQuestion:(GYQuestionModel *)Model;

@end

@interface GYChooseQuestionTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)id <selectQuestionDelegate>Delegate;
@property (nonatomic,strong) NSMutableArray * marrDataSource;
@property (nonatomic,assign) int tag;
@property (strong, nonatomic) IBOutlet UITableView *tvQuestionTable;


@end

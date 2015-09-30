//
//  GYEasyBuyViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#import "DropDownWithChildChooseProtocol.h"
//协议目的：将controller中创建的tableview  选中title 和对应 section 传到另一个controler 中显示
//@protocol sendTitleText <NSObject>
//
//-(void)chooseRowWith:(NSString *)titile WithSection:(NSInteger)index WithTableView: (UITableView *)table;
//
//@end

#import <UIKit/UIKit.h>
#import "DropDownWithChildListView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GYhistoryView.h"
#import "GYNavigationController.h"

@interface GYEasyBuySearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DropDownWithChildChooseDataSource,DropDownWithChildChooseDelegate,deleteTableviewInSectionOne,UITextFieldDelegate,historyViewDelegt>

@property (nonatomic, weak) id<sendTitleText> delegate;
@property (nonatomic,strong)NSMutableArray * marrDataSource;
@property (nonatomic,strong)GYNavigationController *nv;

@end

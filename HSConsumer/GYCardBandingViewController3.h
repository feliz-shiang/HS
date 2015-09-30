//
//  GYCardBandingViewController3.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYCardBandModel.h"



@protocol sendSelectBankModel <NSObject>

@optional
-(void)sendSelectBankModel:(GYCardBandModel *)model ;

@end


#import <UIKit/UIKit.h>

@interface GYCardBandingViewController3 : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvCardBanding;//显示绑定的银行卡

@property (nonatomic,strong)NSMutableArray * marrDatasoure;
@property (nonatomic,weak)id <sendSelectBankModel>delegate;
@property (nonatomic,assign)BOOL isSelectBankList;
@end

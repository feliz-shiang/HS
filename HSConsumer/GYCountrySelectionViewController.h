//
//  GYCountrySelectionViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChooseAreaModel.h"

@protocol selectNationalityDelegate <NSObject>

-(void)selectNationalityModel:(GYChooseAreaModel *)CountryInfo;

@end

@interface GYCountrySelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray * marrSourceData;
@property (nonatomic,weak) id <selectNationalityDelegate> Delegate;

@end

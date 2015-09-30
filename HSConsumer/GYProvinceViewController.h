//
//  GYProvinceViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GYChooseAreaModel.h"
@protocol selectProvinceDelegate <NSObject>

-(void)didSelectProvince:(GYChooseAreaModel *)model;

@end

@interface GYProvinceViewController : UIViewController

@property (nonatomic,weak)id <selectProvinceDelegate>delegate;
@property (nonatomic,strong)NSMutableArray * marrSourceData;
@property (nonatomic,copy)NSMutableString * mstrCountry;
@property (nonatomic,copy)NSString * areaId;
@property (nonatomic,assign)int fromWhere;

@end

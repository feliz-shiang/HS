//
//  GYGetPaymentTypeViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-31.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPaymentType.h"
@protocol selectPaymentType <NSObject>

-(void)selectPaymentWithModel :(GYPaymentType *)model;

@end

@interface GYGetPaymentTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,copy)NSString * strShopid;
@property (nonatomic ,copy)NSString *  isDelivery;
@property (nonatomic,copy) NSDictionary *dicOrderInfo;
@property (nonatomic,weak)id <selectPaymentType>delegate;
@end

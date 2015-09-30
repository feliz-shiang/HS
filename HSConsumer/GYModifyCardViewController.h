//
//  GYCardBandingViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GYSenderTestDataDelegate.h"
#import "GYCardBandModel.h"
#import "GYBankListViewController.h"
#import "GYAddressCountryViewController.h"
@interface GYModifyCardViewController : UIViewController<sendSelectBank>
@property (nonatomic,strong)GYCardBandModel * model;
@property (nonatomic,copy)NSString *strOpenBank;
@end

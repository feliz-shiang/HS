//
//  GYCardBandingViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GYSenderTestDataDelegate.h"
#import "GYBankListViewController.h"
@interface GYCardBandingViewController : UIViewController<UITextFieldDelegate,sendSelectBank>
@property (nonatomic,copy)NSString * strRealName;
@property (nonatomic,copy)NSString * strBalanceCurrency;
@property (nonatomic,copy)NSString * strOpenBank;
@property (nonatomic,copy)NSString * strOpenArea;
@property (nonatomic,copy)NSString * strBankNumber;
@property (nonatomic,copy)NSString * strBankNumberAgain;


@property (nonatomic,strong)NSMutableArray * marrBankList;

@end

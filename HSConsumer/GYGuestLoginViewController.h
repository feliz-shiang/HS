//
//  GYGuestLoginViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYLoginView.h"

@interface GYGuestLoginViewController : UIViewController

@property (assign, nonatomic) id<GYLoginViewDelegate> delegate;
@property (assign, nonatomic) BOOL isStay;

@end

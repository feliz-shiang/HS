//
//  GYCartViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
typedef void(^CartCellsetNumCompletionBlock)(NSInteger);
#import <UIKit/UIKit.h>

@interface GYCartViewController : UIViewController
@property (nonatomic,copy)CartCellsetNumCompletionBlock cartCellsetNumBlock;
@end

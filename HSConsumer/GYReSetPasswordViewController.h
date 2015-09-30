//
//  GYReSetPasswordViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYReSetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic ,copy)NSString * resourceNumber;
@property (nonatomic ,assign)BOOL fromNocard;

@end

//
//  GYReSetPasswordViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYNameBandingViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,copy)NSString * strRealName;
@property (nonatomic,copy)NSString * strRealNameConfirm;
@property (nonatomic ,assign)int fromWhere;
@end

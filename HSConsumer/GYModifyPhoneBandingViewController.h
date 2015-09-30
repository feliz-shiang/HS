//
//  GYPhoneBandingViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "GYQuitPhoneBandingModel.h"
@interface GYModifyPhoneBandingViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic,copy)NSString * strCode;

@property (nonatomic,strong)GYQuitPhoneBandingModel * model ;
@end

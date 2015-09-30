//
//  GYSetupPasswdQuestionViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择问题
#import "GYChooseQuestionTableViewController.h"
@interface GYSetupPasswdQuestionViewController : UIViewController<UITextFieldDelegate,selectQuestionDelegate>
@property (nonatomic,copy)NSString * strContent;
@property (nonatomic,copy)NSString * strAnswer;

@end

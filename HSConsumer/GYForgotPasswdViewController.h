//
//  GYForgotPasswdViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//忘记密码主界面

#import <UIKit/UIKit.h>

@interface GYForgotPasswdViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,copy)NSString * strResourceNum;
@property (nonatomic,copy)NSString * strMobile;
@property (nonatomic,copy)NSString * strCode;
@property (nonatomic,copy)NSString * strQuestion;
@property (nonatomic,copy)NSString * strAnswer;
@property (nonatomic,copy)NSString * strEmail;
@end

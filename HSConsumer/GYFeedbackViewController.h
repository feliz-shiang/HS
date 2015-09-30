//
//  GYFeedbackViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYFeedbackViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)NSString * strContact;
@property (nonatomic,copy)NSString * strContent;
@end

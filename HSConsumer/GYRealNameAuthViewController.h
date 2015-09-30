//
//  GYRealNameAuthViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYRealNameAuthViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,copy)NSString * strRealName;
@property (nonatomic,copy)NSString * strSex;
@property (nonatomic,copy)NSString * strNationality;
@property (nonatomic,copy)NSString * strCerType;
@property (nonatomic,copy)NSString * strCerNumber;
@property (nonatomic,copy)NSString * strCerduration;
@property (nonatomic,copy)NSString * strRegAddress;

@end

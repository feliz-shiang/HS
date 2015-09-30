//
//  GYRealNameRegisterViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GYSenderTestDataDelegate.h"
//国家选择
#import "GYCountrySelectionViewController.h"
@interface GYRealNameRegisterViewController : UIViewController<UITextViewDelegate,selectNationalityDelegate,UITextFieldDelegate>
@property (nonatomic,copy)NSString * strUserName;
@property (nonatomic,copy)NSString * strUserSex;
@property (nonatomic,copy)NSString * strUserJob;
@property (nonatomic,copy)NSString * strUserNationlilty;
@property (nonatomic,copy)NSString * strUserCertificationType;
@property (nonatomic,copy)NSString * strUserCertificationNumber;
@property (nonatomic,copy)NSString * strUserValidDuration;
@property (nonatomic,copy)NSString * strUserFamliyAddress;
@end

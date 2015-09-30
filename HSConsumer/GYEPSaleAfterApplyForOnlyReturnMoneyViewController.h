//
//  GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GYUploadImage.h"
@interface GYEPSaleAfterApplyForOnlyReturnMoneyViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,GYUploadPicDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *dicDataSource;

@property (nonatomic,copy) NSString * commentSting;
@end

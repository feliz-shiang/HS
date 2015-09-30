//
//  GYRealNameAuthConfirmViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYUploadImage.h"
@interface GYImportantChangeConfirmViewController : UIViewController<UIActionSheetDelegate,GYUploadPicDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary * dictInside;
@end

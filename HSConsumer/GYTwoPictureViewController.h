//
//  GYTwoPictureViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYUploadImage.h"
#import "GYRealNameAuthConfirmViewController.h"
//typedef enum
//{
//    useForAuth=0,
//    useForImportantChange,
//    
//}KuseType;
@interface GYTwoPictureViewController : UIViewController<UINavigationControllerDelegate,UIActionSheetDelegate,GYUploadPicDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary * mdictParams;
@property (nonatomic,copy)NSString * strCreFaceUrl;
@property (nonatomic,copy)NSString * strCreBackUrl;

@property (nonatomic,assign)KuseType useType;
@end

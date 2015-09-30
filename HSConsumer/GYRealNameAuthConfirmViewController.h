//
//  GYRealNameAuthConfirmViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYUploadImage.h"
typedef enum
{
    useForAuth=0,
    useForImportantChange,
    
}KuseType;

@interface GYRealNameAuthConfirmViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,GYUploadPicDelegate>

@property (nonatomic,strong)NSMutableDictionary * dictInside;
@property (nonatomic,copy)NSString * strCreFaceUrl;
@property (nonatomic,copy)NSString * strCreBackUrl;
@property (nonatomic,copy)NSString * strCreHoldUrl;
@property (nonatomic,assign) KuseType useType;

@end

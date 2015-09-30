//
//  GYHIMMainViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//消息主界面

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface GYHIMMainViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}
@property (nonatomic, strong) UIImageView * line;
@end

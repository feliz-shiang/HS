//
//  GYPersonalFileViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择地区
#import "GYAddressCountryViewController.h"
//修改签名
#import "GYSignViewController.h"
//修改性别
#import "GYChooseInfoViewController.h"
//修改姓名
#import "GYModifyNameViewController.h"

#import "GYUploadImage.h"
@interface GYPersonDetailFileViewController : UIViewController<UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,sendSignText,sendSelectSexDelegate,getTextDelegate,GYUploadPicDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray * arrDataSource;
@end

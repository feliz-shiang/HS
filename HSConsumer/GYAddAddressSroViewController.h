//
//  GYAddAddressSroViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressModel.h"
#import "GYProvinceChooseViewController.h"
#import "GYCityChooseViewController.h"
//选择区
#import "GYAreaChooseViewController.h"
#import "GYModifyAddressViewController.h"
@interface GYAddAddressSroViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,selectProvince,selectCity,selectArea>
@property (nonatomic,assign)BOOL boolstr;//用来控制push源，两个页面公用一个controller,用来区分
@property (nonatomic,strong)GYAddressModel * AddModel; 
@end

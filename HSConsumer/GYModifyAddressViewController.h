//
//  GYAddAddressViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressModel.h"
#import "GYProvinceChooseViewController.h"
#import "GYCityChooseViewController.h"
#import "GYAreaChooseViewController.h"
#import "GYGetGoodViewController.h"



@interface GYModifyAddressViewController : UIViewController<UITextViewDelegate,selectProvince,selectCity,selectArea>
@property (nonatomic,assign)BOOL boolstr;//用来控制push源，两个页面公用一个controller,用来区分
@property (nonatomic,strong)GYAddressModel * AddModel;
//@property (nonatomic,strong)NSMutableArray * marrAddModel;

@property (nonatomic,copy)NSString * strProvince;
@property (nonatomic,copy)NSString * strCity;
@property (nonatomic,copy)NSString * strArea;
@property (nonatomic,copy)NSString * strDetailAddress;
@property (nonatomic,copy)NSString * strConsignee;
@property (nonatomic,copy)NSString * strPhone;
@property (nonatomic,copy)NSString * strTelPhone;
@property (nonatomic,copy)NSString * strPost;
@end

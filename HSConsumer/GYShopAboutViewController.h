//
//  GYShopAboutViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
#import "GYCitySelectViewController.h"
#import "UIImageView+WebCache.h"
#import  <BaiduMapAPI/BMapKit.h>
#import "JGActionSheet.h"
#import "MWPhotoBrowser.h"
@interface GYShopAboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate>
{
    BMKLocationService* _locService;
@public
    BMKMapPoint mp1;
}

@property (nonatomic,copy) NSString *ShopID;//传值：商铺ID
@property (nonatomic,copy) NSString * strVshopId;
@property  (nonatomic,copy)NSString *strShopDistance;
@property (nonatomic,strong)ShopModel * model;
@property (nonatomic,assign)BMKMapPoint currentMp1;
@end
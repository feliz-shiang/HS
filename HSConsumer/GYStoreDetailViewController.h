//
//  GYStoreDetailViewController.h
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <BaiduMapAPI/BMapKit.h>
@class ShopModel;

@interface GYStoreDetailViewController : UIViewController

@property (nonatomic,strong) ShopModel * shopModel;

//@property (nonatomic,copy) NSString *ShopID;//传值：商铺ID
//@property (nonatomic,copy) NSString * strVshopId;
//@property  (nonatomic,copy)NSString *strShopDistance;
//@property  (nonatomic,assign)int fromEasyBuy;
@property (nonatomic,assign)BMKMapPoint currentMp1;
@end

//
//  GYAppDelegate.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>


@interface GYAppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate>
{
     BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSInteger goodsNum;
@end

//
//  GYBMKViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "GYEasyBuyModel.h"
#import "RoutePlan.h"
@interface GYBMKViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,RouteDelegate>
{
    BMKRouteSearch* _routesearch;
    
}
@property (nonatomic,assign)BOOL isSetMapSpan;
@property (nonatomic,strong)NSMutableArray * marr;
@property (nonatomic,assign)CLLocationCoordinate2D coordinateLocation;//接受店铺的经纬度
@property (nonatomic,copy)NSString * strShopId;

@end

//
//  MMLocationManager.m
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "MMLocationManager.h"

@interface MMLocationManager ()

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) NSStringBlock countryBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation MMLocationManager

+ (MMLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:MMLastLongitude];
        float latitude = [standard floatForKey:MMLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:MMLastCity];
        self.lastAddress=[standard objectForKey:MMLastAddress];
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock withError:(LocationErrorBlock)locationError
{
    self.locationBlock = [locaiontBlock copy];
    self.errorBlock = [locationError copy];

   
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock withError:(LocationErrorBlock)locationError WithCity:(NSStringBlock )cityName
{
    self.locationBlock = [locaiontBlock copy];
    self.errorBlock = [locationError copy];
    self.cityBlock= [cityName copy];
    
    [self startLocation];
}


- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self getAddressCode];
//    [self startLocation];
}
- (void) getCountry:(NSStringBlock)conturyBlock
{
    self.countryBlock = [conturyBlock copy];
//    [self getAddressCode];
       [self startLocation];
}
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

-(void)getAddressCode
{
    if (_mapView) {
        _mapView = nil;
    }
    _mapView = [[BMKMapView alloc] init];
    _mapView.delegate = self;
    _locationService =[[BMKLocationService alloc]init];
    [_locationService startUserLocationService];
    _locationService.delegate=self;
    _mapView.showsUserLocation = YES;
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
   

    CLLocation * newLocation = userLocation.location;
    
    self.lastCoordinate=userLocation.location.coordinate;

    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};

    pt = self.lastCoordinate;
 
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
    
    
     NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
           
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            NSString * country =[addressDic objectForKey:@"Country"];
            self.country=[NSString stringWithFormat:@"%@  %@",country,city];
            self.lastCity = city;
            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];
            
            [self stopLocation];
        }
        
       
        
        if (_cityBlock) {
            _cityBlock(self.lastCity);
            _cityBlock = nil;
        }
        
        if (_locationBlock) {
            _locationBlock(self.lastCoordinate);
            _locationBlock = nil;
        }
       
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
        
        if (_countryBlock) {
            _countryBlock(_country);
            _countryBlock=nil;
        }
        
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];

    if (userLocation) {
        [self stopLocation];
    }
    
    
}


//正向检索地址编码，通过地址编码获取到 经纬度坐标。
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
//        [_mapView addAnnotation:item];
//        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    
    }
}


//反向地址检索，通过坐标 查找 物理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = item.title;
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
      
    }
}


-(void)startLocation
{
    if (_mapView) {
        _mapView = nil;
    }
    _mapView = [[BMKMapView alloc] init];
    _mapView.delegate = self;
    _locationService =[[BMKLocationService alloc]init];
   [_locationService startUserLocationService];
    _locationService.delegate=self;
    _mapView.showsUserLocation = YES;
}

-(void)stopLocation
{
    _mapView.showsUserLocation = NO;
    if (_locationService) {
         [_locationService stopUserLocationService];
    }
   
    _mapView = nil;
    _locationService.delegate=nil;
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (_errorBlock) {
        _errorBlock(error);
       _errorBlock=nil;
    }
       [self stopLocation];
    NSLog(@"location error");
}
@end

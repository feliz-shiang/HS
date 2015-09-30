//
//  GYBMKViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYBMKViewController.h"
#import "GYEasyBuyModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Rotate.h"

#import "GYBusLineMod.h"


@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}
@property (nonatomic) int type;
@property (nonatomic) int degree;
@end


@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end
@interface GYBMKViewController ()



@end

@implementation GYBMKViewController

{
    BMKAnnotationView* newAnnotation;
    
    NSArray *  _annotations;
    
    BMKLocationService *_locationService;
    BMKMapView *_mapView;
    CLLocationCoordinate2D  _coordinate;
    
    
    CLLocationCoordinate2D  currentCoordinate;
    ShopModel * shopMod;
    
      RoutePlan *_routePlan;
    
    __weak IBOutlet UIButton *btnCar;

    __weak IBOutlet UIButton *btnBus;
    
    __weak IBOutlet UIButton *btnWalk;
    
    BMKTransitRouteResult * _transitRouteResult;

    NSMutableArray * marrPopViewData;
    
    NSArray * arrBtn ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"地图显示";
        _marr = [NSMutableArray array];
       
    }
    return self;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @ "mapapi.bundle"]] ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    _locationService = [[BMKLocationService alloc]init];
    _routesearch = [[BMKRouteSearch alloc]init];
    marrPopViewData = [NSMutableArray array];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight-64)];
    arrBtn=[NSArray arrayWithObjects:btnWalk,btnCar,btnBus ,nil];
    
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.zoomLevel=16;
    
    BMKCoordinateRegion region;//设置第一次出现的区域。
    region.center.latitude  = _coordinateLocation.latitude;
    region.center.longitude = _coordinateLocation.longitude;
    region.span.latitudeDelta  = 0.01;
    region.span.longitudeDelta = 0.01;
    
    _coordinate.latitude=_coordinateLocation.latitude;
    _coordinate.longitude=_coordinateLocation.longitude;
    _isSetMapSpan = YES;
    [_mapView setRegion:region animated:YES];//执行设定显示范围
    [_mapView setCenterCoordinate:_coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
    
    [self loadDataMapRequest];
    
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];//让三个btn最上层显示。
    
}

- (void)initUI
{
    [btnBus setBackgroundColor:[UIColor clearColor]];
    [btnCar setBackgroundColor:[UIColor clearColor]];
    [btnWalk setBackgroundColor:[UIColor clearColor]];
    [btnWalk setBackgroundImage:kLoadPng(@"map_walk") forState:UIControlStateNormal];
    [btnWalk setBackgroundImage:kLoadPng(@"map_walk_sel") forState:UIControlStateSelected];
    [btnCar setBackgroundImage:kLoadPng(@"map_car") forState:UIControlStateNormal];
    [btnCar setBackgroundImage:kLoadPng(@"map_car_sel") forState:UIControlStateSelected];
    [btnBus setBackgroundImage:kLoadPng(@"map_bus") forState:UIControlStateNormal];
    [btnBus setBackgroundImage:kLoadPng(@"map_bus_sel") forState:UIControlStateSelected];
}

-(void)loadDataMapRequest
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:[NSString stringWithFormat:@"%@",self.strShopId] forKey:@"shopId"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getFindMap" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * tempDict in ResponseDic[@"data"]) {
                        shopMod =[[ShopModel alloc]init];
                        shopMod.strShopAddress=tempDict[@"addr"];
                        shopMod.strIntroduce=tempDict[@"Tips"];
                        
                        shopMod.strShopId=kSaftToNSString(tempDict[@"id"]);
                        shopMod.strLat=tempDict[@"lat"];
                        shopMod.strLongitude=tempDict[@"longitude"];
                        shopMod.strShopName=tempDict[@"name"];
                        shopMod.strShopTel=tempDict[@"tel"];
                        shopMod.strShopPictureURL=tempDict[@"url"];
                        
                        [self addAnimationView];
                    }
                    
                }
            }
            
        }
        
    }];
    
}



-(void)addAnimationView
{
    
    BMKPointAnnotation *  pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [shopMod.strLat doubleValue];
    coor.longitude = [shopMod.strLongitude doubleValue];
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = shopMod.strShopName;
    pointAnnotation.subtitle = [NSString stringWithFormat:@"电话:%@",shopMod.strShopTel];
    [_mapView addAnnotation:pointAnnotation];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    self.navigationController.navigationBarHidden = NO;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (IBAction)btnByCar:(id)sender {
    
  
    
    btnBus.selected=NO;
    btnWalk.selected=NO;
    UIButton * tempBtn  = (UIButton *)sender;
    tempBtn.selected=!tempBtn.selected;
   
  
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=currentCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=self.coordinateLocation;
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
          [self setRegion];
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示！" message:@"自驾路径检索失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    
    
}

- (IBAction)btnByBus:(id)sender {
  
    btnCar.selected=NO;
    btnWalk.selected=NO;
    UIButton * tempBtn  = (UIButton *)sender;
    tempBtn.selected=YES;
    
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=currentCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=self.coordinateLocation;
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"深圳市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
           [self setRegion];
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
      
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示！" message:@"公交路径检索失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    
}

- (IBAction)btnByWalk:(id)sender {
  
    btnCar.selected=NO;
    btnBus.selected=NO;
    UIButton * tempBtn  = (UIButton *)sender;
    tempBtn.selected=YES;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=currentCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=self.coordinateLocation;
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
          [self setRegion];
    }
    else
    {
         NSLog(@"walk检索发送失败");
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示！" message:@"步行路径检索失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    
    
    
}

#pragma mark 地图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
    _routesearch.delegate = nil; // 不用时，置nil
}


#pragma mark 地图zoomlevel++
-(void)zoomMap:(id)sender
{
    
    _mapView.zoomLevel = _mapView.zoomLevel++;
}
#pragma mark 地图ZoomLevel--
-(void)subMap:(id)sender
{
    
    _mapView.zoomLevel = _mapView.zoomLevel--;
}

#pragma mark 地图长按事件
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"长按");
}

#pragma mark 地图双击手势
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"双击");
}
#pragma mark 在开始定位时调用
- (void)willStartLocatingUser
{
    NSLog(@"开始调用");
}
#pragma mark 在停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    NSLog(@"定位结束");
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation)
    {
        
        NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        currentCoordinate=userLocation.location.coordinate;
        
        [_locationService stopUserLocationService];
        
        [_mapView updateLocationData:userLocation];
    }
    
}



//传入经纬度,将baiduMapView 锁定到以当前经纬度为中心点的显示区域和合适的显示范围
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region;
    if (!_isSetMapSpan)//这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
    {
        region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.0001, 0.0001));//越小地图显示越详细
        _isSetMapSpan = YES;
        [_mapView setRegion:region animated:YES];//执行设定显示范围
    }
    NSLog(@"setmap reginon");
    _coordinate = coordinate;
    [_mapView setCenterCoordinate:_coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        
        return nil;
        
    }else if ([annotation isKindOfClass:[RouteAnnotation class]])
    {
        
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    else
    {
        BMKPinAnnotationView *annotationView =(BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = YES;
            //设置大头针的颜色
            annotationView.pinColor = BMKPinAnnotationColorRed;
            
            
            //从天上落下的动画
            annotationView.animatesDrop=YES;
            UIImageView * LetfImagev =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
            [LetfImagev sd_setImageWithURL:[NSURL URLWithString:shopMod.strShopPictureURL] placeholderImage:[UIImage imageNamed:@"shop1"]];
            annotationView.leftCalloutAccessoryView=LetfImagev;
            
            // add by songjk
            UIFont * nameFont = [UIFont systemFontOfSize:15];
            UIFont * font = [UIFont systemFontOfSize:12];
            CGFloat boder = 5;
            
            
            UIView * paoView =  [[UIView alloc]init];
            paoView.backgroundColor = [UIColor whiteColor];
            
            
            CGFloat lbShopNameY = 0;
            CGFloat lbShopNameW = [Utils sizeForString:shopMod.strShopName font:nameFont width:kScreenWidth*0.8].width;
            CGFloat lbShopNameH = [Utils sizeForString:shopMod.strShopName font:nameFont width:kScreenWidth*0.8].height;
            UILabel *lbShopName = [[UILabel alloc] init];
            lbShopName.numberOfLines = 0;
            lbShopName.lineBreakMode= NSLineBreakByWordWrapping;
            lbShopName.text = shopMod.strShopName;
            lbShopName.textColor = [UIColor blackColor];
            lbShopName.font = nameFont;
            lbShopName.backgroundColor = [UIColor clearColor];
            [paoView addSubview:lbShopName];
            
            NSString * shopAddr = [NSString stringWithFormat:@"地址：%@",shopMod.strShopAddress];
            CGFloat lbShopAddrW = [Utils sizeForString:shopAddr font:font width:kScreenWidth*0.8].width;
            CGFloat lbShopAddrH = [Utils sizeForString:shopAddr font:font width:kScreenWidth*0.8].height;
            UILabel *lbShopAddr = [[UILabel alloc] init];
            lbShopAddr.numberOfLines = 0;
            lbShopAddr.lineBreakMode= NSLineBreakByWordWrapping;
            lbShopAddr.textColor = kCellItemTextColor;
            lbShopAddr.backgroundColor = [UIColor clearColor];
            lbShopAddr.font = font;
            lbShopAddr.text = shopAddr;
            [paoView addSubview:lbShopAddr];
            
            NSString * shopTel = [NSString stringWithFormat:@"电话：%@",shopMod.strShopTel];
            CGFloat lbShopTelW = [Utils sizeForString:shopTel font:font width:kScreenWidth*0.8].width;
            CGFloat lbShopTelH = [Utils sizeForString:shopTel font:font width:kScreenWidth*0.8].height;
            UILabel *lbShopTel = [[UILabel alloc] init];
            lbShopTel.numberOfLines = 0;
            lbShopTel.lineBreakMode= NSLineBreakByWordWrapping;
            lbShopTel.textColor = kCellItemTextColor;
            lbShopTel.backgroundColor = [UIColor clearColor];
            lbShopTel.font = font;
            lbShopTel.text = shopTel;
            [paoView addSubview:lbShopTel];
            
            CGFloat viewH = lbShopTelH + lbShopAddrH + lbShopNameH;
            CGFloat viewW = (lbShopTelW>lbShopAddrW? lbShopTelW:lbShopAddrW) > lbShopNameW? (lbShopTelW>lbShopAddrW? lbShopTelW:lbShopAddrW) :lbShopNameW;
            
            LetfImagev.frame = CGRectMake(boder, 0, viewH *0.875, viewH);
            [paoView addSubview:LetfImagev];
            
            CGFloat lbShopNameX = CGRectGetMaxX(LetfImagev.frame) + boder;
            lbShopName.frame = CGRectMake(lbShopNameX, lbShopNameY, lbShopNameW, lbShopNameH);
            CGFloat lbShopAddrX = lbShopNameX;
            CGFloat lbShopAddrY = CGRectGetMaxY(lbShopName.frame);
            lbShopAddr.frame = CGRectMake(lbShopAddrX, lbShopAddrY, lbShopAddrW, lbShopAddrH);
            CGFloat lbShopTelX = lbShopNameX;
            CGFloat lbShopTelY = CGRectGetMaxY(lbShopAddr.frame);
            lbShopTel.frame = CGRectMake(lbShopTelX, lbShopTelY, lbShopTelW, lbShopTelH);
            
            
            
            paoView.frame = CGRectMake(0, 0, viewW + CGRectGetMaxX(LetfImagev.frame)+boder, viewH);
            annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paoView];
        }
        
        return annotationView;
        
        
        
    }
    
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation *)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}


- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


#pragma mark 公交路线 代理方法
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    

    
    array = [NSArray arrayWithArray:_mapView.overlays];
    int i=1;
    [_mapView removeOverlays:array];
   
    NSMutableArray * marrTempData =[NSMutableArray array];
    
    
    NSLog(@"%d---------error",error);
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
       
        for (BMKTransitRouteLine *line in result.routes) {
            NSLog(@"-----------------------------------------------------");
            NSLog(@"  时间：%2d %2d:%2d:%2d 长度: %d米",
                  line.duration.dates,
                  line.duration.hours,
                  line.duration.minutes,
                  line.duration.seconds,
                  line.distance);
            NSMutableString * strTime =[NSMutableString string];
            if(line.duration.hours){
                [strTime appendFormat:@"%d小时", line.duration.hours];
            }
            
            if(line.duration.minutes){
           
                [strTime appendFormat:@"%d分钟", line.duration.minutes];

            
            }
            
            strTime = [[NSString stringWithFormat:@"(%@)",strTime] mutableCopy];
            GYBusLineMod * model = [[GYBusLineMod alloc]init];
            model.title=[NSString stringWithFormat:@"线路%d%@",i,strTime];
            
            
            for (BMKTransitStep *step in line.steps) {
                NSLog(@"%d-------step.stepType---",step.stepType);
                NSLog(@"%@     %@    %@    %@    %@",
                      step.entrace.title,
                      step.exit.title,
                      step.instruction,
                      (step.stepType == BMK_BUSLINE ? @"公交路段" : (step.stepType == BMK_SUBWAY ? @"地铁路段" : @"步行路段")),
                      [NSString stringWithFormat:@"名称：%@  所乘站数：%d   全程价格：%d  区间价格：%d",
                       step.vehicleInfo.title,
                       step.vehicleInfo.passStationNum,
                       step.vehicleInfo.totalPrice,
                       step.vehicleInfo.zonePrice]);
                NSString  * str;
                switch (step.stepType) {
                    case BMK_BUSLINE:
                    {
                        str=@"公交路段" ;
                    }
                        break;
                    case BMK_SUBWAY:
                    {
                          str=@"地铁路段" ;
                    }
                        break;
                    case BMK_WAKLING:
                    {
                         str=@"步行路段" ;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [model.marrSteps addObject:[NSString stringWithFormat:@"%@ ",step.instruction]];
                
            }
            i++;
            NSLog(@"model:%@", model);
          [marrTempData addObject:model];
            
        }
        
//        BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
//        BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
//        BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
//        BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
//        BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
//        BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
//        BMK_SEARCH_KEY_ERROR,///<key错误

        
        marrPopViewData= marrTempData;
       NSLog(@"marrPopViewData-------%@",marrPopViewData);
        _routePlan = [[RoutePlan alloc] initWithData:marrPopViewData parentView:self.view delegate:self];
        
        
        // 打车信息
        NSLog(@"打车信息------------------------------------------");
        NSLog(@"路线打车描述信息:%@  总路程: %d米    总耗时：约%f分钟  每千米单价：%f元  全程总价：约%d元",
              result.taxiInfo.desc,
              result.taxiInfo.distance,
              result.taxiInfo.duration / 60.0,
              result.taxiInfo.perKMPrice,
              result.taxiInfo.totalPrice);
        
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
            
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"检索词有岐义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"搜素城市有歧义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"该城市不支持公交搜索！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"不支持跨城市公交！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_RESULT_NOT_FOUND)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"没有找到检索结果！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"起终点太近！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_KEY_ERROR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"路径检索失败！" isPopVC:nil];
        
    }

    
}


- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"检索词有岐义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"搜素城市有歧义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"该城市不支持公交搜索！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"不支持跨城市公交！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_RESULT_NOT_FOUND)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"没有找到检索结果！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"起终点太近！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_KEY_ERROR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"路径检索失败！" isPopVC:nil];
        
    }

}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"检索词有岐义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"搜素城市有歧义！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"该城市不支持公交搜索！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"不支持跨城市公交！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_RESULT_NOT_FOUND)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"没有找到检索结果！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"起终点太近！" isPopVC:nil];
        
    }else if (error == BMK_SEARCH_KEY_ERROR)
    {
        [Utils   showMessgeWithTitle:@"提示" message:@"路径检索失败！" isPopVC:nil];
        
    }

    
}

-(void)setRegion{
    BMKCoordinateRegion region;
    region.center.latitude = (self.coordinateLocation.latitude + currentCoordinate.latitude)/2;
    region.center.longitude = (self.coordinateLocation.longitude + currentCoordinate.longitude)/2;
    region.span.latitudeDelta = (self.coordinateLocation.latitude - currentCoordinate.latitude) * 1.2;
    region.span.longitudeDelta = (self.coordinateLocation.longitude - currentCoordinate.longitude) * 1.2;
    //    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
    
}


#pragma mark 定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result.address);
}


#pragma mark 
-(void)showTransitRoute:(int )index
{
    if(index < 0){
        _routePlan = nil;
        return;
    }

}


-(void)dealloc{
    [super dealloc];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    
    
}
@end


//
//  GYEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//    逛商铺

#import "GYFindShopViewController.h"

#import "GYEasyBuyModel.h"
#import "GYShopDetailViewController.h"
//#import "GYEeayBuyTableViewCell.h"

//商品栏目分类model
#import "GYGoodCategoryModel.h"
//逛商品的cell

#import "GYFindShopTableViewCell.h"
#import "DropDownWithChildListView.h"

//获取经纬度
#import "MMLocationManager.h"
#import "GYCitySelectViewController.h"
#import "GlobalData.h"
#import  "GYSortTypeModel.h"
#import "GYCityInfo.h"
#import "GYAreaCodeModel.h"
#import "MJRefresh.h"

#import "GYStoreDetailViewController.h"
#define pageCount 8
@interface GYFindShopViewController ()<selectCity>

@end

@implementation GYFindShopViewController
{
    __weak IBOutlet UITableView *tvEasyBuy;
    NSMutableArray * marrEasyBuySource;
    NSMutableArray * chooseArray;
    NSArray * arr;
    NSMutableArray * marrSortType;
    NSMutableArray * marrSortTtile;
    NSInteger sectionNumber;
    UITableView * tempTv;
    
    NSMutableArray * marrDatasource;
    NSMutableArray * marrLevelTwoTitle;
    NSMutableArray * marrCategoryLevelOne;
    NSMutableArray * marrCategoryLevelTwo;
    
    NSInteger useType;
    NSString * cityString;//城市
    NSString * areaString;//区
    NSString * sectionString;//商圈
    CLLocationCoordinate2D currentLocation;
    NSString * categoryIdString;
    NSInteger sortType;
    BMKMapPoint mp1;
    
    
    NSMutableArray * marrArea;
    NSMutableArray * marrAreaTitle;
    
    
    UIButton * btnRight;
    
    DropDownWithChildListView * dropDownView ;
    
    NSInteger currentPage;//当前页码
    
    NSInteger totalCount;//总个数
    
    BOOL isUpFresh; //是否是上拉刷新
    
    NSInteger totalPage;//总共多少页
    
    BOOL isAdd;
    
    NSString * strLevelOneCategory;
    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//   self.title=_modelTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    useType=1;
    sortType=1;
    if ([GlobalData shareInstance].selectedCityName) {
        cityString = [GlobalData shareInstance].selectedCityName;
    }
    else
    cityString=@"深圳市";
    sectionString=@"";
    areaString=@"";
    currentPage=1;
    marrEasyBuySource=[NSMutableArray array];
    marrDatasource=[NSMutableArray array];
    marrCategoryLevelOne=[NSMutableArray array];
    marrCategoryLevelTwo=[NSMutableArray array];
    marrLevelTwoTitle=[NSMutableArray array];
    marrSortType=[NSMutableArray array];
    marrSortTtile=[NSMutableArray array];
    marrAreaTitle=[NSMutableArray array];
    marrArea = [NSMutableArray array];
    categoryIdString =self.modelID;
    
    btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *tempCityStr=cityString;
    if ([cityString hasSuffix:@"市"]) {
        tempCityStr =  [cityString substringToIndex:cityString.length-1];
        
    }
    [btnRight setTitle:tempCityStr forState:UIControlStateNormal];
    [btnRight.titleLabel setAdjustsFontSizeToFitWidth:YES];
    btnRight.frame=CGRectMake(0, 0, 90, 35);
    [btnRight addTarget:self action:@selector(ToCityVC) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setImage:[UIImage imageNamed:@"sp_down_tab.png"] forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(12, 80,13,-10)];
    btnRight.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnRight.frame.size.width+32, 0, 5)];
    UIBarButtonItem  *butn=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    NSArray *rightBtns=[NSArray arrayWithObjects:butn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYFindShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tvEasyBuy.tableFooterView=[[UIView alloc]init];
    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
    }
    [self loadTopDataFromNetwork];
    [self getLocation];
    [tvEasyBuy addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currentPage=1;
    isUpFresh=YES;
    [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
}


- (void)footerRereshing
{
    isUpFresh=NO;
    if (currentPage<=totalPage) {
        // modify by songjk
        [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
    }
}


-(void)ToCityVC
{
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        [_delegate hidenBackgroundView];
    }
    GYCitySelectViewController * vcCitySelection =[[GYCitySelectViewController alloc]initWithNibName:@"GYCitySelectViewController" bundle:nil];
    self.hidesBottomBarWhenPushed=YES;
    vcCitySelection.delegate=self;
    //
    vcCitySelection.navigationItem.title=cityString;
    [self.navigationController pushViewController:vcCitySelection animated:YES];
    
}

#pragma mark   获取市的代理方法
-(void)getCity:(NSString *)CityTitle WithType:(int)type
{
    [marrAreaTitle removeAllObjects];
    // add by songjk 传入空值退出
    if (!CityTitle || CityTitle.length == 0)
    {
        return;
    }
    // modify 下面用到
    NSString *tempCityStr;
    if (CityTitle.length>0) {
        tempCityStr = CityTitle;// add by songjk 没有包含市的时候取原值
        if ([CityTitle hasSuffix:@"市"]) {
            tempCityStr =  [CityTitle substringToIndex:CityTitle.length-1];
            
        }
        [btnRight setTitle:tempCityStr forState:UIControlStateNormal];
        [self reloadDropViewDatasource];
    }
    cityString=CityTitle;
    currentPage=1;
    
    if (type==1) {
     isAdd=YES;
     [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:@""];
    }
    //将文字转化为areaCode
    NSString *  cityAreaCode;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist"ofType:@"txt"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary * tempDic in dict1[@"data"]) {
        
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder= kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaName isEqualToString:CityTitle])
        {
            cityAreaCode = cityModel.strAreaCode;
        }
        else
        {
            // add by songjk 当后缀没有市的时候执行
            if ([cityModel.strAreaName isEqualToString:tempCityStr])
            {
                cityAreaCode = cityModel.strAreaCode;
            }
        }
    }
    //通过市的code 遍历出市下面的区
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"districtlist"ofType:@"txt"];
    NSData *jsonData1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary * dict2 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray * marrTempAreaTitle =[NSMutableArray array];
    NSMutableArray * marrTempArea =[NSMutableArray array];
    
    for (NSDictionary * tempDic in dict2[@"data"]) {
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder= kSaftToNSString(tempDic[@"sortOrder"]);
        if ([ cityModel.strAreaParentCode isEqualToString:cityAreaCode]) {
            [marrTempAreaTitle addObject:cityModel.strAreaName];
            [marrTempArea addObject:cityModel];
        }
    }

   // if (marrTempAreaTitle.count>0) {
   //     if (marrArea.count>=0) {
            marrArea=marrTempArea;
            marrAreaTitle=marrTempAreaTitle;
            // add by songjk
//            areaString = marrTempAreaTitle[0];
     //   }
   // }
    
    //重新选择城市后，需要重新列出所对应的区，需要刷新 section 的数据源
    [self reloadDropViewDatasource];
    
}



-(void)reloadDropViewDatasource
{
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   marrAreaTitle,
                                                   marrCategoryLevelOne,  marrSortTtile
                                                   ]];
    [dropDownView reloadDatasoureArray:chooseArray];
    
}
//modify by zhangqy
-(void)getLocation
{
    GlobalData *data = [GlobalData shareInstance];
    if (data.selectedCityName == nil) {
    sortType=self.strSortType.intValue;
    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        currentLocation=locationCorrrdinate;
        mp1= BMKMapPointForCoordinate(currentLocation);
        // modify by songjk areaString换成sectionString
        
        if (_FromBottomType) {
            
          [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
        }else{
          [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType]Witharea:areaString];
        }
    } withError:^(NSError *error) {
        currentLocation.latitude=22.549225;
        currentLocation.longitude=114.077427;
        mp1= BMKMapPointForCoordinate(currentLocation);
        // modify by songjk areaString换成sectionString
        
        if (_FromBottomType) {
            [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
        }else{
            
            [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
        }
        
    } WithCity:^(NSString *countryString) {
        if (countryString.length>0) {
            NSString *title=countryString;
            if ([countryString hasSuffix:@"市"]) {
                title =  [countryString substringToIndex:countryString.length-1];
                
            }
            
            [btnRight setTitle:title forState:UIControlStateNormal];
            // add by songjk 这里保存的应该是城市
            // 没有市无法搜索到区域
//            if ([countryString hasSuffix:@"市"]) {
//                countryString =  [countryString substringToIndex:countryString.length-1];
//                
//            }
            if ([countryString hasSuffix:@"市辖区"]) {
              NSRange  range = [countryString rangeOfString:@"市"];
                if (range.location!=NSNotFound) {
                     countryString =  [countryString substringToIndex:range.location];
                }
            }
            cityString = countryString;
        }
        [self getCity:cityString WithType:0];
    }];
    }
    else
    {
        currentLocation = [[MMLocationManager shareLocation] lastCoordinate];
        [marrAreaTitle removeAllObjects];
        cityString = data.selectedCityName;
        [self getCity:data.selectedCityName WithType:0];
        NSString *title=cityString;
        if ([cityString hasSuffix:@"市"]) {
            title =  [cityString substringToIndex:cityString.length-1];
            
        }
        
        [btnRight setTitle:title forState:UIControlStateNormal];
        [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
    }
}

//顶端的横条显示内容
-(void)loadTopDataFromNetwork
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
     NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
//    [dict setValue:[GlobalData shareInstance].ecKey forKeyPath:@"key"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/columnClassify"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * str =[NSString stringWithFormat:@"%@",[ResponseDic objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"])
                {
                    NSArray * arrtest =[ResponseDic objectForKey:@"data"];
                    for (NSDictionary * Dic1 in arrtest)
                    {
                        GYGoodCategoryModel * model1 =[[GYGoodCategoryModel alloc]init];
                        model1.strCategoryTitle =[Dic1 objectForKey:@"name"];
                        model1.strCategoryId =[Dic1 objectForKey:@"id"];
                        for (NSDictionary * Dic2 in [Dic1 objectForKey:@"categories"])
                        {
                            GYGoodCategoryModel * model2 =[[GYGoodCategoryModel alloc]init];
                            model2.strCategoryTitle=[Dic2 objectForKey:@"name"];
                            model2.strCategoryId=[Dic2 objectForKey:@"id"];
                            [model1.marrSubCategory addObject:model2];
                        }
                        [marrDatasource addObject:model1];
                        [marrCategoryLevelOne addObject: model1.strCategoryTitle];
                    }
                      [self getAreaCode];
                }
            }
        }
    }];
}


//当一次进入 获取深圳的商区
-(void)getAreaCode
{
    //add by zhangqy 如果不是深圳 返回；
    if (![cityString hasPrefix:@"深圳"]) {
        [self getSortTypeData];
        return;
    }
    [marrAreaTitle removeAllObjects];
    [marrArea removeAllObjects];
    //这里是第一次进来加载的情况下 显示定位失败 显示 深圳市的区
    NSString *path = [[NSBundle mainBundle] pathForResource:@"districtlist"ofType:@"txt"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary * tempDic in dict1[@"data"]) {
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder= kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaParentCode isEqualToString:@"4403"]) {
            [marrAreaTitle addObject:cityModel.strAreaName];
            [marrArea addObject:cityModel];
        }
    }
    // add by songjk
    if (marrAreaTitle.count>0) {
//        areaString = marrAreaTitle[0];
    }
      [self getSortTypeData];
}

-(void)getAreaCodeRequestWithCode:(NSString * )code
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:code forKey:@"areaCode"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getLocation"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * tempDict in ResponseDic[@"data"]) {
                        GYAreaCodeModel * model = [[GYAreaCodeModel alloc]init];
                        model.areaId=kSaftToNSString(tempDict[@"areaId"]);
                        model.areaName=kSaftToNSString(tempDict[@"areaName"]);
                        model.idString=kSaftToNSString(tempDict[@"id"]);
                        model.locationName=kSaftToNSString(tempDict[@"locationName"]);
                        model.sortOreder=kSaftToNSString(tempDict[@"sortOrder"]);
                        [marrCategoryLevelTwo addObject:model];
                    }
                    [self addTempTableView];
                }
            }
        }
    }];
  
}

//逛商铺  排序
-(void)getSortTypeData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/sortType"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * dict in ResponseDic[@"data"]) {
                        GYSortTypeModel * sortTypeMod =[[GYSortTypeModel alloc]init];
                        sortTypeMod.strSortType=[NSString stringWithFormat:@"%@",dict[@"sortType"]];
                        sortTypeMod.strTitle=[NSString stringWithFormat:@"%@",dict[@"title"]];
                        [marrSortTtile addObject:sortTypeMod.strTitle];
                        [marrSortType addObject:sortTypeMod];
                    }
                    [self addTopSelectView];
                }
            }
        }
    }];
}

#pragma mark 获取商铺列表
-(void)loadListDataFromNetwork : (NSString * )categoryId WithSectionCode :(NSString *)sectionTitle WithSortType :(NSString *)sortTypeString  Witharea : (NSString *)areaTitle
{
    // add by songjk
    if ([sectionTitle isEqualToString:@"全部"] ) {
        sectionTitle = @"";
//        areaTitle=@"";
    }

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:cityString forKey:@"city"];
    [dict setValue:areaTitle forKey:@"area"];
    [dict setValue:sectionTitle forKey:@"section"];
    [dict setValue:[NSString stringWithFormat:@"%ld",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"currentPage"];
    [dict setValue:categoryId forKey:@"categoryId"];
    [dict setValue:[NSString stringWithFormat:@"%@",sortTypeString] forKey:@"sortType"];
    [dict setValue:[NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude] forKey:@"location"];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
      hud.labelText = @"数据加载中....";
    [hud show:YES];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getTopicList" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"])
                {
                     [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    totalCount= [ResponseDic [@"rows"] integerValue] ;
                    tvEasyBuy.backgroundView.hidden=YES;
                    totalPage = [ResponseDic [@"totalPage"] integerValue] ;

                    //用来控制 从城市列表选择城市后需要删除数据源，重新刷新tableview
                    if (isAdd) {
                        isAdd=NO;
                        if (marrEasyBuySource.count>0) {
                            [marrEasyBuySource removeAllObjects];
                        }
                    }
                    NSMutableArray   *   dataSource= [NSMutableArray array];
                    for (NSDictionary * tempDic in ResponseDic[@"data"])
                    {
                        ShopModel * model =[[ShopModel alloc]init];
                        model.strShopId=kSaftToNSString(tempDic[@"id"]);// 之前是id
                        model.strVshopId =kSaftToNSString(tempDic[@"vShopId"]);
                        model.strShopAddress=tempDic[@"addr"];
                        model.strLongitude=tempDic[@"longitude"];
                        model.strLat=tempDic[@"lat"];
                        model.strShopName=tempDic[@"name"];
                        model.strShopTel=tempDic[@"tel"];
                        model.strShopPictureURL=tempDic[@"url"];
                        model.strRate=kSaftToNSString(tempDic[@"rate"]);
                        model.strCompanyName=[NSString stringWithFormat:@"%@",tempDic[@"companyName"]];
                        model.strResno=kSaftToNSString(tempDic[@"resno"]);
                        
                        model.beCash= kSaftToNSString([tempDic[@"beCash"] stringValue]) ;
                        model.beReach=kSaftToNSString([tempDic[@"beReach"] stringValue]);
                        model.beSell=kSaftToNSString([tempDic[@"beSell"] stringValue]);
                        model.beTake=kSaftToNSString([tempDic[@"beTake"] stringValue]);
                        model.beTicket=kSaftToNSString([tempDic[@"beTicket"] stringValue]);
                        
                        // modify by songjk 地址距离改成取字段：dist
//                        CLLocationCoordinate2D shopCoordinate;
//                        shopCoordinate.latitude=model.strLat.doubleValue;
//                        shopCoordinate.longitude=model.strLongitude.doubleValue;
//                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
//                        model.shopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
                        model.shopDistance= kSaftToNSString(tempDic[@"dist"]);
                        if (isUpFresh) {
                             [dataSource addObject:model];
                        }
                        else
                        {
                            [marrEasyBuySource addObject:model];
                        }
                    }
                    if (isUpFresh) {
                        marrEasyBuySource=dataSource;
                    }
                    
                    [tvEasyBuy reloadData];
                    currentPage+=1;
                    if (currentPage<=totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEasyBuy.header endRefreshing];
                        [tvEasyBuy.footer endRefreshing];
                    }else{
                        [tvEasyBuy.header endRefreshing];
                        [tvEasyBuy.footer endRefreshing];
                        [tvEasyBuy.footer noticeNoMoreData];//必须要放在reload后面
                    }
                    
                  if ([ResponseDic[@"data"] isKindOfClass:([NSArray   class])]&&![ResponseDic[@"data"]  count]>0) {
                    tvEasyBuy.footer.hidden=YES;
                    
                    UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                         lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:14.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 40);
                    lbTips.text=@"Sorry,您的周边还没有相关商铺数据!";
                         
                     UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                     imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                     imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                     [background addSubview:imgvNoResult];

                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView=background;
                     }
  
                }else if ([retCode isEqualToString:@"201"])
                {
                    if (marrEasyBuySource.count>0) {
                        [marrEasyBuySource removeAllObjects];
                    }
                    [tvEasyBuy reloadData];
                    [tvEasyBuy.header endRefreshing];
                    tvEasyBuy.footer.hidden=YES;
                    
                    UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                    lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:14.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 40);
                    lbTips.text=@"Sorry,您的周边还没有相关商铺数据!";
                    
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView=background;
                }
            }
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        }
    }];
}

-(void)addTopSelectView
{
    
    [Utils hideHudViewWithSuperView:self.view];
    if (marrSortTtile.count>0&&marrCategoryLevelOne.count>0&&marrSortTtile.count>0) {
        chooseArray = [NSMutableArray arrayWithArray:@[
                                                       marrAreaTitle,
                                                       marrCategoryLevelOne,  marrSortTtile
                                                       ]];
        
        dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self  WithUseType:surroundShopType WithOther :[NSNumber numberWithBool:self.FromBottomType]];
        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview=self;
        dropDownView.dropDownDataSource=self;
        NSLog(@"%d-------frombottom",self.FromBottomType);
        dropDownView.fromSurroundShopBottom=self.FromBottomType;
        dropDownView.has=YES;
        _delegate=dropDownView;
        [self.view addSubview:dropDownView];
    }
}


#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
    sectionNumber=section;
    if (marrCategoryLevelTwo.count>0) {
        [marrCategoryLevelTwo removeAllObjects];
    }
    if (marrEasyBuySource.count>0) {
        [marrEasyBuySource removeAllObjects];
    }
    if (sectionNumber==0&&index==0) {
        currentPage=1;
        sectionString=@"";
         [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:@""];
        return ;
    }
    if (sectionNumber==0) {
        GYCityInfo * cityModel =marrArea[index];
        //add by songjk
        areaString=cityModel.strAreaName;
        [self getAreaCodeRequestWithCode:cityModel.strAreaCode];
    }
    else if (sectionNumber==1){
        GYGoodCategoryModel * CategoryLevelOne =marrDatasource[index];
        NSLog(@"%@-------categoryid",CategoryLevelOne.strCategoryId);
            strLevelOneCategory=CategoryLevelOne.strCategoryId;
            marrCategoryLevelTwo = [NSMutableArray arrayWithArray:CategoryLevelOne.marrSubCategory];
            for (GYGoodCategoryModel * model in marrCategoryLevelTwo) {
                [marrLevelTwoTitle addObject:model.strCategoryTitle];
            }
    }
    [self addTempTableView];
}

-(void)addTempTableView
{
    CGFloat width =self.view.frame.size.width/[chooseArray count];
    if (marrCategoryLevelTwo.count>0) {
        if (tempTv==nil) {
            tempTv =[[UITableView alloc]init];
            tempTv.tag=100;
            tempTv.delegate=self;
            tempTv.dataSource=self;
        }
        if ([tempTv respondsToSelector:@selector(setSeparatorInset:)]) {
            [tempTv setSeparatorInset:UIEdgeInsetsZero];
        }
        if (useType==1) {
            tempTv.frame =CGRectMake(width, 40, self.view.frame.size.width-width, (kScreenHeight-64-40)*0.8);
        }else
        {
            tempTv.frame =CGRectMake(width*(sectionNumber+1)-1, 40, self.view.frame.size.width-width, (kScreenHeight-64-40)*0.8);
        }
        tempTv.tableFooterView=[[UIView alloc]init];
        [self.view addSubview:tempTv];
    }
    [tempTv reloadData];
}

-(void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
    }
}


#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}

//返回的多选列表总共有多少项。
-(NSInteger)multipleChoiceCount
{
    NSInteger   arrCount =[chooseArray count];
    return  [ chooseArray[arrCount-1] count];
}


-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (section>=0) {
        
        // modify by songjk arry改成对应的section
        NSArray *arry =chooseArray[section];
        if (arry.count>0) {
            return [arry count];
        }
    }
    return 1;
    
    
}


-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    // modify by songjk arry改成对应的section
    NSArray * array = chooseArray[section];
    if (array.count>0) {
        return chooseArray[section][index];

    }
    else
        return @"全城";
}


-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    if (tableView.tag==100) {
        return marrCategoryLevelTwo.count;
    }
    return marrEasyBuySource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100) {
        return 40;
    } 
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    static NSString * cellIdentiferForTemp=@"TempCell";
    if (tableView.tag==100) {
        UITableViewCell  * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell==nil) {
            cell  =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor=kCellItemTitleColor;
        //section对应的数据源是不同的，需要分别取出
        switch (sectionNumber) {
            case 0:
            {
                GYAreaCodeModel * model=marrCategoryLevelTwo[indexPath.row];
                cell.textLabel.text=model.locationName;
                if (marrCategoryLevelTwo.count<=0) {
                    cell.textLabel.text = @"全城";
                }
            }
                break;
            case 1:
            {
                GYGoodCategoryModel * categoryMod = marrCategoryLevelTwo[indexPath.row];
                cell.textLabel.text=categoryMod.strCategoryTitle;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    GYFindShopTableViewCell * easyBuyCell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (easyBuyCell==nil) {
        easyBuyCell=[[GYFindShopTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    easyBuyCell.selectionStyle=UITableViewCellSelectionStyleNone;
    ShopModel * modelleft =marrEasyBuySource[indexPath.row];
    [easyBuyCell refreshUIWith:modelleft ];
    easyBuyCell.btnShopTel.tag=indexPath.row;
    [easyBuyCell.btnShopTel addTarget:self action:@selector(phoneNumberCall:) forControlEvents:UIControlEventTouchUpInside];
    return easyBuyCell;
}


//用于隐藏分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)didSelectedOneShow : (NSString *)title WithIndexPath:(NSIndexPath *)indexPath
{
    currentPage=1;
    if (marrEasyBuySource.count>0) {
        [marrEasyBuySource removeAllObjects];
    }
    GYSortTypeModel * sortTypeMod =marrSortType[indexPath.row];
    sortType=sortTypeMod.strSortType.integerValue;
    // modify by songjk
    [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
}


#pragma mark dropDownDataSource 用于选择sorttype回调
-(void)didSelectedOneShow:(NSString *)title WithIndexPath:(NSIndexPath *)indexPath WithCurrentSection:(NSInteger)sectionNumber
{
    currentPage=1;
    if (marrEasyBuySource.count>0) {
        [marrEasyBuySource removeAllObjects];
    }
    GYSortTypeModel * sortTypeMod =marrSortType[indexPath.row];
    sortType=sortTypeMod.strSortType.integerValue;
    // modify by songjk
    [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
}

#pragma mark tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tempTv) {
        switch (sectionNumber) {
            case 0:
            {
                GYAreaCodeModel * Areamodel = marrCategoryLevelTwo[indexPath.row];
                // add by songjk
                sectionString = Areamodel.locationName;
                if (_delegate&&[_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                    isAdd=YES;
                    currentPage=1;
                    if (indexPath.row==0) {
                        // modify by songjk
                         [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
                    }else
                    {
                        self.title=Areamodel.locationName;
                        [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",sortType] Witharea:areaString];
                    }
                    [_delegate chooseRowWith:Areamodel.locationName WithSection:sectionNumber WithTableView :tempTv];
                }
            }
                break;
            case 1:
            {
                if (marrEasyBuySource.count>0) {
                    [marrEasyBuySource removeAllObjects];
                }
                currentPage=1;
                GYGoodCategoryModel * categoryMod = marrCategoryLevelTwo[indexPath.row];
                if (indexPath.row==0) {
                    categoryIdString=strLevelOneCategory;
                }else{
                   categoryIdString=categoryMod.strCategoryId;
                }
                // modify by songjk
                [self  loadListDataFromNetwork :categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%ld",(long)sortType] Witharea:areaString ];
                if (_delegate&&[_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                    self.title=categoryMod.strCategoryTitle;
                    [_delegate chooseRowWith:categoryMod.strCategoryTitle WithSection:sectionNumber WithTableView :tempTv];
                }
            }
                break;
            default:
                break;
        }
    }
    else{
        if (marrEasyBuySource.count>0) {
            ShopModel * model =marrEasyBuySource[indexPath.row];
            // 先屏蔽 测试新页面
            //            GYShopDetailViewController * vcShopDetail =[[GYShopDetailViewController alloc]initWithNibName:@"GYShopDetailViewController" bundle:nil];
            //
            //            vcShopDetail.ShopID=model.strShopId;
            //            vcShopDetail.strVshopId=model.strShopId;
            //            vcShopDetail.currentMp1=mp1;
            //            vcShopDetail->mp1 = mp1;
            //            vcShopDetail.strShopDistance=[NSString stringWithFormat:@"%.02f",model.shopDistance.floatValue];// modify by songjk
            //
            //            self.hidesBottomBarWhenPushed=YES;
            //            [self.navigationController pushViewController:vcShopDetail animated:YES];
            
            GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
            vc.currentMp1 = mp1;
            vc.shopModel = model;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


-(void)phoneNumberCall:(UIButton *)sender
{
    ShopModel * model = marrEasyBuySource[sender.tag];
        JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
        JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
        NSArray *asss = @[ass0, ass1];
        JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
        as.delegate = self;
        [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.section) {
                case 0:
                {
                    if (indexPath.row == 0)
                    {
                        NSLog(@"呼叫号码");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", model.strShopTel]]];
                    }else if (indexPath.row == 1)
                    {
                        NSLog(@"复制号码");
                    }
                }
                    break;
                case 1:
                {
                    NSLog(@"取消");
                }
                    break;
                default:
                    break;
            }
            [sheet dismissAnimated:YES];
        }];
        [as setCenter:CGPointMake(100, 100)];
        [as showInView:self.view animated:YES];
}

-(void)btnClicked:(UIButton *)sender
{
    if (sender.tag<5000) {
        GYEasyBuyModel * mod =marrEasyBuySource[sender.tag-100][0];
    }
    else
    {
        GYEasyBuyModel * mod =marrEasyBuySource[sender.tag-5000][1];
    }
}

@end

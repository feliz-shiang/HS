//
//  GYEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//    逛商品

#import "GYBuyGoodViewController.h"

#import "GYEasyBuyModel.h"

//#import "GYEeayBuyTableViewCell.h"

#import "GYGoodDetailViewController.h"
//逛商品的cell
#import "GYBuyGoodTableViewCell.h"

#import "DropDownWithChildListView.h"

#import "MMLocationManager.h"

#import "GYGoodCategoryModel.h"

#import "GYSortTypeModel.h"

#import "GYCitySelectViewController.h"

#import "GYCityInfo.h"

#import "GYAreaCodeModel.h"

#import "MJRefresh.h"


#define pageCount 10
#define goodlbNameHeight 30
#define shoplbNameHeight 22
#define addresslbHeight 26

// add by songjk 是否已经加载第一次进入是筛选项
static BOOL bRun = NO;

@interface GYBuyGoodViewController ()<selectCity>
@property (nonatomic,copy) NSString * hasCoupon;
@end

@implementation GYBuyGoodViewController
{
    __weak IBOutlet UITableView *tvEasyBuy;
    NSMutableArray * marrEasyBuySource;
    NSMutableArray * chooseArray;
    NSArray * arr;
    NSInteger sectionNumber;
    UITableView * tempTv;
    CLLocationCoordinate2D currentLocation;
    NSMutableArray * marrCategoryLevelOne;
    NSMutableArray * marrDatasource;
    NSMutableArray * marrLevelTwoTitle;
    NSMutableArray *   marrCategoryLevelTwo;
    NSString * strCity;
    
    NSMutableArray * marrSortType;
    NSMutableArray * marrSortTtile;
    NSInteger sortType;
    
    
    NSMutableArray * marrSortName;
    NSMutableArray * marrSortNameTtile;
    
    BMKMapPoint mp1;
    
    UIButton * btnRight;
    NSMutableArray * marrArea;
    NSMutableArray *marrAreaTitle;
    
    NSString *categoryIdString;
    NSString * areaString;// 商圈
    // add by songjk
    NSString * sectionString;// 城市里面的位置
    NSString * strProvince; // add by songjk 省
    NSString * specialService;
    NSMutableArray *marrSpecialService;
    // add by songjk
    NSMutableArray *marrFirstSpecialService;
    DropDownWithChildListView * dropDownView;
    
    int currentPage;//当前页码
    
    int totalCount;//总个数
    
    BOOL isUpFresh;
    
    BOOL isAppend;
    
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
    bRun = NO;
    [super viewDidLoad];
    marrEasyBuySource=[NSMutableArray array];
    categoryIdString=self.modelCommins.uid;
    sectionString=@"";
    specialService=@"";
    if (self.strSpecialService.length>0) {
        specialService=self.strSpecialService;
        // add by songjk
        marrFirstSpecialService = [NSMutableArray arrayWithArray:[specialService componentsSeparatedByString:@","]];
    }

    currentPage=1;
    sortType=1;
    areaString=@"";
    //add by zhangqy
    if ([GlobalData shareInstance].selectedCityName) {
        strCity = [GlobalData shareInstance].selectedCityName;
    }
    else
    strCity = @"深圳";// add by songjk 默认是深圳
    strProvince = @"广东省"; // add by songjk 默认是广东
    marrSortTtile = [NSMutableArray array];
    marrDatasource=[NSMutableArray array];
    marrCategoryLevelOne=[NSMutableArray array];
    marrCategoryLevelTwo=[NSMutableArray array];
    marrLevelTwoTitle=[NSMutableArray array];
    marrSortName=[NSMutableArray array];
    marrSortNameTtile=[NSMutableArray array];
    marrArea =[NSMutableArray array];
    marrAreaTitle=[NSMutableArray array];
    marrSortType=[NSMutableArray array];
    marrSpecialService = [NSMutableArray array];
    
    btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    if ([GlobalData shareInstance].selectedCityName) {
       NSString* tempStrCity = [GlobalData shareInstance].selectedCityName;
        if ([tempStrCity hasSuffix:@"市"]) {
            tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length-1)];
        }
        [btnRight setTitle:tempStrCity forState:UIControlStateNormal];
    }
    else
    [btnRight setTitle:@"深圳" forState:UIControlStateNormal];// modify by songjk 显示不带市
    btnRight.frame=CGRectMake(0, 0, 80, 40);
    [btnRight addTarget:self action:@selector(ToCityVC) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setImage:[UIImage imageNamed:@"sp_down_tab.png"] forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(16,62,15,5)];
    [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnRight.frame.size.width+32, 0, 5)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYFindShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
//    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYBuyGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    tvEasyBuy.tableFooterView=[[UIView alloc]init];
    
    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
   
    }
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [tvEasyBuy addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [tvEasyBuy addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    //    [tvEasyBuy headerBeginRefreshing];
    
    [self loadTopDataFromNetwork];
    
    
   
    


}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currentPage=1;
   
    isUpFresh=YES;
    
    [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%d",sortType] WithSpecialService:specialService];
 
   
}



- (void)footerRereshing
{
    // add by songjk
    isUpFresh = NO;
    [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",sortType] WithSpecialService:specialService];
}


-(void)ToCityVC
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
          [_delegate hidenBackgroundView];
    }
  
    
    GYCitySelectViewController * vcCitySelection =[[GYCitySelectViewController alloc]initWithNibName:@"GYCitySelectViewController" bundle:nil];
    self.hidesBottomBarWhenPushed=YES;
    vcCitySelection.delegate=self;
    [self.navigationController pushViewController:vcCitySelection animated:YES];
    
    
}

#pragma mark   获取市的代理方法
-(void)getCity:(NSString *)CityTitle WithType:(int)type
{
    [marrAreaTitle removeAllObjects];
    NSString* tempStrCity = CityTitle;
    if ([tempStrCity hasSuffix:@"市"]) {
        tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length-1)];
    }
    [btnRight setTitle:tempStrCity forState:UIControlStateNormal];
    //[btnRight setTitle:CityTitle forState:UIControlStateNormal];
    
    strCity=CityTitle;
    currentPage=1;
    
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
        
        if ([cityModel.strAreaName isEqualToString:CityTitle]) {
            cityAreaCode = cityModel.strAreaCode;
            // add by songjk获取省
            [self getProvinceWithProviceCode:cityModel.strAreaParentCode];
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
    if (marrTempAreaTitle.count>0) {
        if (marrArea.count>0) {
            marrArea=marrTempArea;
            marrAreaTitle=marrTempAreaTitle;
            // add by songjk
//            sectionString = marrTempAreaTitle[0];
        }
    }
    //重新选择城市后，需要重新列出所对应的区，需要刷新 section 的数据源
    [self reloadDropViewDatasource];
    // modify by songjk 获得全部地区数据之后才去请求数据
    
    if (type==1) {
        isAppend=YES;
        [self loadListDataFromNetwork :categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",sortType] WithSpecialService:specialService];
    }
    
}
// add by songjk 获取省
-(void)getProvinceWithProviceCode:(NSString * )provinceCode
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"statelist"ofType:@"txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary * tempDic in dict[@"data"]) {
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=tempDic[@"parentCode"];
        cityModel.strAreaSortOrder=tempDic[@"sortOrder"];
        if ([cityModel.strAreaCode isEqualToString:provinceCode]) {
            strProvince = cityModel.strAreaName;
        }
    }
}
-(void)reloadDropViewDatasource
{
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   marrAreaTitle,
                                                   marrCategoryLevelOne,
                                                   marrSortNameTtile ,
                                                   marrSortTtile
                                                   ]];
    [dropDownView reloadDatasoureArray:chooseArray];
}

//顶端的横条显示内容
-(void)loadTopDataFromNetwork
{
    //    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:[GlobalData shareInstance].ecKey forKeyPath:@"key"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/columnClassify"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
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
                        [marrDatasource addObject:model1];//放所有一级分类的
                        
                        [marrCategoryLevelOne addObject: model1.strCategoryTitle];//放一级分类的类名。
                    }
                     [self    getSortTypeData];
                   
                    
                }
                
            }
            
        }
        
    }
     ];
    
    
}


//当一次进入 获取深圳的商区
-(void)getAreaCode
{
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

        cityModel.strAreaParentCode=kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder= kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaParentCode isEqualToString:@"4403"]) {
            [marrAreaTitle addObject:cityModel.strAreaName];
            [marrArea addObject:cityModel];
        }
        
    }
    // add by songjk
    if (marrAreaTitle.count>0) {
//        sectionString = marrAreaTitle[0];
    }
}

-(void)getLocation
{
    //add by zhangqy 判断用户是否已经选择过城市，若没有，则开始定位
    GlobalData *data = [GlobalData shareInstance];
    if (data.selectedCityName == nil) {
        
    
    
    
    // add by songjk 记录获取地址城市的次数
    __block NSInteger getCount = 0;
    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate)
     {
        currentLocation=locationCorrrdinate;
        mp1= BMKMapPointForCoordinate(currentLocation);
         getCount +=1;
         // modify by songjk 请求要带上之前选择的服务项目
//        [self  loadListDataFromNetwork :categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",sortType] WithSpecialService:specialService ];
         if (getCount==2)
         {
             [self loadFirstSelectedChoose];
         }
        
    } withError:^(NSError *error)
    {
        currentLocation.latitude=22.549225;
        currentLocation.longitude=114.077427;
        mp1= BMKMapPointForCoordinate(currentLocation);
       
        // modify by songjk 请求要带上之前选择的服务项目
//        [self  loadListDataFromNetwork :categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",sortType] WithSpecialService:specialService ];
        [self loadFirstSelectedChoose];
        
    } WithCity:^(NSString *countryString)
    {
//        [btnRight setTitle:countryString forState:UIControlStateNormal];
       
        if (countryString.length>0) {
            // modify by songjk 这里保存的应该是城市 不是商圈
//            areaString=countryString;
            
            if ([countryString hasSuffix:@"市"]) {
                countryString =  [countryString substringToIndex:countryString.length-1];
                
            }
            if ([countryString hasSuffix:@"市辖区"]) {
                NSRange  range = [countryString rangeOfString:@"市"];
                if (range.location!=NSNotFound) {
                    countryString =  [countryString substringToIndex:range.location];
                }
            }
            
            
            strCity = countryString;
            [btnRight setTitle:countryString forState:UIControlStateNormal];
        }
        
        // add by songjk
        getCount +=1;
        if (getCount==2)
        {
            [self loadFirstSelectedChoose];
        }
        
    }];
    
    [self addTopSelectView];
    }
    else
    {
        currentLocation = [[MMLocationManager shareLocation] lastCoordinate];
        strCity = data.selectedCityName;
        NSString *tempCity = strCity;
        if ([tempCity hasSuffix:@"市"]) {
            tempCity = [tempCity substringToIndex:(tempCity.length-1)];
        }
       
        [self getCity:strCity WithType:0];
        [self loadFirstSelectedChoose];
        [self addTopSelectView];
        strCity = tempCity;
         [btnRight setTitle:tempCity forState:UIControlStateNormal];
        
    }
}

// add by songjk 第一次加载选中的项目
-(void)loadFirstSelectedChoose
{
    if (marrFirstSpecialService.count>0 && !bRun)
    {
        [dropDownView sectionBtnTouch:dropDownView->sectionBtn];
        dropDownView->currentExtendSection = 3;
        for (int i =0; i<marrFirstSpecialService.count; i++) {
            [dropDownView tableView:dropDownView.mTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[marrFirstSpecialService[i] integerValue]-1 inSection:0]];
        }
        [self ConfirmAction:nil];
    }
    else if (marrFirstSpecialService.count==0 && !bRun) // add by songjk 如果定位失败则直接请求
    {
        [self  loadListDataFromNetwork :categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi",sortType] WithSpecialService:specialService ];
    }
    bRun = YES;
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


        
        tempTv.frame =CGRectMake(140, 40, self.view.frame.size.width-width, (kScreenHeight-64-40)*0.8);
        
        [self.view addSubview:tempTv];
    }
    
    
    [tempTv reloadData];
    
    
}

#pragma mark 加载数据
-(void)loadListDataFromNetwork : (NSString * )categoryId WithAreaCode :(NSString *)areaCode WithSortType :(NSString *)sortTypeString WithSpecialService : (NSString *)specialServiceString
{
    
    
    // add by songjk
    if ([areaCode isEqualToString:@"全部"]) {
        areaCode = @"";
    }

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    self.hasCoupon = @"0";
    // 消费抵扣全 传在hasCoupon
    NSString * strSpecialServiceType = specialServiceString;
    if (specialServiceString && specialServiceString.length>0)
    {
        
        if ([specialServiceString rangeOfString:@"6"].location != NSNotFound)
        {
            self.hasCoupon = @"1";
            
            NSArray * arrService = [specialServiceString componentsSeparatedByString:@","];
            NSMutableArray * marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"6"];
            if (marrService.count>0)
            {
                // modify by songjk 传入的id由数字改为名称
                NSMutableArray * marrName = [NSMutableArray array];
                NSString * strName = @"";
                for (int i =0; i<marrService.count; i++)
                {
                    strName = [Utils getServiceNameWithServiceCode:marrService[i]];
                    if (strName && strName.length>0)
                    {
                        [marrName addObject:strName];
                        
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
        else // 不包含6
        {
            NSArray * arrService = [specialServiceString componentsSeparatedByString:@","];
            if (arrService.count>0)
            {
                // modify 传入的id由数字改为名称
                NSMutableArray * marrName = [NSMutableArray array];
                NSString * strName = @"";
                for (int i =0; i<arrService.count; i++)
                {
                    strName = [Utils getServiceNameWithServiceCode:arrService[i]];
                    if (strName && strName.length>0)
                    {
                        [marrName addObject:strName];
                        
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
        }
    }
    // add by songjk uitf8编码 去掉后面市
    if ([strCity hasSuffix:@"市"]) {
        strCity =  [strCity substringToIndex:strCity.length-1];
        
    }
    if ([strCity hasSuffix:@"市辖区"]) {
        NSRange  range = [strCity rangeOfString:@"市"];
        if (range.location!=NSNotFound) {
            strCity =  [strCity substringToIndex:range.location];
        }
    }
    strSpecialServiceType = [strSpecialServiceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    areaCode = [areaCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString * city = [strCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString * section = [sectionString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * province = [strProvince stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * location = [NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
    location = [location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setValue:province forKey:@"province"];
    [dict setValue:city forKey:@"city"];
    [dict setValue:section forKey:@"area"];
    [dict setValue:areaCode forKey:@"section"];
    [dict setValue:categoryId forKey:@"categoryId"];
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    [dict setValue:[NSString stringWithFormat:@"%@",sortTypeString] forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    
    [dict setValue:location forKey:@"location"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getTopicList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        // modify by songjk
        NSMutableArray   *   dataSource= [NSMutableArray array];
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            if (!error)
            {
                if ([retCode isEqualToString:@"200"]) {
                     totalCount= [ResponseDic [@"rows"] integerValue] ;
                  //用来控制 从城市列表选择城市后需要删除数据源，重新刷新tableview
                    if (isAppend) {
                         isAppend=NO;
                        if (marrEasyBuySource.count>0) {
                            [marrEasyBuySource removeAllObjects];
                        }
                    }
                    // modify by songjk 不用forin方法
                    NSArray * arrData = ResponseDic[@"data"];
                    for (int i =0; i<[arrData count]; i++) {
                        NSDictionary * tempDic =arrData[i];
                        SearchGoodModel * MOD =[[SearchGoodModel alloc]init];
                        // add by songjk 获得商品名称
                        MOD.name = kSaftToNSString(tempDic[@"itemName"]);
                        MOD.addr=kSaftToNSString(tempDic[@"addr"]);
                        
                        MOD.beCash=kSaftToNSString(tempDic[@"beCash"]);
                        MOD.beReach=kSaftToNSString(tempDic[@"beReach"]);
                        MOD.beSell=kSaftToNSString(tempDic[@"beSell"]);
                        MOD.beTake=kSaftToNSString(tempDic[@"beTake"]);
                        MOD.beTicket=kSaftToNSString(tempDic[@"beTicket"]);
                        MOD.moonthlySales=kSaftToNSString(tempDic[@"monthlySales"]);
                        MOD.companyName=kSaftToNSString(tempDic[@"companyName"]);
                        MOD.goodsId=kSaftToNSString(tempDic[@"id"]);
                        MOD.shoplat=kSaftToNSString(tempDic[@"lat"]);
                        MOD.shoplongitude=kSaftToNSString(tempDic[@"longitude"]);
                        MOD.shopsName=kSaftToNSString(tempDic[@"name"]);
                        //                        MOD.price=kSaftToNSString(tempDic[@"price"]);
                        NSNumber *price = tempDic[@"price"];
                        MOD.price = [NSString stringWithFormat:@"%0.02f",[price floatValue]];
                        //                        MOD.goodsPv=kSaftToNSString(tempDic[@"pv"]);
                        NSNumber * pv = tempDic[@"pv"];
                        MOD.goodsPv = [NSString stringWithFormat:@"%.02f",[pv floatValue]];
                        MOD.shopId=kSaftToNSString(tempDic[@"shopId"]);
                        MOD.shopTel=kSaftToNSString(tempDic[@"tel"]);
                        MOD.shopUrl=kSaftToNSString(tempDic[@"url"]);
                        MOD.vShopId=kSaftToNSString(tempDic[@"vShopId"]);
                        MOD.shopSection=kSaftToNSString(tempDic[@"section"]);
                        // add by songjk
                        MOD.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
                        
                        // modiby by songhjk 计算距离改成取返回字段： dist
//                        CLLocationCoordinate2D shopCoordinate;
//                        shopCoordinate.latitude=MOD.shoplat.doubleValue;
//                        shopCoordinate.longitude=MOD.shoplongitude.doubleValue;
//                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
//                        MOD.shopDistance=[NSString stringWithFormat:@"%.02f",dis/1000];
                        
                        MOD.shopDistance= kSaftToNSString(tempDic[@"dist"]);
                        if (isUpFresh) {
                            [dataSource addObject:MOD];
                        }
                        else
                        {
                            [marrEasyBuySource addObject:MOD];
                        }
                    }
                    
                    if (isUpFresh) {
                        marrEasyBuySource=dataSource;
                    }
                    
                    [tvEasyBuy reloadData];
                    
                    [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                    currentPage+=1;
                    int totalPage;
                    
                    if (totalCount%pageCount!=0) {
                        totalPage=totalCount/pageCount+1;
                    }
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
                        // add by songjk
                        if (marrEasyBuySource.count>0) {
                            [marrEasyBuySource removeAllObjects];
                            [tvEasyBuy reloadData];
                        }
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 160);
                        lbTips.numberOfLines=2;
                        lbTips.textAlignment=NSTextAlignmentCenter;
                        lbTips.font=[UIFont systemFontOfSize:15.0];
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 270, 50);
                        lbTips.text=@"您的周边还没有相关商品数据！";
                        UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                        imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView=background;
                    }
                    else // add by songjk 去掉没有找到时的背景提示页面
                    {
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        background.backgroundColor = [UIColor whiteColor];
                        tvEasyBuy.backgroundView=background;
                    }

     
                }
 
            }
   
        }
        if (error)// add by songjk
        {
            if (isUpFresh) {
                [marrEasyBuySource removeAllObjects];
                [tvEasyBuy reloadData];
            }
        }

    }];
    
}




//逛商铺  商区
-(void)getSectionAreaCode
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:@" " forKey:@"areaCode"];
  
 
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getLocation"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * tempDic in ResponseDic[@"data"])
                    {
                        
                        
                        SearchGoodModel * MOD =[[SearchGoodModel alloc]init];
                        MOD.addr=kSaftToNSString(tempDic[@"addr"]);
                        MOD.beCash=kSaftToNSString(tempDic[@"beCash"]);
                        MOD.beReach=kSaftToNSString(tempDic[@"beReach"]);
                        MOD.beSell=kSaftToNSString(tempDic[@"beSell"]);
                        MOD.beTake=kSaftToNSString(tempDic[@"beTake"]);
                        MOD.beTicket=kSaftToNSString(tempDic[@"beTicket"]);
                        MOD.goodsId=kSaftToNSString(tempDic[@"id"]);
                        MOD.shoplat=kSaftToNSString(tempDic[@"lat"]);
                        MOD.shoplongitude=kSaftToNSString(tempDic[@"longitude"]);
                        MOD.shopsName=kSaftToNSString(tempDic[@"name"]);
                        MOD.price=kSaftToNSString(tempDic[@"price"]);
                        MOD.goodsPv=kSaftToNSString(tempDic[@"pv"]);
                        MOD.shopId=kSaftToNSString(tempDic[@"shopId"]);
                        MOD.shopTel=kSaftToNSString(tempDic[@"tel"]);
                        MOD.shopUrl=kSaftToNSString(tempDic[@"url"]);
                        MOD.vShopId=kSaftToNSString(tempDic[@"vShopId"]);
                        MOD.shopSection=kSaftToNSString(tempDic[@"section"]);
                        
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=MOD.shoplat.doubleValue;
                        shopCoordinate.longitude=MOD.shoplongitude.doubleValue;
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                        MOD.shopDistance=[NSString stringWithFormat:@"%.02f",dis/1000];
                        [marrEasyBuySource addObject:MOD];
                        
                    }


                    
                }
                
                
                
            }
            
        }
        
    }];



}


//逛 排序类型
-(void)getSortTypeCodeRequet
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/phapi/goods/sortType"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    
                    
                }
                
                
                
            }
            
        }
        
    }];
    
    
    
}




-(void)addTopSelectView
{
    
    if (marrAreaTitle.count>0&&marrCategoryLevelOne.count>0&&marrSortNameTtile.count>0&&marrSortTtile.count>0) {
      
        chooseArray = [NSMutableArray arrayWithArray:@[
                                                       marrAreaTitle,
                                                       marrCategoryLevelOne,
                                                       marrSortNameTtile ,
                                                       marrSortTtile
                                                       ]];
        dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:surroundGoodsType WithOther:nil];
        
        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview=self;
        [dropDownView.BtnConfirm addTarget:self action:@selector(ConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        dropDownView.has=YES;
        _delegate=dropDownView;
        [self.view addSubview:dropDownView];
    }
    
   
    
}

-(void)ConfirmAction :(UIButton *)sender
{

    if (_delegate &&[_delegate respondsToSelector:@selector(hidenBackgroundView  )]) {
        
        
        NSString * strSpecialService =[marrSpecialService componentsJoinedByString:@","];
        specialService=strSpecialService;
    
        currentPage=1;
        isUpFresh=YES;
        [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%d",sortType] WithSpecialService:strSpecialService];
        
        [_delegate hidenBackgroundView];
        
    }
    
    

    

}

//获取商品列表
-(void)loadDataFromNetwork:(NSString * )categoryID
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
     [dict setValue:@"" forKey:@"province"];
     [dict setValue:strCity forKey:@"city"];
     [dict setValue:@"" forKey:@"area"];
     [dict setValue:@"" forKey:@"section"];
     [dict setValue:categoryID forKey:@"categoryId"];
     [dict setValue:@"0" forKey:@"sortType"];
     [dict setValue:@"" forKey:@"specialService"];
     [dict setValue:@"" forKey:@"location"];
     [dict setValue:@"0" forKey:@"hasCoupon"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getTopicList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * tempDic in ResponseDic[@"data"])
                    {
                        SearchGoodModel * MOD =[[SearchGoodModel alloc]init];
                        MOD.addr=kSaftToNSString(tempDic[@"addr"]);
                        MOD.beCash=kSaftToNSString(tempDic[@"beCash"]);
                        MOD.beReach=kSaftToNSString(tempDic[@"beReach"]);
                        MOD.beSell=kSaftToNSString(tempDic[@"beSell"]);
                        MOD.beTake=kSaftToNSString(tempDic[@"beTake"]);
                        MOD.beTicket=kSaftToNSString(tempDic[@"beTicket"]);
                        MOD.goodsId=kSaftToNSString(tempDic[@"id"]);
                        MOD.shoplat=kSaftToNSString(tempDic[@"lat"]);
                        MOD.shoplongitude=kSaftToNSString(tempDic[@"longitude"]);
                        MOD.shopsName=kSaftToNSString(tempDic[@"name"]);
                        MOD.price=kSaftToNSString(tempDic[@"price"]);
                        MOD.goodsPv=kSaftToNSString(tempDic[@"pv"]);
                        MOD.shopId=kSaftToNSString(tempDic[@"shopId"]);
                        MOD.shopTel=kSaftToNSString(tempDic[@"tel"]);
                        MOD.shopUrl=kSaftToNSString(tempDic[@"url"]);
                        MOD.vShopId=kSaftToNSString(tempDic[@"vShopId"]);
                        MOD.shopSection=kSaftToNSString(tempDic[@"section"]);
                        
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=MOD.shoplat.doubleValue;
                        shopCoordinate.longitude=MOD.shoplongitude.doubleValue;
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                        MOD.shopDistance=[NSString stringWithFormat:@"%.02f",dis/1000];
                        [marrEasyBuySource addObject:MOD];
            
                    }
                    
                }
              
                
                
            }
            
        }
        
    }];

    

}


//逛商品  排序
-(void)getSortTypeData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/sortType"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
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
                        [marrSortTtile addObject:sortTypeMod.strTitle];//注意两个数据的关系，取值是别混淆

                        [marrSortType addObject:sortTypeMod];//排序类型
                        
                    }
                    
                    [self getAreaCode];
                    [self getSortNameData];

                    
                    
                }
                
            }
            
        }
        
    }];
    
}



//逛商品 排序的名称
-(void)getSortNameData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/sortName"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    
                    for (NSDictionary * dict in ResponseDic[@"data"]) {
                        GYSortTypeModel * sortNameMod =[[GYSortTypeModel alloc]init];
                        sortNameMod.strSortType=[NSString stringWithFormat:@"%@",dict[@"sortType"]];
                        sortNameMod.strTitle=[NSString stringWithFormat:@"%@",dict[@"title"]];
                        [marrSortNameTtile addObject:sortNameMod.strTitle];
                        [marrSortName addObject:sortNameMod];//特殊服务
                        
                    }
                    
                    [self getLocation];
 
                }
                
            }
            
        }
        
    }];
    
}


#pragma mark -- dropDownListDelegate 点击 row 触发的回调方法
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
  //section 就是btn的tag
    sectionNumber=section;
    
    if (marrCategoryLevelTwo.count>0) {
        [marrCategoryLevelTwo removeAllObjects];
    }
    
    
    if (sectionNumber==0&&index==0) {
        if (marrEasyBuySource.count>0) {
            [marrEasyBuySource removeAllObjects];
        }
        
        
        currentPage=1;
        sectionString=@"";

        [self loadListDataFromNetwork:categoryIdString WithAreaCode:@"" WithSortType:[NSString stringWithFormat:@"%ld",(long)sortType] WithSpecialService:specialService];
   
        return ;
    }
    
    if (sectionNumber==0) {
        
        GYCityInfo * cityModel =marrArea[index];
        // add by songjk
        sectionString = cityModel.strAreaName;
        
        [self getAreaCodeRequestWithCode:cityModel.strAreaCode];
        
    }
    else if (sectionNumber==1){
        
  
        GYGoodCategoryModel * CategoryLevelOne =marrDatasource[index];
        
        marrCategoryLevelTwo = [NSMutableArray arrayWithArray:CategoryLevelOne.marrSubCategory];
        
        
        for (GYGoodCategoryModel * model in marrCategoryLevelTwo) {
            
            [marrLevelTwoTitle addObject:model.strCategoryTitle];
            
        }
        
    }

    [self addTempTableView];

    
}


#pragma mark 用于消除 多选项中选中的项目
-(void)mutableSelectRemoveObj:(NSIndexPath *)indexPath WithCurrentSectin:(NSInteger)sectionNumber
{
    GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];
    
    [marrSpecialService removeObject:sortTypeMod2.strSortType];

    
}


#pragma mark 删除 tempTV的回调方法
-(void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
    }


}

#pragma mark 多选时用于 清除 多选项中得数据
-(void)btnTouch:(NSInteger)section
{
    if (section==3)
    {
        
    }
    else{
        
        [marrSpecialService removeAllObjects];
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
    NSInteger arrCount =[chooseArray count];
    return  [ chooseArray[arrCount-1] count];
}


-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arry =chooseArray[section];
    return [arry count];

}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}


-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


-(void)didSelectedOneShow : (NSString *)title WithIndexPath:(NSIndexPath *)indexPath WithCurrentSection:(NSInteger)sectionNum
{
    
    switch (sectionNum) {
        case 2:
        {
            GYSortTypeModel * sortTypeMod1 =marrSortName[indexPath.row];
            sortType=sortTypeMod1.strSortType.integerValue;
            currentPage=1;
            isUpFresh=YES;
        
              [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",(long)sortType] WithSpecialService:specialService];
        }
            break;
        case 3:
        {
            
            
    
            GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];

            if ([sortTypeMod2.strTitle isEqualToString:@"全部"]) {
                sortTypeMod2.strSortType = @"";
            }
            [marrSpecialService addObject:sortTypeMod2.strSortType];
 
            
        }
            break;
        default:
            break;
    }
    
   
    
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
//    CGFloat heightStart=13;
//    
//    SearchGoodModel * model =marrEasyBuySource[indexPath.row];
//    
//    CGFloat titleHeight = [Utils heightForString:model.name fontSize:17.0 andWidth:119.f];
//    
//    int mutible=2;
//    titleHeight=titleHeight>goodlbNameHeight?mutible*goodlbNameHeight:goodlbNameHeight;
//    
//    CGFloat shopHeight = [Utils heightForString:[NSString stringWithFormat:@"实体店:%@",model.shopsName ] fontSize:14.0 andWidth:192.f];
//     shopHeight=shopHeight>shoplbNameHeight?shoplbNameHeight*mutible:shoplbNameHeight;
//    
//    CGFloat addressHeight =[Utils heightForString:[NSString stringWithFormat:@"地址:%@",model.addr] fontSize:14.0 andWidth:192.f];
//     addressHeight=addressHeight>addresslbHeight?addresslbHeight*mutible:addresslbHeight;
//    
//    CGFloat totalHeight =heightStart + titleHeight + shopHeight+addressHeight+20+10+5;

    return 131;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"BuyGoodCell";
    static NSString * cellIdentiferForTemp=@"TempCell";
    if (tableView.tag==100) {
        UITableViewCell  * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell==nil) {
            cell  =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
            cell.textLabel.font=[UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor=kCellItemTitleColor;
            
        }

        //section对应的数据源是不同的，需要分别取出
        switch (sectionNumber) {
            case 0:
            {
                GYAreaCodeModel * model=marrCategoryLevelTwo[indexPath.row];
                
                cell.textLabel.text=model.locationName;
                
                
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
    
    GYBuyGoodTableViewCell * easyBuyCell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (easyBuyCell==nil) {
        easyBuyCell = [[[NSBundle mainBundle] loadNibNamed:@"GYBuyGoodTableViewCell" owner:nil options:nil] lastObject];
    }
    
    easyBuyCell.selectionStyle=UITableViewCellSelectionStyleNone;
    easyBuyCell.btnShopTel.tag=indexPath.row;
    [easyBuyCell.btnShopTel addTarget:self action:@selector(shopCall:) forControlEvents:UIControlEventTouchUpInside];
    
    
    SearchGoodModel * model =marrEasyBuySource[indexPath.row];
    
    [easyBuyCell refreshUIWithModel:model];
    
    return easyBuyCell;
    
}

-(void)shopCall:(UIButton *)sender
{
     SearchGoodModel * model =marrEasyBuySource[sender.tag];
    NSString * phoneNo= model.shopTel;
    
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
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNo]]];
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
                break;
                
            default:
                break;
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    [as setCenter:CGPointMake(100, 100)];
    
    [as showInView:self.view animated:YES];
      
}

#pragma mark tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tempTv) {
        
        switch (sectionNumber) {
            case 0:
            {
                
                GYAreaCodeModel * Areamodel = marrCategoryLevelTwo[indexPath.row];
                // add by songjjk
                isAppend=YES;
                areaString =[NSString stringWithFormat:@"%@",Areamodel.locationName];
                currentPage=1;
                 [self loadListDataFromNetwork:categoryIdString WithAreaCode:Areamodel.locationName WithSortType:[NSString stringWithFormat:@"%ld",(long)sortType] WithSpecialService:specialService];
                if (_delegate&&[_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
      
                    [_delegate chooseRowWith:Areamodel.locationName WithSection:sectionNumber WithTableView :tempTv];
                    
                }
                
            }
                break;
            case 1:
            {
                GYGoodCategoryModel * categoryMod = marrCategoryLevelTwo[indexPath.row];
                categoryIdString=categoryMod.strCategoryId;
                currentPage=1;
                self.title=categoryMod.strCategoryTitle;
                isAppend=YES;
                [self  loadListDataFromNetwork :categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld",(long)sortType] WithSpecialService:specialService ];
                if (_delegate&&[_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                    [_delegate chooseRowWith:categoryMod.strCategoryTitle WithSection:sectionNumber WithTableView :tempTv];
                    
                }
                
            }
                break;
            default:
                break;
        }
        

    }
    else{
    
            GYGoodDetailViewController * vcGoodDetail =[[GYGoodDetailViewController alloc]initWithNibName:@"GYGoodDetailViewController" bundle:nil];
            SearchGoodModel * model =marrEasyBuySource[indexPath.row];
            vcGoodDetail.model=model;
           self.hidesBottomBarWhenPushed=YES;
           [self.navigationController pushViewController:vcGoodDetail animated:YES];
    
    
    }


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

-(void)btnClicked:(UIButton *)sender
{
  
    
}
@end

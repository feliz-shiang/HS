//
//  GYShopDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYShopDetailViewController.h"
#import "GYShopDetailHeaderView.h"
#import "UIView+CustomBorder.h"

#import "GYShopInfoWithLocationCell.h"
//热卖商品的cell
#import "GYShopDetailHotGoodTableViewCell.h"
//星星的cell
#import "GYStarTableViewCell.h"
#define hotGoodIdentifier @"hotGood"
#define locationCellIdentifier @"locationCell"
#define allshopCell @"allShopCell"

#import "GYCitySelectViewController.h"

#import "GYBMKViewController.h"
#import  "GYHotItemGoods.h"
#import "GYShopItem.h"
#import "GYGoodDetailListTableViewCell.h"

#import "GYChatItem.h"
#import "GYChatViewController.h"
#import "MMLocationManager.h"
#define pageCount 6
#import  "GYEasyBuyModel.h"
//#import "GYGoodsDetailController.h"
#import "GYMainEvaluateDetailViewController.h"
#import "GYGoodDetailViewController.h"
#import "GYAllShopTableViewCell.h"
#import "SearchGoodModel.h"
#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"
#import "GYPhoneScr.h"

#import "MJRefresh.h"
#import "MWPhotoBrowser.h"


#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
@interface GYShopDetailViewController ()<MWPhotoBrowserDelegate>
// add by songjk
@property (nonatomic,strong) UIImageView * imgvArrow;//箭头
@property (nonatomic,strong) UIImageView * imgvArrow2;//箭头
@property (nonatomic,assign) CGAffineTransform rotationTransform;
@property (nonatomic,assign) CGAffineTransform rotationTransform2;

@property (nonatomic,assign)NSInteger totalPage;
@property(nonatomic,strong) SearchGoodModel * GoodModel;
@property(nonatomic,strong) NSMutableArray *photos;
@property (nonatomic ,assign) NSInteger currentIndex;
@end

@implementation GYShopDetailViewController
{
    
    __weak IBOutlet UITableView *tvShopDetail;
    
    GYShopInfoWithLocationCell * locationCell;
    
    GYStarTableViewCell * starCell;
    
    CLLocationCoordinate2D  coordinate;
    
    UIButton * btnRight;
    
    NSMutableArray * marrDatasorce;
    
    ShopModel * shopInfo;
    
    GYShopDetailHeaderView * header;
    
    NSMutableArray * marrShopItem;
    
    BOOL isShow;
    
    BOOL isShowIntroduction;
    
    NSInteger rows;//控制查看店铺的行数
    
    NSInteger rowsIntroduction;
    
    NSMutableArray * marrHotGoods;
    
    BOOL isAttention;
    
    NSInteger currentPage;//当前页码
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=kLocalized(@"ar_shop_detail");
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    marrDatasorce =[NSMutableArray array];
    marrShopItem=[NSMutableArray array];
    marrHotGoods=[NSMutableArray array];
    CGRect rect = tvShopDetail.frame;
    shopInfo=[[ShopModel alloc]init];
    isShow=YES;
    isShowIntroduction=YES;
    currentPage=1;
    UIView * backgroundView =[[UIView alloc]initWithFrame:rect];
    backgroundView.backgroundColor=kDefaultVCBackgroundColor;
    tvShopDetail.backgroundView=backgroundView;
    tvShopDetail.delegate=self;
    tvShopDetail.dataSource=self;
    tvShopDetail.separatorStyle=UITableViewCellSeparatorStyleNone;

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    self.rotationTransform=CGAffineTransformRotate(self.imgvArrow.transform, DEGREES_TO_RADIANS(360));
    self.rotationTransform2=CGAffineTransformRotate(self.imgvArrow.transform, DEGREES_TO_RADIANS(360));
    
    [tvShopDetail registerNib:[UINib nibWithNibName:@"GYShopInfoWithLocationCell" bundle:nil] forCellReuseIdentifier:locationCellIdentifier];
    [tvShopDetail registerNib:[UINib nibWithNibName:@"GYShopDetailHotGoodTableViewCell" bundle:nil] forCellReuseIdentifier:hotGoodIdentifier];
    [tvShopDetail registerNib:[UINib nibWithNibName:@"GYAllShopTableViewCell" bundle:nil] forCellReuseIdentifier:allshopCell];
    
    [self addHeadview];
    
    [self getCurrentLocation];
    // modify by songjk
//    [self loadShopDataRequest];
    
   // add by songjk 热卖商品分页
    [tvShopDetail addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
-(void)footerRereshing
{
    [self getHotGoods];
}
-(void)getCurrentLocation
{
    // modify by songjk
    if (self.fromEasyBuy == 1)
    {
        
        [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            coordinate=locationCorrrdinate;
            _currentMp1=BMKMapPointForCoordinate(locationCorrrdinate);
            [self loadShopDataRequest];
        } withError:^(NSError *error) {
            
            coordinate.latitude=22.549225;
            coordinate.longitude=114.077427;
            _currentMp1=BMKMapPointForCoordinate(coordinate);
            [self loadShopDataRequest];
        }];
    }
    else
    {
        _currentMp1 = BMKMapPointForCoordinate([MMLocationManager shareLocation].lastCoordinate);
        [self loadShopDataRequest];
    }
}

-(void)setBorderWithView:(UIButton*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    [view setTitleColor:color forState:UIControlStateNormal];
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}

#pragma mark 加载数据的请求
-(void)loadShopDataRequest
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.ShopID forKey:@"shopId"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getShopInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    
                    shopInfo.strShopId=kSaftToNSString(ResponseDic[@"data"][@"id"]);
                    shopInfo.strShopAddress=ResponseDic[@"data"][@"addr"];
                    shopInfo.strLongitude=ResponseDic[@"data"][@"longitude"];
                    shopInfo.strLat=ResponseDic[@"data"][@"lat"];
                    shopInfo.strShopName=ResponseDic[@"data"][@"vShopName"];// modify by songjk
//                    shopInfo.strShopTel=ResponseDic[@"data"][@"tel"];
                    shopInfo.strEvacount=kSaftToNSString(ResponseDic[@"data"][@"evacount"]);
                    
                    if ([ResponseDic[@"data"][@"city"] length]>0) {
                        shopInfo.strCity= ResponseDic [@"data"] [@"city"] ;
                    }else
                    {
                        shopInfo.strCity= @"" ;
                    }
                    
                    if ([ResponseDic[@"data"][@"area"] length]>0) {
                        shopInfo.strArea= ResponseDic [@"data"] [@"area"] ;
                    }else
                    {
                        shopInfo.strArea= @"" ;
                    }
                    
                    if (kSaftToNSString(ResponseDic[@"data"][@"rating"]).length>0) {
                        shopInfo.strRate=[NSString stringWithFormat:@"%.f",[ResponseDic[@"data"][@"rating"] floatValue]];
                    }
                    
                    
                    if ([ResponseDic[@"data"][@"introduce"] isKindOfClass:[NSNull class]]) {
                        shopInfo.strIntroduce=@" ";
                    }else
                    {
                        shopInfo.strIntroduce=ResponseDic[@"data"][@"introduce"];
                        
                    }
                    shopInfo.marrShopImages=ResponseDic[@"data"][@"picList"];
                    shopInfo.marrAllShop =ResponseDic[@"data"][@"shops"];
                    shopInfo.marrHotGoods = ResponseDic [@"data"][@"hotGoods"];
                    shopInfo.strVshopId =kSaftToNSString(ResponseDic[@"data"][@"vShopId"]);
                    shopInfo.strResourceNumber =kSaftToNSString(ResponseDic[@"data"][@"companyResourceNo"])   ;
                    shopInfo.strStoreName = ResponseDic[@"data"][@"name"];// add by songjk;
                    
                    shopInfo.isAttention=[ResponseDic [@"data"][@"bePre"] boolValue];
                    shopInfo.befocus=[ResponseDic [@"data"][@"beFocus"] boolValue];
                    
                    if (shopInfo.befocus) {
                        header.btnAttention.selected=YES;
                        isAttention=YES;//已关注
                    }  else {
                        header.btnAttention.selected=NO;
                        isAttention=NO;//没有关注
                    }
                    
                    // modify by songjk
//                    if (self.fromEasyBuy==1) {
//                        // modify by songjk
//                        [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//                            coordinate=locationCorrrdinate;
//                               _currentMp1=BMKMapPointForCoordinate(locationCorrrdinate);
//                            // songjk
//                            CLLocationCoordinate2D shopCoordinate;
//                            shopCoordinate.latitude=shopInfo.strLat.doubleValue;
//                            shopCoordinate.longitude=shopInfo.strLongitude.doubleValue;
//                            BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                            CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
//                            self.strShopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
//                        } withError:^(NSError *error) {
//                            
//                            coordinate.latitude=22.549225;
//                            coordinate.longitude=114.077427;
//                            // songjk
//                            _currentMp1=BMKMapPointForCoordinate(coordinate);
//                            CLLocationCoordinate2D shopCoordinate;
//                            shopCoordinate.latitude=shopInfo.strLat.doubleValue;
//                            shopCoordinate.longitude=shopInfo.strLongitude.doubleValue;
//                            BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                            CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
//                            self.strShopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
//                        }];
//                        // modify by songjk
//                        
//                    }
//                    else
//                    {
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=shopInfo.strLat.doubleValue;
                        shopCoordinate.longitude=shopInfo.strLongitude.doubleValue;
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
                        self.strShopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
//                    }
                    
                    NSString * strTel = kSaftToNSString(ResponseDic[@"data"][@"hotline"]);
                    if (strTel.length>0) {
                        shopInfo.strShopTel=strTel;
                    }else
                    {
                        shopInfo.strShopTel=@" ";
                    }
                    
                    
                    for (NSDictionary * temDict in ResponseDic[@"data"][@"shops"]) {
                        GYShopItem  * shopItem =[[GYShopItem alloc]init];
                        shopItem.strShopId=kSaftToNSString(temDict[@"id"]) ;
                        shopItem.strShopName=temDict[@"name"];
                        shopItem.strLat=temDict[@"lat"];
                        shopItem.strLongitude=temDict[@"longitude"];
                        shopItem.strTel=temDict[@"tel"];
                         shopItem.strAddr=temDict[@"addr"];
                       
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=[temDict[@"lat"] floatValue];
                        shopCoordinate.longitude=[temDict[@"longitude"] floatValue];
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
                        shopItem.strDistance=[NSString stringWithFormat:@"%.2f",dis/1000];
//                        NSLog(@"%f=========dis",dis);
                        [marrShopItem addObject:shopItem];
                    }
                    
                    for (NSDictionary * temDict in ResponseDic[@"data"][@"hotGoods"]) {
                        GYHotItemGoods * hotGoods =[[GYHotItemGoods alloc]init];
                        hotGoods.strCategoryName=temDict[@"categoryName"];
                        hotGoods.strCategoryId=kSaftToNSString(temDict[@"categoryId"]);
                        hotGoods.strItemId=kSaftToNSString(temDict[@"itemId"]);
                        hotGoods.strItemName=temDict[@"itemName"];
                        hotGoods.strImgUrl=temDict[@"url"];
                        hotGoods.strVshopId=kSaftToNSString(temDict[@"vShopId"]);
                        
                        [marrHotGoods addObject:hotGoods];
                        
                    }
                    
                }
                
                [header setShopInfo:shopInfo];
                tvShopDetail.tableHeaderView = header;
                [tvShopDetail reloadData];
                [self getHotGoods];
                
            }
            
        }
        
    }];
    
}


-(void)getHotGoods
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:shopInfo.strVshopId forKey:@"vshopId"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi",currentPage] forKey:@"currentPage"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getHotItemsByVshopId" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode = kSaftToNSString(ResponseDic[@"retCode"]);
                self.totalPage = kSaftToNSInteger(ResponseDic[@"totalPage"]);
                if ([retCode isEqualToString:@"200"]) {
                    if ([ResponseDic[@"data"] count]>0) {
                        currentPage ++;
                    }
                    for (NSDictionary * tempDict in ResponseDic[@"data"]) {
                        
                        GYHotItemGoods * model = [[GYHotItemGoods alloc]init];
                        model.strCategoryId = kSaftToNSString(tempDict[@"categoryId"]);
                        model.strCategoryName = tempDict[@"categoryName"];
                        model.strItemId = kSaftToNSString(tempDict[@"itemId"]);
                        model.strItemName = tempDict[@"itemName"];
                        model.strImgUrl = tempDict[@"url"];
                        // add by songjk
                        model.strPrice = tempDict[@"price"];
                        model.strPV = tempDict[@"pv"];
                        [marrHotGoods addObject:model];
                    }
                    [tvShopDetail reloadData];
                }
            }
        }
        if (self.totalPage == 0 || self.totalPage == 1 || currentPage == self.totalPage+1) {
            [tvShopDetail.footer noticeNoMoreData];
        }
        if ([tvShopDetail.footer isRefreshing]) {
            [tvShopDetail.footer endRefreshing];
        }
    }];
    
    
    
}


#pragma mark 添加headerview
-(void)addHeadview
{
    
    header =[[GYShopDetailHeaderView alloc]initWithShopModel:CGRectMake(0, 0, kScreenWidth, 360) WithOwer:self];
    [header.btnAttention addTarget:self action:@selector(concernShopRequest) forControlEvents:UIControlEventTouchUpInside];
    [header.btnCollect addTarget:self action:@selector(contactShopRequest) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigPic)];
    [header.srcView addGestureRecognizer:tap];
    tvShopDetail.tableHeaderView=header;
    
    
}

-(void)showBigPic
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    for (int i=0; i<shopInfo.marrShopImages.count; i++) {
        NSString *strUrl =kSaftToNSString(shopInfo.marrShopImages[i][@"url"]);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
        
    }
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    enableGrid = NO;
    self.photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.customRigthButton = NO;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    browser.showIndexOfCount = YES;//add
    browser.clickDismissPhotoBrowser = YES;//add
    [browser setCurrentPhotoIndex:self.currentIndex];
    
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browser animated:YES completion:nil ];
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.newshop) {
        return 2;
    }else
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        {
            return rows;
        }
            break;
        case 2:
        {
            return rowsIntroduction;
        }
            break;
        case 3:
            return 1;
            break;
        case 4:
        {
            int hotRows;
            if (marrHotGoods.count % 2 == 0)
            {
                hotRows = marrHotGoods.count / 2;
            }else
            {
                hotRows = marrHotGoods.count / 2 + 1;
            }
            
            return hotRows;
        }
            
            break;
        default:
            break;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CGFloat startHeight=12;
            CGFloat  heightStoreName = [Utils heightForString:shopInfo.strStoreName fontSize:15.0 andWidth:195];
            CGFloat  heightAddress = [Utils heightForString:[NSString stringWithFormat:@"地址:%@",shopInfo.strShopAddress] fontSize:15.0 andWidth:195];
            CGFloat totalHeight = startHeight + heightStoreName + heightAddress+15+8+10;
            return totalHeight>78?totalHeight:78;
        }
            break;
        case 1:
            return 65;
            break;
        case 2:
        {
            CGFloat  height=30;
            if ([shopInfo.strIntroduce isKindOfClass:[NSNull class]]) {
            }else{
                GYGoodIntroductionModel * model = [[GYGoodIntroductionModel alloc] init];
                model.strData = shopInfo.strIntroduce;
                height = model.fHight>height?(model.fHight):height;
            }
            NSLog(@"%f-----height",height);
            return height;
             break;
        }
            break;
        case 3:
            return 40.f;
            break;
        case 4:
            return 211.f;
            break;
        default:
            break;
    }
    return 0;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            return [self checkAllShop];
            
        }
            return nil;
        case 2:
        {
            return [self seeShopIntroduction];
            
        }
            return nil;
        case 3:
        {
            return [self blankView];
            
        }
            
            break;
        case 4:
        {
            return [self hotGoodView];
        }
            return nil;
            break;
        default:
            break;
    }
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 44;
            break;
        case 3:
            return 0;
            break;
        case 4:
            return 30;
            break;
        default:
            break;
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    static NSString * hotGoodIdentiferInCell =hotGoodIdentifier;

    GYAllShopTableViewCell * AllShopCell =[tableView dequeueReusableCellWithIdentifier:allshopCell];
    GYShopDetailHotGoodTableViewCell * hotGoodCell =[tableView dequeueReusableCellWithIdentifier:hotGoodIdentiferInCell];
    switch (indexPath.section) {
        case 0:
        {
            // modify by songjk
            locationCell=[[[NSBundle mainBundle] loadNibNamed:@"GYShopInfoWithLocationCell" owner:self options:nil]lastObject];
            
            CGFloat  heightStoreName = [Utils heightForString:shopInfo.strStoreName fontSize:15.0 andWidth:195];
            CGFloat  heightAddress = [Utils heightForString:[NSString stringWithFormat:@"地址:%@",shopInfo.strShopAddress] fontSize:15.0 andWidth:195]+5;
            
            CGRect frameShopName = locationCell.lbHsNumber.frame;
            frameShopName.size.height=heightStoreName>25?heightStoreName:25;
            locationCell.lbHsNumber.frame=frameShopName;
            
            CGRect frameShopAddress = locationCell.lbShopAddress.frame;
            frameShopAddress.size.height=heightAddress>15?heightAddress:15;
            frameShopAddress.origin.y=locationCell.lbHsNumber.frame.origin.y+locationCell.lbHsNumber.frame.size.height;
            locationCell.lbShopAddress.frame=frameShopAddress;
            
            CGRect frameTel = locationCell.btnPhoneCall.frame;
            frameTel.origin.y=locationCell.lbShopAddress.frame.origin.y+(heightAddress>15?heightAddress:15);
            locationCell.btnPhoneCall.frame=frameTel;
            
            locationCell.lbHsNumber.text=[NSString stringWithFormat:@"互生号:%@",shopInfo.strResourceNumber];// modify by songjk
            [locationCell.btnPhoneCall setTitle:shopInfo.strShopTel forState:UIControlStateNormal];
            [locationCell.btnPhoneCall addTarget:self action:@selector(CallShop:) forControlEvents:UIControlEventTouchUpInside];
         
            locationCell.lbShopAddress.text= [NSString stringWithFormat:@"%@",shopInfo.strShopAddress];
            locationCell.lbDistance.text= [NSString stringWithFormat:@"%.1fkm",self.strShopDistance.floatValue];// modify by songjk
            [locationCell.btnCheckMap addTarget:self action:@selector(GoToBmkVc) forControlEvents:UIControlEventTouchUpInside];
            cell=locationCell;
        }
            break;
        case 1:
        {
            if (AllShopCell==nil) {
                AllShopCell=[[GYAllShopTableViewCell   alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allshopCell];
            }
            GYShopItem * shopItem = marrShopItem[indexPath.row];
            AllShopCell.lbDistance.text=[NSString stringWithFormat:@"%.1fkm",[shopItem.strDistance doubleValue]];

            UIFont * font = [UIFont systemFontOfSize:13];
            AllShopCell.lbDistance.font =font;
            CGFloat boder = 10;
            CGSize distanctSize = [Utils sizeForString:AllShopCell.lbDistance.text font:font width:200];
            AllShopCell.lbDistance.frame = CGRectMake(kScreenWidth - distanctSize.width - boder, AllShopCell.lbDistance.frame.origin.y, distanctSize.width, AllShopCell.lbDistance.frame.size.height);
            AllShopCell.imgDistance.frame = CGRectMake(AllShopCell.lbDistance.frame.origin.x - AllShopCell.imgDistance.frame.size.width-5, AllShopCell.imgDistance.frame.origin.y, AllShopCell.imgDistance.frame.size.width, AllShopCell.imgDistance.frame.size.height);
            
            AllShopCell.lbAddr.frame = CGRectMake(AllShopCell.lbAddr.frame.origin.x, AllShopCell.lbAddr.frame.origin.y, AllShopCell.imgDistance.frame.origin.x - AllShopCell.lbAddr.frame.origin.x, AllShopCell.lbAddr.frame.size.height);
            AllShopCell.lbAddr.text=[NSString stringWithFormat:@"%@",kSaftToNSString(shopItem.strAddr)];
            
            [AllShopCell.btnShopTel setTitle:[NSString stringWithFormat:@"%@",kSaftToNSString(shopItem.strTel)] forState:UIControlStateNormal];
            cell=AllShopCell;
            [AllShopCell.btnShopTel addTarget:self action:@selector(CallShop:) forControlEvents:UIControlEventTouchUpInside];
        }
            
            break;
        case 2:
        {
            
            GYGoodIntroductionModel * model = [[GYGoodIntroductionModel alloc] init];
            model.strData = shopInfo.strIntroduce;
            GYGoodIntroductionCell *goodInfoCell=[GYGoodIntroductionCell cellWithTableView:tableView];
            goodInfoCell.model = model;
            cell = goodInfoCell;
        }
            break;
        case 3:
        {
            starCell=[[[NSBundle mainBundle] loadNibNamed:@"GYStarTableViewCell" owner:self options:nil]lastObject];
            starCell.lbPoint.text=shopInfo.strRate;
            switch ([shopInfo.strRate intValue]) {
                case 0:
                {
                    starCell.btnStar1.selected=NO;
                    starCell.btnStar2.selected=NO;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                }
                    break;
                case 1:
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=NO;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                }
                    break;
                case 2:
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                }
                    break;
                case 3:
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                }
                    break;
                case 4:
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=YES;
                    starCell.btnStar5.selected=NO;
                }
                    break;
                case 5:
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=YES;
                    starCell.btnStar5.selected=YES;
                }
                    break;
                    
                default:
                    break;
            }
            starCell.lbEvaluatePerson.text=[NSString stringWithFormat:@"%@人评价",shopInfo.strEvacount];
            
            [starCell.contentView addTopBorder];
            cell=starCell;
            
            
        }
            break;
        case 4:
        {
            if (hotGoodCell==nil) {
                hotGoodCell=[[GYShopDetailHotGoodTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotGoodIdentiferInCell];
            }
            
            
            GYHotItemGoods * modelleft =marrHotGoods[indexPath.row*2];
            GYHotItemGoods * modelright =nil;
            if ((indexPath.row*2+1)>=marrHotGoods.count) {
                
            }
            else {
                
                modelright =marrHotGoods[indexPath.row*2+1];
                
            }
            
            cell=hotGoodCell;
            hotGoodCell.btnLeftCover.tag=  100+indexPath.row*2;
            hotGoodCell.btnRightCover.tag= 5000+indexPath.row*2+1;
            if (modelleft)
            {
                [hotGoodCell.btnLeftCover addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [hotGoodCell.btnLeftCover removeTarget:self action:@selector(coverBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
            }
            if (modelright)
            {
                [hotGoodCell.btnRightCover addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [hotGoodCell.btnRightCover removeTarget:self action:@selector(coverBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
            }
            
            [hotGoodCell refreshUIWithModel:modelleft WithSecondModel:modelright];
            
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section==1) {
           [cell.contentView addAllBorder];
    }

}

//coverbtn 监听方法
-(void)coverBtnClick:(UIButton *)sender
{
    
    
    GYHotItemGoods * mod = nil;
    
    if (sender.tag<5000) {
        
        mod = marrHotGoods[sender.tag-100];
        
    }else
    {
        
        mod =marrHotGoods[sender.tag-5000];
        
        
    }
    // modify by songjk
    //    GYEasyBuyModel * EasyBugMod = [[GYEasyBuyModel alloc]init];
    //    EasyBugMod.strGoodId=mod.strItemId;
    //
    //
    //    EasyBugMod.shopInfo=shopInfo;
    
    [self loadHotGoodInfoWithItemid:mod.strItemId vShopid:shopInfo.strVshopId withModel : (GYHotItemGoods * )mod];
    
    //    GYGoodsDetailController * vcGoodsDetail = [[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
    //    vcGoodsDetail.model=EasyBugMod;
    //    [self.navigationController pushViewController:vcGoodsDetail animated:YES];
    
    
}
// add by songjk
-(void)loadHotGoodInfoWithItemid:(NSString *)itemid vShopid:(NSString *)vShopid withModel:(GYHotItemGoods *)mod
{
    
     __block  SearchGoodModel * MOD;
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%@",shopInfo.strShopId] forKey:@"shopId"];
    [dict setValue:[NSString stringWithFormat:@"%@",itemid] forKey:@"itemId"];
    [dict setValue:[NSString stringWithFormat:@"%@",vShopid] forKey:@"vShopId"];
    [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在加载数据..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getGoodsInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error)
     {
         if (!error)
         {
             NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
             NSLog(@"-----------%@",ResponseDic);
             
             if (!error)
             {
                 
                 NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                 NSLog(@"*******************************************************************\n%@",ResponseDic[@"data"]);
                 
                 if ([retCode isEqualToString:@"200"])
                 {
                     NSDictionary * tempDic = ResponseDic[@"data"];
                      MOD =[[SearchGoodModel alloc]init];
                     MOD.name = kSaftToNSString(tempDic[@"itemName"]);
                     MOD.addr=kSaftToNSString(tempDic[@"addr"]);
                     MOD.beCash=kSaftToNSString(tempDic[@"beCash"]);
                     MOD.beReach=kSaftToNSString(tempDic[@"beReach"]);
                     MOD.beSell=kSaftToNSString(tempDic[@"beSell"]);
                     MOD.beTake=kSaftToNSString(tempDic[@"beTake"]);
                     MOD.beTicket=kSaftToNSString(tempDic[@"beTicket"]);
                     MOD.goodsId=kSaftToNSString(tempDic[@"id"]);
                     //                    MOD.shoplat=kSaftToNSString(tempDic[@"lat"]);
                     NSNumber *lat = tempDic[@"lat"];
                     MOD.shoplat = [NSString stringWithFormat:@"%f",[lat floatValue]];
                     //                    MOD.shoplongitude=kSaftToNSString(tempDic[@"longitude"]);
                     NSNumber *longitude = tempDic[@"longitude"];
                     MOD.shoplongitude = [NSString stringWithFormat:@"%f",[longitude floatValue]];
                     MOD.shopsName=kSaftToNSString(tempDic[@"name"]);
                     //                    MOD.price=kSaftToNSString(tempDic[@"price"]);
                     NSNumber *price = tempDic[@"price"];
                     MOD.price = [NSString stringWithFormat:@"%0.02f",[price floatValue]];
                     //                    MOD.goodsPv=kSaftToNSString(tempDic[@"pv"]);
                     NSNumber * pv = tempDic[@"pv"];
                     MOD.goodsPv = [NSString stringWithFormat:@"%.02f",[pv floatValue]];
                     MOD.shopId=kSaftToNSString(tempDic[@"shopId"]);
                     
                     MOD.moonthlySales = kSaftToNSString(tempDic[@"monthlySales"]);
                     MOD.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
                     if ([kSaftToNSString(tempDic[@"tel"]) length]>0) {
                           MOD.shopTel=kSaftToNSString(tempDic[@"tel"]);
                     }else
                     {
                     MOD.shopTel=@" ";
                     }
                  
                     
                     MOD.vShopId=kSaftToNSString(tempDic[@"vShopId"]);
                     MOD.shopSection=kSaftToNSString(tempDic[@"area"]);
                     
                     CLLocationCoordinate2D shopCoordinate;
                     shopCoordinate.latitude=MOD.shoplat.floatValue;
                     shopCoordinate.longitude=MOD.shoplongitude.floatValue;
                     BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                     mp1 = BMKMapPointForCoordinate([MMLocationManager shareLocation].lastCoordinate);
                     CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                     NSLog(@"%f-----dis,mp1.x = %f,mp1.y = %f",dis,mp1.x,mp1.y);
                     MOD.shopDistance=[NSString stringWithFormat:@"%.02f",dis/1000];
                     self.GoodModel = MOD;
                 }
             }
             
         }
         

         [Utils hideHudViewWithSuperView:self.navigationController.view];
         GYGoodDetailViewController * vcGoodDetail =[[GYGoodDetailViewController alloc]initWithNibName:@"GYGoodDetailViewController" bundle:nil];

         vcGoodDetail.model=MOD;
        
         self.hidesBottomBarWhenPushed=YES;
         [self.navigationController pushViewController:vcGoodDetail animated:YES];
     }];
}

-(void)CallShop:(UIButton *)sender
{

     NSString  *phoneNumber = sender.currentTitle;
    //传递号码，还有ActionSheet显示视图
    [Utils callPhoneWithPhoneNumber:phoneNumber showInView:self.view];
  
//    
////    ShopModel * model = marrEasyBuySource[sender.tag];
//   
//    JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
//    JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
//    NSArray *asss = @[ass0, ass1];
//    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
////    as.delegate = self;
//    
//    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
//        
//        switch (indexPath.section) {
//            case 0:
//            {
//                if (indexPath.row == 0)
//                {
//                    NSLog(@"呼叫号码");
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
//                }else if (indexPath.row == 1)
//                {
//                    NSLog(@"复制号码");
//                }
//            }
//                break;
//            case 1:
//            {
//                NSLog(@"取消");
//            }
//                break;
//                break;
//                
//            default:
//                break;
//        }
//        
//        [sheet dismissAnimated:YES];
//    }];
//    
//    [as setCenter:CGPointMake(100, 100)];
//    
//    [as showInView:self.view animated:YES];

    
    
    
}

//-(void)getLocation
//{
//    [Utils showMBProgressHud:self SuperView:self.view Msg:@"正在加载数据..."];
//    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate)
//     {
//         mp1= BMKMapPointForCoordinate(locationCorrrdinate);
//         [Utils hideHudViewWithSuperView:self.view];
//     } withError:^(NSError *error) {
//         CLLocationCoordinate2D currentLocation;
//         currentLocation.latitude=22.549225;
//         currentLocation.longitude=114.077427;
//         mp1= BMKMapPointForCoordinate(currentLocation);
//         [Utils hideHudViewWithSuperView:self.view];
//     } WithCity:^(NSString *countryString) {
//         [Utils hideHudViewWithSuperView:self.view];
//     }];
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 3:
        {
        }
            break;
        case 1:
        {
           GYShopItem * shopItem = marrShopItem[indexPath.row];
            GYBMKViewController * vcBMK =[[GYBMKViewController alloc]initWithNibName:@"GYBMKViewController" bundle:nil];
            vcBMK.hidesBottomBarWhenPushed=YES;
            vcBMK.strShopId=shopItem.strShopId;
            coordinate.latitude=[shopItem.strLat floatValue];
            coordinate.longitude=[shopItem.strLongitude floatValue];
            vcBMK.coordinateLocation=coordinate;
            [self.navigationController pushViewController:vcBMK animated:YES];
        }
            break;
        default:
            break;
    }
}


-(void)GoToBmkVc
{
    CLLocationCoordinate2D coordinateShop;
    coordinateShop.latitude=[shopInfo.strLat floatValue];
    coordinateShop.longitude=[shopInfo.strLongitude floatValue];
    GYBMKViewController * vcBMK =[[GYBMKViewController alloc]initWithNibName:@"GYBMKViewController" bundle:nil];
    vcBMK.hidesBottomBarWhenPushed=YES;
    vcBMK.strShopId=shopInfo.strShopId;
    vcBMK.coordinateLocation=coordinateShop;
    [self.navigationController pushViewController:vcBMK animated:YES];
}


-(void)btnClicked:(UIButton *)sender
{
    sender.selected=YES;
}

-(UIImageView *)imgvArrow
{
    if (_imgvArrow == nil) {
        _imgvArrow = [[UIImageView alloc] init];
        _imgvArrow.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-20, 15, 18, 10);
        _imgvArrow.userInteractionEnabled = NO;
        _imgvArrow.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _imgvArrow.contentMode = UIViewContentModeScaleAspectFit;
        _imgvArrow.image=[UIImage imageNamed:@"image_down_arrow.png"];
    }
    return  _imgvArrow;
}
-(UIImageView *)imgvArrow2
{
    if (_imgvArrow2 == nil) {
        _imgvArrow2 = [[UIImageView alloc] init];
        _imgvArrow2.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-20, 15, 18, 10);
        _imgvArrow2.userInteractionEnabled = NO;
        _imgvArrow2.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _imgvArrow2.contentMode = UIViewContentModeScaleAspectFit;
        _imgvArrow2.image=[UIImage imageNamed:@"image_down_arrow.png"];
    }
    return  _imgvArrow2;
}
-(UIView *)checkAllShop
{
    UIView * backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    UIButton * btnChechShop =[UIButton buttonWithType:UIButtonTypeCustom];
    btnChechShop.frame=CGRectMake(kDefaultMarginToBounds, 0, kScreenWidth, 43);
    btnChechShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btnChechShop.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [btnChechShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChechShop setTitle:kLocalized(@"ar_check_all_shop") forState:UIControlStateNormal];
    [btnChechShop addTarget:self action:@selector(btnCheck) forControlEvents:UIControlEventTouchUpInside];
    [btnChechShop setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [backGroundView addSubview:btnChechShop];
    [backGroundView addBottomBorder];
    
    
    self.imgvArrow.transform= self.rotationTransform;
    [backGroundView addSubview:self.imgvArrow];
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
    topBorder.frame = CGRectMake(backGroundView.frame.origin.x+16   , 0, CGRectGetWidth(backGroundView.frame)-32    , 1.0f);
    [backGroundView.layer addSublayer:topBorder];
    
    return backGroundView;
    
}


-(void)btnCheck
{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        rotationTransform=CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(180));
    //        imgvArrow.transform = rotationTransform;
    //    } completion:^(BOOL finished) {
    //        if (isShow) {
    //            rows=[dic allValues].count;
    //
    //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    //            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    //            isShow=!isShow;
    //        }else
    //        {
    //            rows=0;
    //
    //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    //            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    //            isShow=!isShow;
    //        }
    //    }];
    
    [tvShopDetail reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.rotationTransform=CGAffineTransformRotate(self.imgvArrow.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow.transform = self.rotationTransform;
    } completion:^(BOOL finished) {
        if (isShow) {
            rows=marrShopItem.count;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow=!isShow;
        }else
        {
            rows=0;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow=!isShow;
        }
    }];
}

-(UIView *)seeShopIntroduction
{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    v.backgroundColor=[UIColor whiteColor];
    UIButton * btnChechShop =[UIButton buttonWithType:UIButtonTypeCustom];
    btnChechShop.frame=CGRectMake(kDefaultMarginToBounds, 0, kScreenWidth, 43);
    btnChechShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    btnChechShop.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    btnChechShop.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [btnChechShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChechShop setTitle:@"商铺介绍" forState:UIControlStateNormal];
    [btnChechShop addTarget:self action:@selector(seeIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btnChechShop];
    [v addAllBorder];
    self.imgvArrow2.transform= self.rotationTransform2;
    [v addSubview:self.imgvArrow2];
    return  v;
    
}


-(void)seeIntroduction
{
    NSLog(@"查看简介");
    //一个section刷新
    [tvShopDetail reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.rotationTransform2=CGAffineTransformRotate(self.imgvArrow2.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow2.transform = self.rotationTransform2;
    } completion:^(BOOL finished) {
        if (isShowIntroduction) {
            rowsIntroduction=1;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShowIntroduction=!isShowIntroduction;
        }else
        {
            rowsIntroduction=0;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShowIntroduction=!isShowIntroduction;
        }
    }];
}


-(UIView *)hotGoodView
{
    UIView * vHotGood =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    vHotGood.backgroundColor=kDefaultVCBackgroundColor;
    UILabel * lbHotGood =[[UILabel alloc]initWithFrame:CGRectMake(kDefaultMarginToBounds, 0, 100, 25)];
    lbHotGood.text=kLocalized(@"ar_hot_good");
    lbHotGood.backgroundColor=[UIColor clearColor];
    lbHotGood.font=[UIFont systemFontOfSize:15.0f];
    lbHotGood.textColor=kCellItemTitleColor;
    [vHotGood addSubview:lbHotGood];
    [vHotGood addTopBorder];
    
    return vHotGood;
}


-(UIView *)blankView
{
    UIView * v =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.backgroundColor=kDefaultVCBackgroundColor;
    [v addTopBorder];
    return v;
    
}


-(void)concernShopRequest
{
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    
    //已经关注  就取消关注
//    [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在发送请求..."];
    if (isAttention) {
        [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在取消关注..."];
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        [dict setValue:[NSString stringWithFormat:@"%@",shopInfo.strVshopId] forKey:@"vShopId"];
        [dict setValue:shopInfo.strShopId forKey:@"shopId"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/cancelConcernShop" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
            [Utils hideHudViewWithSuperView:self.navigationController.view];
            if (!error)
            {
                NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (!error)
                {
                    NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"])
                    {
                        isAttention=!isAttention;
                        header.btnAttention.selected=NO;
                        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"取消关注商铺成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
                    }
                    else
                    {
                        [Utils showMessgeWithTitle:nil message:@"取消关注失败！" isPopVC:nil];
                    }
                }
            }
        }];
    }else{
        [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在关注..."];
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        
        [dict setValue:[NSString stringWithFormat:@"%@",shopInfo.strVshopId] forKey:@"vShopId"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [dict setValue:shopInfo.strShopId forKey:@"shopId"];
        [dict setValue:shopInfo.strVshopId forKey:@"vShopId"];
        [dict setValue:shopInfo.strShopName forKey:@"shopName"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/concernShop" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
            [Utils hideHudViewWithSuperView:self.navigationController.view];
            if (!error)
            {
                NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (!error)
                {
                    NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"])
                    {
                        isAttention=!isAttention;
                        header.btnAttention.selected=YES;
                        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"关注商铺成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
                    }else
                    {
                        [Utils showMessgeWithTitle:nil message:@"关注失败！" isPopVC:nil];
                    }
                }
            }
        }];
    }
}


//联系商家请求
-(void)contactShopRequest
{
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%@",shopInfo.strResourceNumber] forKey:@"resourceNo"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getVShopShortlyInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]&&[ResponseDic[@"data"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = ResponseDic[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GYChatViewController *vc = [[GYChatViewController alloc] init];
                        GYChatItem *chatItem = [[GYChatItem alloc] init];
                        chatItem.msgIcon = kSaftToNSString(dic[@"logo"]);
                        chatItem.vshopName = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.msgNote = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.resNo = shopInfo.strResourceNumber;
                        vc.chatItem = chatItem;
                        vc.chatItem.fromUserId = [NSString stringWithFormat:@"%@@%@",chatItem.resNo, [GlobalData shareInstance].hdDomain];
                        vc.chatItem.msgNote = vc.chatItem.vshopName;
                        vc.chatItem.content = @"";
                        vc.chatItem.msg_Type = 1;
                        vc.chatItem.msg_Code = 103;
                        vc.chatItem.sub_Msg_Code = 10301;
                        vc.msgType = 2;
                        vc.dicShopInfo = dic;
                        vc.chatItem.isSelf = YES;
                        vc.isFromShopDetails = YES;
                        vc.chatItem.vshopID = kSaftToNSString(dic[@"vShopId"]);
                        vc.navigationItem.title = chatItem.vshopName;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        [vc.chatItem updateNotReadWithKey:vc.chatItem WithTableType:2];
                    });
                }
            }
        }
    }];
}


#pragma mark selectcity 代理方法
-(void)getCity:(NSString *)CityTitle
{
    [btnRight setTitle:CityTitle forState:UIControlStateNormal];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (scrollView == header.srcView) {
        header.PageControl.currentPage = pageIndex;
        UIImageView * imageViewPic =[[UIImageView alloc]initWithFrame:CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [imageViewPic setBackgroundColor:[UIColor whiteColor]];
        [imageViewPic setContentMode:UIViewContentModeScaleAspectFit];
        [imageViewPic sd_setImageWithURL:[NSURL URLWithString:shopInfo.marrShopImages[pageIndex][@"url"]] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
        [scrollView addSubview:imageViewPic];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}



@end

//
//  GYShopAboutViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYShopAboutViewController.h"
#import "GYShopheaderViewController.h"
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

#import "GYMallBaseInfoModel.h"
#import "MJExtension.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
@interface GYShopAboutViewController ()
{
    UIImageView * imgvArrow;//箭头
    UIImageView * imgvArrow2;//箭头
    CGAffineTransform rotationTransform;
    CGAffineTransform rotationTransform2;
    
    NSInteger totalPage;
    SearchGoodModel * GoodModel;
    NSMutableArray *photos;
    NSInteger currentIndex;
    UITableView *diaosiTableview;
    GYShopInfoWithLocationCell * locationCell;
    GYStarTableViewCell * starCell;
    CLLocationCoordinate2D  coordinate;
    UIButton * btnRight;
    NSMutableArray * marrDatasorce;
    ShopModel * shopInfo;
    GYShopheaderViewController * header;
    NSMutableArray * marrShopItem;
    BOOL isShow;
    BOOL isShowIntroduction;
    NSInteger rows;//控制查看店铺的行数
    NSInteger rowsIntroduction;
    NSMutableArray * marrHotGoods;
    BOOL isAttention;
    NSInteger currentPage;//当前页码
    
    NSString *shareContent;///分享内容
    UIImageView *myImageview;
    NSString *strShopUrl;////商铺Url
}
//**店铺详细*/
@property (nonatomic,strong) GYMallBaseInfoModel * mallDetailInfo;
/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

@end

@implementation GYShopAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺简介";
    [self initView];
    
}

-(void)initView
{
    myImageview=[[UIImageView alloc]init];
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
     [self.panelView addSubview:self.loadingView];
    
    diaosiTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    diaosiTableview.dataSource=self;
    diaosiTableview.delegate=self;
    marrDatasorce =[NSMutableArray array];
    marrShopItem=[NSMutableArray array];
    marrHotGoods=[NSMutableArray array];
    CGRect rect = diaosiTableview.frame;
    shopInfo=[[ShopModel alloc]init];
    isShow=YES;
    isShowIntroduction=YES;
    currentPage=1;
    UIView * backgroundView =[[UIView alloc]initWithFrame:rect];
    backgroundView.backgroundColor=kDefaultVCBackgroundColor;
    diaosiTableview.backgroundView=backgroundView;
    diaosiTableview.delegate=self;
    diaosiTableview.dataSource=self;
    diaosiTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    btnRight =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"share_shop.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(sharebtnrating:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rig=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=rig;//////分享
    
    rotationTransform=CGAffineTransformRotate( imgvArrow.transform, DEGREES_TO_RADIANS(360));
    rotationTransform2=CGAffineTransformRotate( imgvArrow.transform, DEGREES_TO_RADIANS(360));
    
    [diaosiTableview registerNib:[UINib nibWithNibName:@"GYShopInfoWithLocationCell" bundle:nil] forCellReuseIdentifier:locationCellIdentifier];
    [diaosiTableview registerNib:[UINib nibWithNibName:@"GYShopDetailHotGoodTableViewCell" bundle:nil] forCellReuseIdentifier:hotGoodIdentifier];
    [diaosiTableview registerNib:[UINib nibWithNibName:@"GYAllShopTableViewCell" bundle:nil] forCellReuseIdentifier:allshopCell];
    [self.view addSubview:diaosiTableview];
    [self addHeadview];
    [self getCurrentLocation];
}
#pragma mark -

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}



#pragma mark 分享按钮
-(void)sharebtnrating:(UIButton *)sender
{
    //创建分享参数
    shareContent=[NSString stringWithFormat:@"%@%@%@",shopInfo.strShopName,strShopUrl,shopInfo.strIntroduce];
    NSURL *url;NSData *data=[[NSData alloc]init] ;UIImage *image=[[UIImage alloc]init];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (shopInfo.marrShopImages.count>0) {
       url=[NSURL URLWithString:shopInfo.marrShopImages[0]];
         data=[NSData dataWithContentsOfURL:url];
        image=[UIImage imageWithData:data];
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:image
                                            url:[NSURL URLWithString:@"http://www.hsxt.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
 
    }
    else{
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:nil
                                            url:[NSURL URLWithString:@"http://www.hsxt.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];

        
    }
         [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
//                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
}


-(void)getCurrentLocation
{
    // modify by songjk
    //    if (self.fromEasyBuy == 1)
    //    {
    //
    //        [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //            coordinate=locationCorrrdinate;
    //            _currentMp1=BMKMapPointForCoordinate(locationCorrrdinate);
    ////            [self loadShopDataRequest];
    //            [self httpRequestForShopInfo];
    //        } withError:^(NSError *error) {
    //
    //            coordinate.latitude=22.549225;
    //            coordinate.longitude=114.077427;
    //            _currentMp1=BMKMapPointForCoordinate(coordinate);
    ////            [self loadShopDataRequest];
    //            [self httpRequestForShopInfo];
    //        }];
    //    }
    //    else
    //    {
    _currentMp1 = BMKMapPointForCoordinate([MMLocationManager shareLocation].lastCoordinate);
    //        [self loadShopDataRequest];
    [self httpRequestForShopInfo];
    //    }
}

-(void)setBorderWithView:(UIButton*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    [view setTitleColor:color forState:UIControlStateNormal];
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}
#pragma mark 加载店铺信息
-(void)httpRequestForShopInfo
{
    [GYMallBaseInfoModel loadBigShopDataWithVshopid:self.strVshopId result:^(NSDictionary *dictData, NSError *error) {
        if (!dictData)
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"系统繁忙，请稍候再试" isPopVC:self.navigationController];
        }
        else
        {
            // modify by songjk 防止空数据 加上 kSaftToNSString
            NSDictionary * ResponseDic =dictData;
            shopInfo.strShopName=ResponseDic[@"vShopName"];
            strShopUrl=ResponseDic[@"vShopUrl"];
            //add by zhangqy 店名最长显示30字
//            if (shopInfo.strShopName.length>30) {
//                shopInfo.strShopName = [[shopInfo.strShopName substringToIndex:30] stringByAppendingString:@"..."];
//            }
            if (kSaftToNSString(ResponseDic[@"rate"]).length>0) {
                shopInfo.strRate=[NSString stringWithFormat:@"%.01f",[ResponseDic[@"rate"] floatValue]];
            }
            else
            {
                shopInfo.strRate= @"0.0";
            }
            
            
            if ([ResponseDic[@"introduce"] isKindOfClass:[NSNull class]]) {
                shopInfo.strIntroduce=@" ";
            }else
            {
                shopInfo.strIntroduce=ResponseDic[@"introduce"];
                
            }
            shopInfo.marrShopImages=ResponseDic[@"picList"];
            shopInfo.marrAllShop =ResponseDic[@"shops"];
            shopInfo.strVshopId = self.strVshopId;
            shopInfo.strResourceNumber =kSaftToNSString(ResponseDic[@"companyResourceNo"])   ;
           
            shopInfo.strStoreName = kSaftToNSString(ResponseDic[@"vShopName"]);// add by songjk;
            shopInfo.befocus=[ResponseDic[@"beFocus"] boolValue];
            
            if (shopInfo.befocus) {
                header.btnAttention.selected=YES;
                isAttention=YES;//已关注
            }  else {
                header.btnAttention.selected=NO;
                isAttention=NO;//没有关注
            }
            
            NSArray * arrShops = ResponseDic[@"shops"];
            for (int i = 0; i<arrShops.count; i++) {
                NSDictionary * temDict = arrShops[i];
                GYShopItem  * shopItem =[[GYShopItem alloc]init];
                shopItem.strShopId=kSaftToNSString(temDict[@"id"]) ;
                shopItem.strLat=kSaftToNSString(temDict[@"lat"]);
                shopItem.strLongitude=kSaftToNSString(temDict[@"longitude"]);
                shopItem.strTel=kSaftToNSString(temDict[@"tel"]);
                shopItem.strAddr=kSaftToNSString(temDict[@"addr"]);
                
                CLLocationCoordinate2D shopCoordinate;
                shopCoordinate.latitude=[kSaftToNSString(temDict[@"lat"]) floatValue];
                shopCoordinate.longitude=[kSaftToNSString(temDict[@"longitude"]) floatValue];
                BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
                shopItem.strDistance=[NSString stringWithFormat:@"%.2f",dis/1000];
                //                        NSLog(@"%f=========dis",dis);
                [marrShopItem addObject:shopItem];
                if (i == 0)
                {
                    NSString * strTel = shopItem.strTel;
                    if (strTel || strTel.length>0)
                    {
                        shopInfo.strShopTel=strTel;
                    }else
                    {
                        shopInfo.strShopTel=@" ";
                    }
                    shopInfo.strLongitude=shopItem.strLongitude;
                    shopInfo.strLat=shopItem.strLat;
                    shopInfo.strShopAddress=shopItem.strAddr;
                    shopInfo.strShopId=shopItem.strShopId;
                }
            }
            
            CLLocationCoordinate2D shopCoordinate;
            shopCoordinate.latitude=shopInfo.strLat.doubleValue;
            shopCoordinate.longitude=shopInfo.strLongitude.doubleValue;
            BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
            CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
            self.strShopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
            
            [header setShopInfo:shopInfo];
            diaosiTableview.tableHeaderView = header;
            [diaosiTableview reloadData];
        }
    }];
}
#pragma mark 加载数据的请求
//-(void)loadShopDataRequest
//{
//    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
//    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
//    [dict setValue:shopInfo.strVshopId forKey:@"shopId"];
//    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getShopInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
//
//        if (!error)
//        {
//            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
//
//            if (!error)
//            {
//
//                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
//
//                if ([retCode isEqualToString:@"200"])
//                {
//
//                    shopInfo.strShopId=kSaftToNSString(ResponseDic[@"id"]);
//                    shopInfo.strShopAddress=ResponseDic[@"addr"];
//                    shopInfo.strLongitude=ResponseDic[@"longitude"];
//                    shopInfo.strLat=ResponseDic[@"lat"];
//                    shopInfo.strShopName=ResponseDic[@"vShopName"];// modify by songjk
//
//                    shopInfo.strEvacount=kSaftToNSString(ResponseDic[@"evacount"]);
//
//                    if ([ResponseDic[@"city"] length]>0) {
//                        shopInfo.strCity= ResponseDic [@"data"] [@"city"] ;
//                    }else
//                    {
//                        shopInfo.strCity= @"" ;
//                    }
//
//                    if ([ResponseDic[@"area"] length]>0) {
//                        shopInfo.strArea= ResponseDic [@"data"] [@"area"] ;
//                    }else
//                    {
//                        shopInfo.strArea= @"" ;
//                    }
//
//                    if (kSaftToNSString(ResponseDic[@"rating"]).length>0) {
//                        shopInfo.strRate=[NSString stringWithFormat:@"%.01f",[ResponseDic[@"rating"] floatValue]];
//                    }
//
//
//                    if ([ResponseDic[@"introduce"] isKindOfClass:[NSNull class]]) {
//                        shopInfo.strIntroduce=@" ";
//                    }else
//                    {
//                        shopInfo.strIntroduce=ResponseDic[@"introduce"];
//
//                    }
//                    shopInfo.marrShopImages=ResponseDic[@"picList"];
//                    shopInfo.marrAllShop =ResponseDic[@"shops"];
//                    shopInfo.marrHotGoods = ResponseDic [@"data"][@"hotGoods"];
//                    shopInfo.strVshopId =kSaftToNSString(ResponseDic[@"vShopId"]);
//                    shopInfo.strResourceNumber =kSaftToNSString(ResponseDic[@"companyResourceNo"])   ;
//                    shopInfo.strStoreName = ResponseDic[@"name"];// add by songjk;
//
//                    shopInfo.isAttention=[ResponseDic [@"data"][@"bePre"] boolValue];
//                    shopInfo.befocus=[ResponseDic [@"data"][@"beFocus"] boolValue];
//
//                    if (shopInfo.befocus) {
//                        header.btnAttention.selected=YES;
//                        isAttention=YES;//已关注
//                    }  else {
//                        header.btnAttention.selected=NO;
//                        isAttention=NO;//没有关注
//                    }
//                    CLLocationCoordinate2D shopCoordinate;
//                    shopCoordinate.latitude=shopInfo.strLat.doubleValue;
//                    shopCoordinate.longitude=shopInfo.strLongitude.doubleValue;
//                    BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                    CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
//                    self.strShopDistance=[NSString stringWithFormat:@"%f",dis/1000];// modify by songjk
//                    //                    }
//
//                    NSString * strTel = kSaftToNSString(ResponseDic[@"hotline"]);
//                    if (strTel.length>0) {
//                        shopInfo.strShopTel=strTel;
//                    }else
//                    {
//                        shopInfo.strShopTel=@" ";
//                    }
//
//
//                    for (NSDictionary * temDict in ResponseDic[@"shops"]) {
//                        GYShopItem  * shopItem =[[GYShopItem alloc]init];
//                        shopItem.strShopId=kSaftToNSString(temDict[@"id"]) ;
//                        shopItem.strShopName=temDict[@"name"];
//                        shopItem.strLat=temDict[@"lat"];
//                        shopItem.strLongitude=temDict[@"longitude"];
//                        shopItem.strTel=temDict[@"tel"];
//                        shopItem.strAddr=temDict[@"addr"];
//
//                        CLLocationCoordinate2D shopCoordinate;
//                        shopCoordinate.latitude=[temDict[@"lat"] floatValue];
//                        shopCoordinate.longitude=[temDict[@"longitude"] floatValue];
//                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
//                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(_currentMp1 , mp2);
//                        shopItem.strDistance=[NSString stringWithFormat:@"%.2f",dis/1000];
//                        //                        NSLog(@"%f=========dis",dis);
//                        [marrShopItem addObject:shopItem];
//                    }
//
//                    for (NSDictionary * temDict in ResponseDic[@"hotGoods"]) {
//                        GYHotItemGoods * hotGoods =[[GYHotItemGoods alloc]init];
//                        hotGoods.strCategoryName=temDict[@"categoryName"];
//                        hotGoods.strCategoryId=kSaftToNSString(temDict[@"categoryId"]);
//                        hotGoods.strItemId=kSaftToNSString(temDict[@"itemId"]);
//                        hotGoods.strItemName=temDict[@"itemName"];
//                        hotGoods.strImgUrl=temDict[@"url"];
//                        hotGoods.strVshopId=kSaftToNSString(temDict[@"vShopId"]);
//
//                        [marrHotGoods addObject:hotGoods];
//
//                    }
//
//                }
//
//                [header setShopInfo:shopInfo];
//                diaosiTableview.tableHeaderView = header;
//                [diaosiTableview reloadData];
////                [self getHotGoods];
//                [self loadBigShopData];
//            }
//
//        }
//
//    }];
//
//}


#pragma mark 添加headerview
-(void)addHeadview
{
    header =[[GYShopheaderViewController alloc]initWithShopModel:CGRectMake(0, 0, kScreenWidth, 360) WithOwer:self];
    [header.btnAttention addTarget:self action:@selector(concernShopRequest) forControlEvents:UIControlEventTouchUpInside];
    [header.btnCollect addTarget:self action:@selector(contactShopRequest) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigPic)];
    [header.srcView addGestureRecognizer:tap];
    diaosiTableview.tableHeaderView=header;
}

-(void)showBigPic
{
    NSMutableArray *photos1 = [[NSMutableArray alloc] init];
    for (int i=0; i<shopInfo.marrShopImages.count; i++) {
        NSString *strUrl =kSaftToNSString(shopInfo.marrShopImages[i][@"url"]);
        [photos1 addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    enableGrid = NO;
    photos = photos1;
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
    [browser setCurrentPhotoIndex: currentIndex];
    
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browser animated:YES completion:nil ];
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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

-(void)CallShop:(UIButton *)sender
{
    NSString  *phoneNumber = sender.currentTitle;
    //传递号码，还有ActionSheet显示视图
    [Utils callPhoneWithPhoneNumber:phoneNumber showInView:self.view];
}

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
    if (imgvArrow == nil) {
        imgvArrow = [[UIImageView alloc] init];
        imgvArrow.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-20, 15, 18, 10);
        imgvArrow.userInteractionEnabled = NO;
        imgvArrow.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        imgvArrow.contentMode = UIViewContentModeScaleAspectFit;
        imgvArrow.image=[UIImage imageNamed:@"image_down_arrow.png"];
    }
    return  imgvArrow;
}
-(UIImageView *)imgvArrow2
{
    if (imgvArrow2 == nil) {
        imgvArrow2 = [[UIImageView alloc] init];
        imgvArrow2.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-20, 15, 18, 10);
        imgvArrow2.userInteractionEnabled = NO;
        imgvArrow2.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        imgvArrow2.contentMode = UIViewContentModeScaleAspectFit;
        imgvArrow2.image=[UIImage imageNamed:@"image_down_arrow.png"];
    }
    return  imgvArrow2;
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
    
    
    self.imgvArrow.transform=  rotationTransform;
    [backGroundView addSubview:self.imgvArrow];
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
    topBorder.frame = CGRectMake(backGroundView.frame.origin.x+16   , 0, CGRectGetWidth(backGroundView.frame)-32    , 1.0f);
    [backGroundView.layer addSublayer:topBorder];
    
    return backGroundView;
    
}


-(void)btnCheck
{
    [diaosiTableview reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform=CGAffineTransformRotate(self.imgvArrow.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if (isShow) {
            rows=marrShopItem.count;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow=!isShow;
        }else
        {
            rows=0;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
    self.imgvArrow2.transform=  rotationTransform2;
    [v addSubview:self.imgvArrow2];
    return  v;
    
}


-(void)seeIntroduction
{
    NSLog(@"查看简介");
    //一个section刷新
    [diaosiTableview reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform2=CGAffineTransformRotate(self.imgvArrow2.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow2.transform =  rotationTransform2;
    } completion:^(BOOL finished) {
        if (isShowIntroduction) {
            rowsIntroduction=1;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShowIntroduction=!isShowIntroduction;
        }else
        {
            rowsIntroduction=0;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
        //add by zhangqy 店名最长显示30字
//        NSString *tempStrShopName = @"";
//        if (shopInfo.strShopName.length>30) {
//            tempStrShopName = [[shopInfo.strShopName substringToIndex:30] stringByAppendingString:@"..."];
//        }
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
                if ([retCode isEqualToString:@"200"]&&[ResponseDic isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = ResponseDic;
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
    currentIndex = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}



@end

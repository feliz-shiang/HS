//
//  GYShopDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGoodDetailViewController.h"
#import "GYGoodDetailHeaderView.h"
#import "UIView+CustomBorder.h"
#import "UIImageView+WebCache.h"
//地址的cell
#import "GYShopLocationTableViewCell.h"
//商品详情
#import "GYGoodDetailListTableViewCell.h"
#import  "GlobalData.h"
#import "GYSurrondGoodsDetailModel.h"
//星星的cell
#import "GYStarTableViewCell.h"

#import "GYSelCell.h"
#import "GYSelModel.h"
#import "GYSetNumCell.h"

#import "GYSelBtn.h"
#import "GYGoodsDetailModel.h"
#import "GYPayoffViewController.h"

#import "GYBMKViewController.h"
#define hotGoodIdentifier @"hotGood"
#define locationCellIdentifier @"locationCell"
#import "GYChatItem.h"
#import "GYChatViewController.h"
#define smailImageViewWidth 20
#define smailImageViewHeight 20
#define midleLabelWidth 90
#define sepraterSpace 10
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#import "GYMainEvaluateDetailViewController.h"
#import "GYShopDetailHeaderView.h"

#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"
#import "GYCartViewController.h"
#import "GYShopDetailViewController.h"
#import "GYPicDtVC.h"
#import "GYGoodsDetailModel.h"
//#import "GYPhoneScr.h"
#import "GYGoodsParameterViewController.h"
#import "MWPhotoBrowser.h"
#import "GYStoreDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
@interface GYGoodDetailViewController ()<GYSetNumCellDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate>
@property (nonatomic,assign) CGFloat fHeight;
@property(nonatomic,strong) NSMutableArray *photos;
@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic,strong) UIWebView * wvDetail;
@property (nonatomic,assign) CGFloat tableSCHeight;
@property (nonatomic,assign) BOOL bloadDetail;
@end

@implementation GYGoodDetailViewController
{
    
    __weak IBOutlet UITableView *tvShopDetail; //商品详情的TV
    
    GYShopLocationTableViewCell * locationCell;//此cell不用复用，直接用全局变量
    
    GYStarTableViewCell * starCell;//此cell不用复用，直接用全局变量
    
    NSArray * arrTitle;//中间view 的label的 title
    
    //假数据
    NSArray * arrDetailInfo ;
    
    NSDictionary * dic;
    
    NSInteger rows;
    
    BOOL isShow;//控制section 是否展开
    
    UIImageView * imgvArrow;//多个方法调用的箭头
    
    
    CGAffineTransform rotationTransform;
    
    GYSurrondGoodsDetailModel * GoodsDetailMod;
    
    UIView * touchView;
    
    
    UIView * vSel;
    
    CGRect frame;
    
    CGRect frameSel;
    
    UIView * vButton;
    
    GYGoodDetailHeaderView * header;
    
    __weak IBOutlet UIView *vPopView;
    
    CGFloat tbvSelHeight;
    
    NSMutableArray *mArrBtnView;//btnView
    
    NSMutableArray *mArrBtn;//按钮数组
    
    NSString *strRetShopName;//返回店名
    
    NSString *strRetParameter;//返回参数项目名字
    
    NSString *strRetParameterVl;//返回参数项目名字
    
    NSMutableArray *mArrjson;//选择按钮的数组
    
    GYGoodsDetailModel *detailmodel;
    UIButton * btnRight;
    __weak IBOutlet UITableView *tvSkuView;
    
    __weak IBOutlet UILabel *lbTitle;
    
    BOOL isAttention;
    
    BMKMapPoint mp;
    
    NSString * strPictureUrl;
    
    BOOL isShowSkuView;
    NSString *shareContent;///分享内容
    __weak IBOutlet UIImageView *imgGoodsPic;
    
    __weak IBOutlet UILabel *lbGoodsName;
    NSString *shareitemUrl;////分享商品链接
    NSString *sharegoods;////分享商品详情
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=kLocalized(@"ar_good_detail");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect rect = tvShopDetail.frame;
    rows=0;
    isShow=YES;
    strRetParameterVl = @"";
    CGRect  popRect =vPopView.frame;
    popRect.origin.y=kScreenHeight;
    vPopView.frame=popRect;
    
    
    mArrjson = [[NSMutableArray alloc] init];
    mArrBtnView = [[NSMutableArray alloc] init];
    mArrBtn = [[NSMutableArray alloc] init];
    
    imgvArrow =[[UIImageView alloc]init];
    
    detailmodel = [[GYGoodsDetailModel alloc] init];
    
    rotationTransform=CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(360));
    
    lbTitle.textColor=kCellItemTitleColor;
    
    UIView * backgroundView =[[UIView alloc]initWithFrame:rect];
    backgroundView.backgroundColor=kDefaultVCBackgroundColor;
    tvShopDetail.backgroundView=backgroundView;
    tvShopDetail.delegate=self;
    tvShopDetail.dataSource=self;
    tvShopDetail.decelerationRate = 0.05;
    arrTitle=[NSArray arrayWithObjects:kLocalized(@"ar_delivery_in_time"),kLocalized(@"ar_delivery_home"),kLocalized(@"ar_cash_on_delivery"),kLocalized(@"ar_get_by_yourself"), kLocalized(@"ar_send_ticket_good"),nil];
    
    [tvSkuView registerNib:[UINib nibWithNibName:@"GYSelCell" bundle:nil] forCellReuseIdentifier:@"CELLSEL"];
    [tvSkuView registerNib:[UINib nibWithNibName:@"GYSetNumCell" bundle:nil] forCellReuseIdentifier:@"CELLNUM"];
    
    [self setTheButton];
    [tvShopDetail registerNib:[UINib nibWithNibName:@"GYShopLocationTableViewCell" bundle:nil] forCellReuseIdentifier:locationCellIdentifier];
    [tvShopDetail registerNib:[UINib nibWithNibName:@"GYGoodDetailListTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodCell"];
    [self removeGoodDetail];
    tvSkuView.tableFooterView=[[UILabel alloc] init];
    
    header =[[GYGoodDetailHeaderView alloc]initWithShopModel:_model WithFrame:CGRectMake(0, 0, 320, 390) WithOwer:self];
    [header.btnAttention addTarget:self action:@selector(addToCollectionRequest) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigPic)];
    [header.mainScrollView addGestureRecognizer:tap];
    self.btnEnterShop.titleLabel.font=[UIFont systemFontOfSize:10.0];
    [self.btnEnterShop setImage:[UIImage imageNamed:@"image_enter_shop.png"] forState:UIControlStateNormal];
    
    
    self.btnEnterShop.imageEdgeInsets=UIEdgeInsetsMake(0, 19, 18, 19);
    self.btnEnterShop.titleEdgeInsets=UIEdgeInsetsMake(21, -self.btnEnterShop.frame.size.width-10, 0, 0);// 调整按钮文字位置
   
    self.btnEnterShopPro.imageEdgeInsets=UIEdgeInsetsMake(0, 19, 18, 19);
    self.btnEnterShopPro.titleLabel.font=[UIFont systemFontOfSize:10.0];
    [self.btnEnterShopPro setImage:[UIImage imageNamed:@"image_enter_shop.png"] forState:UIControlStateNormal];
    self.btnEnterShopPro.titleEdgeInsets=UIEdgeInsetsMake(21, -self.btnEnterShopPro.frame.size.width+19, 0, 0);
    
    [self.btnContactShop setImage:[UIImage imageNamed:@"image_contact_shop.png"] forState:UIControlStateNormal];
    self.btnContactShop.imageEdgeInsets=UIEdgeInsetsMake(0, 22, 18, 22);
    self.btnContactShop.titleLabel.font=[UIFont systemFontOfSize:10.0];
      self.btnContactShop.titleEdgeInsets= UIEdgeInsetsMake(19, -self.btnContactShop.frame.size.width+18, 0, 0);
     [self.btnContactShopPop setImage:[UIImage imageNamed:@"image_contact_shop.png"] forState:UIControlStateNormal];
    self.btnContactShopPop.imageEdgeInsets=UIEdgeInsetsMake(0, 22, 18, 22);
    self.btnContactShopPop.titleLabel.font=[UIFont systemFontOfSize:12.0];
    self.btnContactShopPop.titleEdgeInsets= UIEdgeInsetsMake(19, -self.btnContactShopPop.frame.size.width+17, 0, 0);
    
    
    tvShopDetail.tableHeaderView=header;
    tvShopDetail.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    // modify by songjk

    //临时设置
    vButton.frame = CGRectMake(0, kScreenHeight - 44, vButton.frame.size.width, vButton.frame.size.height);
    [self.tabBarController.view.window addSubview:vButton];
    touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    touchView.backgroundColor = [UIColor blackColor];
    touchView.alpha = 0.5;
    tvSkuView.delegate=self;
    tvSkuView.dataSource=self;
    frame = CGRectMake(vButton.frame.origin.x, vButton.frame.origin.y, vButton.frame.size.width, vButton.frame.size.height);
    
    UIImage* image= kLoadPng(@"ep_img_nav_cart");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.rightBarButtonItem = btnSetting;
    
    
    
    btnRight =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"share_shop.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(sharebtnrating:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rig=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItems=@[btnSetting,rig];//////分享

    [self loadDataFromNetwork];
}


#pragma mark 分享按钮
-(void)sharebtnrating:(UIButton *)sender
{
    //创建分享参数
    shareContent=[NSString stringWithFormat:@"%@%@%@",GoodsDetailMod.itemName,shareitemUrl,sharegoods];
    UIImage *iamge=[[UIImage alloc ]init];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (GoodsDetailMod.shopUrl.count>0) {
        NSURL *url=[NSURL URLWithString:GoodsDetailMod.shopUrl[0][@"url"]];
        NSData *data=[NSData dataWithContentsOfURL:url];
         iamge=[UIImage imageWithData:data];
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:@[iamge]
                                            url:[NSURL URLWithString:@"http://www.hsxt.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];

    }else{
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:kNavigationBarColor];
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        [[UINavigationBar appearance]setTintColor:[UIColor redColor]];
    }else
    {
        //        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
        self.navigationController.navigationBar.barTintColor =[UIColor redColor];
        //        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    
    //隐藏 navigationController
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO   animated:YES];

}

-(void)showBigPic
{
   
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i=0; i<GoodsDetailMod.shopUrl.count; i++) {
        NSString *strUrl =kSaftToNSString(GoodsDetailMod.shopUrl[i][@"url"]);
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


- (IBAction)enterShop:(id)sender {
    // 测试新界面
//    GYShopDetailViewController * vcShopDetail = [[GYShopDetailViewController alloc]initWithNibName:@"GYShopDetailViewController" bundle:nil];
//    vcShopDetail.ShopID=self.model.shopId ;
//    vcShopDetail.fromEasyBuy=0;
//    // add by songjk
//    CLLocationCoordinate2D shopCoordinate;
//    shopCoordinate.latitude=_model.shoplat.doubleValue;
//    shopCoordinate.longitude=_model.shoplongitude.doubleValue;
//    mp = BMKMapPointForCoordinate(shopCoordinate);
//    vcShopDetail->mp1 = mp;
//    [self.navigationController pushViewController:vcShopDetail animated:YES];
    
    GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
    CLLocationCoordinate2D shopCoordinate;
    shopCoordinate.latitude=_model.shoplat.doubleValue;
    shopCoordinate.longitude=_model.shoplongitude.doubleValue;
    mp = BMKMapPointForCoordinate(shopCoordinate);
    vc.currentMp1 = mp;
    ShopModel  * model = [[ShopModel alloc] init];
    model.strVshopId = self.model.vShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



//进入购物车
- (void)pushCartVc:(id)sender
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
}

#pragma mark - pushVC

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}


-(void)setTheButton
{
    //设置按钮
    [self.vBottomView addAllBorder];
    [self.vBottomViewPop addAllBorder];
    [self.btnBrowse setTitle:kLocalized(@"buy_now") forState:UIControlStateNormal];
    [self.btnContactShop setTitle:kLocalized(@"ar_contact_shop") forState:UIControlStateNormal];
    [self.btnAddToShopCar setTitle:kLocalized(@"add_into_shopcar") forState:UIControlStateNormal];
    [self.btnBrowsePop setTitle:kLocalized(@"buy_now") forState:UIControlStateNormal];
    [self.btnContactShopPop setTitle:kLocalized(@"ar_contact_shop") forState:UIControlStateNormal];
    [self.btnAddToShopCarPop setTitle:kLocalized(@"add_into_shopcar") forState:UIControlStateNormal];
    
    [self setBorderWithView:self.btnContactShop WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    [self setBorderWithView:self.btnBrowse WithWidth:1 WithRadius:0 WithColor:kNavigationBarColor WithBackgroundColor:kNavigationBarColor WithTitleColor:nil];
    [self setBorderWithView:self.btnAddToShopCar WithWidth:1 WithRadius:3.0 WithColor:[UIColor orangeColor] WithBackgroundColor:[UIColor orangeColor] WithTitleColor:nil];
    [self setBorderWithView:self.btnContactShopPop WithWidth:1 WithRadius:3.0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    [self setBorderWithView:self.btnBrowsePop WithWidth:1 WithRadius:3.0 WithColor:kNavigationBarColor WithBackgroundColor:kNavigationBarColor WithTitleColor:nil];
    [self setBorderWithView:self.btnAddToShopCarPop WithWidth:1 WithRadius:3.0 WithColor:[UIColor orangeColor] WithBackgroundColor:[UIColor orangeColor] WithTitleColor:nil];
    [self setBorderWithView:self.btnEnterShop WithWidth:0 WithRadius:0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    [self.btnAddToShopCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBrowse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAddToShopCarPop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBrowsePop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


-(void)addToCollectionRequest
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
//    [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在发送请求..."];
    if (isAttention) {
        [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在取消收藏..."];
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
        [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [Network HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/cancelCollectionGoods"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
            [Utils hideHudViewWithSuperView:self.navigationController.view];
            if (!error) {
                NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (!error) {
                    NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"])
                    {
                        isAttention=!isAttention;
                        header.btnAttention.selected=NO;
                        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"取消收藏！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
                    }
                }
            }
        }];
    }else
    {
        [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在收藏..."];
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
        [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
        [dict setValue:GoodsDetailMod.serviceResourceNo forKey:@"serviceResourceNo"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/collectionGoods"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
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
                        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
                    }
                }
            }
        }];
    }
}

-(void)enterVshop
{
    GYShopDetailViewController * vcShopDetail = [[GYShopDetailViewController alloc]initWithNibName:@"GYShopDetailViewController" bundle:nil];
    vcShopDetail.ShopID=self.model.shopId ;
    vcShopDetail.fromEasyBuy=1;
    // add by songjk
    CLLocationCoordinate2D shopCoordinate;
    shopCoordinate.latitude=_model.shoplat.doubleValue;
    shopCoordinate.longitude=_model.shoplongitude.doubleValue;
    mp = BMKMapPointForCoordinate(shopCoordinate);
    vcShopDetail->mp1 = mp;
    [self.navigationController pushViewController:vcShopDetail animated:YES];
}


-(void)addToShareRequest
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
    [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    [dict setValue:GoodsDetailMod.serviceResourceNo forKey:@"serviceResourceNo"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/collectionGoods"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
    if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"])
                {
                    header.btnAttention.selected=YES;
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
            }
        }
    }];
}


-(void)contactShopRequest
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:GoodsDetailMod.companyResourceNo forKey:@"resourceNo"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getVShopShortlyInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"]&&[ResponseDic[@"data"] isKindOfClass:[NSDictionary class]])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            GYChatViewController *vc = [[GYChatViewController alloc] init];
                            GYChatItem *chatItem = [[GYChatItem alloc] init];
                            chatItem.msgIcon = kSaftToNSString(ResponseDic[@"data"][@"logo"]);
                            chatItem.vshopName = kSaftToNSString(ResponseDic[@"data"][@"vShopName"]);
                            chatItem.msgNote = kSaftToNSString(ResponseDic[@"data"][@"vShopName"]);
                            chatItem.resNo = GoodsDetailMod.companyResourceNo;
                            vc.chatItem = chatItem;
                            vc.chatItem.fromUserId = [NSString stringWithFormat:@"%@@%@",chatItem.resNo, [GlobalData shareInstance].hdDomain];
                            vc.chatItem.msgNote = vc.chatItem.vshopName;
                            vc.chatItem.content = @"";
                            vc.chatItem.msg_Type = 1;
                            vc.chatItem.msg_Code = 103;
                            vc.chatItem.sub_Msg_Code = 10301;
                            vc.msgType = 2;
                            vc.dicShopInfo = ResponseDic[@"data"];
                            vc.chatItem.isSelf = YES;
                            vc.chatItem.vshopID = kSaftToNSString(ResponseDic[@"data"][@"vShopId"]);
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


-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:_model.goodsId forKey:@"itemId"];
    [dict setValue:self.model.vShopId  forKey:@"vShopId"];
    [dict setValue:self.model.shopId  forKey:@"shopId"];
    [dict setValue:@"1213"  forKey:@"key"];
    NSLog(@"%@",dict);
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getGoodsInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        // add by songjk
        if (error) {
            [Utils showMessgeWithTitle:@"提示" message:@"系统繁忙，请稍候再试" isPopVC:self.navigationController];
        }
        if (!error)
        {
            NSDictionary * responseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * str =[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"])
                {
                    GoodsDetailMod = [[GYSurrondGoodsDetailModel alloc]init];
                                   GoodsDetailMod.addr=responseDict[@"data"][@"addr"];
                    GoodsDetailMod.shopId= kSaftToNSString(responseDict[@"data"] [@"shopId"]);//kSaftToNSString([responseDict[@"data"][@"shopId"]);
                    GoodsDetailMod.beCash=kSaftToNSString(responseDict [@"data"][@"beCash"]);
//                    kSaftToNSString(responseDict [@"data"][@"beTicket"])
                    GoodsDetailMod.beReach= kSaftToNSString(responseDict [@"data"][@"beReach"]);
                    GoodsDetailMod.beSell=kSaftToNSString(responseDict [@"data"][@"beSell"]);
                    GoodsDetailMod.beTake= kSaftToNSString(responseDict [@"data"][@"beTake"]);
                    GoodsDetailMod.beTicket=kSaftToNSString(responseDict [@"data"][@"beTicket"]);
                    GoodsDetailMod.companyResourceNo=responseDict [@"data"][@"companyResourceNo"];
                    GoodsDetailMod.evacount=responseDict[@"data"] [@"evacount"];
                    GoodsDetailMod.goodsId= kSaftToNSString(responseDict[@"data"] [@"id"]);
    
                    if (responseDict [@"data"][@"introduces"] == nil || [responseDict [@"data"][@"introduces"] isKindOfClass:[NSNull class]])
                    {
                        GoodsDetailMod.itemName = @"";
                    }
                    else
                    {
                        GoodsDetailMod.introduces=responseDict [@"data"][@"introduces"];
                    }
                    GoodsDetailMod.itemName=responseDict [@"data"][@"itemName"];//商品名称
                    GoodsDetailMod.goodsPv=responseDict[@"data"][@"pv"];
                    GoodsDetailMod.lat=responseDict[@"data"] [@"lat"];
                    GoodsDetailMod.longitude=responseDict[@"data"] [@"longitude"];
                    GoodsDetailMod.picDetails=responseDict[@"data"] [@"picDetails"];
                    GoodsDetailMod.beFocus= [responseDict [@"data"] [@"beFocus"] boolValue];
                    // add by songjk
                    GoodsDetailMod.isApplyCard = [NSString stringWithFormat:@"%@",responseDict [@"data"] [@"isApplyCard"]];
                    GoodsDetailMod.postageMsg = responseDict[@"data"][@"postageMsg"];
                    GoodsDetailMod.postage = [NSString stringWithFormat:@"%@",responseDict [@"data"] [@"postage"]];
                                                                 
                    if (responseDict[@"data"][@"city"] && [responseDict[@"data"][@"city"] length]>0) {
                         GoodsDetailMod.city= responseDict [@"data"] [@"city"] ;
                    }else
                    {
                    GoodsDetailMod.city= @"" ;
                    }
                    if (responseDict[@"data"][@"area"] && [responseDict[@"data"][@"area"] length]>0) {
                        GoodsDetailMod.area= responseDict [@"data"] [@"area"] ;
                    }else
                    {
                        GoodsDetailMod.area= @"" ;
                    }
                    if (GoodsDetailMod.beFocus) {
                        header.btnAttention.selected=YES;
                        isAttention=YES;//已关注
                    }  else {
                        header.btnAttention.selected=NO;
                        isAttention=NO;//没有关注
                    }
                    shareitemUrl=responseDict[@"data"][@"itemUrl"];
                    sharegoods=responseDict[@"data"][@"introduces"];
                    GoodsDetailMod.shopName=responseDict[@"data"] [@"shopName"];//商铺名称
                    GoodsDetailMod.price=kSaftToNSString(responseDict [@"data"][@"price"]);
                    GoodsDetailMod.rating=responseDict [@"data"][@"rating"];
                    GoodsDetailMod.serviceResourceNo=responseDict[@"data"] [@"serviceResourceNo"];
                    GoodsDetailMod.shopId=kSaftToNSString(responseDict[@"data"] [@"shopId"]);
                    GoodsDetailMod.shopName=responseDict [@"data"][@"shopName"];
                    if (responseDict[@"data"] [@"tel"] == nil || [responseDict[@"data"] [@"tel"] isKindOfClass:[NSNull class]])
                    {
                        GoodsDetailMod.itemName = @"";
                    }
                    else
                    {
                        GoodsDetailMod.shopTel=responseDict[@"data"] [@"tel"];
                    }
                    GoodsDetailMod.propList=responseDict[@"data"][@"propList"];//产品的SKU数组
                    GoodsDetailMod.shopUrl=responseDict[@"data"] [@"picList"];//图片数组
                    GoodsDetailMod.vShopId=kSaftToNSString(responseDict[@"data"] [@"vShopId"]);
                    GoodsDetailMod.vShopName=responseDict [@"data"][@"vShopName"];
                    GoodsDetailMod.monthlySales =responseDict [@"data"][@"monthlySales"];// add by songjk
                                  //组建jeson字符串
                    GoodsDetailMod.saleCount = kSaftToNSString(responseDict [@"data"][@"salesCount"]);// add by songjk
                       detailmodel.goodsNum = @"1";
                    detailmodel.title = responseDict[@"data"][@"itemName"];
                    detailmodel.categoryId = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"categoryId"]];
#warning 修改标记 删除stringvalue
                    detailmodel.goodsID=responseDict[@"data"] [@"id"];
                    detailmodel.pv = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"pv"]];
                    detailmodel.strPrice=[NSString stringWithFormat:@"%@",responseDict [@"data"][@"price"]];
                     detailmodel.vShopId=[NSString stringWithFormat:@"%@",responseDict [@"data"][@"vShopId"]];
                     detailmodel.serviceResourceNo=[NSString stringWithFormat:@"%@",responseDict [@"data"][@"serviceResourceNo"]];
                    detailmodel.companyResourceNo=[NSString stringWithFormat:@"%@",responseDict [@"data"][@"companyResourceNo"]];
                    // add by songjk
                    detailmodel.strRuleID = [NSString stringWithFormat:@"%@",responseDict [@"data"][@"ruleId"]];
                    detailmodel.isApplyCard = [NSString stringWithFormat:@"%@",responseDict [@"data"][@"isApplyCard"]];
                    detailmodel.postageMsg = responseDict[@"data"][@"postageMsg"];
                    detailmodel.postage = [NSString stringWithFormat:@"%@",responseDict [@"data"] [@"postage"]];

                    for (NSDictionary *dicTemp in responseDict[@"data"][@"propList"])
                    {
                        ArrModel *arrModel = [[ArrModel alloc] init];
                        arrModel.propId = [NSString stringWithFormat:@"%@",dicTemp[@"id"]];
                        arrModel.propName = [NSString stringWithFormat:@"%@",dicTemp[@"name"]];

                        for (NSDictionary *dic1 in dicTemp[@"subs"]) {
                            ArrSubsModel *subsModel = [[ArrSubsModel alloc] init];
                            subsModel.vid = [NSString stringWithFormat:@"%@",dic1[@"vid"]];
                            subsModel.vName = [NSString stringWithFormat:@"%@",dic1[@"vname"]];
                            [arrModel.arrSubs addObject:subsModel];
                        }
                        [detailmodel.arrPropList addObject:arrModel];
                    }
                    
                    // add by songjk
                    //获取参数数据
                    for (NSDictionary *dictBase in responseDict[@"data"][@"basicParameter"]) {
                        ArrModel *arrModel = [[ArrModel alloc] init];
                        arrModel.key = [NSString stringWithFormat:@"%@",dictBase[@"key"]];
                        arrModel.value = [NSString stringWithFormat:@"%@",dictBase[@"value"]];
                        [detailmodel.arrBasicParameter addObject:arrModel];
                    }
                    GYEasyBuyModel * model = [[GYEasyBuyModel alloc]init];
                    if (GoodsDetailMod.shopUrl.count>0) {
                       model.strGoodPictureURL=GoodsDetailMod.shopUrl[0][@"url"];
                    }else
                    {
                       model.strGoodPictureURL = @" ";
                    }
                    model.strGoodName=GoodsDetailMod.itemName;
                    model.strGoodPrice=GoodsDetailMod.price;
                    model.strGoodId = detailmodel.goodsID;
                    ShopModel * shopModel = [[ShopModel alloc]init];
                    shopModel.strShopId = GoodsDetailMod.shopId;
                    model.shopInfo=shopModel;
                    model.numBroweTime = @([[NSDate date] timeIntervalSince1970]);//用于显示排序
                    [self saveBrowsingHistory:model];
                    [self setBtn];
                    [self getTbvHeight];
                    [header setInfoForHeaderView:GoodsDetailMod];
                    [tvShopDetail reloadData];
                    [tvSkuView reloadData];
                    [self setTopView];
                    
                }
                else if ([str isEqualToString:@"507"]) // add by songjk判读商品下架
                {
                    [Utils showMessgeWithTitle:@"提示" message:@"该商品已下架" isPopVC:self.navigationController];
                }
                else
                {
                    [Utils showMessgeWithTitle:@"提示" message:@"系统繁忙，请稍候再试" isPopVC:self.navigationController];
                }
            }
            else
            {
                [Utils showMessgeWithTitle:@"提示" message:@"系统繁忙，请稍候再试" isPopVC:self.navigationController];
            }
        }
        
    }
     ];
    
}


//保存浏览历史记录
- (void)saveBrowsingHistory:(GYEasyBuyModel *)model
{
//    model.numBroweTime = @([[NSDate date] timeIntervalSince1970]);//用于显示排序
    NSString *key = kKeyForBrowsingHistory;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (!(model.strGoodPictureURL.length>0||model.strGoodName.length>0||model.strGoodPrice.length>0||model.strGoodId.length>0||model.shopInfo.strShopId.length>0)) {
        return;
    }
    NSDictionary *dicGoods = @{@"goodsPictureUrl":model.strGoodPictureURL,
                               @"goodsName":model.strGoodName,
                               @"goodsPrice":model.strGoodPrice,
                               @"goodsId":model.strGoodId,
                               @"shopId":self.model.vShopId,
                               @"numBroweTime":model.numBroweTime
                               };
    [dicBrowsing setObject:dicGoods forKey:model.strGoodId];
    
    //保存
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
}



-(void)setBtn
{
    NSInteger z = 1;
    for (ArrModel *arrModel in detailmodel.arrPropList) {
        CGFloat x = 0;
        CGFloat y = 0;
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 200)];
        
        NSInteger s = 0;
        for (ArrSubsModel *subsModel in arrModel.arrSubs) {
            GYSelBtn *btn = [GYSelBtn buttonWithType:UIButtonTypeCustom];
           
            btn.dic = [[NSMutableDictionary alloc] init];
            
            btn.frame = CGRectMake(15 + x, 10 + y, 21 + subsModel.vName.length * 10, 21);
            
            if (x != 0 && btn.frame.origin.x + btn.frame.size.width > [UIScreen mainScreen].bounds.size.width) {
                x = 0;
                y = btn.frame.origin.y + btn.frame.size.height;
                btn.frame = CGRectMake(15 + x, 10 + y, 21 + subsModel.vName.length * 10, 21);
            }
            x = btn.frame.origin.x + btn.frame.size.width;
            [btn setTitle:subsModel.vName forState:UIControlStateNormal];
            [btn setTitle:subsModel.vName forState:UIControlStateHighlighted];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = z * 10000 + s;
            s++;
            
            btn.row = z -1;
            [btn.dic setValue:arrModel.propId forKey:@"pId"];
            [btn.dic setValue:arrModel.propName forKey:@"pName"];
            [btn.dic setValue:subsModel.vid forKey:@"pVId"];
            [btn.dic setValue:subsModel.vName forKey:@"pVName"];
            [mArrBtn addObject:btn];
            btnView.frame = CGRectMake(0, 34, [UIScreen mainScreen].bounds.size.width, btn.frame.origin.y + btn.frame.size.height);
            [btnView addSubview:btn];
            
            if (btn.row == mArrjson.count) {
                [mArrjson addObject:btn];
            }
        }
        z++;
        [mArrBtnView addObject:btnView];
    }
}


-(void)setTopView
{
    lbGoodsName.text = GoodsDetailMod.itemName;
    lbGoodsName.textColor = kCellItemTitleColor;
    lbTitle.textColor = kNavigationBarColor;
    lbTitle.text = [NSString stringWithFormat:@"%.2f",GoodsDetailMod.price.floatValue];
    NSDictionary  * dict = GoodsDetailMod.shopUrl[0];
    NSString * str = kSaftToNSString(dict[@"url"]);
    [imgGoodsPic sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
}

//按钮点击逻辑
-(void)btnClick:(GYSelBtn*)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        for (GYSelBtn *btn in mArrBtn) {
            //判断按钮是否是同一行
            if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) ||(btn.tag < sender.tag && (sender.tag - btn.tag)< 100)) {
                btn.selected = NO;
                if (btn.selected == NO)
                {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
          
            }
        }
        //设置按钮选择颜色为红色
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    //取消按钮选择颜色
    for (GYSelBtn *btn in mArrBtn) {
        //判断按钮是否是同一行
        if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) ||(btn.tag < sender.tag && (sender.tag - btn.tag)< 100)) {
            btn.selected = NO;
            if (btn.selected == NO) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            break;
        }
    }
    //选择后更改json数组 选择按钮数据
    NSMutableArray *mArrTemp = [[NSMutableArray alloc] initWithArray:mArrjson];
    for (GYSelBtn *btnJson in mArrjson) {
        NSInteger i = 0;
        if (sender.row == btnJson.row) {
            [mArrTemp replaceObjectAtIndex:sender.row withObject:sender];
        }
        i++;
    }
    mArrjson = mArrTemp;
    for (GYSelBtn *btn in mArrjson) {
        if (btn.selected == NO) {
//            lbTitle.text = [NSString stringWithFormat:@"请选择%@",btn.dic[@"pName"]];
            break;
        }
        if (btn == mArrjson[mArrjson.count - 1]) {
            if (btn.selected == YES) {
                [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
                [self getSKUNetData];
            }
        }
    }
}


#pragma mark - getSKUNetData
-(void)getSKUNetData
{
    //创建 json数组
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
     NSMutableArray * tempArr =[NSMutableArray array];
    for (GYSelBtn *btn in mArrjson) {
        [mArray addObject:btn.dic];
        [tempArr addObject:[NSString stringWithFormat:@"%@:%@",btn.dic[@"pName"],btn.dic[@"pVName"]]];
        strRetParameterVl = [[strRetParameterVl stringByAppendingString:[NSString stringWithFormat:@",%@",btn.dic[@"pVId"]]] mutableCopy];
    }
    strRetParameterVl = [strRetParameterVl substringFromIndex:1];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:strRetParameterVl forKey:@"sku"];
    [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
    [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getGoodsSKU",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
         [Utils hideHudViewWithSuperView:self.view.window];
        if (error) {
            //网络请求错误
            
        }else{
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                strRetParameterVl=[@"" mutableCopy];//重置 规格id。
                //返回正确数据，并进行解析
                detailmodel.strPicList = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"picList"]];
                detailmodel.strPrice = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"price"]];
                detailmodel.strPv = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"pv"]];
                detailmodel.strSkuId = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"skuId"]];
                detailmodel.goodsSkus=ResponseDic[@"data"][@"sku"];
                strPictureUrl=ResponseDic[@"data"][@"picList"][0][@"url"];
                [self setViewValues];
            }else{
                [Utils hideHudViewWithSuperView:self.view];
                //返回数据不正确
            }
        }
    }];
}

-(void)setViewValues
{
    lbTitle.text = [NSString stringWithFormat:@"%.2f",detailmodel.strPrice.floatValue] ;
    [imgGoodsPic sd_setImageWithURL:[NSURL URLWithString:strPictureUrl] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
}

#pragma mark 加入购物车
-(void)addToNetCard
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%@",detailmodel.goodsNum ] forKey:@"num"];
    [dict setValue:detailmodel.strPrice forKey:@"originalPrice"];
    [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    [dict setValue:GoodsDetailMod.vShopName forKey:@"vShopName"];
    [dict setValue:GoodsDetailMod.shopId forKey:@"shopId"];
    [dict setValue:GoodsDetailMod.shopName forKey:@"shopName"];
    [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
    [dict setValue:detailmodel.strSkuId forKey:@"skuId"];
    [dict setValue:detailmodel.goodsSkus forKey:@"skus"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:@"2" forKey:@"sourceId"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getAddCart",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        if (error) {
            //网络请求错误
        }else{
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView *av =[[UIAlertView alloc] initWithTitle:nil message:@"成功添加到购物车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else{
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView *av =[[UIAlertView alloc] initWithTitle:nil message:@"添加到购物车失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                //返回数据不正确
            }
        }
    }];
}


-(void)buyNowAction
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    for (GYSelBtn *btn in mArrjson)
    {
        if (btn.selected==NO)
        {
            if (isShowSkuView)
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请先选择商品类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        if (btn.selected == NO)
        {
            [self showSKUView];
            break;
        }
        if (btn == mArrjson[mArrjson.count - 1])
        {
            
            if (btn.selected == YES)
            {
                if (detailmodel.strSkuId)
                {
                    [self hideSKUView];
                    if (self.navigationController.navigationBarHidden == YES)
                    {
                        [self hideSKUView];
                    }
                    GYPayoffViewController *vc = [[GYPayoffViewController alloc] init];
                    NSMutableArray *mArrTemp = [self buildPayoffJson];
                    vc.isRightAway = @"1";
                    vc.mArrShop = mArrTemp;
                      vc.strPictureUrl=strPictureUrl;
                    //                    vc.detailModel = detailmodel;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}


-(NSMutableArray *)buildPayoffJson
{
    NSMutableArray *mArrShop = [[NSMutableArray alloc] init];
    NSMutableDictionary *mDicShop = [[NSMutableDictionary alloc] init];
    NSMutableArray *mArrGoodsList = [[NSMutableArray alloc] init];
    NSMutableDictionary *mDicGoodsList = [[NSMutableDictionary alloc] init];
    float subTotal = [detailmodel.strPrice floatValue] * [detailmodel.goodsNum floatValue];
    float subPoints = [detailmodel.strPv floatValue] * [detailmodel.goodsNum floatValue];
    
    //－－－－－－－－－－－－－－－－－－－－goodsList－－－－－－－－－－－－－－－－－－－－－－－－－－
    [mDicGoodsList setObject:detailmodel.categoryId forKey:@"categoryId"];
    
    [mDicGoodsList setObject:detailmodel.goodsID forKey:@"itemId"];
    
    [mDicGoodsList setObject:detailmodel.title forKey:@"itemName"];
    
    [mDicGoodsList setObject:detailmodel.strPv forKey:@"point"];
    
    [mDicGoodsList setObject:detailmodel.strPrice forKey:@"price"];
    
    [mDicGoodsList setObject:detailmodel.goodsNum forKey:@"quantity"];
    
    [mDicGoodsList setObject:detailmodel.strSkuId forKey:@"skuId"];
    
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subPoints]
                      forKey:@"subPoints"];
    
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subTotal]
                      forKey:@"subTotal"];
    
    [mDicGoodsList setObject:detailmodel.vShopId forKey:@"vShopId"];
    
    [mDicGoodsList setObject:detailmodel.goodsSkus forKey:@"skus"];
    
    // add by songjk 添加ruleid 抵扣券规则
    [mDicGoodsList setValue:detailmodel.strRuleID forKey:@"ruleId"];
    // add by songjk 是否选择申请互生卡
    [mDicGoodsList setValue:detailmodel.isApplyCard forKey:@"isApplyCard"];
    
    [mArrGoodsList addObject:mDicGoodsList];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subTotal]
                forKey:@"actuallyAmount"];
    
    [mDicShop setValue:@"2" forKey:@"channelType"];
    
    [mDicShop setValue:detailmodel.companyResourceNo forKey:@"companyResourceNo"];
    
    [mDicShop setValue:mArrGoodsList forKey:@"orderDetailList"];
    
    [mDicShop setValue:detailmodel.serviceResourceNo forKey:@"serviceResourceNo"];
   
    [mDicShop setValue:GoodsDetailMod.shopId forKey:@"shopId"];
    
    [mDicShop setValue:GoodsDetailMod.shopName forKey:@"shopName"];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subTotal] forKey:@"totalAmount"];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subPoints] forKey:@"totalPoints"];
    
    [mDicShop setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    
    [mDicShop setValue:GoodsDetailMod.vShopName forKey:@"vShopName"];
    [mArrShop addObject:mDicShop];
    
    return mArrShop;
    
    
}


//获取tbvSel高度
-(void)getTbvHeight
{
    tbvSelHeight = 44;
    for (UIView* view in mArrBtnView) {
        tbvSelHeight = view.frame.size.height + tbvSelHeight + 44;
    }
}

-(void)setBorderWithView:(UIButton*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color WithBackgroundColor : (UIColor *)backgroundColor WithTitleColor:(UIColor *) titleColor
{
    [view setTitleColor:color forState:UIControlStateNormal];
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    if (titleColor) {
      [view setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    [view setBackgroundColor:backgroundColor];
    
}


#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==tvSkuView) {
        return 1;
    }else
    {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tvSkuView) {
        return detailmodel.arrPropList.count +1;
    }else{
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 0;
                break;
            case 2:
                return rows;
                break;
            case 3: // add by songjk基本参数
                return 1;
                break;
            case 4:
                return 1;
                break;
            case 5:
                return 1;
                break;
            default:
                break;
        }
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodIntroductionModel * model = [[GYGoodIntroductionModel alloc] init];
    model.strData = GoodsDetailMod.introduces;
    if (tableView==tvSkuView) {
        if (indexPath.row == detailmodel.arrPropList.count) {
            return 44;
        }else{
            UIView *view = mArrBtnView[indexPath.row];
            return 44 + view.frame.size.height;
        }
    }
    switch (indexPath.section) {
        case 0:
        {
            CGFloat startHeight=9;
            CGFloat  heightGoodsName = [Utils heightForString:_model.name fontSize:15.0 andWidth:195];
            CGFloat  heightAddress = [Utils heightForString:[NSString stringWithFormat:@"地址：%@%@%@",GoodsDetailMod.city,GoodsDetailMod.area,_model.addr] fontSize:15.0 andWidth:195];
            CGFloat totalHeight = startHeight +heightGoodsName + heightAddress+30+10;
            return totalHeight>85?totalHeight:85;
        }
            break;
        case 1:
            return 0.f;
            break;
        case 2:
            // modify by songjk
//            return 25.f;
            return model.fHight+20;
            break;
        case 3:
            return 44.f;
            break;
        case 4:
            return 44.f;
            break;
        case 5:
            return 44.f;
            break;
        default:
            break;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    if (tableView==tvSkuView) {
        return nil;
    }else{
        switch (section) {
            case 0:
                return nil;
                break;
            case 1:
            {
                return [self listSurppotWay];
                
            }
                return nil;
            case 2:
            {
                return [self  goodDetail];
                
            }
                break;
            case 3:
            {
                return nil;
            }
                break;
            case 4:
            {
                
            }
            case 5:
            {
                return nil;
            }
                return nil;
                break;
            default:
                break;
        }
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView==tvSkuView) {
        return 0;
    }else{
        switch (section) {
            case 0:
                return 0;
                break;
            case 1:
                return 90;
                break;
            case 2:
                return 40;
                break;
            case 3:
                return 0;
                break;
            case 4:
                return 0;
                break;
            case 5:
                return 0;
                break;
            default:
                break;
        }
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView==tvSkuView) {
        if (indexPath.row == detailmodel.arrPropList.count) {
            GYSetNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLNUM"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else{
            GYSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLSEL"];
            ArrModel *arrModel = detailmodel.arrPropList[indexPath.row];
            cell.lbTitle.text = arrModel.propName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell.btnView != nil) {
                [cell.btnView removeFromSuperview];
                cell.btnView = nil;
            }
            cell.btnView = mArrBtnView[indexPath.row];
            [cell addSubview:cell.btnView];
            return cell;
        }
    }else{
        switch (indexPath.section) {
            case 0:
            {
                //商品名称的cell
                locationCell=[[[NSBundle mainBundle] loadNibNamed:@"GYShopLocationTableViewCell" owner:self options:nil]lastObject];
                // add by songjk
                
//                CGFloat  heightAddress = [Utils heightForString:[NSString stringWithFormat:@"地址：%@",_model.addr] fontSize:15.0 andWidth:195]+5;
//                CGFloat heightGoodsName =[Utils heightForString:_model.name fontSize:15.0 andWidth:203];

//                CGRect frameGoodsName =locationCell.lbGoodName.frame;
//                frameGoodsName.size.height=heightGoodsName>25?heightGoodsName:25;
//                locationCell.lbGoodName.frame=frameGoodsName;
//                CGRect frameShopName = locationCell.lbShopName.frame;
//                frameShopName.size.height=heightStoreName>25?heightStoreName:25;
//                locationCell.lbShopName.frame=frameShopName;
//                
//                CGRect frameShopAddress = locationCell.lbShopAddress.frame;
//                frameShopAddress.size.height=heightAddress>15?heightAddress:15;
//                frameShopAddress.origin.y=locationCell.lbShopName.frame.origin.y+locationCell.lbShopName.frame.size.height;
//                locationCell.lbShopAddress.frame=frameShopAddress;
                
//                CGRect frameTel = locationCell.btnShopTel.frame;
//                frameTel.origin.y=locationCell.lbShopAddress.frame.origin.y+(heightAddress>15?heightAddress:15);
//                locationCell.btnShopTel.frame=frameTel;
                
                // modfiy by songjk
                UIFont *nameFont = [UIFont systemFontOfSize:15];
                NSString * strName = GoodsDetailMod.itemName;
                CGSize nameSize = [Utils sizeForString:strName font:nameFont width:locationCell.lbGoodName.frame.size.width];
                locationCell.lbGoodName.text = GoodsDetailMod.itemName;
                locationCell.lbGoodName.font =nameFont;
                locationCell.lbGoodName.frame = CGRectMake(locationCell.lbGoodName.frame.origin.x, locationCell.lbGoodName.frame.origin.y, nameSize.width, nameSize.height);
                
                [Utils setFontSizeToFitWidthWithLabel:locationCell.lbShopName labelLines:2];
                locationCell.lbDistance.text=[NSString stringWithFormat:@"%.1fkm",_model.shopDistance.floatValue];// modify by sngjk
                
                // modify by songjk
                UIFont *font = [UIFont systemFontOfSize:13];
                NSString * strAddr = [NSString stringWithFormat:@"%@",GoodsDetailMod.addr];
                CGSize addrSize = [Utils sizeForString:strAddr font:font width:locationCell.lbShopAddress.frame.size.width];
                locationCell.lbShopAddress.text=strAddr;
                locationCell.lbShopAddress.font =font;
                locationCell.lbShopAddress.frame = CGRectMake(locationCell.lbShopAddress.frame.origin.x, CGRectGetMaxY(locationCell.lbGoodName.frame)+5, addrSize.width, addrSize.height);
                [locationCell.btnShopTel setTitle:GoodsDetailMod.shopTel forState:UIControlStateNormal];
                CGRect rectForTel =locationCell.btnShopTel.frame;
                rectForTel.origin.y= CGRectGetMaxY(locationCell.lbShopAddress.frame)+5;
                locationCell.btnShopTel.frame=rectForTel;
                [locationCell.btnShopTel addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
                [locationCell.btnCheckMap addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
                cell=locationCell;
                
            }
                break;
            case 1:
            {
                //第二个section 中没有cell
                cell=nil;
            }
                break;
            case 2:
            {
                // modify by songjk
                //第三个section 中cell
//                GYGoodDetailListTableViewCell * goodInfoCell =[tableView dequeueReusableCellWithIdentifier:indentifer];
//                if (goodInfoCell==nil) {
//                    goodInfoCell=[[GYGoodDetailListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
//                }
//                NSArray * arr2 = [dic allKeys];
//                NSArray * arr1 =[dic allValues];
//                [goodInfoCell refreshUIWith:arr2[indexPath.row] WithDetail:arr1[indexPath.row]];
//                cell=goodInfoCell;
//
                GYGoodIntroductionModel * model = [[GYGoodIntroductionModel alloc] init];
                 model.strData = GoodsDetailMod.introduces;
                GYGoodIntroductionCell *goodInfoCell=[GYGoodIntroductionCell cellWithTableView:tableView];
                goodInfoCell.model = model;
                cell = goodInfoCell;
                
            }
                break;
            case 3:
            {
                UITableViewCell *  baceInfoCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"picCell"];
                
                baceInfoCell.backgroundColor = [UIColor whiteColor];
                baceInfoCell.contentView.backgroundColor = [UIColor whiteColor];
                UIImageView * imgv =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ep_cell_btn_right_arrow.png"]];
                imgv.frame=CGRectMake(45, 10, 9, 16);
                UIView * accessoryView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
                [accessoryView addSubview:imgv];
                baceInfoCell.accessoryView=accessoryView;
                baceInfoCell.textLabel.text=@" 基本参数";
                baceInfoCell.textLabel.textColor=kCellItemTitleColor;
                baceInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [baceInfoCell addTopBorder];
                cell=baceInfoCell;
            }
                break;
//            case 4:
//            {
//                UITableViewCell *  picDetailCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"picCell"];
//                picDetailCell.contentView.backgroundColor = [UIColor whiteColor];
//                UIImageView * imgv =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ep_cell_btn_right_arrow.png"]];
//                imgv.frame=CGRectMake(45, 10, 9, 16);
//                UIView * accessoryView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//                [accessoryView addSubview:imgv];
//                picDetailCell.accessoryView=accessoryView;
//                picDetailCell.textLabel.text=@" 图文详情";
//                picDetailCell.textLabel.textColor=kCellItemTitleColor;
//                picDetailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [picDetailCell addTopBorder];
//                cell=picDetailCell;
//            }
//                break;
            case 4:
            {
                starCell=[[[NSBundle mainBundle] loadNibNamed:@"GYStarTableViewCell" owner:self options:nil]lastObject];
                starCell.btnStar1.selected=YES;
                starCell.btnStar2.selected=YES;
                starCell.btnStar3.selected=YES;
                starCell.btnStar4.selected=YES;
                if (GoodsDetailMod.rating.intValue<=0) {
                    starCell.btnStar1.selected=NO;
                    starCell.btnStar2.selected=NO;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                }else if (GoodsDetailMod.rating.intValue>0&&GoodsDetailMod.rating.intValue<=1)
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=NO;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                    
                    
                }else if (GoodsDetailMod.rating.intValue>1&&GoodsDetailMod.rating.intValue<=2)
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=NO;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                    
                    
                }else if (GoodsDetailMod.rating.intValue>2&&GoodsDetailMod.rating.intValue<=3)
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=NO;
                    starCell.btnStar5.selected=NO;
                    
                    
                }else if (GoodsDetailMod.rating.intValue>3&&GoodsDetailMod.rating.intValue<=4)
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=YES;
                    starCell.btnStar5.selected=NO;
                    
                    
                }else if (GoodsDetailMod.rating.intValue>4&&GoodsDetailMod.rating.intValue<=5)
                {
                    starCell.btnStar1.selected=YES;
                    starCell.btnStar2.selected=YES;
                    starCell.btnStar3.selected=YES;
                    starCell.btnStar4.selected=YES;
                    starCell.btnStar5.selected=YES;
                    
                }
                
                
                starCell.lbPoint.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.01f",[GoodsDetailMod.rating floatValue]]];
                starCell.lbEvaluatePerson.text=[NSString stringWithFormat:@"%@人评价",GoodsDetailMod.evacount];
                starCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [starCell.contentView addTopBorder];
                cell=starCell;
                NSLog(@"cllHeight = %f",CGRectGetMaxY(starCell.frame));
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 3:
        {
            // add by songjk
            if (detailmodel.arrBasicParameter.count == 0) {
                [Utils showMBProgressHud:self SuperView:self.view Msg:@"该商品暂没有参数数据" ShowTime:0.5];
                return;
            }
            GYGoodsParameterViewController *vc = [[GYGoodsParameterViewController alloc] init];
            vc.title = @"基本参数";
            vc.model = detailmodel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 4:
//        {
//            GYPicDtVC * vcPicDetail =[[ GYPicDtVC alloc]initWithNibName:@"GYPicDtVC" bundle:nil];
//            vcPicDetail.title=@"图文详情";
//            GYGoodsDetailModel * model =[[GYGoodsDetailModel alloc]init];
//            model.picDetails=GoodsDetailMod.picDetails;
//            vcPicDetail.model=model;
//            [self.navigationController pushViewController:vcPicDetail animated:YES];
//            
//        }
//            break;
            
        case 4:
        {
            GYMainEvaluateDetailViewController * vcMainEvaluateDetail =[[ GYMainEvaluateDetailViewController alloc]initWithNibName:@"GYMainEvaluateDetailViewController" bundle:nil];
            vcMainEvaluateDetail.title=@"评价详情";
            vcMainEvaluateDetail.strGoodId=_model.goodsId;
            [self.navigationController pushViewController:vcMainEvaluateDetail animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark scrollview代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (scrollView == header.mainScrollView) {
        header.pageControl.currentPage = pageIndex;
        UIImageView * imageViewPic =[[UIImageView alloc]initWithFrame:CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageViewPic.contentMode=UIViewContentModeScaleAspectFit;
        [imageViewPic sd_setImageWithURL:[NSURL URLWithString:GoodsDetailMod.shopUrl[pageIndex][@"url"]] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
        [scrollView addSubview:imageViewPic];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
    NSLog(@"scrollView == %@",NSStringFromClass([scrollView class]));
    NSLog(@"tableViewFrame = %@",NSStringFromCGSize( tvShopDetail.contentSize));
    NSLog(@"heigh = %f",tvShopDetail.contentSize.height-tvShopDetail.frame.size.height);
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset) );
    CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame) ;
    if (!self.bloadDetail)
    {
        if (scrollView == tvShopDetail )
        {
            CGFloat offHeight = scrollView.contentOffset.y;
            self.tableSCHeight = tvShopDetail.contentSize.height-tvShopDetail.frame.size.height;
            if (self.tableSCHeight+kScreenHeight *0.1<offHeight)
            {
                NSLog(@"显示商品详情");
                [self showGoodDetails];
            }
        }
    }
    else if(tvShopDetail.contentOffset.y< self.tableSCHeight+wbHeight - 100)
    {
        NSLog(@"关闭商品详情");
        [self removeGoodDetail];
    }

}
-(UIWebView *)wvDetail
{
    if (_wvDetail == nil) {
        CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame)- self.vBottomView.frame.size.height ;
        _wvDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, wbHeight)];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:GoodsDetailMod.picDetails]];
        
        
        // add by songjk
        _wvDetail.scalesPageToFit = YES;
        _wvDetail.delegate = self;
        [_wvDetail loadRequest:request];
    }
    return _wvDetail;
}
-(void)showGoodDetails
{
    self.bloadDetail = YES;
    CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame)  - self.vBottomView.frame.size.height;
    UIView * vFoot = [[UIView alloc] initWithFrame:self.wvDetail.frame];
    [vFoot addSubview:self.wvDetail];
    tvShopDetail.tableFooterView = vFoot;
    [UIView animateWithDuration:0.5 animations:^{
        tvShopDetail.contentOffset = CGPointMake(0, self.tableSCHeight+wbHeight);
    }];
}
-(void)removeGoodDetail
{
    self.bloadDetail = NO;
    [UIView animateWithDuration:0.3 animations:^{
        UIView * vFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        vFoot.backgroundColor = kDefaultVCBackgroundColor;
        UILabel * lbShowMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        lbShowMore.text = @"继续上拉，显示图文详情";
        lbShowMore.backgroundColor = [UIColor clearColor];
        lbShowMore.textAlignment = NSTextAlignmentCenter;
        lbShowMore.textColor = kCellItemTitleColor;
        lbShowMore.font = [UIFont systemFontOfSize:14];
        [vFoot addSubview:lbShowMore];
        tvShopDetail.tableFooterView = vFoot;
//        tvShopDetail.contentOffset = CGPointMake(0, self.tableSCHeight);
    }];
}
-(void)btnClicked:(UIButton *)sender
{
    sender.selected=YES;
}


-(UIView *)listSurppotWay
{
    UIView * backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    // add by songjk
    NSArray * arrData = [NSArray arrayWithObjects:
                         GoodsDetailMod.beReach,
                         GoodsDetailMod.beSell,
                         GoodsDetailMod.beCash,
                         GoodsDetailMod.beTake,
                         GoodsDetailMod.beTicket,
                         nil];
    if (!arrData.count>0) {
        return nil;
    }
#pragma mark 特殊服务
    CGFloat xw=16;///首行x轴坐标
    CGFloat Yh=10;//首行Y轴坐标
    CGFloat jux=20;//x方向的间距
    CGFloat juy= 15;//Y方向的间距
    CGFloat w=(kScreenWidth-(xw*2)-(jux*2))/3;///整个bgview 的宽度
    CGFloat h=25;///bgview的高度
    for (int i=0; i<arrData.count; i++) {
        ///先循环5个图片
        UIView *bgView=[[UIView alloc]init];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.frame = CGRectMake(xw+(w+jux)*(i%3), Yh+(h+juy)*(i/3), w+10, h);
        ///添加小图标
        BOOL imagebg=[[NSString stringWithFormat:@"%@",arrData[i]] isEqual:@"1"]?YES:NO;
        UIImageView *imag=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, h-2, h-2)];
        if (imagebg)
        {
            imag.image= [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%d",i+1]];
        }
        else
        {
            imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail_unselected_%d",i+1]];
        }
        [bgView addSubview:imag];
        //添加label
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(h+2, 0, bgView.bounds.size.width-h, h)];
        lab.textColor=kCellItemTextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [arrTitle objectAtIndex:i];
        lab.font=[UIFont systemFontOfSize:12.0f];
        [bgView addSubview:lab];
        [backGroundView addSubview:bgView];
    }
    CALayer *topBorder = [CALayer layer];
    topBorder.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
    topBorder.frame = CGRectMake(backGroundView.frame.origin.x+16   , 0, CGRectGetWidth(backGroundView.frame)-32    , 1.0f);
    [backGroundView.layer addSublayer:topBorder];
    return backGroundView;
}


-(void)btnCheck
{
    NSLog(@"查看全部分店");
}

-(void)callShop:(UIButton *)sender
{
    NSString * phoneNumber=GoodsDetailMod.shopTel;
    if (phoneNumber== nil || [phoneNumber isKindOfClass:[NSNull class]]) {
        return;
    }
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
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
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

-(void)goToMap
{
    GYBMKViewController * mapVC=[[GYBMKViewController alloc]init];
    mapVC.strShopId=GoodsDetailMod.shopId;
    CLLocationCoordinate2D coordinateShop;
    coordinateShop.latitude=[GoodsDetailMod.lat floatValue];
    coordinateShop.longitude=[GoodsDetailMod.longitude floatValue];
    mapVC.coordinateLocation=coordinateShop;
    mapVC.title=@"地图显示";
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(UIView *)goodDetail
{
    UIView *  v =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    v.backgroundColor=[UIColor whiteColor];
    UIButton * btnGoodIntroduction =[UIButton buttonWithType:UIButtonTypeCustom];
    btnGoodIntroduction.frame=CGRectMake(kDefaultMarginToBounds, 0, 304, 40);
    [btnGoodIntroduction setTitle:kLocalized(@"ar_good_introduction") forState:UIControlStateNormal];
    btnGoodIntroduction.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnGoodIntroduction.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 225);
    btnGoodIntroduction.backgroundColor=[UIColor clearColor];
    [btnGoodIntroduction setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnGoodIntroduction addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventTouchUpInside];
    imgvArrow.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-20, 15, 18, 10);
    imgvArrow.userInteractionEnabled = NO;
    imgvArrow.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    imgvArrow.contentMode = UIViewContentModeScaleAspectFit;
    imgvArrow.transform= rotationTransform;
    imgvArrow.image=[UIImage imageNamed:@"image_down_arrow.png"];
    [v addSubview:imgvArrow];
    
    [v addSubview:btnGoodIntroduction];
    [v addTopBorder];
    return v;
    
}


-(void)reloadTableView
{
    // modify by songjk
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform=CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(180));
        imgvArrow.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if (isShow) {
            rows=1;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow=!isShow;
        }else
        {
            rows=0;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow=!isShow;
        }
    }];
}

//联系商家点击事件
- (IBAction)btnContactShop:(id)sender {
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    [self contactShopRequest];
}


- (IBAction)btnAddToShopCar:(id)sender {
    
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    
    
    for (GYSelBtn *btn in mArrjson) {
        
        if (btn.selected==NO) {
            if (isShowSkuView) {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请先选择商品类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        if (btn.selected == NO) {
            [self showSKUView];
            break;
        }
        if (btn == mArrjson[mArrjson.count - 1]) {
            if (btn.selected == YES) {
                if (detailmodel.strSkuId) {
                    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
                    [self addToNetCard];
                    [self hideSKUView];
                }
            }
        }
    }
}




//弹出SKU界面
-(void)showSKUView
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //                         [self.view addSubview:touchView];
                         isShowSkuView=YES;
                         if ([GlobalData shareInstance].currentDeviceScreenInch==kDeviceScreenInch_3_5) {
                             vPopView.frame = CGRectMake(0, 20, 320, 460);
                         }else{
                             vPopView.frame = CGRectMake(0, 568-480, 320, 480);
                         }
                         [self.tabBarController.view.window addSubview:vPopView];
                         self.navigationController.navigationBarHidden = YES;
                     }
                     completion:NULL];
}


-(void)hideSKUView
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //                         [touchView removeFromSuperview];
                           isShowSkuView=NO;
                         self.navigationController.navigationBarHidden = NO;
                         vPopView.frame = CGRectMake(0, kScreenHeight+50, 320, 0);
                         
                         [self.tabBarController.view.window addSubview:vSel];
                     }
                     completion:NULL
     ];
}

//立即购买点击按钮
- (IBAction)btnBuyNow:(id)sender {
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    [self buyNowAction];
    
}
- (IBAction)hidenPopView:(id)sender {
    [self hideSKUView];
}

#pragma mark 商品个数的代理方法
-(void)retNum:(NSInteger)Num
{
    detailmodel.goodsNum=[NSString stringWithFormat:@"%ld",(long)Num];
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

//
//  GYEasyPurchaseMainViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kKeyGoodsPicture    @"GoodsPicture"
#define kKeyGoodsTitle      @"GoodsTitle"
#define kKeyGoodslDescription @"GoodslDescription"
#define kKeyGoodsCategoryId @"GoodsCategoryId"

#import "GYEasyPurchaseMainViewController.h"
#import "EasyPurchaseHead.h"
#import "GYCartViewController.h"
#import "CellHScrollCell.h"
#import "CellViewGoodsType.h"
#import "GYEasyBuyModel.h"
#import "ViewGoodsType.h"
#import "UIView+CustomBorder.h"
#import "MJRefresh.h"
#import "TestViewController.h"
#import "GYEasyBuyViewController.h"
#import "UIImageView+WebCache.h"
#import "GlobalData.h"
#import "ViewTipBkgView.h"
#import "GYEasyBuySearchViewController.h"
#import "GYEPMyHEViewController.h"
#import "UIButton+enLargedRect.h"
#import "GYAppDelegate.h"
@interface GYEasyPurchaseMainViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    EasyPurchaseHead *viewHeader;           //自定义搜索栏
    CellHScrollCell *cellConvenientEntry;   //快捷入口cell
    NSMutableArray *arrUsualPower;          //常用功能
    GlobalData *data;
    NSMutableArray *arrDataSource;
    NSMutableArray *arrResult;//section1 Result
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GYEasyPurchaseMainViewController

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
    
    //自定义返回，手势失效的问题
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }

    data = [GlobalData shareInstance];
    //设置自定义搜索栏
    
    viewHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EasyPurchaseHead class]) owner:self options:nil] lastObject];
//    CGRect cHframe = self.navigationController.navigationBar.frame;
//    cHframe.origin.x = 0;
//    cHframe.origin.y = 0;
//    
//
//    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
//    {
//        cHframe.size.height += [[UIApplication sharedApplication] statusBarFrame].size.height;
//    }
//
//    [viewHeader setFrame:cHframe];
    [viewHeader setBackgroundColor:kNavigationBarColor];
    [self.view addSubview: viewHeader];
    [viewHeader.btnSearch addTarget:self action:@selector(btnSearchGood:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader.btnCart addTarget:self action:@selector(pushToMyHS:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader.btnMyHushang setEnlargEdgeWithTop:10 right:13 bottom:10 left:5];
    [viewHeader.btnMyHushang addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                  CGRectGetMaxY(viewHeader.frame),
                                                                  self.view.frame.size.width,
                                                                   CGRectGetHeight(self.view.frame) - CGRectGetHeight(viewHeader.frame) - self.tabBarController.tabBar.frame.size.height
                                                                   )
                                                  style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    
     //注册cell以复用
    cellConvenientEntry = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CellHScrollCell class]) owner:self options:nil] lastObject];
    [cellConvenientEntry addTopBorder];
    [cellConvenientEntry addBottomBorder];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellViewGoodsType class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellViewGoodsTypeIdentifier];
    
    //兼容IOS6设置背景色
    
    ViewTipBkgView *  tBkg = [[ViewTipBkgView alloc] init];
    tBkg.lbTip.text = kLocalized(@"没有搜到相关商品数据！");
    [tBkg setFrame:self.tableView.bounds];
    self.tableView.backgroundView = tBkg;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.hidden = YES;
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    //设置常用功能
    arrUsualPower = [NSMutableArray array];
    [arrUsualPower addObject:[GYEasyBuyModel initWithName:kLocalized(@"ep_usual_browsing_history") pictureURL:@"ep_cell_browsing_history"]];
    [arrUsualPower addObject:[GYEasyBuyModel initWithName:kLocalized(@"ep_usual_concerns_collect") pictureURL:@"ep_cell_concerns_collect"]];
    [arrUsualPower addObject:[GYEasyBuyModel initWithName:kLocalized(@"ep_my_coupons") pictureURL:@"ep_cell_order_center_coupons"]];
    [arrUsualPower addObject:[GYEasyBuyModel initWithName:kLocalized(@"ep_usual_order_center") pictureURL:@"ep_cell_order_center"]];
    [arrUsualPower addObject:[GYEasyBuyModel initWithName:kLocalized(@"ep_usual_myhe") pictureURL:@"ep_cell_mine"]];
//    [cellConvenientEntry setTitlesAndImages:arrUsualPower];
//    cellConvenientEntry.vcPrarentVC = self;
//    
    arrDataSource = [NSMutableArray array];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        [strongSelf loadTopicFromNetwork:NO];
    }];
    [self getGoodsNum];
}

#warning 商品个数
-(void)getGoodsNum
{
    GlobalData *data = [GlobalData shareInstance];
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getCartMaxSize"] parameters:nil requetResult:^(NSData *jsonData, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
            if (!error){
                
                if (kSaftToNSInteger(dict[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    GYAppDelegate * delegate = (GYAppDelegate *)[[UIApplication sharedApplication]delegate];
                    delegate.goodsNum=[dict[@"data"] integerValue];
                    NSLog(@"%ld",delegate.goodsNum);
                }
                else{
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }
        }
        
    }];
    
}



-(void)btnSearchGood:(UIButton *)sender
{
    GYEasyBuySearchViewController * vcSearch =[[GYEasyBuySearchViewController alloc]initWithNibName:@"GYEasyBuySearchViewController" bundle:nil];
    
    self.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:vcSearch animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}


-(void)pushToMyHS:(UIButton *)sender
{
//add by zhangqy,测试新页面入口用
#if 0
    UIViewController *foodVC = [[NSClassFromString(@"GYFoodViewController") alloc]init];
    [self pushVC:foodVC animated:YES];
#endif
#if 1
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYEPMyHEViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
   
    vcCart.navigationItem.title = @"我的互商";
    [self pushVC:vcCart animated:YES];
#endif

}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    
}

- (void)loadTopicFromNetwork:(BOOL)isShowHUD
{
    NSDictionary *allParas = @{@"key": @""};
    
    MBProgressHUD *hud;
    if (isShowHUD)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = NO;
        [self.view addSubview:hud];
        //    hud.labelText = @"初始化数据...";
        [hud show:YES];
    }
    
    [Network  HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getHomePage"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    NSArray * arrList =[dic objectForKey:@"data"];
                    for (NSDictionary * tempDic in arrList)
                    {
                        NSDictionary *dicType = @{kKeyGoodsCategoryId : kSaftToNSString(tempDic[@"id"]),
                                                  kKeyGoodsPicture :kSaftToNSString(tempDic[@"url"]),
                                                  kKeyGoodsTitle : kSaftToNSString(tempDic[@"title"]),
                                                  kKeyGoodslDescription :kSaftToNSString(tempDic[@"subTitle"])
                                                  };
                        [arr addObject:dicType];
                    }
                    if (arr.count > 0)
                    {
                        arrDataSource = [NSMutableArray arrayWithObjects: arr, nil];
                        arrResult = arrDataSource[0];
                        self.tableView.backgroundView.hidden = YES;
                    }else
                    {
                        self.tableView.backgroundView.hidden = NO;
                    }
                    [self.tableView reloadData];

                }else//返回失败数据
                {
//                    [Utils showMessgeWithTitle:nil message:@"." isPopVC:nil];
                }
            }else
            {
//                [Utils showMessgeWithTitle:nil message:@"." isPopVC:nil];
            }
            
        }else
        {
//            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        [self.tableView.header endRefreshing];
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTopicFromNetwork:YES];
    //隐藏 navigationController
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入购物车
- (void)pushCartVc:(id)sender
{
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
}

//弹出新窗口
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section)
    {
        case 0:
            if (arrResult.count % 2 == 0)
            {
                rows = arrResult.count / 2;
            }else
            {
                rows = arrResult.count / 2 + 1;
            }
            
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    static NSString *cellid = kCellViewGoodsTypeIdentifier;
    CellViewGoodsType *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
//    {
////        cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
//        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    } else
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    }
    if (!cell)
    {
        NSLog(@"rows:%d", (int)indexPath.row);
        cell = [[CellViewGoodsType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        if (kSystemVersionLessThan(@"7.0"))
        {
            UIView *cellBk = [[UIView alloc] init];
            [cellBk setBackgroundColor:[UIColor whiteColor]];
            [cell setBackgroundView:cellBk];
        }
    }
    
    ViewGoodsType *vgt0 = cell.viewGoodsType0;
    int vgt0Index = row * 2;

    [vgt0.ivPicture sd_setImageWithURL:[NSURL URLWithString:kSaftToNSString(arrResult[vgt0Index][kKeyGoodsPicture])] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];//kLoadPng(@"ep_placeholder_image_type1")
    [vgt0 setGoodsTypeTitleTextWithDefaultAttributes:arrResult[vgt0Index][kKeyGoodsTitle]];
    [vgt0 setGoodsTypeDescriptionTextWithDefaultAttributes:arrResult[vgt0Index][kKeyGoodslDescription]];
    [vgt0 setStrID:arrResult[vgt0Index][kKeyGoodsCategoryId]];
   
    [vgt0 addTarget:self action:@selector(pushTopicsVc:) forControlEvents:UIControlEventTouchUpInside];
    
    ViewGoodsType *vgt1 = cell.viewGoodsType1;
    int vgt1Index = vgt0Index + 1;
    if (vgt1Index >= arrResult.count)
    {
        vgt1.ivPicture.image = nil;
        vgt1.lbGoodsTypeTitle.text = @"";
        vgt1.lbGoodsTypeDescription.text = @"";
        [vgt1 setEnabled:NO];
    }else
    {
        [vgt1 setEnabled:YES];

        [vgt1.ivPicture sd_setImageWithURL:[NSURL URLWithString:kSaftToNSString(arrResult[vgt1Index][kKeyGoodsPicture])]  placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
        [vgt1 setGoodsTypeTitleTextWithDefaultAttributes:arrResult[vgt1Index][kKeyGoodsTitle]];
        [vgt1 setGoodsTypeDescriptionTextWithDefaultAttributes:arrResult[vgt1Index][kKeyGoodslDescription]];
        [vgt1 setStrID:arrResult[vgt1Index][kKeyGoodsCategoryId]];

        [vgt1 addTarget:self action:@selector(pushTopicsVc:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)pushTopicsVc:(id)sender
{
    NSLog(@"%@ onClicked", sender);//
    ViewGoodsType *vgt = sender;
    
    GYEasyBuyViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEasyBuyViewController class]));
    vc.strGoodsCategoryId = vgt.strID;
    vc.navigationItem.title = vgt.strTitleTextNoTags;
    NSUserDefaults * userDefaultGoods =[NSUserDefaults standardUserDefaults];
    [userDefaultGoods setObject:vgt.strTitleTextNoTags forKey:@"easyBuyTitle"];
    [userDefaultGoods synchronize];
    [self pushVC:vc animated:YES];


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    UIView *vFooter = [[UIView alloc] init];
    return vFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cllh = 0;
    switch (indexPath.section)
    {
        case 0:
            cllh = 104;
            
            break;
        default:
            break;
    }    
    return cllh;
}

@end
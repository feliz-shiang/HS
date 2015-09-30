//
//  GYStoreDetailViewController.m
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYStoreDetailViewController.h"
#import "MenuTabView.h"
#import "GYShopHeader.h"
//#import "GYStoreTableViewCell.h"
#import "MJExtension.h"

#import "GYEasyBuyModel.h"
#import "GYShopBaseInfoModel.h"
#import "GYShopGoodListModel.h"

#import "GYShopDetailViewController.h"

#import "GYGoodDetailViewController.h"
#import "GYChatViewController.h"
#import "MMLocationManager.h"
#import "MWPhotoBrowser.h"
#import "GYSearchShopGoodsViewController.h"
#import "MWPhotoBrowser.h"
#import "GYShopCategoryChooseController.h"
#import "GYShopBrandChooseController.h"
#import "UIView+CustomBorder.h"
#import "GYShopAboutViewController.h"

#import "GYStoreTableViewCell.h"
#import "MJRefresh.h"
#import "GYMallBaseInfoModel.h"


#define kCellIdentifier  @"storeCellIndentifer"
// 热卖商品用
#define pageCount 6
@interface GYStoreDetailViewController ()< MenuTabViewDelegate,ShopHeaderDelegate,MWPhotoBrowserDelegate,ShopBrandChooseControllerDelegate,UITableViewDataSource,UITableViewDelegate,StoreTableViewCellDelegate>
@property(nonatomic,strong) GYShopHeader* headerView;
//**店铺详细*/
@property (nonatomic,strong) GYMallBaseInfoModel * mallDetailInfo;
//@property (nonatomic,strong) GYShopBaseInfoModel * shopDetailInfo;
@property (nonatomic,strong) NSMutableArray * marrAllGoods;

@property (weak, nonatomic) IBOutlet UIView *vBottom;

@property (weak, nonatomic) IBOutlet UIButton *btnGoodType;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnIntrouduce;
@property (weak, nonatomic) IBOutlet UIView *vNavationBar;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnType;


@property (strong,nonatomic) NSArray * photos;

@property (copy,nonatomic) NSString * strBrandName;

@property (nonatomic,strong) UITableView * tableView;

// 热卖商品用
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic , assign)BOOL shouldRefresh;
@property (nonatomic , assign)BOOL isHotGoods;
@end

@implementation GYStoreDetailViewController
{
    MenuTabView *menu;      //菜单视图
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnGoodType addRightBorder];
    [self.btnIntrouduce addRightBorder];
    self.shouldRefresh = NO;
    
    self.currentPage = 1;
    self.totalPage = 0;
//    UIView * vSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    vSearch.backgroundColor = [UIColor grayColor];
//    CGFloat tfSearchW = 150;
//    CGFloat tfSearchH = 30;
//    CGFloat tfSearchX = (vSearch.frame.size.width - tfSearchW)*0.5;
//    CGFloat tfSearchY = 5;
//    UIButton * btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(tfSearchX, tfSearchY, tfSearchW, tfSearchH)];
//    [btnSearch setTitle:@"搜索店铺内商品" forState:UIControlStateNormal];
//    btnSearch.adjustsImageWhenHighlighted = NO;
//    [btnSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
//    [vSearch addSubview:btnSearch];
//    self.navigationItem.titleView = vSearch;
    
    [self.btnGoodType setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    self.btnGoodType.backgroundColor = [UIColor whiteColor];
    [self.btnChat setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
     self.btnChat.backgroundColor = [UIColor whiteColor];
    [self.btnIntrouduce setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
     self.btnIntrouduce.backgroundColor = [UIColor whiteColor];
    
    
    [self.btnSearch setTitle:@"搜索店铺内商品" forState:UIControlStateNormal];
    self.btnSearch.backgroundColor = kCorlorFromRGBA(208, 35, 26, 1);
//    [self httpRequestForShopInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //add by shiang
    if (kSystemVersionLessThan(@"7.0"))
    {
        [self.navigationController.navigationBar setBackgroundImage:[self buttonImageFromColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
        
    }
    
    
    [self httpRequestForShopInfo];
}

//add by shiang
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)setup
{
    self.currentPage = 1;
    self.totalPage = 0;
    [self.marrAllGoods removeAllObjects];
    [self.tableView.footer resetNoMoreData];
}
-(void)footerRereshing
{
    if (self.isHotGoods) {
        [self getHotGoods];
    }
    else
    {
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:self.strBrandName sortType:nil];
    }
    
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrAllGoods.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYStoreTableViewCell * cell = [GYStoreTableViewCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray * arrcELL = self.marrAllGoods[indexPath.row];
    if (arrcELL.count==2) {
        cell.leftModel = arrcELL[0];
        cell.rightModel = arrcELL[1];
    }
    else if (arrcELL.count==1)
    {
        cell.leftModel = arrcELL[0];
    }
    cell.backgroundColor = kDefaultVCBackgroundColor;
    cell.delegate = self;
    return cell;
}
-(NSMutableArray *)marrAllGoods
{
    if (!_marrAllGoods) {
        _marrAllGoods = [NSMutableArray array];
    }
    return _marrAllGoods;
}
/**去分类*/
-(IBAction)toSearch
{
    GYSearchShopGoodsViewController *searchVc= [[GYSearchShopGoodsViewController alloc]init];
//    searchVc.vshopId = self.shopDetailInfo.vShopId;
    searchVc.vshopId = self.shopModel.strVshopId;
//    searchVc.delegate = self;
    [self.navigationController pushViewController:searchVc animated:YES];
    NSLog(@"跳转到搜索页面,shopId:%@",searchVc.vshopId);
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseType:(id)sender {
    GYShopCategoryChooseController * vcCategory = [[GYShopCategoryChooseController alloc] init];
    vcCategory.strShopID = self.shopModel.strVshopId;
    vcCategory.pushedVC = self;
    vcCategory.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcCategory animated:YES];
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat tableViewH = kScreenHeight - self.vBottom.frame.size.height;
        
        CGFloat tableViewY = 0;
        if (kSystemVersionLessThan(@"6.9"))
        {
            tableViewH = tableViewH - 20;
        }
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, kScreenWidth, tableViewH)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerNib:[UINib nibWithNibName:@"GYStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = kDefaultVCBackgroundColor;
        
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [self.view addSubview:self.tableView];
        
        
        UIView *HeaderView = [[UIView alloc] init];
        HeaderView.backgroundColor = [UIColor clearColor];
        
        self.headerView = [GYShopHeader initWithXib];
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, self.headerView.frame.size.height);
        self.headerView.model = self.mallDetailInfo;
        self.headerView.delegate = self;
        [HeaderView addSubview:self.headerView];
        
        
        CGFloat menuH = 40;
        //    NSArray *   menuTitles = @[@"全部商品", @"品牌专区",@"热销商品"];
        NSArray *   menuTitles = @[@"全部商品", @"品牌专区",@"热销商品"];
        menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), kScreenWidth, menuH) isShowSeparator:YES];
        menu.delegate = self;
        [HeaderView addSubview:menu];
        HeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(menu.frame));
        self.tableView.tableHeaderView = HeaderView;
        [self.view bringSubviewToFront:self.vNavationBar];
    }
    return _tableView;
}
#pragma mark 加载店铺信息
-(void)httpRequestForShopInfo
{

   

    [GYMallBaseInfoModel loadBigShopDataWithVshopid:self.shopModel.strVshopId result:^(NSDictionary *dictData, NSError *error) {
        if (!dictData)
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"系统繁忙，请稍候再试" isPopVC:self.navigationController];
        }
        else
        {
            self.mallDetailInfo = [GYMallBaseInfoModel objectWithKeyValues:dictData];
            if (self.headerView)
            {
                self.headerView.model = self.mallDetailInfo;
            }
            if (!self.shouldRefresh)
            {
                [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
            }
        }
    }];
}
//-(void)httpRequestForShopInfo
//{
//    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
//    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
//    [dict setValue:self.shopModel.strVshopId forKey:@"shopId"];
//    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
//    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getShopInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
//        [Utils hideHudViewWithSuperView:self.view];
//        if (!error)
//        {
//            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
//            
//            if (!error)
//            {
//                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
//                
//                if ([retCode isEqualToString:@"200"])
//                {
//                    self.shopDetailInfo = [GYShopBaseInfoModel objectWithKeyValues:ResponseDic[@"data"]];
//                    [self settupHeader];
//                }
//            }
//            else
//            {
//                [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺信息失败" isPopVC:self.navigationController];
//            }
//        }
//        else
//        {
//            [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺信息失败" isPopVC:self.navigationController];
//        }
//    }];
//    
//}
- (IBAction)showIntroduct:(id)sender {
    GYShopAboutViewController * vcShopDetail =[[GYShopAboutViewController alloc]init];
    vcShopDetail.ShopID=self.shopModel.strShopId;
    vcShopDetail.strVshopId=self.shopModel.strVshopId;
//    vcShopDetail->mp1 = self.currentMp1;
//    vcShopDetail.strShopDistance=[NSString stringWithFormat:@"%.02f",self.shopModel.shopDistance.floatValue];
    vcShopDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vcShopDetail animated:YES];
}
- (IBAction)chatClick:(id)sender {
    [self contactShopRequest];
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
    [dict setValue:[NSString stringWithFormat:@"%@",self.mallDetailInfo.companyResourceNo] forKey:@"resourceNo"];
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
                        // add by songjk
                        chatItem.displayName = chatItem.vshopName;
                        chatItem.resNo = self.mallDetailInfo.companyResourceNo;
                        if (chatItem.vshopName.length == 0 || [chatItem.vshopName isKindOfClass:[NSNull class]] || [chatItem.vshopName rangeOfString:@"null"].location != NSNotFound) {
                            chatItem.vshopName = chatItem.resNo;
                        }
                        chatItem.displayName = chatItem.vshopName;
                        chatItem.msgNote = chatItem.vshopName;
                        
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
            else
            {
                [Utils showMessgeWithTitle:@"友情提示" message:@"联系失败" isPopVC:self.navigationController];
            }
            
        }
        else
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"联系失败" isPopVC:self.navigationController];
        }
        
    }];
    
}
// add by songjk
-(void)loadHotGoodInfoWithItemid:(NSString *)itemid vShopid:(NSString *)vShopid shopID:(NSString *)shopID
{
    __block  SearchGoodModel * MOD;
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%@",shopID] forKey:@"shopId"];
    [dict setValue:[NSString stringWithFormat:@"%@",itemid] forKey:@"itemId"];
    [dict setValue:[NSString stringWithFormat:@"%@",vShopid] forKey:@"vShopId"];
    [Utils showMBProgressHud:self SuperView:self.tableView Msg:@"正在加载数据..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getGoodsInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error)
     {
         [Utils hideHudViewWithSuperView:self.tableView];
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
                     BMKMapPoint mp1 = BMKMapPointForCoordinate([MMLocationManager shareLocation].lastCoordinate);
                     CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                     NSLog(@"%f-----dis,mp1.x = %f,mp1.y = %f",dis,mp1.x,mp1.y);
                     MOD.shopDistance=[NSString stringWithFormat:@"%.02f",dis/1000];
                 }
             }
             else
             {
                 [Utils showMessgeWithTitle:@"友情提示" message:@"加载数据失败" isPopVC:self.navigationController];
                 return ;
             }
             
             
         }
         else
         {
             [Utils showMessgeWithTitle:@"友情提示" message:@"加载数据失败" isPopVC:self.navigationController];
             return ;
         }
         
         [Utils hideHudViewWithSuperView:self.navigationController.view];
         GYGoodDetailViewController * vcGoodDetail =[[GYGoodDetailViewController alloc]initWithNibName:@"GYGoodDetailViewController" bundle:nil];
         
         vcGoodDetail.model=MOD;
         
         self.hidesBottomBarWhenPushed=YES;
         [self.navigationController pushViewController:vcGoodDetail animated:YES];
     }];
}
#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    self.isHotGoods = NO;
    [menu updateMenu:index];
    NSLog(@"%zi====index",index);
    [self setup];
    [self.marrAllGoods removeAllObjects];
    [self.tableView reloadData];
    
    if (index ==0)
    {
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
    }
    else  if (index == 2)
    {
        self.isHotGoods =YES;
        [self getHotGoods];
    }
    
    else if (index == 1)
    {
        GYShopBrandChooseController * vcBrand = [[GYShopBrandChooseController alloc] init];
        vcBrand.strShopID = self.shopModel.strVshopId;
        vcBrand.delegate =self;
        [self.navigationController pushViewController:vcBrand animated:YES];
    }
}
-(void)menuTabViewDidSelectIndex:(NSInteger)index
{
    if (index == 1)
    {
        self.isHotGoods = NO;
        NSLog(@"%zi====index",index);
        [self setup];
        [self.marrAllGoods removeAllObjects];
        [self.tableView reloadData];
        GYShopBrandChooseController * vcBrand = [[GYShopBrandChooseController alloc] init];
        vcBrand.strShopID = self.shopModel.strVshopId;
        vcBrand.delegate =self;
        [self.navigationController pushViewController:vcBrand animated:YES];
    }
}
-(NSString *)strBrandName
{
    if (!_strBrandName) {
        _strBrandName = @"";
    }
    return _strBrandName;
}
#pragma mark ShopBrandChooseControllerDelegate
-(void)ShopBrandChooseControllerDidChooseBrand:(NSString *)brand
{
    self.currentPage = 1;
    self.isHotGoods = NO;
    if (![self.strBrandName isEqualToString:brand] || [brand isEqualToString:@""] || self.marrAllGoods.count == 0)
    {
        self.strBrandName = brand;
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:brand sortType:nil];
    }
}
#pragma mark ShopHeaderDelegate
-(void)ShopHeaderDidSelectShowBigPicWithHeader:(GYShopHeader *)header index:(NSInteger)index
{
    [self showBigPicWithIndex:index];
}
-(void)ShopHeaderDidSelectPayAtentionBtn:(GYShopHeader *)header
{
    // 关注或者取消关注
    [self concernShopRequest];
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
//    [Utils showMBProgressHud:self SuperView:self.tableView  Msg:@"正在发送请求..."];
    if (self.mallDetailInfo.beFocus) {
        [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"正在取消关注..."];
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        [dict setValue:[NSString stringWithFormat:@"%@",self.shopModel.strVshopId] forKey:@"vShopId"];
        [dict setValue:self.shopModel.strVshopId forKey:@"shopId"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/cancelConcernShop" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
            [Utils hideHudViewWithSuperView:self.tableView ];
            if (!error)
            {
                NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (!error)
                {
                    NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"])
                    {
                        self.mallDetailInfo.beFocus=!self.mallDetailInfo.beFocus;
                        [self.headerView changePayAttentionBtnWithStatus:self.mallDetailInfo.beFocus];
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
        
        [dict setValue:[NSString stringWithFormat:@"%@",self.shopModel.strVshopId] forKey:@"vShopId"];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [dict setValue:self.mallDetailInfo.vShopName forKey:@"shopName"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/concernShop" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
            [Utils hideHudViewWithSuperView:self.tableView ];
            if (!error)
            {
                NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (!error)
                {
                    NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"])
                    {
                        self.mallDetailInfo.beFocus=!self.mallDetailInfo.beFocus;
                        [self.headerView changePayAttentionBtnWithStatus:self.mallDetailInfo.beFocus];
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

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
-(void)showBigPicWithIndex:(NSInteger )index
{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i=0; i<self.mallDetailInfo.picList.count; i++) {
        GYShopBaseInfoPicListModel * model = self.mallDetailInfo.picList[i];
        NSString *strUrl =kSaftToNSString(model.url);
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
    [browser setCurrentPhotoIndex:index];
    
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browser animated:YES completion:nil ];
    
}
#pragma mark StoreTableViewCellDelegate
-(void)StoreTableView:(GYStoreTableViewCell *)cell chooseOne:(NSInteger)type model:(GYShopGoodListModel *)model
{
    [self loadHotGoodInfoWithItemid:model.itemId vShopid:self.shopModel.strVshopId shopID:model.shopId];
}
#pragma mark 加载全部商品
-(void)httpRequestForGoodsWithKeyWords:(NSString *)keyWords categoryName:(NSString *)categoryName brandName:(NSString *)brandName sortType:(NSString *)sortType
{
    self.shouldRefresh = YES;
    if (categoryName == nil) {
        categoryName = @"";
    }
    if (brandName == nil) {
        brandName = @"";
    }
    if (keyWords == nil) {
        keyWords = @"";
    }
    if (sortType == nil) {
        sortType = @"0";
    }
//    keyWords = @"白酒";
    keyWords = [keyWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    categoryName = [categoryName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    brandName = [brandName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.shopModel.strVshopId forKey:@"vShopId"];
    [dict setValue:keyWords forKey:@"keyword"];
    [dict setValue:categoryName forKey:@"categoryName"];
    [dict setValue:@"" forKey:@"categoryId"];// add by songjk 传入cid
    [dict setValue:brandName forKey:@"brandName"];
    [dict setValue:sortType forKey:@"sortType"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi",self.currentPage] forKey:@"currentPage"];
        [Utils showMBProgressHud:self SuperView:self.tableView  Msg:@"数据加载中..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/searchShopItem" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.tableView ];
        if (!error)
        {
            if (self.marrAllGoods.count>0 && ![self.tableView.footer isRefreshing]) {
                [self.marrAllGoods removeAllObjects];
            }
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSInteger retCode =kSaftToNSInteger(ResponseDic[@"retCode"]) ;
                self.totalPage = kSaftToNSInteger(ResponseDic[@"totalPage"]);
                if (retCode == 200)
                {
                    if ([ResponseDic[@"data"] count]>0) {
                        self.currentPage ++;
                    }
                    NSArray * arrData = ResponseDic[@"data"];
                    NSMutableArray * arrCell = [NSMutableArray array];
                    for (int i = 0; i<arrData.count; i++)
                    {
                        GYShopGoodListModel * goodModel = [GYShopGoodListModel objectWithKeyValues:arrData[i]];
                        [arrCell addObject:goodModel];
                        if (i%2==1)
                        {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                        else if (i%2!=1 && i == arrData.count-1)
                        {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                    }
                }
            }
            else
            {
                [Utils showMessgeWithTitle:@"友情提示" message:@"加载数据失败" isPopVC:self.navigationController];
                return ;
            }
            
        }
        else
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"加载数据失败" isPopVC:self.navigationController];
            return ;
        }
        
        [self.tableView reloadData];
        if (self.totalPage == 0 || self.totalPage == 1 || self.currentPage == self.totalPage+1) {
            [self.tableView.footer noticeNoMoreData];
        }
        if ([self.tableView.footer isRefreshing]) {
            [self.tableView.footer endRefreshing];
        }
    }];
    
}
//热卖 getHotItemsByVshopId
-(void)getHotGoods
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:self.shopModel.strVshopId forKey:@"vshopId"];
//    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi",self.currentPage] forKey:@"currentPage"];
    [Utils showMBProgressHud:self SuperView:self.tableView  Msg:@"数据加载中..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getHotItemsByVshopId" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.tableView ];
        if (self.marrAllGoods.count>0 && ![self.tableView.footer isRefreshing]) {
            [self.marrAllGoods removeAllObjects];
        }
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode = kSaftToNSString(ResponseDic[@"retCode"]);
                self.totalPage = kSaftToNSInteger(ResponseDic[@"totalPage"]);
                NSArray * arrData = ResponseDic[@"data"];
                if (![arrData isKindOfClass:[NSNull class]] && [retCode isEqualToString:@"200"])
                {
                    if ([ResponseDic[@"data"] count]>0) {
                        self.currentPage ++;
                    }
                    NSMutableArray * arrCell = [NSMutableArray array];
                    for (int i = 0; i<arrData.count; i++)
                    {
                        NSDictionary * tempDict = arrData[i];
                        GYShopGoodListModel * goodModel = [[GYShopGoodListModel alloc] init];
                        goodModel.itemId = kSaftToNSString(tempDict[@"itemId"]);
                        goodModel.itemName = kSaftToNSString(tempDict[@"itemName"]);
                        goodModel.price = kSaftToNSString(tempDict[@"price"]);
                        goodModel.pv = kSaftToNSString(tempDict[@"pv"]);
                        goodModel.rate = kSaftToNSString(tempDict[@"rate"]);
                        goodModel.salesCount =  kSaftToNSString(tempDict[@"salesCount"]);
                        goodModel.url = kSaftToNSString(tempDict[@"url"]);
                        goodModel.shopId = kSaftToNSString(tempDict[@"shopId"]);
                        [arrCell addObject:goodModel];
                        if (i%2==1)
                        {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                        else if (i%2!=1 && i == arrData.count-1)
                        {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                    }
                }
            }
        }
        [self.tableView reloadData];
        if (self.totalPage == 0 || self.totalPage == 1 || self.currentPage == self.totalPage+1) {
            [self.tableView.footer noticeNoMoreData];
        }
        if ([self.tableView.footer isRefreshing]) {
            [self.tableView.footer endRefreshing];
        }
    }];
}
@end

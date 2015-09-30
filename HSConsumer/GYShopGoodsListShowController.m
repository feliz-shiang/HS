//
//  GYShopGoodsListShowController.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYShopGoodsListShowController.h"
#import "GYShopBaseInfoModel.h"
#import "GYStoreTableViewCell.h"
#import "GYShopGoodListModel.h"
#import "GYShopGoodListModel.h"
#import "MJExtension.h"
#import "GYHotItemGoods.h"
#import "MJRefresh.h"
#define kCellIdentifier  @"storeCellIndentifer"

// 热卖商品用
#define pageCount 10

@interface GYShopGoodsListShowController ()<StoreTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray * marrAllGoods;

// 热卖商品用
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPage;
//@property (nonatomic,strong) UITableView * tvAllGoods;
@end

@implementation GYShopGoodsListShowController
//-(UITableView *)tvAllGoods
//{
//    if (!_tvAllGoods)
//    {
//        _tvAllGoods = [[UITableView alloc ] initWithFrame:self.view.bounds];
//        _tvAllGoods.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tvAllGoods.backgroundColor = kDefaultVCBackgroundColor;
//        [_tvAllGoods registerNib:[UINib nibWithNibName:@"GYStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
//    }
//    _tvAllGoods.delegate = self;
//    _tvAllGoods.dataSource = self;
//    return _tvAllGoods;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
}
-(NSMutableArray *)marrAllGoods
{
    if (!_marrAllGoods) {
        _marrAllGoods = [NSMutableArray array];
    }
    return _marrAllGoods;
}
-(NSString *)strBrandName
{
    if (_strBrandName == nil) {
        _strBrandName = @"";
    }
    return _strBrandName;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}
-(void)setup
{
    self.currentPage = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"GYStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    if (self.isHotGood) {
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    }
}
-(void)footerRereshing
{
    [self getHotGoods];
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrAllGoods.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
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
#pragma mark StoreTableViewCellDelegate
-(void)StoreTableView:(GYStoreTableViewCell *)cell chooseOne:(NSInteger)type model:(GYShopGoodListModel *)model
{
    if ([self.delegate respondsToSelector:@selector(ShopGoodsListShowController:model:)])
    {
        [self.delegate ShopGoodsListShowController:self model:model];
    }
}
#pragma mark 加载全部商品
-(void)httpRequestForGoodsWithKeyWords:(NSString *)keyWords categoryName:(NSString *)categoryName brandName:(NSString *)brandName sortType:(NSString *)sortType
{
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
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.shopDetailInfo.vShopId forKey:@"vShopId"];
    [dict setValue:keyWords forKey:@"keyword"];
    [dict setValue:categoryName forKey:@"categoryName"];
    [dict setValue:brandName forKey:@"brandName"];
    [dict setValue:sortType forKey:@"sortType"];
//    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/searchShopItem" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
//        [Utils hideHudViewWithSuperView:self.view];
        if (!error)
        {
            if (self.marrAllGoods.count>0) {
                [self.marrAllGoods removeAllObjects];
            }
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSInteger retCode =kSaftToNSInteger(ResponseDic[@"retCode"]) ;
                if (retCode == 200)
                {
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
    }];
    
}
//热卖
-(void)getHotGoods
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:self.shopDetailInfo.vShopId forKey:@"vshopId"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi",self.currentPage] forKey:@"currentPage"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getHotItemsByVshopId" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
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
                if ([retCode isEqualToString:@"200"]) {
                    if ([ResponseDic[@"data"] count]>0) {
                        self.currentPage ++;
                    }
                    NSArray * arrData = ResponseDic[@"data"];
                    NSMutableArray * arrCell = [NSMutableArray array];
                    for (int i = 0; i<arrData.count; i++)
                    {
                        NSDictionary * tempDict = arrData[i];
                        GYShopGoodListModel * goodModel = [[GYShopGoodListModel alloc] init];
                        goodModel.itemId = kSaftToNSString(tempDict[@"itemId"]);
                        goodModel.itemName = kSaftToNSString(tempDict[@"itemName"]);
                        goodModel.price = kSaftToNSString(tempDict[@"price"]);
                        goodModel.pv = kSaftToNSString(tempDict[@"pv"]);
                        goodModel.rate = @"0";
                        goodModel.salesCount =  @"0";
                        goodModel.url = kSaftToNSString(tempDict[@"url"]);
                        
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

//
//  GYConcernsCollectGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYConcernsCollectGoodsViewController.h"
#import "MJRefresh.h"
#import "CellGoodsNameAndPriceCell.h"
#import "GYEasyBuyModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+CustomBorder.h"
#import "GYGoodsDetailController.h"
#import "ViewTipBkgView.h"

@interface GYConcernsCollectGoodsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD *hud;
    ViewTipBkgView *viewTipBkg;
}
@end

@implementation GYConcernsCollectGoodsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    [viewTipBkg.lbTip setText:kLocalized(@"您还没有关注的记录哦~")];
    [self.view addSubview:viewTipBkg];
    viewTipBkg.hidden = YES;

    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellGoodsNameAndPriceCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];

    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    CGRect hfFrame = self.tableView.bounds;
    hfFrame.size.height = kDefaultMarginToBounds;
    UIView *vHeader = [[UIView alloc] initWithFrame:hfFrame];
    [vHeader setBackgroundColor:self.view.backgroundColor];
    [vHeader addBottomBorder];
    self.tableView.tableHeaderView = vHeader;
    
    hfFrame.size.height = 30;
    UIView *vFooter = [[UIView alloc] initWithFrame:hfFrame];
    [vFooter setBackgroundColor:self.view.backgroundColor];
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        [vFooter addTopBorder];
    self.tableView.tableFooterView = vFooter;
    
    [self getConcernsCollectGoodsListIsAppendResult:NO andShowHUD:YES];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

    
    
    
//    [self headerRereshing];
//    
//    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    //    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    //自动刷新(一进入程序就下拉刷新)
//    //    [self.tableView headerBeginRefreshing];
//    // 设置文字(默认的文字在MJRefreshConst中修改)
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (hud.superview)
    {
        [[Network sharedInstance] cancelAllOperation];
        [hud removeFromSuperview];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cll = nil;
    
    CellGoodsNameAndPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    if (!cell)
    {
        cell = [[CellGoodsNameAndPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    }
    
    GYEasyBuyModel *eb = self.arrResult[row];
    cell.lbGoodsName.text = eb.strGoodName;
    cell.lbPrice.text = [Utils formatCurrencyStyle:[eb.strGoodPrice doubleValue]];
    cell.ivGoodsImage.image = kLoadPng(eb.strGoodPictureURL);
    
    NSString *imgUrl = eb.strGoodPictureURL;
    [cell.ivGoodsImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];

    cll = cell;
    return cll;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYGoodsDetailController * vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYGoodsDetailController class]));
    vcGoodDetail.model = self.arrResult[indexPath.row];
    
    GYEasyBuyModel *model = self.arrResult[indexPath.row];
    DDLogDebug(@"model.goodsid:%@", model.strGoodId);
    DDLogDebug(@"model.shopInfo.strShopId:%@", model.shopInfo.strShopId);
    
    
    self.hidesBottomBarWhenPushed = YES;
    [self pushVC:vcGoodDetail animated:YES];
    //    if (indexPath.section == 0) return;
    //
    //    NSArray *arrAcc = self.arrResult[indexPath.section];
    //    NSString *nextVCName = arrAcc[indexPath.row][kKeyNextVcName];
    //    NSString *nextVCTitle = arrAcc[indexPath.row][kKeyAccName];
//        UIViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
//        vc.navigationItem.title = kLocalized(@"ep_order_detail");
//        if (vc)
//        {
//            [self pushVC:vc animated:YES];
//        }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)//删除
//    {
//        [self.arrResult removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kLocalized(@"ep_delete");
//}

//可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self requestToCancelCollect:indexPath];
        //数据请求成功后，再删除tableView的数据
    }
}

#pragma mark-  删除服务器上的收藏数据
-(void)requestToCancelCollect:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    GYEasyBuyModel *model=self.arrResult[indexPath.row];
    [dict setValue:model.strGoodId forKey:@"itemId"];
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/cancelCollectionGoods",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                NSLog(@"取消收藏成功");
                
                [self.arrResult  removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //设置菜单角标
                NSString *goods;
                if(self.arrResult.count!=0)
                {
                    goods=[NSString stringWithFormat:@"商品(%lu)",self.arrResult.count];
                }
                else
                {
                    goods=@"商品";
                    viewTipBkg.hidden=NO;
                }
                if(self.block)
                {
                    self.block(0,goods);
                    
                }
                else
                {
                    
                }

                [Utils showMessgeWithTitle:nil message:@"取消关注成功！" isPopVC:nil];
                
                
            }else{
                
               [Utils showMessgeWithTitle:nil message:@"取消关注失败！" isPopVC:nil];
            }
        }
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLocalized(@"cancel_collection");
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav)
    {
        [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
        [self.nav pushViewController:vc animated:ani];
    }
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getConcernsCollectGoodsListIsAppendResult:NO andShowHUD:NO];
}

- (void)getConcernsCollectGoodsListIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey};
    
//    MBProgressHUD *hud = nil;
    if (isShow)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        [self.nav.view addSubview:hud];
        //    hud.labelText = @"初始化数据...";
        [hud show:YES];
    }
    
    [Network  HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getMyConcernGoods"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
        
        if (!append)
        {
            self.arrResult = [NSMutableArray array];
        }
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            //            DDLogInfo(@"get_integral_act_trade_list dic:%@", dic);
            
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSArray *arrItems = dic[@"data"];
                    GYEasyBuyModel *model = nil;
                    for (NSDictionary *dicItem in arrItems)
                    {
                        model = [[GYEasyBuyModel alloc] init];
                        model.strGoodName = kSaftToNSString(dicItem[@"title"]);
                        model.strGoodId = kSaftToNSString(dicItem[@"id"]);
                        model.strGoodPrice = kSaftToNSString(dicItem[@"price"]);
                        model.strGoodPictureURL = kSaftToNSString(dicItem[@"url"]);
                        
                        ShopModel * shopModel =[[ShopModel alloc] init];
                        shopModel.strShopId = kSaftToNSString(dicItem[@"vShopId"]);
                        model.shopInfo = shopModel;

                        [self.arrResult addObject:model];
                    }
                    
                }else//返回失败数据
                {
                    [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
                }
            }else
            {
                [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
            }
            
        }else
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.arrResult isKindOfClass:[NSNull class]])
            {
                self.arrResult = nil;
            }
            self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            viewTipBkg.hidden = !self.tableView.hidden;
            
            NSString *title = kLocalized(@"ep_concerns_collect_goods");
            if (!self.tableView.hidden)
            {
                title = [NSString stringWithFormat:@"%@(%lu)", kLocalized(@"ep_concerns_collect_goods"), self.arrResult.count];
            }
            if (self.btnMenu)
            {
                [self.btnMenu setTitle:title forState:UIControlStateNormal];
            }
            
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        });
    }];
}

//- (void)footerRereshing
//{
//    //    // 1.添加假数据
//    //    for (int i = 0; i<5; i++) {
//    //        [self.fakeData addObject:MJRandomData];
//    //    }
//    static int i;
//    NSLog(@"rereshing:%d", i++);
//    
//    
//    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tableView footerEndRefreshing];
//    });
//}


@end

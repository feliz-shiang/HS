//
//  GYBrowsingHistoryViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYBrowsingHistoryViewController.h"
#import "CellGoodsNameAndPriceCell.h"
#import "GYEasyBuyModel.h"
#import "UIView+CustomBorder.h"
#import "EasyPurchaseData.h"
#import "UIImageView+WebCache.h"
#import "GYGoodsDetailController.h"
#import "GYEasyPurchaseMainViewController.h"
#import "ViewTipBkgView.h"

@interface GYBrowsingHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    ViewTipBkgView *viewTipBkg;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrResult;

@end

@implementation GYBrowsingHistoryViewController

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

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    [viewTipBkg.lbTip setText:kLocalized(@"您还没有商品浏览记录哦~")];
    [self.view addSubview:viewTipBkg];
    viewTipBkg.hidden = YES;

    //初始化设置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellGoodsNameAndPriceCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView.tableHeaderView setHidden:YES];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

//    //设置显示测试结果
//    if (!self.arrResult)//用于测试
//    {
//        self.arrResult = [[NSMutableArray alloc] init];
//        int i = 0;
//        for (i = 0; i < 20; i++)
//        {
//            [self.arrResult addObject:[GYEasyBuyModel initWithName:[NSString stringWithFormat:@"麦片 %d", i]
//                                                             price:[NSString stringWithFormat:@"%.2f", 10.0 * i]
//                                                        pictureURL:[NSString stringWithFormat:@"classification%d",i%10]]];
//        }
//    }
    
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
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadBrowsingHistory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    CellGoodsNameAndPriceCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    if (!cell)
    {
        cell = [[CellGoodsNameAndPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    }
    GYEasyBuyModel *eb = self.arrResult[row];
    cell.lbGoodsName.text = eb.strGoodName;
    cell.lbPrice.text = [Utils formatCurrencyStyle:[eb.strGoodPrice doubleValue]];
//    [cell.ivGoodsImage sd_setImageWithURL:[NSURL URLWithString:eb.strGoodPictureURL]];//kLoadPng(@"ep_placeholder_image_type1")
    [cell.ivGoodsImage sd_setImageWithURL:[NSURL URLWithString:eb.strGoodPictureURL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)//删除
    {
        [self deleteBrowsingHistory:self.arrResult[indexPath.row]];
        [self.arrResult removeObjectAtIndex:indexPath.row];
        if (self.arrResult.count == 0)
        {
            [self loadBrowsingHistory];
        }else
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLocalized(@"ep_delete");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYGoodsDetailController * vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYGoodsDetailController class]));
    vcGoodDetail.model = self.arrResult[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

- (void)loadBrowsingHistory
{
//    if (![GlobalData shareInstance].isEcLogined)
//    {
//        viewTipBkg.hidden = NO;
//        [self.tableView setHidden:YES];
//        return;
//    }
//    NSString *key = [kKeyForBrowsingHistory stringByAppendingString:[GlobalData shareInstance].user.cardNumber];
    
    NSString *key = kKeyForBrowsingHistory;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicBrowsing = [userDefault objectForKey:key];

    if (!dicBrowsing)
    {
        viewTipBkg.hidden = NO;
        [self.tableView setHidden:YES];
        return;
    }
        
    self.arrResult = [[NSMutableArray alloc] init];
    for (NSString *key in [dicBrowsing allKeys])
    {
        NSDictionary *dic = dicBrowsing[key];
        GYEasyBuyModel * model = [[GYEasyBuyModel alloc] init];
        model.strGoodPictureURL = dic[@"goodsPictureUrl"];
        model.strGoodName = dic[@"goodsName"];
        model.strGoodPrice = dic[@"goodsPrice"];
        model.strGoodId = dic[@"goodsId"];
        model.strGoodPictureURL = dic[@"goodsPictureUrl"];
        model.numBroweTime = dic[@"numBroweTime"];

        ShopModel * shopModel =[[ShopModel alloc] init];
        shopModel.strShopId = dic[@"shopId"];
        model.shopInfo = shopModel;
        
        [self.arrResult addObject:model];
    }
    if ([self.arrResult isKindOfClass:[NSNull class]])
    {
        self.arrResult = nil;
    }

    self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
    viewTipBkg.hidden = !self.tableView.hidden;
    
    NSArray *sortedArray = [self.arrResult sortedArrayUsingComparator:^NSComparisonResult(GYEasyBuyModel *p1, GYEasyBuyModel *p2){//倒序
        return [p2.numBroweTime compare:p1.numBroweTime];
    }];
    self.arrResult = [sortedArray mutableCopy];
    [self.tableView reloadData];
}

- (void)deleteBrowsingHistory:(GYEasyBuyModel *)model
{
//    if (![GlobalData shareInstance].isEcLogined)
//    {
//        viewTipBkg.hidden = NO;
//        [self.tableView setHidden:YES];
//        return;
//    }
//    
//    NSString *key = [kKeyForBrowsingHistory stringByAppendingString:[GlobalData shareInstance].user.cardNumber];
    
    NSString *key = kKeyForBrowsingHistory;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    [dicBrowsing removeObjectForKey:model.strGoodId];
    
    //保存
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
}

@end

//
//  GYEPMyOrderViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kPageSize 10
#define kCellSubCellHeight 80.f

#import "GYEPMyOrderViewController.h"
#import "MJRefresh.h"
#import "ViewHeaderForMyOrder.h"
#import "ViewFooterForMyOrder.h"
#import "CellForMyOrderCell.h"
#import "ViewTipBkgView.h"
#import "GYEasyPurchaseMainViewController.h"

@interface GYEPMyOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ViewTipBkgView *viewTipBkg;

    int pageSize;   //每次/每页获取多少行记录
    int pageNo;     //下一页
}
// add by songjk 记录通知传来的nsnumber
@property (nonatomic,copy) NSString * strNumber;
@end

@implementation GYEPMyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isQueryRefundRecord = NO;
        _orderState = kOrderStateAll;
        _firstTipsErr = NO;
        _startPageNo = 1;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageSize = kPageSize;
    pageNo = _startPageNo;
    //注册通知
    NSString * strNotificationName = [kNotificationNameRefreshOrderList stringByAppendingString:[@(self.orderState) stringValue]];
    NSLog(@"strNotificationName = %@",strNotificationName);
    // modify by songjk
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:strNotificationName object:nil];

    if (self.navigationController)//用于传下一界面
        self.nav = self.navigationController;
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    if (self.isQueryRefundRecord)
    {
        [viewTipBkg.lbTip setText:kLocalized(@"您还没有退换货记录！")];
    }else
    {
        [viewTipBkg.lbTip setText:kLocalized(@"您还没有相关订单记录！")];
    }
    //zhangqy
//    [self.view addSubview:viewTipBkg];
//    viewTipBkg.hidden = YES;
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];

    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
        [self.tableView registerClass:[CellForMyOrderCell class] forCellReuseIdentifier:kCellForMyOrderCellIdentifier];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
  
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self getMyOrderlistIsAppendResult:NO andShowHUD:YES];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}


-(void)viewWillDisappear:(BOOL)animated
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
    [self headerRereshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellid = kCellForMyOrderCellIdentifier;
    CellForMyOrderCell *cell = nil;
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];//使用此方法加载，必须先注册nib或class
    } else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    }
    if (!cell)
    {
        cell = [[CellForMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        NSLog(@"init load detail:%d", (int)row);
    }
    // add by songjk 改变付款状态
    NSMutableDictionary * dictData = [NSMutableDictionary dictionaryWithDictionary:self.arrResult[row]] ;
    NSString *orderNum = [dictData objectForKey:@"number"];
    if (self.strNumber && [self.strNumber isEqualToString:orderNum]) {
        [dictData setValue:@"1" forKey:@"status"];
    }
    
    NSInteger subRows = [self.arrResult[row][@"items"] count];
    cell.cellSubCellRowHeight = kCellSubCellHeight;
//    [cell.tableView setUserInteractionEnabled:NO];
    cell.tableView.frame = CGRectMake(0,
                                      0,
                                      kScreenWidth,
                                      [ViewFooterForMyOrder getHeight] +
                                      [ViewHeaderForMyOrder getHeight] +
                                      subRows * kCellSubCellHeight);
    cell.dicDataSource = dictData;
    
    cell.nav = self.nav;
    cell.isQueryRefundRecord = self.isQueryRefundRecord;
    cell.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell reloadData];//表格嵌套，复用须 reloaddata，否则无法更新数据
    });
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ViewFooterForMyOrder getHeight] +
    [ViewHeaderForMyOrder getHeight] +
    [self.arrResult[indexPath.row][@"items"] count] * kCellSubCellHeight +
    kDefaultMarginToBounds;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@-----datasource",self.arrResult[indexPath.row]);
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav)
    {
        [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
        [self.nav pushViewController:vc animated:ani];
    }
}
// add by songjk 刷新通知  用于银联付款
-(void)refreshData:(NSNotification*)sender
{
    self.strNumber = [sender object];
    NSLog(@"strNumber = %@",self.strNumber);
    pageNo = _startPageNo;
    [self.tableView.footer resetNoMoreData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMyOrderlistIsAppendResult:NO andShowHUD:NO];
    });
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
//    pageSize = kPageSize;
    pageNo = _startPageNo;
    [self.tableView.footer resetNoMoreData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMyOrderlistIsAppendResult:NO andShowHUD:NO];
    });
}

- (void)getMyOrderlistIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSString *sUrl = @"/easybuy/getMyOrder";
    NSMutableDictionary *allParas = [@{@"key": data.ecKey,
                                       @"count": [@(pageSize) stringValue],
                                       @"currentPage": [@(pageNo) stringValue]
                                       } mutableCopy];
    
    if (self.isQueryRefundRecord)
    {
        sUrl = @"/easybuy/getRefundRecord";
    }else
    {
        if (self.orderState != kOrderStateAll)
        {
            if (self.orderState == kOrderStateWaittingConfirmReceiving)
            {
                [allParas setObject:[NSString stringWithFormat:@"%ld,%ld", self.orderState, kOrderStateSellerWaittingPayConfirm] forKey:@"status"];
            }else
                [allParas setObject:[@(self.orderState) stringValue] forKey:@"status"];
        }
    }
    
    MBProgressHUD *hud = nil;
    if (isShow)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        [self.nav.view addSubview:hud];
        //    hud.labelText = @"初始化数据...";
        [hud show:YES];
    }
    
    [Network  HttpGetForRequetURL:[data.ecDomain stringByAppendingString:sUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
        if (!append)
        {
            if (self.arrResult && self.arrResult.count > 0)
            {
                [self.arrResult removeAllObjects];
                self.arrResult = nil;
            }
            self.arrResult = [NSMutableArray array];
        }
        
        BOOL hasNext = NO;
        
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
                    int totalPage = kSaftToNSInteger(dic[@"totalPage"]);
//                    self.arrResult =  dic[@"data"];
                    if (dic[@"data"] && [dic[@"data"] isKindOfClass:[NSArray class]])
                    {
                        [self.arrResult addObjectsFromArray:dic[@"data"]];
                        // add by songjk 待付款刷新付款之后数据
                        if (self.orderState == kOrderStateWaittingPay)
                        {
                            for (NSDictionary * dict in self.arrResult)
                            {
                                NSString * strNumber = [dict objectForKey:@"number"];
                                if (self.strNumber && [strNumber isEqualToString:self.strNumber]) {
                                    [self.arrResult removeObject:dict];
                                    break;
                                }
                            }
                        }
                    }else
                    {
                        [self.arrResult addObjectsFromArray:@[]];
                    }
                    pageNo++;
                    if (pageNo <= totalPage)
                    {
                        hasNext = YES;
                    }
                    
                }else//返回失败数据
                {
                    if (self.firstTipsErr)
                        [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
                }
            }else
            {
                if (self.firstTipsErr)
                    [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
            }            
        }else
        {
            if (self.firstTipsErr)
                [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.firstTipsErr = YES;
            
            if ([self.arrResult isKindOfClass:[NSNull class]])//{"currentPageIndex":null,"data":null,"msg":null,"retCode":200,"rows":null,"totalPage":null}
            {
                self.arrResult = nil;
            }
            //modify by zhangqy
//            self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
//            viewTipBkg.hidden = !self.tableView.hidden;
            self.tableView.footer.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            if (self.tableView.footer.hidden) {
                self.tableView.tableFooterView = viewTipBkg;
            }
            else
            {
                self.tableView.tableFooterView = nil;
            }

//            [lbNoResultTip setText:self.tableView.hidden ? kLocalized(@"details_no_result") : @""];

            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            if (!hasNext)
            {
                [self.tableView.footer noticeNoMoreData];//必须要放在reload后面
            }
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        });
    }];
}

- (void)footerRereshing
{
    [self getMyOrderlistIsAppendResult:YES andShowHUD:NO];
}

@end

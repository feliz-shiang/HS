//
//  GYEPMyOrderViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kPageSize 10

#import "GYEPMyCouponsViewController.h"
#import "MJRefresh.h"
#import "CellForMyCouponsCell.h"
#import "ViewTipBkgView.h"
#import "DiscountModel.h"

@interface GYEPMyCouponsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ViewTipBkgView *viewTipBkg;
    NSArray *arrLabelTexts;
    int pageSize;   //每次/每页获取多少行记录
    int pageNo;     //下一页
}
@end

@implementation GYEPMyCouponsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _firstTipsErr = NO;
        _startPageNo = 1;
        _couponsType = kCouponsTypeUnUse;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageSize = kPageSize;
    pageNo = _startPageNo;

    if (self.navigationController)//用于传下一界面
        self.nav = self.navigationController;
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    // add by songjk
    if (![GlobalData shareInstance].user.isRealNameRegistration)//没有实名注册的
    {
        [viewTipBkg.lbTip setText:kLocalized(@"实名注册成功后可以享有平台5000元抵扣券")];
        viewTipBkg.hidden = NO;
        [self.view addSubview:viewTipBkg];
        self.tableView.hidden = YES;
        return;
    }
    if (self.couponsType == kCouponsTypeUnUse)
    {
        [viewTipBkg.lbTip setText:kLocalized(@"您还没有消费抵扣券！")];
    }else
    {
        [viewTipBkg.lbTip setText:kLocalized(@"您还没有已使用的消费抵扣券！")];
    }
    viewTipBkg.hidden = YES;
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForMyCouponsCell class]) bundle:kDefaultBundle]
             forCellReuseIdentifier:kCellForMyCouponsCellIdentifier];

    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
  
    arrLabelTexts = @[@"面值",
                      @"可用数量",
                      @"已用数量",
                      @"有效期"
                      ];
    if (self.couponsType == kCouponsTypeUsed)
    {
        arrLabelTexts = @[@"面值",
                          @"使用数量",
                          @"使用时间",
                          @"订单号"
                          ];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self getMyOrderlistIsAppendResult:NO andShowHUD:YES];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellid = kCellForMyCouponsCellIdentifier;
    CellForMyCouponsCell *cell = nil;
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];//使用此方法加载，必须先注册nib或class
    } else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    }
    if (!cell)
    {
        cell = [[CellForMyCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.lbRow1L.text = arrLabelTexts[0];
    cell.lbRow2L.text = arrLabelTexts[1];
    cell.lbRow3L.text = arrLabelTexts[2];
    cell.lbRow4L.text = arrLabelTexts[3];
    
    DiscountModel *model = self.arrResult[row];
    cell.lbRow0.text = model.couponName;
    cell.lbRow1R.text = [Utils formatCurrencyStyle:[model.faceValue doubleValue]];
    if (self.couponsType == kCouponsTypeUnUse)
    {
        cell.lbRow2R.text = model.surplusNum;
        cell.lbRow3R.text = model.usedNumber;
        NSDate *cdate = [NSDate dateWithTimeIntervalSince1970:[model.expEnd longLongValue] / 1000];
        NSString * exEndTime = [Utils dateToString:cdate dateFormat:@"yyyy-MM-dd"];
        if ([exEndTime hasPrefix:@"1970"]) {
            exEndTime = @"长期";
        }
        cell.lbRow4R.text = exEndTime ;
    }else if (self.couponsType == kCouponsTypeUsed)
    {
        cell.lbRow2R.text = model.surplusNum;
        NSDate *cdate = [NSDate dateWithTimeIntervalSince1970:[model.couponUseTime longLongValue] / 1000];
        cell.lbRow3R.text = [Utils dateToString:cdate];
        cell.lbRow4R.text = model.orderNo;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CellForMyCouponsCell getHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSString *sUrl = [@"/easybuy/" stringByAppendingString:@"getMyVoucher"];//未使用
    if (self.couponsType == kCouponsTypeUsed)
    {
        sUrl = [@"/easybuy/" stringByAppendingString:@"getUsedVoucher"];    //已使用
    }
    NSMutableDictionary *allParas = [@{@"key": data.ecKey,
                                       @"count": [@(pageSize) stringValue],
                                       @"currentPage": [@(pageNo) stringValue]
                                       } mutableCopy];
    
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
            
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSInteger totalPage = kSaftToNSInteger(dic[@"totalPage"]);
//                    self.arrResult =  dic[@"data"];
                    NSMutableArray *marrValue = [NSMutableArray array];
                    if (dic[@"data"] && [dic[@"data"] isKindOfClass:[NSArray class]])
                    {
                        for (NSDictionary *dicTmp in dic[@"data"])
                        {
                            if (![dicTmp isKindOfClass:[NSDictionary class]])
                            {
                                continue;
                            }
                            DiscountModel *model = [[DiscountModel alloc] init];
                            model.couponName = kSaftToNSString(dicTmp[@"couponName"]);
                            model.faceValue = kSaftToNSString(dicTmp[@"faceValue"]);
                            
                            if (self.couponsType == kCouponsTypeUnUse)
                            {
                                model.surplusNum = kSaftToNSString(dicTmp[@"surplusNumber"]);
                                model.usedNumber = kSaftToNSString(dicTmp[@"usedNumber"]);
                                model.expEnd = kSaftToNSString(dicTmp[@"expEnd"]);

                            }else if (self.couponsType == kCouponsTypeUsed)
                            {
                                model.surplusNum = kSaftToNSString(dicTmp[@"number"]);
                                model.couponUseTime = kSaftToNSString(dicTmp[@"couponUseTime"]);
                                model.orderNo = kSaftToNSString(dicTmp[@"orderNo"]);
                            }
                            [marrValue addObject:model];
                        }
                        
                        [self.arrResult addObjectsFromArray:marrValue];

                    }else
                    {
                        [self.arrResult addObjectsFromArray:marrValue];
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
            
            if ([self.arrResult isKindOfClass:[NSNull class]])
            {
                self.arrResult = nil;
            }
            
            self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            viewTipBkg.hidden = !self.tableView.hidden;
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

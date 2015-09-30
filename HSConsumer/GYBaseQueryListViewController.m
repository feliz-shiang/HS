//
//  GYBaseQueryListViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询类

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define kCellSubCellHeight 18.f

#import "GYBaseQueryListViewController.h"
#import "DropDownListView.h"
#import "GlobalData.h"
#import "CellViewDetailCell.h"
#import "CellDetailRow.h"
#import "UIView+CustomBorder.h"
#import "GYInvestDividendsDetailsViewController.h"
#import "ViewTipBkgView.h"
#import "MJRefresh.h"

@interface GYBaseQueryListViewController ()<UITableViewDataSource,
UITableViewDelegate, DropDownListViewDelegate>
{
    GlobalData *data;             //全局单例

    IBOutlet UILabel *lbLabelSelectLeft;    //显示左边选中的菜单
    IBOutlet UILabel *lbLabelSelectRight;   //显示右边选中的菜单
    ViewTipBkgView *viewTipBkg;

    IBOutlet UIView *ivSelectorBackgroundView;//菜单背景
    IBOutlet UIView *ivMenuSeparator;   //菜单分隔列
    
    IBOutlet UIButton *btnMenuLeft; //左边菜单箭头
    IBOutlet UIButton *btnMenuRight;//右边菜单箭头
    
    DropDownListView *selectorLeft; //左边弹出菜单
    DropDownListView *selectorRight;//右边弹出菜单
    
    NSDictionary *dicConf;          //取得明细的配置文件对应模块
    NSDictionary *dicTransCodes;    //交易类型字典
    NSArray *arrListProperty;  //取得列表的属性文件
    
    int pageSize;   //每次/每页获取多少行记录
//    BOOL isHasNext; //有下一页
    int pageNo;    //下一页
//    NSDictionary *jsonDataDic;//测试的本地数据
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeftDropMenu;
@property (nonatomic, strong) NSArray *arrRightDropMenu;
@property (nonatomic, strong) NSMutableArray *arrQueryResult;

@end

@implementation GYBaseQueryListViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isShowBtnDetail = YES;
        _startPageNo = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_isShowBtnDetail) {
        lbLabelSelectLeft.hidden=YES;
        lbLabelSelectRight.hidden=YES;
        ivSelectorBackgroundView.hidden=YES;
        ivMenuSeparator.hidden=YES;
        btnMenuLeft.hidden=YES;
        btnMenuRight.hidden=YES;
        CGRect frame=self.tableView.frame;
        frame.origin.y=0;
        self.tableView.frame=frame;
    }
    //实例化单例
    data = [GlobalData shareInstance];
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    [viewTipBkg.lbTip setText:kLocalized(@"报歉，暂无相关记录！")];
    [self.view addSubview:viewTipBkg];
    viewTipBkg.hidden = YES;

    [ivSelectorBackgroundView addTopBorder];
    [ivSelectorBackgroundView addBottomBorder];
    
    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(160, 160, 160, 1)];
    
    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelSelectLeft labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbLabelSelectRight labelLines:1];
    
    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
        [self.tableView registerClass:[CellViewDetailCell class] forCellReuseIdentifier:kCellViewDetailCellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];

    //    [self.tableView setBackgroundView:nil];
    //    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //    self.tableView.hidden = YES;
    
    //设置下拉菜单单击事件
    UITapGestureRecognizer *singleTapRecognizerLeft = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerLeft.numberOfTapsRequired = 1;
    [singleTapRecognizerLeft addTarget:self action:@selector(selectorLeftClick:)];
    lbLabelSelectLeft.userInteractionEnabled = YES;
    //modify by zhangqy
    [lbLabelSelectLeft addGestureRecognizer:singleTapRecognizerLeft];
    
    UITapGestureRecognizer *singleTapRecognizerRight = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerRight.numberOfTapsRequired = 1;
    [singleTapRecognizerRight addTarget:self action:@selector(selectorRightClick:)];
    lbLabelSelectRight.userInteractionEnabled = YES;
    
    
    // add by songjk 当只有选择只有一个的时候不提供下拉
    if (self.arrRightParas.count <=1)
    {
        lbLabelSelectRight.userInteractionEnabled = NO;
        btnMenuRight.hidden=YES;
    }
    if (self.arrLeftParas.count<=1) {
        lbLabelSelectLeft.userInteractionEnabled = NO;
        btnMenuLeft.hidden=YES;
    }
    //modify by zhangqy
    [lbLabelSelectRight addGestureRecognizer:singleTapRecognizerRight];
    
    pageSize = 10;
    pageNo = _startPageNo;
    if (data.dicHsConfig)
    {
        NSString *dicKey = [@"conf_" stringByAppendingString:[@(self.detailsCode) stringValue]];
        dicConf = data.dicHsConfig[dicKey];
        DDLogInfo(@"明细的配置字典dicConf(key:%@): %@", dicKey, [Utils dictionaryToString:dicConf]);
        self.arrLeftDropMenu = dicConf[@"list_left_menu"];
        self.arrRightDropMenu = dicConf[@"list_rigth_menu"];
        arrListProperty = dicConf[@"list_property"];
        pageSize =  [dicConf[@"list_pageSize"] intValue];
        dicTransCodes = dicConf[@"trans_code_list"];
    }else
    {
        DDLogInfo(@"未能找到查询明细列表的配置文件。");
        [self.tableView setHidden:YES];
        [Utils showMessgeWithTitle:@"Config File Not Found" message:@"Please reinstall the app." isPopVC:self.navigationController];
        return;
    }
    
    if (!self.arrLeftParas|| !self.arrRightParas)//左 右下拉菜单 必须项
    {
        DDLogInfo(@"Params init error.");
        [self.tableView setHidden:YES];
        [Utils showMessgeWithTitle:nil message:@"Params init error." isPopVC:self.navigationController];
        return;
    }
    
    CGRect rFrameLeft = lbLabelSelectLeft.frame;
    rFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft = [[DropDownListView alloc] initWithArray:arrLeftDropMenu parentView:self.view widthSenderFrame:rFrameLeft];
    //设置初始值
    selectorLeft.selectedIndex = 0;
    lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
    selectorLeft.isHideBackground = NO;
    selectorLeft.delegate = self;
    
    CGRect rFrameRight = lbLabelSelectRight.frame;
    rFrameRight.origin.x = CGRectGetMaxX(ivMenuSeparator.frame);
    rFrameRight.size.width = rFrameLeft.size.width;
    selectorRight = [[DropDownListView alloc] initWithArray:arrRightDropMenu parentView:self.view widthSenderFrame:rFrameRight];
    //设置初始值
    selectorRight.selectedIndex = 0;
    lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
    selectorRight.isHideBackground = NO;
    selectorRight.delegate = self;
    if (!self.arrQueryResult) self.arrQueryResult = [NSMutableArray array];

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

    [self get_act_trade_list_isAppendResult:NO andShowHUD:YES];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    pageNo = _startPageNo;
    [self.tableView.footer resetNoMoreData];
    [self get_act_trade_list_isAppendResult:NO andShowHUD:NO];
}

- (void)footerRereshing
{
    [self get_act_trade_list_isAppendResult:YES andShowHUD:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 查询动作

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //测试
//    [self queryWithLeftMenuIndex:0 rightMenuIndex:0];
}

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    DDLogDebug(@"【明细查询】 条件【%@】【%@】 正在查询，请稍后...", self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex]);
    
    pageNo = _startPageNo;
    [self.tableView.footer resetNoMoreData];
    [self get_act_trade_list_isAppendResult:NO andShowHUD:YES];
    
//    [self.tableView reloadData];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:self.view.window];
//	[self.view.window addSubview:hud];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"查询中...";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        [self.tableView reloadData];
//        
//		[hud removeFromSuperview];
//	}];
}

//根据账户类型返回查询接口的参数
- (NSArray *)get_cmd_para_and_list_key
{
    NSArray *p_k = @[@"", @""];
 
    switch (self.detailsCode)
    {
        case kDetailsCode_Point:
            p_k = @[@"get_integral_act_trade_list", @"integralTradeList"];

            break;
            
        case kDetailsCode_Cash:
            p_k = @[@"get_cash_act_trade_list", @"cashTradeList"];
            break;
            
        case kDetailsCode_HSDToCash:
            p_k = @[@"get_hsb_transfer_cash_trade_list", @"hsbTransferCashTradeList"];
            break;
            
        case kDetailsCode_HSDToCon:
            p_k = @[@"get_hsb_transfer_consume_trade_list", @"hsbTransferConsumeTradeList"];
            break;

        case kDetailsCode_InvestPoint:
            p_k = @[@"get_invest_act_trade_list", @"investTradeList"];
            break;
            
        case kDetailsCode_InvestDividends:
            p_k = @[@"get_invest_dividends_list", @"data"];
            break;

        default:
            break;
    }
    return p_k;
}

- (void)get_act_trade_list_isAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"item": self.arrLeftParas[selectorLeft.selectedIndex],
                               @"period": self.arrRightParas[selectorRight.selectedIndex],// @"2015-01-04~2015-02-04",
                               @"pageNo": [@(pageNo) stringValue],
                               @"pageSize": [@(pageSize) stringValue]
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": [self get_cmd_para_and_list_key][0],
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    MBProgressHUD *hud = nil;
    if (isShow)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        [self.view addSubview:hud];
        //    hud.labelText = @"初始化数据...";
        [hud show:YES];
    }
    
    [Network  HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
        if (!append)
        {
            if (self.arrQueryResult && self.arrQueryResult.count > 0)
            {
                [self.arrQueryResult removeAllObjects];
                self.arrQueryResult = nil;
            }
            self.arrQueryResult = [NSMutableArray array];
        }
        
        BOOL hasNext = NO;
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    int totalPage = kSaftToNSInteger(dic[@"totalPage"]);//用于判断是否有下一页
                    pageNo = kSaftToNSInteger(dic[@"pageNo"]);
                    
                    NSArray *arrRes = dic[[self get_cmd_para_and_list_key][1]];
                    NSString *transString = @"";
                    NSString *detailsType = @"0";
                    for (NSDictionary *dicArrRes in arrRes)
                    {
                        NSString *transToAcc = kSaftToNSString(dicArrRes[@"itemName"]);  //转入账户

                        NSMutableArray *arrSubTmp = [NSMutableArray array];
                        for (NSArray *keys in arrListProperty)
                        {
                            NSString *flag = kSaftToNSString(keys[2]);
                            NSString *title = kSaftToNSString(keys[1]);
                            if ([flag isEqualToString:@"0"])//直接取返回的key
                            {
                                [arrSubTmp addObject:@{@"title":title,
                                                       @"value":kSaftToNSString(dicArrRes[keys[0]])
                                                       }];
                                
                            }else if ([flag isEqualToString:@"1"])//业务类别,收入或支出
                            {
                                double amount = [kSaftToNSString(dicArrRes[keys[0]]) doubleValue];
                                NSString *strValue = self.arrLeftDropMenu[2];//收入
                                if (amount < 0)//支出
                                {
                                    strValue = self.arrLeftDropMenu[1];
                                }
                                [arrSubTmp addObject:@{@"title":title,
                                                       @"value":strValue
                                                       }];

                            }else if ([flag isEqualToString:@"2"])//交易类型,根据返回的transCode取对应的中文
                            {
//                                NSString *strValue = dicConf[@"trans_code_list"][kSaftToNSString(dicArrRes[keys[0]])];
                              
                                NSArray *transCode = [dicTransCodes[kSaftToNSString(dicArrRes[keys[0]])] componentsSeparatedByString:@","];
                                NSLog(@"%@-------transcode",dicTransCodes[kSaftToNSString(dicArrRes[keys[0]])]);
                                NSString *strValue = transCode[0];

                                if (transCode.count > 1)
                                {
                                    detailsType = transCode[1];
                                }
                                
                                if (!strValue)//显示未知类型
                                {
                                    DDLogInfo(@"明细列表数据，未知交易类型代码为:%@", kSaftToNSString(dicArrRes[keys[0]]));
                                    strValue = dicTransCodes[@"UNKNOW_TYPE"];
                                }else
                                {
//                                    transString = [strValue stringByAppendingString:@"详情"];
                                    transString = strValue;
                                }
                                
                                [arrSubTmp addObject:@{@"title":title,
                                                       @"value":strValue
                                                       }];
                            }
                            
//                            [arrSubTmp addObject:@{@"title":keys[1],
//                                                   @"value": [NSString stringWithFormat:@"%@", dicArrRes[keys[0]]]}];//因为返回的value有数值，有字符，故强制转为字符，否则后面的了视图错解析出错。
                        }
                        [self.arrQueryResult addObject:@{@"subRes":arrSubTmp,
                                                         @"trade_sn": kSaftToNSString(dicArrRes[dicConf[@"trade_sn_key"]]),
                                                         @"transString":transString,
                                                         @"detailsType": detailsType,
                                                         @"dicItem":dicArrRes
                                                         }];
//                        [self.arrQueryResult addObject:arrSubTmp];
                    }
                    
                    if (pageNo < totalPage)
                    {
                        hasNext = YES;
                        pageNo++;
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
            if ([self.arrQueryResult isKindOfClass:[NSNull class]])
            {
                self.arrQueryResult = nil;
            }
            self.tableView.hidden = (self.arrQueryResult && self.arrQueryResult.count > 0 ? NO : YES);
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

#pragma mark - 单击下拉菜单

- (void)selectorLeftClick:(UITapGestureRecognizer *)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if(selectorRight.isShow)
    {
        [selectorRight hideExtendedChooseView];
        btnMenuRight.transform = transform;
    }
    
    if(selectorLeft.isShow)
    {
        [selectorLeft hideExtendedChooseView];
    }else
    {
        [selectorLeft showChooseListView];
        transform = CGAffineTransformRotate(btnMenuLeft.transform, DEGREES_TO_RADIANS(180));
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        btnMenuLeft.transform = transform;
    }];
}

- (void)selectorRightClick:(UITapGestureRecognizer *)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if(selectorLeft.isShow)
    {
        [selectorLeft hideExtendedChooseView];
        btnMenuLeft.transform = transform;
    }
    
    if(selectorRight.isShow)
    {
        [selectorRight hideExtendedChooseView];
    }else{
        [selectorRight showChooseListView];
        transform = CGAffineTransformRotate(btnMenuRight.transform, DEGREES_TO_RADIANS(180));
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        btnMenuRight.transform = transform;
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQueryResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellid = kCellViewDetailCellIdentifier;
    CellViewDetailCell *cell = nil;
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];//使用此方法加载，必须先注册nib或class
    } else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    }
    if (!cell)
    {
        cell = [[CellViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        NSLog(@"init load detail:%d", (int)row);
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

//    NSMutableArray *sortArr = [self sortByIndex:self.arrQueryResult[row]];
//    cell.arrDataSource = sortArr;
    if (dicConf)//高亮配置
    {
        cell.rowValueHighlightedProperty = dicConf[@"list_value_highlighted_property"];
        cell.rowTitleHighlightedProperty = dicConf[@"list_title_highlighted_property"];
    }
    cell.arrDataSource = self.arrQueryResult[row][@"subRes"];
    
    NSInteger subRows = cell.arrDataSource.count;
    cell.cellSubCellRowHeight = kCellSubCellHeight;
    [cell.tableView setUserInteractionEnabled:NO];
    if (self.isShowBtnDetail)
    {
        cell.tableView.frame = CGRectMake(0, 5, 320, kCellSubCellHeight * (subRows + 1));
//        [cell.btnButton setUserInteractionEnabled:NO];
        [cell.labelShowDetails setFont:[UIFont systemFontOfSize:13]];
        cell.labelShowDetails.frame = CGRectMake(0,
                                          kCellSubCellHeight * subRows + 4,
                                          320,
                                          kCellSubCellHeight);
    }else
    {
        cell.tableView.frame = CGRectMake(0, 5, 320, kCellSubCellHeight * subRows);
        if (cell.labelShowDetails.superview)
        {
            [cell.labelShowDetails removeFromSuperview];
            cell.labelShowDetails = nil;
        }
    }
    [cell.tableView  reloadData];//表格嵌套，复用须 reloaddata，否则无法更新数据
    return cell;
}

//按index递增排序
- (NSMutableArray *)sortByIndex:(NSMutableArray *)arr
{
    NSMutableArray *arrDataSource = arr;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        int obj1Idx = [obj1 intValue];
        int obj2Idx = [obj2 intValue];
        return obj1Idx < obj2Idx ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    [arrDataSource sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return arrDataSource;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = kCellSubCellHeight * ([self.arrQueryResult[indexPath.row][@"subRes"] count] + (self.isShowBtnDetail ? 1 : 0)) + 10;
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.isShowBtnDetail)return;//没有详情
    
    NSInteger row = indexPath.row;
    NSString *trade_sn = arrQueryResult[row][@"trade_sn"];//kSaftToNSString(dicArrRes[dicConf[@"trade_sn_key"]]);
    
    if (self.detailsCode == kDetailsCode_InvestDividends) //投资分红明细
    {
        GYInvestDividendsDetailsViewController *details = [[GYInvestDividendsDetailsViewController alloc] init];
        details.dicConf = dicConf[@"details_property"][@"sub_list"];
        details.strTradeSn = trade_sn;
        details.navigationItem.title = @"投资分红详情";
        details.isShowBtnDetail = NO;
        [self.navigationController pushViewController:details animated:YES];

    }else
    {
        GYDetailsNextViewController *details = [[GYDetailsNextViewController alloc] init];
        details.dicDetailsProperty = dicConf[@"details_property"][[@"details_key_value_type_" stringByAppendingString:arrQueryResult[row][@"detailsType"]]];
      
        details.dicItem = arrQueryResult[row][@"dicItem"];
        details.detailsCode = self.detailsCode;
        details.dicTransCodes = dicTransCodes;
        details.dicCurrencyCodes = dicConf[@"currency_code_list"];
        details.strTradeSn = trade_sn;
        
        details.strTransString = kSaftToNSString(arrQueryResult[row][@"transString"]);
        details.navigationItem.title = [details.strTransString stringByAppendingString:@"详情"];
        [self.navigationController pushViewController:details animated:YES];
    }
}

#pragma mark - DropDownListViewDelegate
- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender
{
    if (sender == selectorLeft)
    {
        if (isChange)//只有选择不同的条件才执行操作
        {
            lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
        }
        [self selectorLeftClick:nil];
    }else if (sender == selectorRight)
    {
        if (isChange)//只有选择不同的条件才执行操作
        {
            lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
        }
        [self selectorRightClick:nil];
    }
    if (isChange)
    {
        [self queryWithLeftMenuIndex:selectorLeft.selectedIndex rightMenuIndex:selectorRight.selectedIndex];
    }
}

+ (NSString *)getDateRangeFromTodayWithDays:(NSInteger)daysAgo
{
    NSString *dateFormat = @"yyyy-MM-dd";
    if (daysAgo < 0)//全部
    {
        return [NSString stringWithFormat:@"%@~%@", @"0000-00-00", [Utils dateToString:[NSDate date] dateFormat:dateFormat]];
    }
    
    NSDate *today = [NSDate date];
    NSString *strToday = [Utils dateToString:today dateFormat:dateFormat];
    if (daysAgo == 0)//今天
    {
        return [NSString stringWithFormat:@"%@~%@", strToday, strToday];
    }
    
    //以下按天数
    NSDate *oldDays = [NSDate dateWithTimeIntervalSinceNow:-24.0f * 60 * 60 * daysAgo];
    NSString *strOldDays = [Utils dateToString:oldDays dateFormat:dateFormat];
    return [NSString stringWithFormat:@"%@~%@", strOldDays, strToday];

//    if (daysAgo < 0)//全部
//    {
//        return @"AAAA~AAAA";
//    }
//    
//    NSString *dateFormat = @"yyyy-MM-dd";
//    NSDate *today = [NSDate date];
//    NSString *strToday = [Utils dateToString:today dateFormat:dateFormat];
//    if (daysAgo == 0)//今天
//    {
//        return [NSString stringWithFormat:@"%@~%@", strToday, strToday];
//    }
//    
//    //以下按天数
//    NSDate *oldDays = [NSDate dateWithTimeIntervalSinceNow:-24.0f * 60 * 60 * daysAgo];
//    NSString *strOldDays = [Utils dateToString:oldDays dateFormat:dateFormat];
//    return [NSString stringWithFormat:@"%@~%@", strOldDays, strToday];
}

@end

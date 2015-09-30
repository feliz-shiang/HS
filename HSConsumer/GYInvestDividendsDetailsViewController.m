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

#import "GYInvestDividendsDetailsViewController.h"
#import "CellViewDetailCell.h"
#import "CellDetailRow.h"
#import "UIView+CustomBorder.h"

@interface GYInvestDividendsDetailsViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    GlobalData *data;   //全局单例

    IBOutlet UIView *viewHBkg;
    IBOutlet UILabel *lblHrow0;
    IBOutlet UILabel *lbHrow0;
    IBOutlet UILabel *lblHrow1;
    IBOutlet UILabel *lbHrow1;
    IBOutlet UILabel *lblHrow2;
    IBOutlet UILabel *lbHrow2;
    IBOutlet UILabel *lblHrow3;
    IBOutlet UILabel *lbHrow3;
    
//    NSDictionary *dicConf;          //取得明细的配置文件对应模块
    NSDictionary *dicTransCodes;    //交易类型字典
    NSArray *arrListProperty;       //取得列表的属性文件
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeftDropMenu;
@property (nonatomic, strong) NSArray *arrRightDropMenu;
@property (nonatomic, strong) NSMutableArray *arrQueryResult;

@end

@implementation GYInvestDividendsDetailsViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult, dicConf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isShowBtnDetail = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //实例化单例
    data = [GlobalData shareInstance];
    [viewHBkg addTopBorderAndBottomBorder];
    [viewHBkg setBackgroundColor:kCorlorFromRGBA(255, 252, 211, 1)];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    [lblHrow0 setTextColor:kCellItemTitleColor];
    [lblHrow1 setTextColor:kCellItemTitleColor];
    [lblHrow2 setTextColor:kCellItemTitleColor];
    [lblHrow3 setTextColor:kCellItemTitleColor];
    
    [lbHrow0 setTextColor:kValueRedCorlor];
    [lbHrow1 setTextColor:kValueRedCorlor];
    [lbHrow2 setTextColor:kValueRedCorlor];
    [lbHrow3 setTextColor:kValueRedCorlor];
    
    [lblHrow0 setText:kLocalized(@"dividend_details_invest_integral_total")];
    [lblHrow1 setText:kLocalized(@"dividend_details_invest_dividends_total")];
    [lblHrow2 setText:kLocalized(@"dividend_details_invest_dividend_cycle")];
    [lblHrow3 setText:kLocalized(@"dividend_details_invest_radio")];
    
    [Utils setFontSizeToFitWidthWithLabel:lblHrow0 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lblHrow1 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lblHrow2 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lblHrow3 labelLines:1];
    
    [Utils setFontSizeToFitWidthWithLabel:lbHrow0 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHrow1 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHrow2 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:lbHrow3 labelLines:1];
    
    //设置菜单中分隔线颜色
    
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
        [self.tableView registerClass:[CellViewDetailCell class] forCellReuseIdentifier:kCellViewDetailCellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];

    //    [self.tableView setBackgroundView:nil];
    //    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //    self.tableView.hidden = YES;
    
    if (dicConf)
    {
//        NSString *dicKey = [@"conf_" stringByAppendingString:[@(self.detailsCode) stringValue]];
//        dicConf = data.dicHsConfig[dicKey];
//        DDLogInfo(@"明细的配置字典dicConf(key:%@): %@", dicKey, [Utils dictionaryToString:dicConf]);
        self.arrLeftDropMenu = dicConf[@"list_left_menu"];
        self.arrRightDropMenu = dicConf[@"list_rigth_menu"];
        arrListProperty = dicConf[@"list_property"];
        dicTransCodes = dicConf[@"trans_code_list"];
    }else
    {
        DDLogInfo(@"未能找到查询明细列表的配置文件。");
        [self.tableView setHidden:YES];
        [Utils showMessgeWithTitle:@"Config File Not Found" message:@"Please reinstall the app." isPopVC:self.navigationController];
        return;
    }
    
    if (!self.arrQueryResult) self.arrQueryResult = [NSMutableArray array];
    
    [self get_invest_dividends_detail];
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

- (void)get_invest_dividends_detail
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"trade_sn":self.strTradeSn
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_invest_dividends_detail",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];

    [Network  HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
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
                    lbHrow0.text = [Utils formatCurrencyStyle:kSaftToCGFloat(dic[@"investIntegralTotal"])];
                    lbHrow1.text = [Utils formatCurrencyStyle:kSaftToCGFloat(dic[@"currDividendsTotal"])];
                    lbHrow2.text = kSaftToNSString(dic[@"dividendCycle"]);
                    CGFloat radio = kSaftToCGFloat(dic[@"dividendRadio"]) * 100;
                    lbHrow3.text = [NSString stringWithFormat:@"%d%%", (int)radio];
                    
//                  self.arrQueryResult = dic[@"data"];
                    NSArray *arrRes = dic[@"data"];
                    for (NSDictionary *dicArrRes in arrRes)
                    {
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
                                
                            }
                        }
                        if (arrSubTmp.count > 0)
                        {
                            [self.arrQueryResult addObject:@{@"subRes":arrSubTmp
                                                             }];
                            NSLog(@"%@--------bbbb",self.arrQueryResult);
                        }
                    }
                    
                    CGRect noMoreFrame = [self.tableView bounds];
                    noMoreFrame.size.height = 34.f;
                    UILabel *lbShowInfo = [[UILabel alloc] initWithFrame:noMoreFrame];
                    [lbShowInfo setBackgroundColor:self.view.backgroundColor];
                    [lbShowInfo setFont:[UIFont systemFontOfSize:12.f]];
                    [lbShowInfo setText:@"没有更多了..."];
                    [lbShowInfo setTextColor:kCellItemTextColor];
                    [lbShowInfo setTextAlignment:NSTextAlignmentCenter];
                    self.tableView.tableFooterView = lbShowInfo;

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
            [self.tableView reloadData];
            
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        });
    }];
}

#pragma mark - Table view data source
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = kCellSubCellHeight * ([self.arrQueryResult[indexPath.row][@"subRes"] count] + (self.isShowBtnDetail ? 1 : 0)) + 10;
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

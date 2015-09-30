//
//  GYDetailNextViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//



#define kCellSubCellHeight 24.f

#import "GYDetailsNextViewController.h"
#import "CellDetailRow.h"
#import "UIView+CustomBorder.h"
#import "CellDetailTwoRow.h"

@interface GYDetailsNextViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    GlobalData *data;   //全局单例
    NSArray *arrItmes_k_v;//row属性数组
    NSString *detailsUrlType;// 1为支付/撤单/退货明细数据 url ,其它为账户的明细URL
    NSInteger revokeReturnType;//撤单/退货类型
}
@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation GYDetailsNextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        _rowAmountIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //实例化单例
    data = [GlobalData shareInstance];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    CGFloat _y = 10;//距离父上下相距的视图y 10
    
    CGFloat statusH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat maxHeight = kScreenHeight - statusH - navBarH - 2 * 16;//ios6 限制当前详情界面的最大高度, 上下相距16
    
    BOOL scrEnable = NO;
    arrItmes_k_v = self.dicDetailsProperty[@"item_k_v"];
    if (arrItmes_k_v.count < 1)
    {
        [Utils showMessgeWithTitle:nil message:@"暂无详情" isPopVC:self.navigationController];
        return;
    }
    detailsUrlType = kSaftToNSString(self.dicDetailsProperty[@"details_url_type"]);
    revokeReturnType = kSaftToNSInteger(self.dicDetailsProperty[@"revoke_return_type"]);
    

    
    NSMutableArray * arrTwoRow=[NSMutableArray array];
    for (NSArray * arr in arrItmes_k_v) {
        for (NSString * a in arr) {
            if ([a isEqualToString:@"关联业务受理流水号"]) {
                [arrTwoRow addObject:a];
            }
        }
    }
    
    CGFloat backgroudViewHeight = arrItmes_k_v.count * kCellSubCellHeight +arrTwoRow.count*30+ _y*2;
    if (backgroudViewHeight > maxHeight)
    {
        backgroudViewHeight = maxHeight;
        scrEnable = YES;
    }
    
    CGRect tbvFrame = CGRectMake(self.view.frame.origin.x,
                                 _y,
                                 self.view.frame.size.width,
                                 backgroudViewHeight - _y*2);
    //用于加载tableview的父视图
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(tbvFrame.origin.x,
                                                                     16,
                                                                     tbvFrame.size.width,
                                                                     backgroudViewHeight)
                             ];
    [backgroudView setBackgroundColor:[UIColor whiteColor]];
    [backgroudView addTopBorderAndBottomBorder];
    [self.view addSubview:backgroudView];
    
    self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.tableView setUserInteractionEnabled:scrEnable];//控制子tableview是否可以滚动
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailRowIdentifier];
       [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailTwoRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailTwoRowIdentifier];
    [backgroudView addSubview:self.tableView];
    
    DDLogInfo(@"dicDetailsProperty;%@", self.dicDetailsProperty);
    self.tableView.hidden = YES;
    
    if ([detailsUrlType isEqualToString:@"2"])// 货币转银行的查询流水号使用订单号
    {
        self.strTradeSn = kSaftToNSString(self.dicItem[@"srcOrderNo"]);
    }else if ([detailsUrlType isEqualToString:@"3"])// 货币转银行失败
    {
        self.strTradeSn = kSaftToNSString(self.dicItem[@"refOEvidence"]);
    }
    
    [self get_details_info];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell * nomalCell;
    CellDetailRow *cell = [tableView dequeueReusableCellWithIdentifier:kCellDetailRowIdentifier];
    CellDetailTwoRow * TwoRowCell = [tableView dequeueReusableCellWithIdentifier:kCellDetailTwoRowIdentifier];

    if ([self.arrDataSource[indexPath.row][@"title"] isEqualToString:@"关联业务受理流水号"]) {
       
       if (TwoRowCell==nil) {
            TwoRowCell=[[CellDetailTwoRow alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailTwoRowIdentifier];
        }
    
       TwoRowCell.lbTitle.text=self.arrDataSource[row][@"title"];
       TwoRowCell.lbValue.text=self.arrDataSource[row][@"value"];
       [TwoRowCell.lbTitle setTextColor:kCellItemTitleColor];
       [TwoRowCell.lbValue setTextColor:kCellItemTextColor];
       nomalCell=TwoRowCell;
    
        
    }else
    {
        if (!cell)
        {
            cell = [[CellDetailRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailRowIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        
         if ([self.arrDataSource[indexPath.row][@"title"] isEqualToString:@"撤单转入金额"])
         {
             NSString * fee = self.arrDataSource[8][@"value"];
             NSString * inputAmount = self.arrDataSource[3][@"value"];
             cell.lbTitle.text = self.arrDataSource[row][@"title"];
             cell.lbValue.text = [NSString stringWithFormat:@"%ld",(fee.integerValue+inputAmount.integerValue)];
         }else
         {
             cell.lbTitle.text = self.arrDataSource[row][@"title"];
             cell.lbValue.text = self.arrDataSource[row][@"value"];
         }
       
        [cell setBackgroundColor:[UIColor clearColor]];
      
       
        [cell.lbTitle setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.lbValue setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.lbTitle setTextColor:kCellItemTitleColor];
        [cell.lbValue setTextColor:kCellItemTextColor];
        nomalCell=cell;
    }
    
    
    
    NSArray *rowTitleHighlightedProperty = self.dicDetailsProperty[@"title_highlighted_property"];
    //设置title高亮的颜色
    if (rowTitleHighlightedProperty)
    {
        [rowTitleHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([(NSArray *)obj count] > 1)
            {
                if ([cell.lbTitle.text isEqualToString:obj[0]])//Title的颜色
                {
                    [cell.lbTitle setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];
                }
            }
        }];
    }else
        [cell.lbTitle setTextColor:kCellItemTitleColor];
    
    NSArray *rowValueHighlightedProperty = self.dicDetailsProperty[@"vaule_highlighted_property"];
    //设置value高亮的颜色
    if (rowValueHighlightedProperty)
    {
        [rowValueHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([(NSArray *)obj count] > 1)
            {
                if ([cell.lbTitle.text isEqualToString:obj[0]])//value的颜色
                {
                    [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
                    [cell.lbValue setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];
                    
                    if ([(NSArray *)obj count] > 2 && [obj[2] boolValue])//为真是格式化货币值
                    {
                        cell.lbValue.text = [Utils formatCurrencyStyle:[cell.lbValue.text doubleValue]];
                    }
                }
            }
        }];
    }else
        [cell.lbValue setTextColor:kCellItemTextColor];
    
    return nomalCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=0;
    
        if ([self.arrDataSource[indexPath.row][@"title"] isEqualToString:@"关联业务受理流水号"]) {
        
            height=50;
        
        }else{
            height=kCellSubCellHeight;
        }
    
    return height;
}

//根据账户类型返回查询接口的参数
- (NSArray *)get_cmd_para_and_details_key
{
    NSArray *p_k = @[@"", @""];
    switch (self.detailsCode)
    {
        case kDetailsCode_Point:
            if ([detailsUrlType isEqualToString:@"1"])// 1为支付/撤单/退货明细数据 url
            {
                p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
            }else
                p_k = @[@"get_integral_act_trade_detail", @"integralTradeDetail"];
            
            break;
            
        case kDetailsCode_Cash:
            if ([detailsUrlType isEqualToString:@"2"])// 货币转银行
            {
                p_k = @[@"get_transfer_cash_to_bank_detail", @"result"];
            }else if ([detailsUrlType isEqualToString:@"3"])// 货币转银行失败
            {
                p_k = @[@"get_transfer_cash_to_bank_fail_detail", @"result"];
            }else
                p_k = @[@"get_cash_act_trade_detail", @"cashTradeDetail"];

            break;
            
        case kDetailsCode_HSDToCash:
            
            if ([detailsUrlType isEqualToString:@"1"])// 1为支付/撤单/退货明细数据 url
            {
                p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
            }else
                p_k = @[@"get_hsb_transfer_cash_trade_detail", @"hsbTransferCashTradeDetail"];
            break;
            
        case kDetailsCode_HSDToCon:
            if ([detailsUrlType isEqualToString:@"1"])// 1为支付/撤单/退货明细数据 url
            {
                p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
            }else
                p_k = @[@"get_hsb_transfer_consume_trade_detail", @"hsbTransferConsumeTradeDetail"];
            break;
            
//        case kDetailsCode_InvestPoint:
//            p_k = @[@"get_invest_act_trade_list", @"investTradeList"];
//            break;
            
        case kDetailsCode_InvestDividends:
            p_k = @[@"get_invest_dividends_detail", @"data"];
            break;
            
        default:
            break;
    }
    return p_k;
}

- (NSArray *)revoke_return_type_string
{
    NSArray *arrType = @[@[@"", @""],//占位
                         @[@"webOrderPayRefund", @"webOrderPay", @"comsumePointReFund", @"comsumePoint"],//1 网上订单支付退货, 网上订单支付退货原单，消费积分撤单，消费积分原单
                         @[@"hsbDealReFund", @"hsbDeal", @"comsumePointReFund", @"comsumePoint"],//2 互生币支付退货, 互生币支付退货原单，消费积分撤单，消费积分原单
                         @[@"webOrderDealRefund", @"webOrderPay"],//3 网上订单支付撤单, 网上订单支付撤单原单
                         @[@"hsbPayRefund", @"hsbDeal", @"comsumePointReFund", @"comsumePoint"],//4 互生币支付撤单, 互生币支付撤单原单，消费积分撤单，消费积分原单
                         @[@"comsumePointReFund", @"comsumePoint"],//5 消费积分撤单，消费积分原单
                         @[@"hsbDeal", @"comsumePoint"],//6 互生币支付，消费积分原单
                         @[@"webOrderPay", @"comsumePoint"],//7 网上订单支付，消费积分原单

                         ];
    if (revokeReturnType > arrType.count - 1)
    {
        return  @[@"", @""];
    }
    return arrType[revokeReturnType];
}

#pragma mark - 网络数据交换
- (void)get_details_info    //获取详情
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"trade_sn":self.strTradeSn
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": [self get_cmd_para_and_details_key][0],
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
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
//                    DDLogInfo(@"dic key:%@", [self get_cmd_para_and_details_key][1]);
                    
                    if ([detailsUrlType isEqualToString:@"1"])// 1为支付/撤单/退货明细数据 url
                    {
                        NSArray *arrKeys = [self get_cmd_para_and_details_key][1];
                        
                        NSMutableDictionary *dicRefound = [NSMutableDictionary dictionaryWithDictionary:dic[arrKeys[0]]];
                        NSDictionary *dicSrc = dic[arrKeys[1]];
                        //将原单信息合拼到一个dic里 ,避免key重复，原单key加上前缀s_
                        for (NSString *key in dicSrc.allKeys)
                        {
                            [dicRefound setValue:dicSrc[key] forKey:[@"s_" stringByAppendingString:key]];
                        }
                        if (arrKeys.count > 3)
                        {
                            dicSrc = dic[arrKeys[2]];
                            for (NSString *key in dicSrc.allKeys)
                            {
                                [dicRefound setValue:dicSrc[key] forKey:[@"p_" stringByAppendingString:key]];//消费积分 撤单/退货
                            }
                            dicSrc = dic[arrKeys[3]];
                            for (NSString *key in dicSrc.allKeys)
                            {
                                [dicRefound setValue:dicSrc[key] forKey:[@"ps_" stringByAppendingString:key]];//消费积分 撤单/退货 原单
                            }
                        }
                        dic = dicRefound;
//                        DDLogInfo(@"arrKeys:%@", arrKeys);
//                        DDLogInfo(@"撤单/退货后合拼的dic:%@", dic);

                    }else
                    {
                        dic = dic[[self get_cmd_para_and_details_key][1]];
                    }
                    
                    self.arrDataSource = [NSMutableArray array];
                        for (NSArray *keys in arrItmes_k_v)
                        {
//                            NSMutableArray *arrSubTmp = [NSMutableArray array];
                            NSString *flag = kSaftToNSString(keys[2]);
//                            NSLog(@"%@-----flag",flag);
                            NSString *title = kSaftToNSString(keys[1]);
                            if ([flag isEqualToString:@"0"])//直接取返回的key
                            {
                                [self.arrDataSource addObject:@{@"title":title,
                                                       @"value":kSaftToNSString(dic[keys[0]])
                                                       }];
                            }
//                            else if ([flag isEqualToString:@"1"])//业务类别,收入或支出
//                            {
//                                double amount = [kSaftToNSString(dicArrRes[keys[0]]) doubleValue];
//                                NSString *strValue = self.arrLeftDropMenu[2];//收入
//                                if (amount < 0)//支出
//                                {
//                                    strValue = self.arrLeftDropMenu[1];
//                                }
//                                [arrSubTmp addObject:@{@"title":title,
//                                                       @"value":strValue
//                                                       }];
//                                
//                            }
                            else if ([flag isEqualToString:@"2"])//交易类型,根据返回的transCode取对应的中文
                            {
//                                NSArray *transCode = [self.dicTransCodes[kSaftToNSString(dic[keys[0]])] componentsSeparatedByString:@","];
                                NSString *strValue = self.strTransString;// transCode[0];
                                if (!strValue)//显示未知类型
                                {
                                    DDLogInfo(@"明细详情数据，未知交易类型代码为:%@", kSaftToNSString(dic[keys[0]]));
                                    strValue = self.dicTransCodes[@"UNKNOW_TYPE"];
                                }
                                [self.arrDataSource addObject:@{@"title":title,
                                                       @"value":strValue
                                                       }];
                            }else if ([flag isEqualToString:@"3"])//货币代码转成中文
                            {
                                NSString *c_key = [@"currency_code_" stringByAppendingString:kSaftToNSString(dic[keys[0]])];
                                NSString *strValue = self.dicCurrencyCodes[c_key];
                                if (!strValue)//显示未知类型
                                {
                                    DDLogInfo(@"明细详情数据，未知货币类型代码为:%@", kSaftToNSString(dic[keys[0]]));
                                    strValue = self.dicCurrencyCodes[@"currency_code_unknow"];
                                }
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":strValue
                                                                }];
                            }else if ([flag isEqualToString:@"4"])//格式化时间
                            {
                                NSTimeInterval ti = [kSaftToNSString(dic[keys[0]]) doubleValue] / 1000;
                                NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
                                NSString *strValue = [Utils dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                if ([strValue hasPrefix:@"1970-"])//防止后台不厚道，有时返回毫秒时间，有返回格式化后的时间。
                                {
                                    strValue = kSaftToNSString(dic[keys[0]]);
                                }
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":strValue
                                                                }];
                            }else if ([flag isEqualToString:@"6"])//显示转入互生币（用于流通币）
                            {
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":[Utils formatCurrencyStyle:[self.dicItem[@"amount"] doubleValue]]
                                                                }];
                            }else if ([flag isEqualToString:@"7"])//支付成功还是失败
                            {
                                NSString *value = [kSaftToNSString(dic[keys[0]]) lowercaseString];
//                                成功-N\失败-Y
                                NSString *str = @"成功";
                                if ([value isEqualToString:@"y"])
                                {
                                    str = @"失败";
                                }
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":str
                                                                }];
                            }else if ([flag isEqualToString:@"99"])
                            {
//                                NSString *value = [kSaftToNSString(dic[keys[0]]) lowercaseString];
                                //                                成功-N\失败-Y
                                NSString *str = @"受理成功";
                                
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":str
                                                                }];
                            }
                            else if ([flag isEqualToString:@"8"])//用于退货，撤单的撤销金额(退货金额)
                            {
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":kSaftToNSString(dic[@"transAmount"])
                                                                }];
                            }else if ([flag isEqualToString:@"9"])//用于货币转银行状态
                            {
                                /*
                                 licf(李传飞) 04-29 15:07:51
                                 转账：
                                 PENDING_PAY：待转出
                                 PAYING：转出中
                                 PAYED：已转出
                                 PAY_FAIL：转出失败
                                 CANCELED：已撤单
                                 收款：
                                 PENDING_PAY：待支付
                                 PAYING：支付中
                                 PAYED：已支付
                                 PAY_FAIL：支付失败
                                 CANCELED：已撤单
                                 ABANDONED：已废弃
                                 汇兑：
                                 SUCCESS：已成功
                                 FAIL：已失败
                                 licf(李传飞) 04-29 15:08:13
                                 支付方式：
                                 CASHACCT：货币支付
                                 EBANK：网银支付
                                 HSB：互生币支付
                                 REMITTANCE:转账汇款
                                 */
                                NSString *value = kSaftToNSString(dic[keys[0]]);
                                NSString *str = @"unknow";
                                if ([value isEqualToString:@"PENDING_PAY"])
                                {
                                    str = @"待转出";
                                }else if ([value isEqualToString:@"PAYING"])
                                {
                                    str = @"转出中";
                                }else if ([value isEqualToString:@"PAYED"])
                                {
                                    str = @"已转出";
                                }else if ([value isEqualToString:@"PAY_FAIL"])
                                {
                                    str = @"转出失败";
                                }else if ([value isEqualToString:@"CANCELED"])
                                {
                                    str = @"已撤单";
                                }
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":str
                                                                }];
                            }else if ([flag isEqualToString:@"10"])//写死的，显示配置key在value上
                            {
                                NSString *value = kSaftToNSString(keys[0]);
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":value
                                                                }];
                            }else if ([flag isEqualToString:@"11"])//当地结算货币，取登录返回的全局参数
                            {
                                NSString *value = data.user.settlementCurrencyName;
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":value
                                                                }];
                            }else if ([flag isEqualToString:@"12"])//从传过来item的获取
                            {
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":kSaftToNSString(self.dicItem[keys[0]])
                                                                }];
                            }else if ([flag isEqualToString:@"13"])//货币兑换互生币 受理方式
                            {
                                NSDictionary *dicTypes = @{@"WEB":@"网页终端",
                                                           @"POS":@"POS终端",
                                                           @"MCR":@"刷卡器终端",
                                                           @"MOBILE":@"移动终端",
                                                           @"HSPAD":@"互生平板",
                                                           @"SYS":@"系统终端",
                                                           @"IVR":@"语音终端",
                                                           @"SHOP":@"经营平台"};
                                NSString *_k = kSaftToNSString(dic[keys[0]]);
                                [self.arrDataSource addObject:@{@"title":title,
                                                                @"value":kSaftToNSString(dicTypes[_k])
                                                                }];
                            }
                        }
                
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取详情失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取详情失败." isPopVC:self.navigationController];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.arrDataSource && self.arrDataSource.count > 0)
                self.tableView.hidden = NO;

            [self.tableView reloadData];
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        });

    }];
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CellViewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellViewDetailCellIdentifier];
//    
//    if (!cell)
//    {
//        cell = [[CellViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellViewDetailCellIdentifier];
//    }
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//
//    cell.arrDataSource = self.arrDataSource;
//    cell.cellSubCellRowHeight = kCellSubCellHeight;
//    cell.tableView.frame = self.tableView.bounds;
////    [cell.tableView setUserInteractionEnabled:cellSubCellScrollEnabled];
//    //移除自定义控件的按钮
//    if (cell.btnButton && cell.btnButton.superview)
//    {
//        [cell.btnButton removeFromSuperview];
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.detailRows * kCellSubCellHeight;
//}

@end

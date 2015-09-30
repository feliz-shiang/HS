//
//  GYEPOrderDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-24.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEPOrderDetailViewController.h"
#import "ViewHeaderForOrderDetail.h"
#import "ViewFooterForOrderDetail.h"
#import "CellForOrderDetailCell.h"
#import "UIView+CustomBorder.h"
#import "UIButton+enLargedRect.h"
#import "GYEPSaleAfterApplyForViewController.h"
#import "GYCartViewController.h"
#import "UIImageView+WebCache.h"

#import "ViewUseVouchesInfo.h"
#import "ViewGoodsAmount.h"
#import "ViewShopInfo.h"
#import "ViewOrderStateInfo.h"
#import "EasyPurchaseData.h"
#import "GYShopDetailViewController.h"
#import "GYChatViewController.h"
#import "GYGetPaymentTypeViewController.h"
#import "GYEPOrderQRCoderViewController.h"
#import "GYShowWebInfoViewController.h"
#import "GYGoodsDetailController.h"//商品详情
@interface GYEPOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate,CellForOrderDetailCellDelegate>
{
    ViewHeaderForOrderDetail *vHeader;
    ViewFooterForOrderDetail *vFooter;
    
    ViewOrderStateInfo *vOrderStateInfo;
    ViewShopInfo *vShopInfo;
    ViewGoodsAmount *vAmount;
    ViewUseVouchesInfo *vVouches;
    NSDictionary *dicResult;
    
    EMOrderState orderState;
    BOOL isHasCouponInfo;
}
@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnContact;
@property (strong, nonatomic) IBOutlet UIButton *btn0;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIView *btnsBkg;
//add by zhangqy
@property (copy,nonatomic) NSString *day;//倒计时，天数
@property (copy,nonatomic) NSString *hour;//倒计时，小时
@property (assign,nonatomic)BOOL checkApply;//是否可申请延时收货
@property (copy,nonatomic) NSString *takeCode;//自提码，如果是在线支付且自提方式下才有
@property (copy,nonatomic) NSString *status;
@property (assign,nonatomic)BOOL logistics; //是否有物流信息
@property (assign,nonatomic)CGRect btn0Frame;
@property (assign,nonatomic)CGRect btn1Frame;
@end

@implementation GYEPOrderDetailViewController

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
    self.title=@"订单详情";
    _btn0Frame = self.btn0.frame;
    _btn1Frame = self.btn1.frame;
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    isHasCouponInfo = NO;
    //    //注册通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderInfo) name:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil];
    
    self.btnsBkg.hidden = YES;
    self.tableView.hidden = YES;
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    vHeader = [[ViewHeaderForOrderDetail alloc] init];
    [vHeader.btnVshopName addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    vHeader.mvArrowRight.hidden = YES; // add by songjk 隐藏取商铺的尖头
    vFooter = [[ViewFooterForOrderDetail alloc] init];
    
    vOrderStateInfo = [[ViewOrderStateInfo alloc] init];
    [vOrderStateInfo addTopBorder];
    
    vShopInfo = [[ViewShopInfo alloc] init];
    [vShopInfo.vLine addTopBorder];
    
    vAmount = [[ViewGoodsAmount alloc] init];
    [vAmount.vBkg0 addTopBorder];
    [vAmount addTopBorder];
    
    vVouches = [[ViewUseVouchesInfo alloc] init];
    [vVouches.vLine addTopBorder];
    [vVouches addBottomBorder];
    [vVouches setBottomBorderInset:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForOrderDetailCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForOrderDetailCellIdentifier];
    
    [self.btnContact setBackgroundColor:kClearColor];
    [self.btnContact setTitleColor:kCorlorFromRGBA(0, 143, 215, 1) forState:UIControlStateNormal];
    [self.btnContact setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromRGBA(0, 143, 215, 1)];
    [self.btnContact removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.btnContact addTarget:self action:@selector(btnContactClick:) forControlEvents:UIControlEventTouchUpInside];
    [self getOrderInfo];
}
//zhangqiyun
- (void)confirmGetGoodsBtnClicked:(UIButton*)btn
{
    [self btnConfirmClick:btn];
}
- (void)delayGetGoodsBtnClicked:(UIButton*)btn
{
    UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"是否要延时收货？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0)
        {
            DDLogDebug(@"延时收货");
            [self delayOrder];
        }
    }];
    [alert show];
}
-(void)delayOrder
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": _orderID
                               };
    
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.dimBackground = YES;
    //    [self.view.window addSubview:hud];
    //    //    hud.labelText = @"初始化数据...";
    //    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/saler/delayDeliver"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    //add by zhangqy  刷新倒计时
                    [Utils showMessgeWithTitle:nil message:@"延时收货申请成功。" isPopVC:nil];
                    [self.delegate performSelector:@selector(headerRereshing)];

                    [self refreshTimerNetworking];
                    
                   
                    //[self reloadData];
                    
                    //                    NSInteger newDay = self.day.integerValue +3;
                    //                    self.day = @(newDay).stringValue;
                    //                    [self setupTimerAndDelay];
                    
                    
                    //self.btn0.hidden = YES;
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                }else//返回失败数据
                {
                    //modify by zhangqy
                    //  [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                    //[Utils showMessgeWithTitle:nil message:@"操作失败.已延时2次" isPopVC:nil];
                    [Utils showMessgeWithTitle:nil message:@"操作失败.延时次数已用完" isPopVC:nil];
                    self.btn0.hidden = YES;
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        //        if (hud.superview)
        //        {
        //            [hud removeFromSuperview];
        //        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount = [self.arrDataSource count];
    if (isHasCouponInfo)
    {
        dataCount += 5;//加一个订单状态，实体店信息,金额，互生券 【20150506因为后台接口没返回互生券的信息，暂时隐藏】
    }else
    {
        dataCount += 4;//加一个订单状态，实体店信息,金额，互生券 【20150506因为后台接口没返回互生券的信息，暂时隐藏】
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *cellid = kCellForOrderDetailCellIdentifier;
    UITableViewCell *cll = nil;
    switch (section)
    {
        case 0:
        {
            if (row < self.arrDataSource.count)
            {
                CellForOrderDetailCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell)
                {
                    cell = [[CellForOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                cell.delegate = self;
                cell.index = row;
                NSDictionary *dic = self.arrDataSource[row];
                cell.lbGoodsName.text = kSaftToNSString(dic[@"title"]);
                cell.lbGoodsProperty.text = kSaftToNSString(dic[@"desc"]);
                cell.lbGoodsCnt.text = [NSString stringWithFormat:@"x %@", dic[@"count"]];
                
                NSString *imgUrl = kSaftToNSString(dic[@"url"]);
                [cell.ivGoodsPicture sd_setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
                
                cll = cell;
            }else if (row == self.arrDataSource.count)//订单状态
            {
                cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                [cll.contentView addSubview:vOrderStateInfo];
            }else if (row == self.arrDataSource.count + 1)//实体店
            {
                cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                [vShopInfo.btnShopTel addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
                [cll.contentView addSubview:vShopInfo];
            }else if (row ==self.arrDataSource.count+2)/////发票数据
            {
                cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                UILabel *toplabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 2, 50, 20)];
                toplabel.text=@"发票信息";
                toplabel.font=[UIFont boldSystemFontOfSize:12];
                [cll.contentView addSubview:toplabel];
                
                UILabel *notetitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 22, 100, 20)];
                notetitle.font=[UIFont systemFontOfSize:12];
                notetitle.textColor=kCellItemTextColor;
                notetitle.text= @"是否开具发票：";
                [cll.contentView addSubview:notetitle];
                
                UILabel *note=[[UILabel alloc]initWithFrame:CGRectMake(100, 22, 20, 20)];
                note.font=[UIFont systemFontOfSize:12];
                note.textColor=kCellItemTextColor;
                note.text= [kSaftToNSString(dicResult[@"isDrawed"]) isEqualToString: @"0"]?@"否":@"是";
                [cll.contentView addSubview:note];
                ////发票抬头信息
                UILabel *invoiceTitlelab=[[UILabel alloc]initWithFrame:CGRectMake(15, note.frame.size.height+note.frame.origin.y+2, self.view.bounds.size.width-30,  [self labelheight:[NSString stringWithFormat:@"发票抬头：%@",kSaftToNSString(dicResult[@"invoiceTitle"])]])];
                invoiceTitlelab.text=[NSString stringWithFormat:@"发票抬头：%@",kSaftToNSString(dicResult[@"invoiceTitle"])];
                invoiceTitlelab.textColor=kCellItemTextColor;
                invoiceTitlelab.font = [UIFont systemFontOfSize:12];
                invoiceTitlelab.numberOfLines=0;
                [cll.contentView addSubview:invoiceTitlelab];
                ////中线
                UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(15, invoiceTitlelab.frame.origin.y+invoiceTitlelab.bounds.size.height+5, self.view.bounds.size.width, 0.2)];
                line.backgroundColor=kCellItemTextColor;
                [cll.contentView addSubview:line];
                
                UILabel *messagetitle=[[UILabel alloc]initWithFrame:CGRectMake(15, line.frame.origin.y+line.frame.size.height+3, 100, 10)];
                messagetitle.text=@"买家留言：";
                messagetitle.font=[UIFont systemFontOfSize:12];
                messagetitle.textColor= kCellItemTextColor;
                [cll.contentView addSubview:messagetitle];
                ////买家留言内容
                UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(15, messagetitle.frame.origin.y+messagetitle.bounds.size.height, self.view.bounds.size.width-30, [self labelheight:dicResult[@"userNote"]])];
                message.textColor=kCellItemTextColor;
                message.text =kSaftToNSString(dicResult[@"userNote"]);
                message.font=[UIFont systemFontOfSize:12];
                message.numberOfLines=0;
                [cll.contentView addSubview:message];
                
            }else if (row == self.arrDataSource.count + 3)//金额
            {
                cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                [cll.contentView addSubview:vAmount];
                
            }else if (row == self.arrDataSource.count + 4)//互生券
            {
                cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
                [cll.contentView addSubview:vVouches];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    [cll setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //    [cell.contentView addBottomBorder];
    return cll;
}
#pragma mark CellForOrderDetailCellDelegate
-(void)CellForOrderDetailCellDidCliciPictureWithCell:(CellForOrderDetailCell *)cell
{
    GYEasyBuyModel * mod = [[GYEasyBuyModel alloc]init];
    
    mod.strGoodId=self.itemId;
    ShopModel * shopInfo = [[ShopModel alloc]init];
    shopInfo.strShopId = self.vShopId;
    mod.shopInfo=shopInfo;
    
    GYGoodsDetailController * vcGoodDetail =[[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
    vcGoodDetail.model=mod;
    [self pushVC:vcGoodDetail animated:YES];
}
////算高度
-(CGFloat)labelheight:(NSString *)string
{
    //modify by zhangqy
    if (![string isKindOfClass:[NSNull class]]) {
        
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.bounds.size.width-30,10000.0f)lineBreakMode:UILineBreakModeWordWrap];
        return size.height;
    }
    return 20;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 80.0f;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section)
    {
        case 0:
            if (row < self.arrDataSource.count)
            {
                h = 80.0f;
            }else if (row == self.arrDataSource.count)//订单状态
            {
                if (self.takeCode.length>0) {
                    h = [ViewOrderStateInfo getHeight];
                }
                else{
                    
                    h = [ViewOrderStateInfo getHeight]-21;
                }
                
            }else if (row == self.arrDataSource.count + 1)//实体店
            {
                h=[ViewShopInfo getHeight];
                
            }
            else if (row == self.arrDataSource.count + 2)/////发票数据  需要根据发票信息和买家留言 两个label 来计算高度
            {
                h=[self labelheight:[NSString stringWithFormat:@"发票台头：%@",kSaftToNSString(dicResult[@"invoiceTitle"])]]+[self labelheight:dicResult[@"userNote"]]+68;
            }
            else if (row == self.arrDataSource.count + 3)//金额
            {
                h = [ViewGoodsAmount getHeight];
                
            }else if (row == self.arrDataSource.count + 4)//互生券
            {
                h = [ViewUseVouchesInfo getHeight];
            }
            
            break;
        default:
            break;
    }
    return h;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [ViewFooterForOrderDetail getHeight];
}



-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return vFooter;
}

#pragma mark -   拨打电话
- (void)callShop:(UIButton *)button
{
    
    [Utils callPhoneWithPhoneNumber:button.currentTitle showInView:self.view];
    
    
}
#pragma mark - 查看物流详情
- (void)btnCheckLogisticDetailClick:(id)sender
{
    GYShowWebInfoViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYShowWebInfoViewController class]));
    vc.strUrl = vHeader.strCheckLogisticDetailUrl;
    vc.navigationItem.title = kLocalized(@"物流详情");
    [self pushVC:vc animated:YES];
}

#pragma mark - 联系商家
- (void)btnContactClick:(id)sender
{
    GlobalData *data = [GlobalData shareInstance];
    NSString *resourceNo = kSaftToNSString(dicResult[@"companyResourceNo"]);
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"resourceNo": resourceNo
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view.window addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getVShopShortlyInfo"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    dic = dic[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        GYChatViewController *vc = [[GYChatViewController alloc] init];
                        GYChatItem *chatItem = [[GYChatItem alloc] init];
                        chatItem.msgIcon = kSaftToNSString(dic[@"logo"]);
                        chatItem.vshopName = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.msgNote = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.resNo = resourceNo;
                        
                        vc.chatItem = chatItem;
                        vc.chatItem.fromUserId = [NSString stringWithFormat:@"%@@%@",chatItem.resNo, data.hdDomain];
                        vc.chatItem.msgNote = vc.chatItem.vshopName;
                        vc.chatItem.content = @"";
                        vc.chatItem.msg_Type = 1;
                        vc.chatItem.msg_Code = 103;
                        vc.chatItem.sub_Msg_Code = 10301;
                        vc.msgType = 2;
                        vc.dicShopInfo = dic;
                        vc.chatItem.isSelf = YES;
                        vc.chatItem.vshopID = kSaftToNSString(dic[@"vShopId"]);
                        vc.navigationItem.title = chatItem.vshopName;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        [vc.chatItem updateNotReadWithKey:vc.chatItem WithTableType:2];
                        
                    });
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取商家信息失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取商家信息失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
    
    
}

#pragma mark - 取消订单
- (void)btnCancelClick:(id)sender
{
    UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"是否要取消订单？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0)
        {
            DDLogDebug(@"取消订单");
            [self cancelOrder];
        }
    }];
    [alert show];
}

- (void)cancelOrder
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": _orderID
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view.window addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/cancelOrder"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    [Utils showMessgeWithTitle:nil message:@"订单已取消。" isPopVC:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - 进入商铺
- (void)btnShopNameClick:(id)sender
{
    //    GYShopDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYShopDetailViewController class]));
    //    ;
    //    vc.ShopID = kSaftToNSString(dicResult[@"shopId"]);
    //    vc.fromEasyBuy = 1;
    ////    vc.vShopID = kSaftToNSString(dicResult[@"vShopNameId"]);
    //    [self pushVC:vc animated:YES];
}

#pragma mark - 售后申请
- (void)btnSaleAfterClick:(id)sender
{
    DDLogDebug(@"售后申请");
    GYEPSaleAfterApplyForViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPSaleAfterApplyForViewController class]));
    vc.dicDataSource = self.dicDataSource;
    vc.navigationItem.title = kLocalized(@"ep_after_sales_service_apply_for");
    [self pushVC:vc animated:YES];
}

#pragma mark - 再次购买
- (void)btnBuyAgainClick:(id)sender
{
    [self buyAgain];
    DDLogDebug(@"再次购买");
    
}

- (void)buyAgain
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"sourceType": @"2",
                               @"orderId": _orderID
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    [Network HttpPostRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/againBuy"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        //    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/againBuy"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    //去刷新吧
                    UIAlertView *alert = [UIAlertView showWithTitle:@"提示" message:@"已经加入购物车，是否进入购物车." cancelButtonTitle:kLocalized(@"否") otherButtonTitles:@[kLocalized(@"是")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex != 0)
                        {
                            DDLogDebug(@"再次购买");
                            GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
                            vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
                            [self pushVC:vcCart animated:YES];
                            
                        }
                    }];
                    [alert show];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - 确认收货
- (void)btnConfirmClick:(id)sender
{
    UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"请确认是否收到货?" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0)
        {
            DDLogDebug(@"确认收货");
            [self confirmReceipt];
        }
    }];
    [alert show];
}

- (void)confirmReceipt
{
    GlobalData *data = [GlobalData shareInstance];
    NSArray *orderNos = @[_orderID];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderIds": [orderNos componentsJoinedByString:@","]//多个订单使用,分隔
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/confirmReceipt"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    //去刷新吧
                    DDLogDebug(@"确认收货成功.");
                    [Utils showMessgeWithTitle:nil message:@"确认收货成功." isPopVC:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - 立即付款
- (void)btnPayClick:(id)sender
{
    DDLogDebug(@"立即付款");
    GYGetPaymentTypeViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYGetPaymentTypeViewController class]));
    vc.dicOrderInfo = self.dicDataSource;
    vc.delegate = nil;
    //    deliveryType，送货方式，1 快递 2 实体店自提 3 送货上门
    if ([kSaftToNSString(self.dicDataSource[@"deliveryType"]) isEqual:@"1"])
    { vc.isDelivery = @"1";}
    else
    { vc.isDelivery = @"0";}
    vc.strShopid = kSaftToNSString(self.dicDataSource[@"shopId"]);
    [self pushVC:vc animated:YES];
    
}

#pragma - 刷新数据
- (void)setupTimerAndDelay
{
    UIColor *cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor *cRed = kCorlorFromRGBA(250, 60, 40, 1);
    if ([self.status isEqualToString:@"0"]||[self.status isEqualToString:@"3"]||[self.status isEqualToString:@"10"]){
        
        if (_logistics) {
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight];
            [vHeader setFrame:tmpRect];
            CGRect vb3Frame = vHeader.viewBkg3.frame;
            vb3Frame.origin.y=kDefaultMarginToBounds;
            vHeader.viewBkg3.frame = vb3Frame;
        }
        else
        {
            [vHeader.viewBkg2 setHidden:YES];
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight]-vHeader.viewBkg2.frame.size.height -kDefaultMarginToBounds;
            [vHeader setFrame:tmpRect];
            
            CGRect vb3Frame = vHeader.viewBkg3.frame;
            vb3Frame.origin.y=kDefaultMarginToBounds;
            vHeader.viewBkg3.frame = vb3Frame;
        }
        
        //待买家付款
        if ([self.status isEqualToString:@"0"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:@"还剩%@天%@小时取消订单",_day,_hour];
        }
        //待确认收货/待确认收货
        if ([self.status isEqualToString:@"3"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:@"还剩%@天%@小时确认收货",_day,_hour];
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [self.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //  CGRect rect0 = self.btnContact.frame;
 
            self.btn1.frame = _btn0Frame;
            
            
            self.btn0.frame = _btn1Frame;
            [self.btn0 setTitle:@"延时收货" forState:UIControlStateNormal];
            [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 addTarget:self action:@selector(delayGetGoodsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 setBackgroundColor:[UIColor clearColor]];
            [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            
            if (!self.checkApply) {
                self.btn0.hidden = YES;
            }
            else
            {
                self.btn0.hidden = NO;
            }
        }
        //已申请取消/买家取消待确认
        if ([self.status isEqualToString:@"10"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:@"还剩%@天%@小时取消订单",_day,_hour];
        }
    }
    else
    {
        vHeader.viewBkg3.hidden = YES;
        
        if (_logistics) {
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight]-vHeader.viewBkg3.frame.size.height-kDefaultMarginToBounds;
            [vHeader setFrame:tmpRect];
            [vHeader.viewBkg3 setHidden:YES];
            CGRect vb2Frame = vHeader.viewBkg2.frame;
            vb2Frame.origin.y=0;
            vHeader.viewBkg2.frame = vb2Frame;
            
            CGRect vb0Frame = vHeader.viewBkg0.frame;
            vb0Frame.origin.y=kDefaultMarginToBounds*2+vb2Frame.size.height;
            vHeader.viewBkg0.frame = vb0Frame;
            
            CGRect vb1Frame = vHeader.viewBkg1.frame;
            vb1Frame.origin.y=kDefaultMarginToBounds+vb0Frame.origin.y+vb0Frame.size.height;
            vHeader.viewBkg1.frame = vb1Frame;
        }
        else
        {
            [vHeader.viewBkg2 setHidden:YES];
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight]-vHeader.viewBkg3.frame.size.height-vHeader.viewBkg2.frame.size.height-kDefaultMarginToBounds*2;
            [vHeader setFrame:tmpRect];
            
            CGRect vb0Frame = vHeader.viewBkg0.frame;
            vb0Frame.origin.y=kDefaultMarginToBounds;
            vHeader.viewBkg0.frame = vb0Frame;
            
            CGRect vb1Frame = vHeader.viewBkg1.frame;
            vb1Frame.origin.y=kDefaultMarginToBounds+vb0Frame.origin.y+vb0Frame.size.height;
            vHeader.viewBkg1.frame = vb1Frame;
        }
        
        
    }
}

- (void)reloadData
{
    [self.btn0 setHidden:YES];
    [self.btn1 setHidden:YES];
    
    //zhangqy
    
    
    //
    //    vHeader.lbTimeLeft.text = [NSString stringWithFormat:@"还剩%@天%@小时订单自动确认收货",_day,_hour];
    //    if (!_checkApply) {
    //        self.delayGetGoodsBtn.hidden = YES;
    //    }
    //    订单状态                   操作
    //    待付款                    取消订单、立即付款
    //    待收货                    确认收货
    //    交易成功                  售后申请、再次购买 、删除
    //    交易关闭                  再次购买、删除
    //    待发货、买家已付款         取消订单
    //    商家取消订单、买家已取消  再次购买、删除
    //
    //    再次购买是加入购物车
    UIColor *cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor *cRed = kCorlorFromRGBA(250, 60, 40, 1);
    
    _arrDataSource = dicResult[@"items"];
    orderState = kSaftToNSInteger(dicResult[@"status"]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderInfo) name:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil];
    
    NSString *strLogisticName = kSaftToNSString(dicResult[@"logisticName"]);
    NSString *strLogisticOrderNo = kSaftToNSString(dicResult[@"logisticCode"]);
    if (strLogisticName.length > 0 && strLogisticOrderNo.length > 0)
    {
        [vHeader.lbLogisticName setText:[kLocalized(@"快递公司：") stringByAppendingString:strLogisticName]];
        [vHeader.lbLogisticOrderNo setText:[kLocalized(@"快递单号：") stringByAppendingString:strLogisticOrderNo]];
        vHeader.strCheckLogisticDetailUrl = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",
                                             kSaftToNSString(dicResult[@"logisticId"]),
                                             strLogisticOrderNo];
        //        vHeader.strCheckLogisticDetailUrl = @"http://m.kuaidi100.com/index_all.html?type=zhongtong&postid=762770440654&callbackurl=gyorderDetail";//测试
        [vHeader.btnCheckLogisticDetail addTarget:self action:@selector(btnCheckLogisticDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        _logistics = YES;
    }else//没有物流信息 隐藏
    {
        
        _logistics = NO;
        
    }
    [vHeader.lbConsignee setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"收货人"), dicResult[@"receiver"]]];
    [vHeader.lbTel setText:kSaftToNSString(dicResult[@"receiverContact"])];
    
    NSString *str = kSaftToNSString(dicResult[@"receiverAddress"]);
    if ([str hasPrefix:@"收货地址"]) {
        str = [str substringFromIndex:5];
    }
    
    [vHeader.lbConsigneeAddress setText:str];
    [vHeader.btnVshopName setTitle:kSaftToNSString(dicResult[@"vShopName"]) forState:UIControlStateNormal] ;
    
    // self.tableView.tableHeaderView = vHeader;
    
    [vOrderStateInfo.lbState setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"订单状态"), [EasyPurchaseData getOrderStateString:orderState]]];
    [vOrderStateInfo.lbOrderNo setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"订单号"), kSaftToNSString(dicResult[@"orderId"])]];
    [vOrderStateInfo.lbOrderDatetime setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"成交时间"), dicResult[@"createTime"]]];
    if (self.takeCode&&self.takeCode.length>0) {
        vOrderStateInfo.lbOrderTakeCode.hidden = NO;
        [vOrderStateInfo.lbOrderTakeCode setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"自提码"), self.takeCode]];
    }
    else{
        CGRect vframe = vOrderStateInfo.frame;
        vframe.size.height -=21;
        vOrderStateInfo.frame = vframe;
    }
    
    //    [vShopInfo.lbShopName setText:kSaftToNSString(dicResult[@"shopName"])];
    //    NSString *tmpStr = [NSString stringWithFormat:@"%@%@%@%@", kLocalized(@"地址："), dicResult[@"city"], dicResult[@"area"], dicResult[@"shopAddress"]];
    NSString *tmpStr = [NSString stringWithFormat:@"%@%@", kLocalized(@"地址："), dicResult[@"shopAddress"]];
    [vShopInfo.lbShopAddress setText:tmpStr];
    tmpStr = [NSString stringWithFormat:@"%@",  dicResult[@"contactWay"]];
    [vShopInfo.btnShopTel setTitle:tmpStr forState:UIControlStateNormal];
    
    [vAmount.lbAmount setText:[Utils formatCurrencyStyle:kSaftToCGFloat(dicResult[@"orderTotal"])]];
    [vAmount.lbCourierFees setText:[Utils formatCurrencyStyle:kSaftToCGFloat(dicResult[@"postAge"])]];
    [vAmount.lbPoint setText:[Utils formatCurrencyStyle:kSaftToCGFloat(dicResult[@"totalPoints"])]];
    
    [vFooter.lbRealisticAmount setText:[Utils formatCurrencyStyle:kSaftToCGFloat(dicResult[@"actuallyAmount"])]];
    [vFooter.lbPoint setText:[Utils formatCurrencyStyle:kSaftToCGFloat(dicResult[@"totalPoints"])]];
    
    NSDictionary *couponInfo = dicResult[@"couponInfo"];
    if (couponInfo && [couponInfo isKindOfClass:[NSDictionary class]])
    {
        vVouches.lbLabelHSConsumptionVouchers.text = kSaftToNSString(couponInfo[@"name"]);
        vVouches.lbVouchersInfo0.text = [NSString stringWithFormat:@"%@元/张 x%@", couponInfo[@"faceValue"], couponInfo[@"num"]];
        CGFloat val = kSaftToCGFloat(couponInfo[@"faceValue"]);
        NSInteger num = kSaftToNSInteger(couponInfo[@"num"]);
        vVouches.lbHSConsumptionVouchers.text = [Utils formatCurrencyStyle:val * num];
        vVouches.lbTotalVouchers.text = [Utils formatCurrencyStyle:val * num];
        isHasCouponInfo = YES;
    }
    
    switch (orderState)
    {
        case kOrderStateWaittingPay://待买家付款
            [self.btn0 setHidden:NO];
            [self.btn1 setHidden:NO];
            
            [self.btn0 setBackgroundColor:kClearColor];
            [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn0 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
            [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [self.btn1 setTitle:kLocalized(@"立即付款") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case kOrderStateHasPay://买家已付款
        case kOrderStateWaittingDelivery://待发货
        case kOrderStateWaittingSellerSendGoods://待商家送货
            [self.btn1 setHidden:NO];
            [self.btn0 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"提醒发货") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(alertToSendGoods) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btn0 setBackgroundColor:kClearColor];
            [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn0 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
            [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case kOrderStateWaittingPickUpCargo://待自提
        {
            BOOL isPostPay = [kSaftToNSString(dicResult[@"isPostPay"]) boolValue];//是否货到付款
            if (isPostPay)//货到付款
            {
                [self.btn1 setHidden:NO];
                [self.btn1 setBackgroundColor:kClearColor];
                [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [self.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
                [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                //                [self.btn0 setHidden:NO];
                [self.btn1 setHidden:NO];
                
                [self.btn1 setBackgroundColor:kClearColor];
                [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [self.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
                [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //                [self.btn1 setBackgroundColor:kClearColor];
                //                [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
                //                [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
                //                [self.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
                //                [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
            
        case kOrderStateWaittingConfirmReceiving://待确认收货
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [self.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case kOrderStateFinished://交易成功
        {
            [self.btn0 setHidden:NO];
            [self.btn1 setHidden:NO];
            
            [self.btn0 setBackgroundColor:kClearColor];
            [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn0 setTitle:kLocalized(@"售后申请") forState:UIControlStateNormal];
            [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 addTarget:self action:@selector(btnSaleAfterClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!self.dicDataSource)//未传订单列表信息过来，不可以进行售后申请
            {
                [self.btn0 setHidden:YES];
            }
            
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case kOrderStateClosed://交易关闭
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case kOrderStateSellerPreparingGoods://交易关闭
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case kOrderStateCancelBySeller://商家取消订单
        case kOrderStateCancelByBuyer://买家已取消
        case kOrderStateCancelBySystem://系统取消订单
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        default:
            break;
    }
    //add by zhangqy
    
    [self setupTimerAndDelay];
    self.tableView.tableHeaderView = vHeader;
    
    if ([self.arrDataSource isKindOfClass:[NSNull class]])
    {
        self.arrDataSource = nil;
    }
    self.tableView.hidden = (self.arrDataSource && self.arrDataSource.count > 0 ? NO : YES);
    self.btnsBkg.hidden = self.tableView.hidden;
    [self.tableView reloadData];
}


#pragma mark 卖家提醒
- (void)alertToSendGoods
{
    
    
    
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": _orderID,
                               @"resNo": self.dicDataSource[@"companyResourceNo"],
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/remindDeliver"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    [Utils showMessgeWithTitle:nil message:@"提醒卖家发货成功" isPopVC:nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}


- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (vc)
    {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:ani];
    }
}

#pragma   mark - 获取订单详情
- (void)getOrderInfo
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": self.orderID
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getOrderInfo"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    dicResult = dic[@"data"];
                    _day = kSaftToNSString([dicResult[@"day"] stringValue]);
                    _hour = kSaftToNSString([dicResult[@"hour"] stringValue]);
                    _status = kSaftToNSString([dicResult[@"status"] stringValue]);
                    _checkApply = [dicResult[@"checkApply"] boolValue];
                    _takeCode = kSaftToNSString(dicResult[@"takeCode"]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadData];
                        
                        //显示二维码
                        UIImage* image= kLoadPng(@"icon_qrcoder");
                        CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
                        UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
                        backButton.frame = backframe;
                        [backButton setBackgroundImage:image forState:UIControlStateNormal];
                        [backButton setTitle:@"" forState:UIControlStateNormal];
                        [backButton addTarget:self action:@selector(pushQRcoder:) forControlEvents:UIControlEventTouchUpInside];
                        UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
                        self.navigationItem.rightBarButtonItem = btnSetting;
                        
                    });
                    
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"查询订单详情失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"查询订单详情失败." isPopVC:self.navigationController];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:self.navigationController];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

//add by zhangqy  延时收货后，重新请求倒计时时间
- (void)refreshTimerNetworking
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": self.orderID
                               };
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getOrderInfo"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    dicResult = dic[@"data"];
                    _day = kSaftToNSString([dicResult[@"day"] stringValue]);
                    _hour = kSaftToNSString([dicResult[@"hour"] stringValue]);
                    _status = kSaftToNSString([dicResult[@"status"] stringValue]);
                    _checkApply = [dicResult[@"checkApply"] boolValue];
                    _takeCode = kSaftToNSString(dicResult[@"takeCode"]);
                    [self setupTimerAndDelay];
                }
            }
        }
    }];
}

//订单二维码
- (void)pushQRcoder:(id)sender
{
    GYEPOrderQRCoderViewController *qrCoder = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderQRCoderViewController class]));
    qrCoder.navigationItem.title = kLocalized(@"订单二维码");
    qrCoder.orderID = self.orderID;
    [self pushVC:qrCoder animated:YES];
}

//#pragma mark - UPPayPluginDelegate
//- (void)UPPayPluginResult:(NSString *)result
//{
//    //    支付状态返回值:success、fail、cancel
//    if ([result isEqualToString:@"success"])
//    {
//        [Utils showMessgeWithTitle:kLocalized(@"提示") message:kLocalized(@"付款成功。") isPopVC:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
//
//    }else
//    {
//        [Utils showMessgeWithTitle:kLocalized(@"提示") message:kLocalized(@"付款失败。") isPopVC:nil];
//    }
//}

@end

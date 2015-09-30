//
//  CellForMyOrderCell.m
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellForMyOrderCell.h"
#import "CellForMyOrderSubCell.h"
#import "ViewHeaderForMyOrder.h"
#import "ViewFooterForMyOrder.h"
#import "CellForMyOrderSubCell.h"
#import "UIView+CustomBorder.h"
#import "GYEPSaleAfterApplyForViewController.h"//售后申请
#import "GYCartViewController.h"//购物车
#import "GYEPOrderDetailViewController.h"//订单详情
#import "UIButton+enLargedRect.h"
#import "EasyPurchaseData.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+Blocks.h"
#import "GYEasyBuyModel.h"
//#import "UPPayPlugin.h"
#import "GYShopDetailViewController.h"//进入商铺
#import "GYOrderRefundDetailsViewController.h"//退款详情
#import "GYGetPaymentTypeViewController.h"
#import "GYGoodsDetailController.h"

#import "GYStoreDetailViewController.h"
@interface CellForMyOrderCell ()<UITableViewDataSource, UITableViewDelegate>
{
    ViewHeaderForMyOrder *vHeader;
    ViewFooterForMyOrder *vFooter;
    NSInteger orderState;
    BOOL isShowTrash;
    NSArray *arrDataSource;
    NSString *orderNo;
//    NSString *orderID;//暂时去掉
}
@end

@implementation CellForMyOrderCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = kDefaultVCBackgroundColor;
        vHeader = [[ViewHeaderForMyOrder alloc] init];
        [vHeader.lbState setTextColor:kValueRedCorlor];
        [vHeader.lbOrderNo setTextColor:kCellItemTextColor];
        [Utils setFontSizeToFitWidthWithLabel:vHeader.lbOrderNo labelLines:1];
        [vHeader.btnTrash addTarget:self action:@selector(btnTrashClick:) forControlEvents:UIControlEventTouchUpInside];
        [Utils setFontSizeToFitWidthWithLabel:vHeader.lbState labelLines:1];
        vHeader.lbOrderNo.hidden = YES;//UI更改，不显示
        [vHeader addTopBorder];
        
        [vHeader.btnShopName setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
        [vHeader.btnShopName addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];
        [vHeader.btnShopName2 addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];
        
        vFooter = [[ViewFooterForMyOrder alloc] init];
        [vFooter.lbLabelMoney setTextColor:kCellItemTitleColor];
        
        [Utils setFontSizeToFitWidthWithLabel:vFooter.lbMoneyAmount labelLines:2];
        [Utils setFontSizeToFitWidthWithLabel:vFooter.lbPointAmount labelLines:1];
        [Utils setFontSizeToFitWidthWithLabel:vFooter.btn0.titleLabel labelLines:1];
        [Utils setFontSizeToFitWidthWithLabel:vFooter.btn1.titleLabel labelLines:1];
        
        [vFooter.lbPointAmount setTextColor:kCorlorFromRGBA(0, 143, 215, 1)];
        [vFooter addBottomBorder];
        [vFooter setBottomBorderInset:YES];
        
        CGRect tbvFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(vHeader.frame) + CGRectGetHeight(vFooter.frame) + 10);
        self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setScrollEnabled:NO];
        self.tableView.tableHeaderView = vHeader;
        self.tableView.tableFooterView = vFooter;
        [self addSubview:self.tableView];
        
//        self.arrDataSource = [NSMutableArray array];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForMyOrderSubCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForMyOrderSubCellIdentifier];
        
        isShowTrash = YES;//Trash显示的初始状态
    }
    return self;
}

- (void)showTrash:(BOOL)isShow
{
    if (isShowTrash != isShow)//tableview的复用
    {
        CGRect lbStateFrame = vHeader.lbState.frame;
        CGFloat _x = CGRectGetMaxX(vHeader.btnTrash.frame) - CGRectGetMinX(vHeader.viewLine.frame) + 14;
        if (isShow)
            lbStateFrame.size.width -= _x;
        else
            lbStateFrame.size.width += _x;
        vHeader.lbState.frame = lbStateFrame;
    }
    isShowTrash = isShow;
    vHeader.viewLine.hidden = !isShow;
    vHeader.btnTrash.hidden = !isShow;
    
    //调整商城名称宽度
    CGFloat _shopName_X = 5;//商城名称与箭头之间的间隔
    CGRect btnShopNameFrame = vHeader.btnShopName.frame;
    CGRect btnShopNameFrame2 = vHeader.btnShopName2.frame;
    CGFloat maxWidth = CGRectGetMinX(vHeader.lbState.frame) - CGRectGetMinX(vHeader.btnShopName.frame) - 3;
    CGFloat maxShopNameWidth = maxWidth - btnShopNameFrame2.size.width - _shopName_X;

    NSString *str = [vHeader.btnShopName titleForState:UIControlStateNormal];
    CGSize strSize = [str sizeWithFont:vHeader.btnShopName.titleLabel.font
                     constrainedToSize:CGSizeMake(MAXFLOAT, vHeader.btnShopName.titleLabel.frame.size.width)];
    if (strSize.width > maxShopNameWidth)
    {
        strSize.width = maxShopNameWidth;
    }
    
    btnShopNameFrame.size.width = strSize.width;
    btnShopNameFrame2.origin.x = CGRectGetMaxX(btnShopNameFrame) + _shopName_X;
    vHeader.btnShopName.frame = btnShopNameFrame;
    vHeader.btnShopName2.frame = btnShopNameFrame2;
}

- (void)reloadData
{
    //先移除之前的方法；
    [vFooter.btn0 removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [vFooter.btn1 removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [vFooter.btn0 setHidden:YES];
    [vFooter.btn1 setHidden:YES];
    
//    再次购买是加入购物车
    UIColor *cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor *cRed = kCorlorFromRGBA(250, 60, 40, 1);
/*
    kOrderStateCancelBySystem = -1,//系统取消订单
    kOrderStateWaittingPay = 0, //待买家付款
    kOrderStateHasPay = 1,      //买家已付款
    kOrderStateWaittingDelivery = 2,        //待发货
    kOrderStateWaittingConfirmReceiving = 3,//待确认收货
    kOrderStateFinished = 4,//交易成功
    kOrderStateClosed = 5,  //交易关闭
    kOrderStateWaittingPickUpCargo = 6, //待自提
    kOrderStateWaittingSellerSendGoods = 7, //待商家送货
    kOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
    kOrderStateCancelBySeller = 98,//商家取消订单
    kOrderStateCancelByBuyer = 99,//买家已取消
    kOrderStateAll = 1000       //全部订单
*/
    arrDataSource = self.dicDataSource[@"items"];
    orderState = kSaftToNSInteger(self.dicDataSource[@"status"]);
    if (self.isQueryRefundRecord)
    {
        orderNo = kSaftToNSString(self.dicDataSource[@"id"]);
    }else
    {
        orderNo = kSaftToNSString(self.dicDataSource[@"number"]);
    }
    [vHeader.btnShopName setTitle:kSaftToNSString(self.dicDataSource[@"virtualShopName"]) forState:UIControlStateNormal];

//    kOrderStateCancelBySystem = -1,//取消订单
//    kOrderStateWaittingPay = 0, //待买家付款
//    kOrderStateHasPay = 1,      //买家已付款
//    kOrderStateWaittingDelivery = 2,        //商家备货中
//    kOrderStateWaittingConfirmReceiving = 3,//待确认收货
//    kOrderStateFinished = 4,//交易成功
//    kOrderStateClosed = 5,  //交易关闭
//    kOrderStateWaittingPickUpCargo = 6, //待自提、已备货待提
//    kOrderStateWaittingSellerSendGoods = 7, //待商家送货、商家备货中
//    kOrderStateSellerWaittingPayConfirm = 8, //企业待支付确认、待收货
//    kOrderStateSellerPreparingGoods = 9, //待备货
//    kOrderStateSellerCancelOrder = 10, //已申请取消订单
//    kOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
//    kOrderStateCancelBySeller = 98,//商家取消订单
//    kOrderStateCancelByBuyer = 99,//买家已取消
//    kOrderStateAll = 1000       //全部订单
    
    
    switch (orderState)
    {
        case kOrderStateWaittingPay://待买家付款
            [vFooter.btn0 setHidden:NO];
            [vFooter.btn1 setHidden:NO];

            [vFooter.btn0 setBackgroundColor:kClearColor];
            [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn0 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
            [vFooter.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [vFooter.btn1 setTitle:kLocalized(@"立即付款") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self showTrash:NO];

            break;
        case kOrderStateHasPay://买家已付款
        case kOrderStateWaittingDelivery://待发货
        case kOrderStateWaittingSellerSendGoods://待商家送货
            [vFooter.btn1 setHidden:NO];
            [vFooter.btn0 setHidden:NO];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"提醒发货") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(alertToSendGoods) forControlEvents:UIControlEventTouchUpInside];
            
            
            [vFooter.btn0 setBackgroundColor:kClearColor];
            [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn0 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
            [vFooter.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

            [self showTrash:NO];

            break;
            
        case kOrderStateWaittingPickUpCargo://待自提
        {
            BOOL isPostPay = [kSaftToNSString(self.dicDataSource[@"isPostPay"]) boolValue];//是否货到付款
            if (isPostPay)//货到付款kOrderStateWaittingPickUpCargo
            {
                [vFooter.btn1 setHidden:NO];
               
                [vFooter.btn1 setBackgroundColor:kClearColor];
                [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [vFooter.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
                [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
//                [vFooter.btn0 setHidden:NO];
                [vFooter.btn1 setHidden:NO];
                
                [vFooter.btn1 setBackgroundColor:kClearColor];
                [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [vFooter.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
                [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
                
//                [vFooter.btn1 setBackgroundColor:kClearColor];
//                [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
//                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
//                [vFooter.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
//                [vFooter.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self showTrash:NO];
        }
            break;

        case kOrderStateWaittingConfirmReceiving://待确认收货
            [vFooter.btn1 setHidden:NO];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [vFooter.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self showTrash:NO];
            //add by zhangqy 延时收货按钮
            [vFooter.btn0 setHidden:NO];
            [vFooter.btn0 setBackgroundColor:kClearColor];
            [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn0 setTitle:kLocalized(@"延时收货") forState:UIControlStateNormal];
            [vFooter.btn0 addTarget:self action:@selector(btnDelayClick:) forControlEvents:UIControlEventTouchUpInside];
            BOOL checkApplay = [self.dicDataSource[@"checkApply"] boolValue];
            if (!checkApplay) {
                vFooter.btn0.hidden = YES;
            }
            

            break;
        case kOrderStateFinished://交易成功
        {
            if (!self.isQueryRefundRecord)
            {
                [vFooter.btn0 setHidden:NO];
                [vFooter.btn1 setHidden:NO];
                
                [vFooter.btn0 setBackgroundColor:kClearColor];
                [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
                [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [vFooter.btn0 setTitle:kLocalized(@"售后申请") forState:UIControlStateNormal];
                [vFooter.btn0 addTarget:self action:@selector(btnSaleAfterClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [vFooter.btn1 setBackgroundColor:kClearColor];
                [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [vFooter.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
                [vFooter.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self showTrash:YES];
        }
            break;
        case kOrderStateSellerPreparingGoods://待备货
        {
            if (!self.isQueryRefundRecord)
            {
                [vFooter.btn0 setHidden:YES];
                [vFooter.btn1 setHidden:NO];
            
                
                [vFooter.btn1 setBackgroundColor:kClearColor];
                [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
                [vFooter.btn1 setTitle:kLocalized(@"取消订单") forState:UIControlStateNormal];
                [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            [self showTrash:NO];
        }
            break;

        case kOrderStateClosed://交易关闭
            [vFooter.btn1 setHidden:NO];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self showTrash:YES];

            break;
            
        case kOrderStateCancelBySeller://商家取消订单
        case kOrderStateCancelByBuyer://买家已取消
        case kOrderStateCancelBySystem://系统取消订单kOrderStateSellerCancelOrder
            [vFooter.btn1 setHidden:NO];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"再次购买") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self showTrash:YES];
            
            break;
  
        default:
            [self showTrash:NO];
            
            
            
            break;
    }
    
    if (self.isQueryRefundRecord)
    {
        [vFooter.btn0 setHidden:YES];//隐藏
        [vFooter.btn1 setHidden:YES];//隐藏
        [vHeader.lbState setText:[EasyPurchaseData getOrderRefundStateString:orderState]];
        if (orderState == kOrderRefundStateSellerDisAgree ||
            orderState == kOrderRefundStateRefundSuccess ||
            orderState == kOrderRefundStateRefundFaild ||
            orderState == kOrderRefundStateCancelAppling
            )
        {
            [self showTrash:YES];
        }else
        {
            [self showTrash:NO];
        }
    }
    else
        [vHeader.lbState setText:[EasyPurchaseData getOrderStateString:orderState]];
    
    [vHeader.lbOrderNo setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"订单号"), orderNo]];
    
    vFooter.lbMoneyAmount.text = [Utils formatCurrencyStyle:[self.dicDataSource[@"total"] doubleValue]];
    
    vFooter.lbPointAmount.text = [Utils formatCurrencyStyle:[self.dicDataSource[@"totalPv"] doubleValue]];
    [self.tableView reloadData];
}

#pragma mark - 延时收货
- (void)btnDelayClick:(UIButton*)btn
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
    NSString *orderId = self.dicDataSource[@"id"];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": orderId
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
                    [self.delegate performSelector:@selector(headerRereshing)];
                    [Utils showMessgeWithTitle:nil message:@"延时收货申请成功。" isPopVC:nil];
                    
//                    [self getOrderInfo];
//                    [self reloadData];
                    
                    //                    NSInteger newDay = self.day.integerValue +3;
                    //                    self.day = @(newDay).stringValue;
                    //                    [self setupTimerAndDelay];
                    
                    
                    //self.btn0.hidden = YES;
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                }else//返回失败数据
                {
                    //modify by zhangqy
                    //  [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                    [Utils showMessgeWithTitle:nil message:@"操作失败.延时次数已用完" isPopVC:nil];
                    vFooter.btn0.hidden = YES;
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
#pragma mark - 进入商铺
- (void)btnShopNameClick:(id)sender
{
//    GYShopDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYShopDetailViewController class]));
//    ;
//    vc.ShopID = kSaftToNSString(self.dicDataSource[@"shopId"]);
//    vc.fromEasyBuy = 1;
//    [self pushVC:vc animated:YES];
    
    GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
    
    ShopModel  * model = [[ShopModel alloc] init];
    model.strShopId = kSaftToNSString(self.dicDataSource[@"shopId"]);
    NSDictionary * dictData = [arrDataSource lastObject];
 //   model.strVshopId = [dictData objectForKey:@"vShopId"];
    model.strVshopId = [_dicDataSource objectForKey:@"virtualShopId"];
    if (!model.strVshopId || model.strVshopId.length == 0) {
        return;
    }
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVC:vc animated:YES];
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

#pragma mark 提醒发货
- (void)alertToSendGoods
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": orderNo,
                               @"resNo": self.dicDataSource[@"companyResourceNo"]
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.nav.view.window];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.nav.view.window addSubview:hud];
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
                    [Utils showMessgeWithTitle:nil message:@"提醒卖家发货成功！" isPopVC:nil];
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



- (void)cancelOrder
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": orderNo
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.nav.view.window];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.nav.view.window addSubview:hud];
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

#pragma mark - 立即付款
- (void)btnPayClick:(id)sender
{
    DDLogDebug(@"立即付款");
    GYGetPaymentTypeViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYGetPaymentTypeViewController class]));
    vc.dicOrderInfo = self.dicDataSource;
    vc.delegate = nil;
    
//    deliveryType，送货方式，1 快递 2 实体店自提 3 送货上门
    if ([kSaftToNSString(self.dicDataSource[@"deliveryType"]) isEqual:@"1"])
        vc.isDelivery = @"1";
    else
        vc.isDelivery = @"0";
    vc.strShopid = kSaftToNSString(self.dicDataSource[@"shopId"]);
    [self pushVC:vc animated:YES];
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
    NSArray *orderNos = @[orderNo];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderIds": [orderNos componentsJoinedByString:@","]//多个订单使用,分隔
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.nav.view addSubview:hud];
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
                if (kSaftToNSInteger(dic[@"retCode"])  == kEasyPurchaseRequestSucceedCode)//返回成功数据
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
                               @"orderId": orderNo
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.nav.view addSubview:hud];
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

#pragma mark - 删除订单
- (void)btnTrashClick:(id)sender
{
    UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"确认删除此订单?" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0)
        {
            DDLogDebug(@"删除订单");
            [self deleteOrder];
        }
    }];
    [alert show];
}

- (void)deleteOrder
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": orderNo
                               };
    NSString *appendUrl = @"/easybuy/deleteOrder";
    
    if (_isQueryRefundRecord)//删除售后记录
    {
        allParas = @{@"key": data.ecKey,
                     @"refId": orderNo
                     };
        appendUrl = @"/easybuy/deleteRefund";
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.nav.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:appendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
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
                    
                    DDLogDebug(@"删除订单成功.");
                    [Utils showMessgeWithTitle:nil message:@"删除成功." isPopVC:nil];
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

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav)
    {
        [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
        [self.nav pushViewController:vc animated:ani];
    }
}

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"CellForMyOrderCell frame:%@", NSStringFromCGRect(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table view data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDataSource.count;//[self.dicDataSource[@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellForMyOrderSubCellIdentifier];
//    return cell0;
    
    NSInteger row = indexPath.row;
    CellForMyOrderSubCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellForMyOrderSubCellIdentifier];
    
    if (!cell)
    {
        cell = [[CellForMyOrderSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellForMyOrderSubCellIdentifier];
    }
    
    [cell.viewContentBkg setBottomBorderInset:row == arrDataSource.count - 1 ? YES : NO];
    
    NSString *imgUrl = kSaftToNSString(arrDataSource[row][@"url"]);
    [cell.ivGoodsPicture sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    
     UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToGoodsDetail:)];
    cell.ivGoodsPicture.tag = row;
    [cell.ivGoodsPicture addGestureRecognizer:tap];
    
    cell.lbGoodsName.text = kSaftToNSString(arrDataSource[row][@"title"]);
    cell.lbGoodsPrice.text = [Utils formatCurrencyStyle:kSaftToCGFloat(arrDataSource[row][@"price"])];
    cell.lbGoodsCnt.text = [NSString stringWithFormat:@"x %@", arrDataSource[row][@"count"]];
    cell.lbGoodsProperty.text = kSaftToNSString(arrDataSource[row][@"desc"]);
    
    //    cell.accessoryType = UITableViewCellAccessoryNone;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat minHeight = 60;

    return self.cellSubCellRowHeight > minHeight ? self.cellSubCellRowHeight : minHeight;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section == 0) return;
    //
    //    NSArray *arrAcc = self.arrResult[indexPath.section];
    //    NSString *nextVCName = arrAcc[indexPath.row][kKeyNextVcName];
    //    NSString *nextVCTitle = arrAcc[indexPath.row][kKeyAccName];
    //        UIViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([TestViewController class]));
    //    vc.navigationItem.title = nextVCTitle;
    //        if (vc)
    //        {
    //            [self pushVC:vc animated:YES];
    //        }
    UIViewController *vcs = nil;
    if (self.isQueryRefundRecord)
    {
        GYOrderRefundDetailsViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYOrderRefundDetailsViewController class]));
        vc.orderID = orderNo;
        vc.navigationItem.title = kLocalized(@"退款详情");
        vcs = vc;
    }else
    {
        GYEPOrderDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
        vc.orderID = orderNo;
        vc.dicDataSource = self.dicDataSource;
        vc.delegate = self.delegate;
        vc.navigationItem.title = kLocalized(@"ep_order_detail");
        // add by songjk
        vc.vShopId = arrDataSource[indexPath.row][@"vShopId"];
        if (!vc.vShopId || vc.vShopId.length == 0) {
            vc.vShopId = [self.dicDataSource objectForKey:@"virtualShopId"];
        }
        vc.itemId = arrDataSource[indexPath.row][@"id"];
        vcs = vc;
    }
    
    if (vcs)
    {
        [self pushVC:vcs animated:YES];
    }
}

-(void)pushToGoodsDetail:(UITapGestureRecognizer *)tap
{
    UIImageView * imgv =(UIImageView *)tap.view;

    GYEasyBuyModel * mod = [[GYEasyBuyModel alloc]init];
    
    mod.strGoodId=arrDataSource[imgv.tag][@"id"];
    ShopModel * shopInfo = [[ShopModel alloc]init];
    shopInfo.strShopId = arrDataSource[imgv.tag][@"vShopId"];
    if (!shopInfo.strShopId || shopInfo.strShopId.length == 0) {
        shopInfo.strShopId = [self.dicDataSource objectForKey:@"virtualShopId"];
    }
    mod.shopInfo=shopInfo;
    
    GYGoodsDetailController * vcGoodDetail =[[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
    vcGoodDetail.model=mod;
    [self pushVC:vcGoodDetail animated:YES];
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGRect tbvFrame = CGRectMake(0,
//                                 0,
//                                 kScreenWidth,
//                                 CGRectGetHeight(vHeader.frame) + CGRectGetHeight(vFooter.frame) + self.arrDataSource.count * self.cellSubCellRowHeight);
//    [self.tableView setFrame:tbvFrame];
//    [self setNeedsLayout];
//}
//- (void)layoutSubviews
//{
//    self setn
//}

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

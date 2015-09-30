//
//  EasyPurchaseData.m
//  HSConsumer
//
//  Created by liangzm on 15-2-6.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "EasyPurchaseData.h"

@implementation EasyPurchaseData

+ (NSString *)getOrderStateString:(EMOrderState)state
{
    
//    kOrderStateCancelBySystem = -1,//系统取消订单
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
    
    switch (state)
    {
        case kOrderStateCancelBySystem:
            // 改为订单取消
            return kLocalized(@"订单取消");
            break;

        case kOrderStateWaittingPay:
            return kLocalized(@"未付款");
//            return kLocalized(@"待买家付款");
            
            break;
            
        case kOrderStateHasPay:
            return kLocalized(@"已付款");
//            return kLocalized(@"买家已付款");
            
            break;
            
        case kOrderStateWaittingDelivery:
            return kLocalized(@"商家备货中");
            
            break;
            
        case kOrderStateWaittingConfirmReceiving:
            return kLocalized(@"待确认收货");
//            return kLocalized(@"待确认收货");
            
            break;
            
        case kOrderStateFinished:
            return kLocalized(@"交易成功");
            
            break;
            
        case kOrderStateClosed:
            return kLocalized(@"交易关闭");
            break;
            
        case kOrderStateWaittingPickUpCargo:
            return kLocalized(@"已备货待提");
            break;
            
        case kOrderStateWaittingSellerSendGoods:
            return kLocalized(@"商家备货中");
            break;

        case kOrderStateCancelBySeller:
            // 改为订单取消
            return kLocalized(@"订单取消");
            break;
            
        case kOrderStateCancelPaidOrderByBuyer:
            return kLocalized(@"买家退款退货");
            break;
            
        case kOrderStateSellerWaittingPayConfirm:
            return kLocalized(@"待收货");//待商家确认支付//企业待支付确认
            break;
            
        case kOrderStateSellerPreparingGoods:
            return kLocalized(@"待备货");//待商家确认支付//企业待支付确认
            break;
            
        case kOrderStateSellerCancelOrder:
            return kLocalized(@"已申请取消");//待商家确认支付//企业待支付确认
            break;
            
        case kOrderStateCancelByBuyer:
            // 改为订单取消
            return kLocalized(@"订单取消");//消费者取消订单
            break;
            
        default:
            break;
    }
    return kLocalized(@"状态未知");
}

+ (NSString *)getOrderRefundStateString:(EMOrderRefundState)state
{
    switch (state)
    {
        case kOrderRefundStateAppling:
            return kLocalized(@"提交申请");
            break;
            
        case kOrderRefundStateSellerDisAgree:
            return kLocalized(@"企业不同意");
            break;
            
        case kOrderRefundStateWaittingSellerComeReceive:
            return kLocalized(@"待企业上门取货");
            break;
            
        case kOrderRefundStateWaittingBuyersDelivery:
            return kLocalized(@"待买家发货");
            break;

        case kOrderRefundStateWaittingSellerConfirmReceiving:
            return kLocalized(@"待企业收货确认");
            break;
            
        case kOrderRefundStateRefunding:
            return kLocalized(@"退款中");
            break;
            
        case kOrderRefundStateRefundSuccess:
            return kLocalized(@"售后完成");
            break;
            
        case kOrderRefundStateRefundFaild:
            return kLocalized(@"退款失败");
            break;
            
        case kOrderRefundStateWaittingSellerDeliveryOrChangeGoods:
            return kLocalized(@"待企业发货");
            break;
            
        case kOrderRefundStateWaittingbuyerConfirmReceiving:
            return kLocalized(@"待买家确认收货");
            break;
            
        case kOrderRefundStateWaittingSellerSendGoodsHomeOrChangeGoods:
            return kLocalized(@"待企业送货上门");
            break;
            
        case kOrderRefundStateUnApply:
            return kLocalized(@"未申请");
            break;
            
        case kOrderRefundStateCancelAppling:
            return kLocalized(@"取消申请");
            break;
            
        default:
            break;
    }
    return kLocalized(@"状态未知");
}
@end

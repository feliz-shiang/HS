//
//  CartModel.h
//  HSConsumer
//
//  Created by 00 on 15-1-22.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

@property (nonatomic , copy) NSString *categoryId;
@property (nonatomic , copy) NSString *companyResourceNo;
@property (nonatomic , copy) NSString *count;
@property (nonatomic , copy) NSString *heightAuction;
@property (nonatomic , copy) NSString *cartItemsId;
@property (nonatomic , copy) NSString *price;
@property (nonatomic , copy) NSString *pv;
@property (nonatomic , copy) NSString *sku;
@property (nonatomic , copy) NSString *skuId;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *vShopId;
@property (nonatomic , copy) NSString *vShopName;


@property (nonatomic , copy) NSString *cartId;



@property (nonatomic , copy) NSString *serviceResourceNo;
@property (nonatomic , copy) NSString *shopId;
@property (nonatomic , copy) NSString *shopName;
@property (nonatomic , copy) NSString *url;

@property (nonatomic , assign) BOOL isSel;

// add by songjk 抵扣券规则id
@property (nonatomic , copy) NSString *ruleID;
// songjk 是否申请互生卡
@property (nonatomic, copy) NSString * isApplyCard;
@end

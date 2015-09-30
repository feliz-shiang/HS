//
//  GYCardBandModel.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYCardBandModel : NSObject


@property (nonatomic,copy)NSString *strCustId;// 客户id

@property (nonatomic,copy)NSString *strBankCode;//开户银行代号

@property (nonatomic,copy)NSString *strAcctType;//账户类型（DR_CARD-借记卡,CR_CARD-贷记卡,CORP_ACCT-对公帐号,PASSBOOK-存折）

@property (nonatomic,copy)NSString *strCityName;//收款账户开户市,跨行转账必输,如:"深圳"

@property (nonatomic,copy)NSString *strCustResNo;//客户资源号

@property (nonatomic,assign)BOOL  strDefaultFlag;//默认账户标识

@property (nonatomic,copy)NSString *strCustResType;//客户资源类型

@property (nonatomic,copy)NSString *strBankAcctId;//客户银行账户ID

@property (nonatomic,copy)NSString *strBankAreaNo;//开户地区代号

@property (nonatomic,copy)NSString *strBankAcctName;//客户银行户名

@property (nonatomic,copy)NSString *strBankAccount;//客户银行账号

@property (nonatomic,copy)NSString *strBankBranch;//开户支行名称

@property (nonatomic,copy)NSString *strBankName;//开户支行名称

@property (nonatomic,copy)NSString *strProvinceCode;//收款账户银行开户省代码或省名称,跨行转账必输,如44广东省
@property (nonatomic,assign)BOOL   strUsedFlag;//账户验证标识

@property (nonatomic,copy)NSString *  strTempAccount;//账户验证标识

@end

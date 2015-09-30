//
//  GYPersonInfo.h
//  HSConsumer
//
//  Created by apple on 15-3-12.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYPersonInfo : NSObject

/*baseinfo*/
@property(nonatomic,copy)NSString * baseStatus;
@property(nonatomic,copy)NSString * cardRemakableStatus;
@property(nonatomic,copy)NSString * cardRemakeStatus;
@property(nonatomic,copy)NSString * custId;//客户号
@property(nonatomic,copy)NSString * custName;//用户名
@property(nonatomic,copy)NSString * emailFlag;//是否邮箱绑定
@property(nonatomic,copy)NSString * payStatus;//支付状态
@property(nonatomic,copy)NSString * phoneFlag;//是否手机号码绑定
@property(nonatomic,copy)NSString * pvFlag;//是否积分绑定
@property(nonatomic,copy)NSString * pvNotGetPeriod;
@property(nonatomic,copy)NSString * regStatus;//注册状态
@property(nonatomic,copy)NSString * resNo;//资源号
@property(nonatomic,copy)NSString * statusDate;
@property(nonatomic,copy)NSString * verifyStatus;//认证状态
/*extinfo*/
@property(nonatomic,copy)NSString * birthAddress;//户籍地址
@property(nonatomic,copy)NSString * country;//国家
@property(nonatomic,copy)NSString * creBackImg;//证件背面照
@property(nonatomic,copy)NSString * creExpiryDate;//证件过期时间
@property(nonatomic,copy)NSString * creFaceImg;//证件正面照
@property(nonatomic,copy)NSString * creHoldImg;//手持证件照
@property(nonatomic,copy)NSString * creNo;//证件号码
@property(nonatomic,copy)NSString * creType;//证件类型
@property(nonatomic,copy)NSString * creVerifyOrg;//证件核发机构
@property(nonatomic,copy)NSString * created;
@property(nonatomic,copy)NSString * createdBy;
@property(nonatomic,copy)NSString * email;//邮箱地址
@property(nonatomic,copy)NSString * ensureInfo;//预留信息
@property(nonatomic,copy)NSString * homeAddrPostcode;//邮编
@property(nonatomic,copy)NSString * homeAddress;//常住地址
@property(nonatomic,copy)NSString * homePhone;//家庭电话
@property(nonatomic,copy)NSString * isActive;//是否激活
@property(nonatomic,copy)NSString * mobile;//手机号
@property(nonatomic,copy)NSString * nationality;//汉族
@property(nonatomic,copy)NSString * profession;//职业
@property(nonatomic,copy)NSString * pwdAnswer;//密保答案
@property(nonatomic,copy)NSString * pwdQuestNo;//密保问题Id
@property(nonatomic,copy)NSString * sex;//性别
@property(nonatomic,copy)NSString * updated;
@property(nonatomic,copy)NSString * updatedBy;
@property(nonatomic,copy)NSString * verifyRemark;
@property(nonatomic,copy)NSString * importantInfoStatus;
@property(nonatomic,copy)NSString * verifyAppReason;//返回的 审批不通过的原因
@end

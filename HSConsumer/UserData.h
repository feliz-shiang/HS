//
//  UserData.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//用户信息类
@interface UserData : NSObject


/****************以下是有卡用户的属性******************/

@property (strong, nonatomic) NSString *cardNumber;     //*用户资源号 积分卡号
@property (strong, nonatomic) NSString *userPassword;   //用户登录密码（MD5密文)
@property (strong, nonatomic) NSString *userName;       //*用户名
@property (strong, nonatomic) NSString *phoneNumber;    //手机号
@property (strong, nonatomic) NSString *useHeadPictureURL; //用户头像URL;
//@property (copy, nonatomic) NSString * resourceNo;      //用户资源号
@property (strong, nonatomic) NSString *custId;          //*客户号

@property (strong, nonatomic) NSString *settlementCurrencyName; //结算币种名称,如：人民币;
@property (strong, nonatomic) NSString *currencyShortName;      //货币简称：CNY
@property (strong, nonatomic) NSString *currencyCode; //hs 货币 ID ,156

@property (assign, nonatomic) BOOL isRealName;      //*是否实名认证
@property (assign, nonatomic) BOOL isPhoneBinding;  //*是否绑定手机
@property (assign, nonatomic) BOOL isEmailBinding;  //*是否绑定邮箱
@property (assign, nonatomic) BOOL isBankBinding;   //*是否绑定银行卡
@property (assign, nonatomic) BOOL isRealNameRegistration;//*是否实名注册

@property (assign, nonatomic) double pointAccBal;    //*积分账户余额
@property (assign, nonatomic) double cashAccBal;     //*现金账户余额
@property (assign, nonatomic) double HSDToCashAccBal;//*互生币账户流通币余额
@property (assign, nonatomic) double HSDConAccBal;   //*互生币账户消费币余额
@property (assign, nonatomic) double HSWalletAccBal; //互生钱包余额
@property (assign, nonatomic) double investAccTotal; //*投资账户总数

@property (assign, nonatomic) double grandTotalPointAmount; //累计积分总数
@property (assign, nonatomic) double availablePointAmount;  //*可用积分
@property (assign, nonatomic) double todayPointAmount;      //*今日积分
@property (assign, nonatomic) double minPointToCashAmount;  //*积分转货币最低值
@property (assign, nonatomic) double minPointToInvest;     //*个人积分投资最低值
@property (assign, nonatomic) double minHSDTransferToCash;  //*个人互生币转现最低数
@property (assign, nonatomic) double minHSDTransferToConsume;//*个人互生币转消费最低数
@property (assign, nonatomic) double minCashTransferToBank; //*个人现金转账最低数
@property (assign, nonatomic) double minPointToHSD;         //个人积分转互生币最低数

@property (assign, nonatomic) double pointToCashRate;   //*积分转货币比率
@property (assign, nonatomic) double pointToHSDRate;    //*积分转互生币比率
@property (assign, nonatomic) double hsdToCashRate;     //*互生币转货币比率  *如果使用到货币转互生币则除于该比率（如购互生币）。
@property (assign, nonatomic) double hsdToCashCurrencyConversionFee; //*互生币转货币转换费比率
@property (assign, nonatomic) double investmentDividendsTotal;//*投资分红总额
@property (assign, nonatomic) double investAccToHSDToCashAccTotal;//*投资账户转入流通币总数
@property (assign, nonatomic) double investAccToHSDToConAccTotal;//*投资账户转入消费币总数

@property (assign, nonatomic) double pointForReachAccidentalInjuriesSafeguard;//达到意外伤害保障积分数
@property (assign, nonatomic) double pointForReachFreeMedicalSubsidy;//达到免费医疗补贴积分数

@property (strong, nonatomic) NSString *fileHttpUrl;    //*fileHttpUrl	文件http地址
@property (strong, nonatomic) NSString *lastLoginTime;  //*上次登录时间 2015-01-22 15:37:14

@property (assign, nonatomic) BOOL isNeedRefresh;       //*完成业务操作后，是否要刷新本地数据
@property (assign, nonatomic) double dailyBuyHsbMaxmum;  //个人购互生币每日上限
@property (assign, nonatomic) double todayBuyHsbTotalAmount;  //个人购互生币每日上限
@property (assign, nonatomic) double notRegisteredBuyHsbMaxmum;  //*未实名注册用户购互生币单笔最高
@property (assign, nonatomic) double notRegisteredBuyHsbMinimum; //*未实名注册用户购互生币单笔最少
@property (assign, nonatomic) double registeredBuyHsbMaxmum;     //*实名注册用户购互生币单笔最高
@property (assign, nonatomic) double registeredBuyHsbMinimum;    //*实名注册用户购互生币单笔最少
//@property (strong, nonatomic) NSArray *bankInfoList;    //用户银行的列表信息

/****************以下是无卡用户的属性******************/


@end


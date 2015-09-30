//
//  GlobalData.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//存储全局数据类


//系统语言枚举类型，目前只做3种，除了简体、繁体中文外，其它均为英文
typedef enum : NSInteger
{
    kAppLanguageEnglish = 0,
    kAppLanguageChineseSimplified,
    kAppLanguageChineseTraditional
}AppLanguage;

//枚举类型设备屏幕英寸
typedef enum : NSInteger
{
    kDeviceScreenInch_3_5 = 0,
    kDeviceScreenInch_4_0,
    kDeviceScreenInch_5_5
}DeviceScreenInch;


#import <Foundation/Foundation.h>
#import "UserData.h"
#import "GYImUserInfo.h"
#import "GYPersonInfo.h"

// 修改登录
//@class GYLoginView;
@class GYLoginController;
@interface GlobalData : NSObject

//登录返回的各系统域名信息
@property (assign, nonatomic) BOOL isLoing;   //是否正在登录
@property (assign, nonatomic) BOOL isLogined;   //用户互生登录状态；默认为NO
@property (assign, nonatomic) BOOL isHdLogined; //用户动登录状态；默认为NO
@property (assign, nonatomic) BOOL isEcLogined; //用户电商互生登录状态；默认为NO
@property (assign, nonatomic) BOOL isCardUser;  //是持卡用户还是无卡用户登录。
@property (strong, nonatomic) NSString *hsKey;  //互生key
@property (strong, nonatomic) NSString *ecKey;  //互商key 及互动业务使用的key
@property (strong, nonatomic) NSString *midKey; //登录鉴权通过的key，也是xmpp登录的密码,也是ymlt
@property (strong, nonatomic) NSString *hsDomain;   //互生域名
@property (strong, nonatomic) NSString *ecDomain;   //电商域名
@property (strong, nonatomic) NSString *hdbizDomain;//互动业务子系统URL，用于查好友，加好友...
@property (strong, nonatomic) NSString *hsPayDomain;//互生支付URL...
@property (strong, nonatomic) NSString *cKey;//互生参数加密密钥

@property (strong, nonatomic) NSString *tfsDomain;   //图片服务域名
@property (strong, nonatomic) NSString *hdImPersonInfoDomain;   //互动个人资料域名,
@property (strong, nonatomic) NSString *hdDomain;   //互动用户后缀域名 "hdimVhosts": "im.gy.com",
@property (strong, nonatomic) NSString *hdhost;     //互动主机或ip地址不含端口 ldev04.dev.gyist.com  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取
@property (assign, nonatomic) UInt32 hdPort;        //互动端口 5222  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取

@property (strong, nonatomic) UserData *user;       //当前用户信息、保存有卡，无卡登录用户的信息
@property (strong, nonatomic) GYImUserInfo *IMUser; //互动个人资料信息
@property (assign, nonatomic) DeviceScreenInch currentDeviceScreenInch; //当前设备屏英寸
@property (assign, nonatomic) AppLanguage currentLanguage;              //系统使用的语言

@property (strong, nonatomic) UINavigationController *navVCMyHS;    //我的互生对应的NavigationController
@property (strong, nonatomic) UITabBarController *topTabBarVC;      //首界面的TabBarController
//@property (strong, nonatomic, readonly) GYLoginView *loginView;     //持卡用户登录界面
@property (strong, nonatomic, readonly) GYLoginController *loginView;     //持卡用户登录界面
@property (strong, nonatomic) NSDictionary *dicHsConfig;            //互生的配置文件
@property (nonatomic,strong) GYPersonInfo * personInfo;
@property (nonatomic, assign) NSTimeInterval lastQueryUpdateTime;    //
@property (nonatomic, assign) BOOL isNeedUpdateApp; //强制更新
@property (nonatomic,strong) NSString *appURL;      //app更新的url

@property (nonatomic,copy) NSString *selectedCityName; //zhangqy   手动选择了城市名，没有选则为nil

/**
 *	构建单例，用于存储全局数据
 *
 *	@return	返回单例
 */
+ (GlobalData *)shareInstance;

/**
 *	取得当前系统语言,目前只做3种，除了简体、繁体中文外，其它均为英文
 *
 *	@return	系统语言，自定义的枚举值
 */
+ (AppLanguage)getAppLanguage;

/**
 *	弹出登录框
 *
 *	@param 	view 	要展示在哪个VIEW
 *	@param 	delegate 	代理
 *	@param 	stay 	登录后是否停留在当前
 */
- (void)showLoginInView:(UIView *)view withDelegate:(id)delegate isStay:(BOOL)stay;

/**
 *	登录失败时，清除登录信息，如各种key
 */
- (void)clearLoginInfo;

/**
 *	同步银行字典信息
 */
- (void)ayncDictionaryOfBank;

/**
 *	取得银行字典信息
 *
 *	@return	银行字典信息
 */
- (NSDictionary *)getDictionaryOfBank;

/**
 *  取得系统时间与北京时间的时间差
 *
 *	@param 	isCheck 	是否要再联网检测一次
 *
 *	@return	毫秒的时间差
 */
- (NSTimeInterval)getTimeDifference:(BOOL)isCheck;

/**
 *	取得网络时间，返回是GTM+0时间
 *
 *	@return	NSDate的时间
 */
- (NSDate *)getNowTimeIsCheck;

- (void)queryUpdate;

@end

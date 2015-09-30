//
//  Network.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//网络请求类

//以下为统一登录中心固定的参数
#define kIEMMac @"00-00-00-00-00-00" //mac地址
#define kIEMType @"m"   //登录类型

//以下为互生必须固定的参数
#define kuType          @"ios"  //设备类型
#define kHSMac          kIEMMac //mac地址
#define kHSApiAppendUrl @"/api" //（hsDomain）http://192.168.229.21:9092/gy + /api 的后面部分

#define kHSRequestSucceedCode @"SVC0000" //互生请求返回正确的数据的代码
#define kHSRequestNotYetLogin @"API1000" //互生请求鉴权失败代码、要求重新登录
#define kHSRequestSucceedSubCode (int)0  //互生请求返回正确的数据的子代码

typedef void (^HTTPHandler)(NSData *jsonData, NSError *error);

#import <Foundation/Foundation.h>

@class AFHTTPClient;
@interface Network : NSObject

/**
 HTTP Client Properties
 */
@property (nonatomic, strong) AFHTTPClient *httpClient;

/**
 超时时间，默认为kHttpClientTimeout的值；每次使用后均设置值为 -1
 */
@property (nonatomic, assign) CGFloat httpClientTimeout;

/**
 *	构建Network单例
 *
 *	@return	返回单例
 */
+ (Network *)sharedInstance;

/**
 *	取消所有操作
 */
- (void)cancelAllOperation;

//////////////////////////////GET METHOD//////////////////////////////

/**
 *	http GET请求  parameters拼接后的方式，如：
 cmd=get_user_info&params={resource_no=06186010000,user_name=0000}&mId=IOxgCL
 *
 *	@param 	urlString 	url地址
 *	@param 	parameters 	参数：Dictionary
 *	@param 	handler 	请求响应的回调
 */
- (void)HttpGetForRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler;

/**
 *	http GET请求  parameters拼接后的方式，如：
 cmd=get_user_info&params={resource_no=06186010000,user_name=0000}&mId=IOxgCL
 *
 *	@param 	urlString 	url地址
 *	@param 	parameters 	参数：Dictionary
 *	@param 	handler 	请求响应的回调
 */
+ (void)HttpGetForRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler;

//////////////////////////////POST METHOD//////////////////////////////

/**
 *	http post请求 输入要post的httpBody的数据
 *
 *	@param 	urlString 	url地址
 *	@param 	postData 	post httpBody的数据
 *	@param 	handler 	请求响应的回调
 */
- (void)HttpPostRequetURL:(NSString *)urlString postData:(NSData *)postData  requetResult:(HTTPHandler)handler;

/**
 *	http post请求, httpBody拼接后的方式：a=xxxx&b=xxxxx&c=xxxxxx
 *
 *	@param 	urlString 	url地址
 *	@param 	parameters 	参数：Dictionary
 *	@param 	handler 	请求响应的回调
 */
- (void)HttpPostRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler;

/**
 *	http post请求 httpBody拼接后的方式：a=xxxx&b=xxxxx&c=xxxxxx
 *
 *	@param 	urlString 	url地址
 *	@param 	parameters 	参数：Dictionary
 *	@param 	handler 	请求响应的回调
 */
+ (void)HttpPostRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler;

/**
 *	http post请求 httpBody拼接后的方式：{"a":"xx","b":"xx"}
 *
 *	@param 	urlString 	url地址
 *	@param 	parameters 	参数：Dictionary
 *	@param 	handler 	请求响应的回调
 */
+ (void)HttpPostForImRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler;

/**
 *	有卡用户登录接口
 *
 *	@param 	userName 	卡号
 *	@param 	pwd 	卡登录密码
 *	@param 	handler 	请求响应的回调
 */
+ (void)loginCardUser:(NSString *)userName password:(NSString *)pwd requetResult:(HTTPHandler)handler;

/**
 *	无卡用户登录接口
 *
 *	@param 	userName 	卡号
 *	@param 	pwd 	卡登录密码
 *	@param 	handler 	请求响应的回调
 */
+ (void)loginNoCardUser:(NSString *)userName password:(NSString *)pwd requetResult:(HTTPHandler)handler;

/**
 *	所有用户登出接口
 *
 *	@param 	parameters  参数：Dictionary，如 @{@"userName": data.user.resourceNo, @"mid": data.midKey, @"ecKey": data.ecKey}
 *	@param 	handler 	请求响应的回调
 */
+ (void)logoutWithParameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler;

/**
 *	针对用户 取得mid，只管取就行了
 *
 *	@param 	userName 	针对的用户
 *
 *	@return	mid
 */
+ (NSString *)getMidForUser:(NSString *)userName;

+ (NSString*)urlEncoderParameter:(NSString *)para;
@end

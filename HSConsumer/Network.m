//
//  Network.m
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kHttpClientTimeout 20.0f

#import "Network.h"
#import "AFNetworking.h"
#import "LoginEn.h"
#import "GYencryption.h"
#import "NSData+Base64.h"

@interface Network()
{
    AFHTTPRequestOperation *operater;
    UIAlertView *alert;
}
@end

@implementation Network

+ (Network *)sharedInstance
{
    static Network *_sNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sNetwork = [[Network alloc] init];
    });
    return _sNetwork;
}

- (void)cancelAllOperation
{
    [operater cancel];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"/"]];
        _httpClientTimeout = -1.0f;
    }
    return self;
}

- (CGFloat)httpClientTimeout
{
    if (_httpClientTimeout < 0.001f)
    {
        _httpClientTimeout = kHttpClientTimeout;
    }
    return _httpClientTimeout;
}


- (void)HttpGetForRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler
{
    NSString * paramStr =[[self class] httpBodyWithParameters:parameters withURLString:urlString];
    
    NSString* URLFinalString = [NSString stringWithFormat:@"%@?%@", urlString, paramStr];
    DDLogInfo(@"<<*******************打印 GET 请求链接**********************");
    DDLogInfo(@"GET请求URL：%@",URLFinalString);
    DDLogInfo(@"*******************完成打印 GET 请求链接*******************>>");
    
//    URLFinalString = [[self class] URLEncodedString:URLFinalString];//不进行url编码
    if ([GlobalData shareInstance].ecDomain && [urlString hasPrefix:[GlobalData shareInstance].ecDomain])//加密参数
    {
        URLFinalString = [[self class] URLEncodedString:URLFinalString];
    }    
//    NSURL *url = [NSURL URLWithString:URLFinalString];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:URLFinalString parameters:nil];
    [request setTimeoutInterval:self.httpClientTimeout];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    operater = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id data) {
        if (operation.isCancelled)return;
        DDLogInfo(@"<<*******************打印 GET 响应结果*******************");
        NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DDLogInfo(@"GET 响应结果: %@",jsonString);
        DDLogInfo(@"*******************完成打印 GET 响应结果****************>>");
        
        if (!data)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:@"null response" forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:@"Could not decode string" forKey:NSLocalizedFailureReasonErrorKey];
            NSError *error = [[NSError alloc] initWithDomain:@"com.gyist.hs" code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            handler(nil, error);
            _httpClientTimeout = -1;//重置超时时间
            return;
        }
        if (![self isVerifiedKeys:data])//检验keys 已经失效
        {
            DDLogInfo(@"重新登录.");
            GlobalData *appData = [GlobalData shareInstance];
            UINavigationController *nav = appData.topTabBarVC.viewControllers[[appData.topTabBarVC selectedIndex]];
            for (UIView *view in nav.view.subviews)
            {
                if ([view isKindOfClass:[MBProgressHUD class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (alert)
                {
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }
                alert = [UIAlertView showWithTitle:@"提示" message:@"您的账户已经在别处登陆，请注意安全！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [nav popToRootViewControllerAnimated:NO];
                    [appData showLoginInView:nav.view withDelegate:nav.topViewController isStay:NO];
                    alert = nil;
                }];
            });

            return;
        }
        
        handler(data, nil);
        _httpClientTimeout = -1;//重置超时时间
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.isCancelled)return;
        DDLogInfo(@"<<*******************打印 GET 响应结果*******************");
        DDLogError(@"GET 响应错误 Error:%@", error);
        DDLogInfo(@"*******************完成打印 GET 响应结果****************>>");
        handler(nil, error);
        _httpClientTimeout = -1;//重置超时时间
        
    }];
    [operater start];
}

- (BOOL)isVerifiedKeys:(NSData *)responseData
{
    BOOL isVerified = YES;
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData
                                                        options:kNilOptions
                                                          error:&error];
    if (!error)
    {
        if (dic[@"code"] && [kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestNotYetLogin])//互生key失效
        {
            [GlobalData shareInstance].isLogined = NO;
            DDLogInfo(@"互生key失效.");
            return NO;
        }
        if (dic[@"retCode"] && kSaftToNSInteger(dic[@"retCode"]) == 210)//互商key失效
        {
            [GlobalData shareInstance].isEcLogined = NO;
            [GlobalData shareInstance].isHdLogined = NO;
            DDLogInfo(@"互商key失效.");
            return NO;
        }
        if (dic[@"retCode"] && kSaftToNSInteger(dic[@"retCode"]) == 215)//互商key失效
        {
            [GlobalData shareInstance].isEcLogined = NO;
            [GlobalData shareInstance].isHdLogined = NO;
            DDLogInfo(@"互商key失效.");
            return NO;
        }
        if (dic[@"retCode"] && kSaftToNSInteger(dic[@"retCode"]) == 810)//互动个人资料key失效或登录时鉴权失败
        {
            [GlobalData shareInstance].isEcLogined = NO;
            [GlobalData shareInstance].isHdLogined = NO;
            DDLogInfo(@"互动个人资料key失效或登录时鉴权失败.");
            return NO;
        }
        if (dic[@"retCode"] && kSaftToNSInteger(dic[@"retCode"]) == 208)//互动业务key失效
        {
            [GlobalData shareInstance].isEcLogined = NO;
            [GlobalData shareInstance].isHdLogined = NO;
            DDLogInfo(@"互动业务key失效.");
            return NO;
        }        
    }
    return isVerified;
}

- (void)upLoadImage
{

}

+ (void)HttpGetForRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler
{
 
    [[[self class] sharedInstance] HttpGetForRequetURL:urlString parameters:parameters requetResult:handler];
}

- (void)HttpPostRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler
{

    NSString * paramStr =[[self class] httpBodyWithParameters:parameters withURLString:urlString];
    NSData *postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    [self HttpPostRequetURL:urlString postData:postData requetResult:handler];
}

+ (void)HttpPostRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler
{
    if ([parameters isKindOfClass:[NSDictionary class] ]) {
           [[[self class] sharedInstance] HttpPostRequetURL:urlString parameters:parameters requetResult:handler];
    }
    
 
}



- (void)HttpPostRequetURL:(NSString *)urlString postData:(NSData *)postData  requetResult:(HTTPHandler)handler
{
    DDLogInfo(@"<<*******************打印 POST 请求链接*******************");
    NSString *strPostData = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    DDLogInfo(@"POST请求URL：%@  httpBody:%@", urlString, strPostData);
    DDLogInfo(@"*******************完成打印 POST 请求链接*****************>>");
    
    NSString* URLFinalString = [[self class] URLEncodedString:urlString];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:URLFinalString parameters:nil];
    [request setTimeoutInterval:self.httpClientTimeout];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setValue:[@(postData.length) stringValue] forHTTPHeaderField:@"Content-Length"];
    //    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    operater = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id data) {
        if (operation.isCancelled)return;
        DDLogInfo(@"<<*******************打印 POST 响应结果*******************");
        NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DDLogInfo(@"POST 响应结果: %@",jsonString);
        DDLogInfo(@"*******************完成打印 POST 响应结果****************>>");
        
        if (!data)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:@"null response" forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:@"Could not decode string" forKey:NSLocalizedFailureReasonErrorKey];
            NSError *error = [[NSError alloc] initWithDomain:@"com.gyist.hs" code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            handler(nil, error);
            _httpClientTimeout = -1;//重置超时时间
            return;
        }
        if (![self isVerifiedKeys:data])//检验keys 已经失效
        {
            DDLogInfo(@"重新登录.");
            GlobalData *appData = [GlobalData shareInstance];
            UINavigationController *nav = appData.topTabBarVC.viewControllers[[appData.topTabBarVC selectedIndex]];
            for (UIView *view in nav.view.subviews)
            {
                if ([view isKindOfClass:[MBProgressHUD class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (alert)
                {
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }
                alert = [UIAlertView showWithTitle:@"提示" message:@"登录已失效，请重新登录？" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [nav popToRootViewControllerAnimated:NO];
                    [appData showLoginInView:nav.view withDelegate:nav.topViewController isStay:NO];
                    alert = nil;
                }];
            });
            
            return;
        }

        handler(data, nil);
        _httpClientTimeout = -1;//重置超时时间
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.isCancelled)return;
        DDLogInfo(@"<<*******************打印 POST 响应结果*******************");
        DDLogError(@"POST 响应错误 Error:%@", error);
        DDLogInfo(@"*******************完成打印 POST 响应结果****************>>");
        handler(nil, error);
        _httpClientTimeout = -1;//重置超时时间
        
    }];
    [operater start];
}

+ (void)HttpPostForImRequetURL:(NSString *)urlString parameters:(NSDictionary *)parameters  requetResult:(HTTPHandler)handler
{
    NSData * postData =[NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    [[[self class] sharedInstance] HttpPostRequetURL:urlString postData:postData requetResult:handler];
}

+ (NSString *)httpBodyWithParameters:(NSDictionary *)parameters withURLString:(NSString *)urlString
{
    if (!parameters) return @"";//防止解析空参数
    
    NSMutableArray *parametersArray = [NSMutableArray array];
    for (NSString * key in [parameters allKeys])
    {
        id value = [parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key, [self serializeDictionary:value withURLString:urlString]]];
        }

    }

    return [parametersArray componentsJoinedByString:@"&"];
}

//序列化GET请求体内部字典
+(NSString *)serializeDictionary :(NSDictionary *)dict withURLString:(NSString *)urlString
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString * key in [dict allKeys])
    {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]]; 
        }
       
    }
    NSString * str =[NSString stringWithFormat:@"{%@}",[parametersArray componentsJoinedByString:@","]];
    

//    if ([LoginEn sharedInstance].loginLine == kLoginEn_dev_with_default_user_pwd ||//当前开始环境 测试加密
//        [LoginEn sharedInstance].loginLine == kLoginEn_dev_no_default_user_pwd)
//    {
        if ([urlString hasPrefix:[GlobalData shareInstance].hsDomain])//加密参数
        {
            NSLog(@"对参数加密：%@， cKey:%@", str, [GlobalData shareInstance].cKey);
            str = [GYencryption h2:str k:[GlobalData shareInstance].cKey];
            NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
            str = [strData base64EncodedString];
            NSLog(@"加密base64后1：%@", str);
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSLog(@"加密base64后2：%@", str);
            str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            NSLog(@"加密base64后3：%@", str);
            
            str = [self urlEncoderParameter:str];
            NSLog(@"urlEncoderParameter后4：%@", str);

            ////        str = [str stringByReplacingOccurrencesOfString:@"\" withString:@""];
            //        NSLog(@"加密base64后4：%@", str);
//            去空格
        }
//    }
    
    return str;
}

+ (NSString*)urlEncoderParameter:(NSString *)para
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)para,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    return encodedString ;
}

+ (NSString*)URLEncodedString:(NSString *)urlString
{
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                     (CFStringRef)urlString,
                                                                                                     (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                     NULL,
                                                                                                     kCFStringEncodingUTF8));
    return encodedString;
}

//备用方法
+(NSString *)URLEncodedString2:(id<NSObject>)value
{
    if ([value isKindOfClass:[NSNumber class]])
    {
        value = [(NSNumber*)value stringValue];
    }
    NSAssert([value isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes. '%@' is of class %@.", value, [value class]);
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) value,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

+ (void)loginCardUser:(NSString *)userName password:(NSString *)pwd requetResult:(HTTPHandler)handler
{
    NSString *baseUrl = [[LoginEn sharedInstance] getLoginUrl];
    NSString *logintURL = [baseUrl stringByAppendingString:@"/uias/userLogin"];
    NSString *randMidKey = [[self class] getMidForUser:userName];
    
    NSDictionary *parameters = @{@"resNo": @"", @"userName": userName, @"password": pwd, @"mac": kIEMMac, @"mid": randMidKey, @"userType": @"c", @"endType": kIEMType};
    [self HttpPostRequetURL:logintURL parameters:parameters requetResult:^(NSData *jsonData, NSError *error) {
        handler(jsonData, error);
    }];
}

//+ (void)forceLogin:(NSString *)userName password:(NSString *)pwd ecKey:(NSString *)ecKey mid:(NSString *)mid requetResult:(HTTPHandler)handler
//{
//    NSString *baseUrl = [[LoginEn sharedInstance] getLoginUrl];
//    NSString *logintURL = [baseUrl stringByAppendingString:@"/uias/updateSameType"];
//    NSString *randMidKey = @"111111";
//    //    NSString *randMidKey = [Utils getRandomString:6];
//    
//    NSDictionary *parameters = @{@"acc": @"", @"loginId": userName, @"password": pwd, @"mac": kIEMMac, @"mid": randMidKey, @"userType": @"c", @"endType": kIEMType, @"enkey": ecKey};
//    [self HttpPostRequetURL:logintURL parameters:parameters requetResult:^(NSData *jsonData, NSError *error) {
//        handler(jsonData, error);
//    }];
//}


+ (void)loginNoCardUser:(NSString *)userName password:(NSString *)pwd requetResult:(HTTPHandler)handler
{
    NSString *baseUrl = [[LoginEn sharedInstance] getLoginUrl];
    NSString *logintURL = [baseUrl stringByAppendingString:@"/uias/userLogin"];
    NSString *randMidKey = [[self class] getMidForUser:userName];

    NSDictionary *parameters = @{@"resNo": @"", @"userName": userName, @"password": pwd, @"mac": kIEMMac, @"mid": randMidKey, @"userType": @"nc", @"endType": kIEMType};
    [self HttpPostRequetURL:logintURL parameters:parameters requetResult:^(NSData *jsonData, NSError *error) {
        handler(jsonData, error);
    }];
}

+ (void)logoutWithParameters:(NSDictionary *)parameters requetResult:(HTTPHandler)handler
{
    NSString *baseUrl = [[LoginEn sharedInstance] getLoginUrl];
    NSString *logoutURL = [baseUrl stringByAppendingString:@"/uias/logout"];
    NSMutableDictionary *fixParameters = [@{@"mac": kIEMMac, @"endType": kIEMType} mutableCopy];
    [fixParameters addEntriesFromDictionary:parameters];
    [self HttpPostRequetURL:logoutURL parameters:(NSDictionary *)fixParameters requetResult:^(NSData *jsonData, NSError *error) {
        handler(jsonData, error);
    }];
}

+ (NSString *)getMidForUser:(NSString *)userName
{
    NSString *mid = [GYencryption getMid:@"mid"];
//    DDLogInfo(@"getMidForUser");
//    NSLog(@"getMidForUser:%@", mid);
    return mid;
}

@end

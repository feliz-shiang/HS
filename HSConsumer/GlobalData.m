//
//  GlobalData.m
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GlobalData.h"
// 修改登录
#import "GYLoginView.h"
#import "GYLoginController.h"
#import "GYencryption.h"
#import "NSData+Base64.h"
#import "GYAppDelegate.h"

@interface GlobalData()
{
    NSTimeInterval nowTimeInterval;
}
@end

@implementation GlobalData
@synthesize dicHsConfig = _dicHsConfig;

+ (GlobalData *)shareInstance
{
    static GlobalData *sGlobalData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    sGlobalData = [[super allocWithZone:NULL] init];
    });
    return sGlobalData;
}



- (instancetype)init
{
    if (self = [super init])
    {
        [self setInitValues];
    }
    return self;
}

- (NSDictionary *)dicHsConfig
{
    if (_dicHsConfig) return _dicHsConfig;
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:[@"config_" stringByAppendingString:[@(_currentLanguage) stringValue]]
                                                               ofType:@"plist"];
    if (!configFilePath)return nil;
    _dicHsConfig = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    return _dicHsConfig;
}

- (void)setInitValues //设置类初始化默认值
{
    _appURL = @"";
    _isNeedUpdateApp = NO;
    _lastQueryUpdateTime = 0;
    _hsDomain = @"";
    _isLogined = NO;
    _isCardUser = NO;
    _isEcLogined = NO;
    _isHdLogined = NO;
    _user = [[UserData alloc] init];
    _IMUser = [[GYImUserInfo alloc] init];
    _personInfo =[[GYPersonInfo alloc]init];
    _hsKey = @"";
    _ecKey = @"";
    _user.minPointToHSD = 100.00;
    nowTimeInterval = 0;
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    if (screenSize.height == 480.0f)
    {
        _currentDeviceScreenInch = kDeviceScreenInch_3_5;
    }else if (screenSize.height == 568.0f)
    {
        _currentDeviceScreenInch = kDeviceScreenInch_4_0;
    }else
    {
        _currentDeviceScreenInch = kDeviceScreenInch_5_5;
    }
    _hdPort = 5222;
    _currentLanguage = [[self class] getAppLanguage];
}

- (void)showLoginInView:(UIView *)view withDelegate:(id)delegate isStay:(BOOL)stay
{
    // 修改登录
    if (_loginView)
    {
        [_loginView closeAndRemoveSelf:nil];
    }
    _loginView = nil;
//    _loginView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil] lastObject];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _loginView = [[GYLoginController alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    _loginView.delegate = delegate;
    _loginView.isStay = stay;
//    [_loginView showInView:view];
    _loginView.alpha = 0;
    GYAppDelegate * app  = (GYAppDelegate *)[UIApplication sharedApplication].delegate;
    [_loginView showInView:app.window];
    [UIView animateWithDuration:0.5 animations:^{
        _loginView.alpha = 0.5;
        _loginView.alpha = 1;
        _loginView.frame = frame;
    }];
}

- (void)clearLoginInfo//只用于登出时清除数据
{
    _hsDomain = @"";
    self.isEcLogined = NO;
    self.isHdLogined = NO;
    self.isLogined = NO;
    self.user.cardNumber = @"";
    self.isCardUser = NO;
    self.IMUser = [[GYImUserInfo alloc] init];//不可以设置为nil，防止切换用户用户数据赋值失败
    self.hdImPersonInfoDomain = @"";
    [[GYXMPP sharedInstance] Logout];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

+ (AppLanguage)getAppLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //获取系统当前语言版本(简体中文zh-Hans,繁体中文zh-Hant,英文en)
    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"])
    {
        return kAppLanguageChineseSimplified;
    }else if ([currentLanguage isEqualToString:@"zh-Hant"])
    {
        return kAppLanguageChineseTraditional;
    }else
    {
        return kAppLanguageEnglish;
    }
}

//同步银行字典
- (void)ayncDictionaryOfBank
{
    NSDictionary *subParas = @{@"resource_no": self.user.cardNumber};
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_bank_list",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": self.midKey,
                               @"key": self.hsKey
                               };
    
    [Network HttpGetForRequetURL:[self.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
//            DDLogInfo(@"get_bank_list dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    NSString *path = [NSString pathWithComponents:@[kAppCachesDirectoryPath, @"bk.data"]];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                    NSString *content = [GYencryption DES3_EncWithString:con withKey:[GYencryption baiduMapKeyWithMode:1]];
                    
                    if([fileManager createFileAtPath:path contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil])
                    {
                        DDLogInfo(@"同步银行字典并写入文件成功:%@", path);
                    }else
                    {
                        DDLogInfo(@"同步银行字典成功,写入文件失败");
                    }
                   
                }else//返回失败数据
                {
                    DDLogInfo(@"同步银行字典失败");
                }
            }else
            {
                DDLogInfo(@"同步银行字典失败");
            }
            
        }else
        {
            DDLogInfo(@"同步银行字典失败:%@", [error localizedDescription]);
        }
    }];
}

- (NSDictionary *)getDictionaryOfBank
{
    NSString *path = [NSString pathWithComponents:@[kAppCachesDirectoryPath, @"bk.data"]];
    NSError *error;
    NSString *con = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        path = [[NSBundle mainBundle]pathForResource:@"bk" ofType:@"data"];
        NSError *error1;
        con = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error1];
        if (error1) return nil;
        DDLogInfo(@"取本地Bundle里的银行字典成功");
    }else
        DDLogInfo(@"取本地CachesDirectoryPath里的银行字典成功");
    
    return [Utils stringToDictionary:con];
}

//- (NSDictionary *)getDictionaryOfBank
//{
//    NSString *path = [NSString pathWithComponents:@[kAppCachesDirectoryPath, @"bk.data"]];
//    NSError *error;
//    NSString *con = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    if (error)
//    {
//        path = [[NSBundle mainBundle]pathForResource:@"bk" ofType:@"data"];
//        NSError *error1;
//        con = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error1];
//        if (error1) return nil;
//        DDLogInfo(@"取本地Bundle里的银行字典成功");
//    }else
//        DDLogInfo(@"取本地CachesDirectoryPath里的银行字典成功");
//    
//    NSString *content = [GYencryption DES3_DecWithString:con withKey:[GYencryption baiduMapKeyWithMode:1]];
//    return [Utils stringToDictionary:content];
//}

- (void)queryUpdate
{
    NSString *c_key = @"";
    if (kisReleaseTo == 1)
    {
//        c_key = @"5220d592-e866-4eac-a6d0-1ab5c1ea21c1";
        [self queryUpdate2];
        return;
    }else if(kisReleaseTo == 2)
    {
        c_key = @"b473afed-6c7a-4155-b544-7231d571f8ae";
    }
    NSString *thisVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"%@------thisver",thisVer);
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    NSString *urlString = [[LoginEn sharedInstance] getDefaultUpdateDm];
    [Network sharedInstance].httpClientTimeout = 6.f;//6s超时
    [Network HttpGetForRequetURL:urlString parameters:@{@"app_key": c_key, @"version_code": thisVer} requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
//{"app_key":"5220d592-e866-4eac-a6d0-1ab5c1ea21c1","version_code":"2.0.1","down_url":"http://l123","up_info":"PHA+c2Rmc2Rmc2RmPC9wPg==","url":"http://upgrade.hsxt.mobi:8001/mobile/","update_type":1}
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            _lastQueryUpdateTime =  [[NSDate date] timeIntervalSince1970];//本次查询更新时间
            if (!error)
            {
                NSString *sVer = kSaftToNSString(dic[@"version_code"]);
                int a=3;
                if ([self checkVersionsSelfVerion:thisVer onlineVersion:sVer updateType:&a])//有更新
//                    if (![thisVer isEqualToString:sVer])//不用这方法比较
                {
                    NSString *up_info = kSaftToNSString(dic[@"up_info"]);
//                    NSLog(@"%@-------url",kSaftToNSString(dic[@"down_url"]));
                    NSData *infoData = [NSData dataFromBase64String:up_info];
                    up_info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
                    _appURL = kSaftToNSString(dic[@"down_url"]);

//                    _appURL =[NSString stringWithFormat:@"%@",@"itms-services://?action=download-manifest&url=https://upgrade.hsxt.mobi/mobile/person/ios/app0.plist"];
                    NSInteger upCode = kSaftToNSInteger(dic[@"update_type"]);//升级类型,1:强制升级,2:增量升级,3:全量升级
                    switch (upCode)
                    {
                        case 1:
                        {
                            _isNeedUpdateApp = YES;
                            [UIAlertView showWithTitle:[NSString stringWithFormat:@"版本更新v%@",sVer] message:@"检测到新版本, 您必须升级为最新版本才可以使用！" cancelButtonTitle:@"立即更新" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                
                                NSLog(@"%d-----index",buttonIndex);
                                if (buttonIndex==0) {
                                _appURL = [_appURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    NSURL *url = [NSURL URLWithString:_appURL];
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                                
                            }];
                        }
                            break;
                        case 2:
                        case 3:
                        {
                            [UIAlertView showWithTitle:[NSString stringWithFormat:@"版本更新v%@",sVer] message:@"检测到新版本,请您升级为最新版本使用！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即更新"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                 NSLog(@"%d-----index",buttonIndex);
                                if (buttonIndex==1) {
                                    NSURL *url = [NSURL URLWithString:_appURL];
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                                
                            }];

                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }else
                {
//                    [Utils showMessgeWithTitle:@"提示" message:@"当前版本已经是最新版." isPopVC:nil];
                }
            }else
            {
//                [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
            }
        }else
        {
//            [Utils showMessgeWithTitle:@"提示" message:@"连接问题，请稍后再试." isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];

}

- (void)queryUpdate2
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    
//    static NSString *urlString = @"http://itunes.apple.com/lookup?id=725215709";
    
    [Network sharedInstance].httpClientTimeout = 6.f;//6s超时
    [Network HttpGetForRequetURL:@"http://itunes.apple.com/lookup" parameters:@{@"id": @"725215709"} requetResult:^(NSData *jata, NSError *error) {
        if (!error)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jata
                                                                options:kNilOptions
                                                                  error:&error];
            _lastQueryUpdateTime =  [[NSDate date] timeIntervalSince1970];//本次查询更新时间
            if (!error)
            {
                NSArray *resultsKey = [jsonData objectForKey:@"results"];
                if (resultsKey && [resultsKey isKindOfClass:[NSArray class]] && resultsKey.count > 0)
                {
                    NSDictionary *info = [resultsKey objectAtIndex:0];
                    NSString *onlineVer = kSaftToNSString(info[@"version"]);
                    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    
                    DDLogInfo(@"当前线上版本:%@, 该版本:%@", onlineVer, ver);
                    
                    int updateType = 3;//升级类型,1:强制升级,2:增量升级,3:全量升级
                    if ([self checkVersionsSelfVerion:ver
                                        onlineVersion:onlineVer
                         updateType:&updateType])
                    {
                        _appURL = kSaftToNSString(info[@"trackViewUrl"]);
                        switch (updateType)
                        {
                            case 1:
                            {
                                _isNeedUpdateApp = YES;
                                [UIAlertView showWithTitle:[NSString stringWithFormat:@"版本更新v%@",onlineVer] message:@"检测到新版本, 您必须升级为最新版本才可以使用！" cancelButtonTitle:@"立即更新" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                    NSURL *url = [NSURL URLWithString:_appURL];
                                    [[UIApplication sharedApplication] openURL:url];
                                }];
                            }
                                break;
                            case 2:
                            case 3:
                            {
                                [UIAlertView showWithTitle:[NSString stringWithFormat:@"版本更新v%@",onlineVer] message:@"检测到新版本,请您升级为最新版本使用！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即更新"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                    if (buttonIndex != 0)//更新
                                    {
                                        NSURL *url = [NSURL URLWithString:_appURL];
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }];
                                
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                }
                
            }else
            {
                //                [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
            }
        }else
        {
            //            [Utils showMessgeWithTitle:@"提示" message:@"连接问题，请稍后再试." isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];

}

- (BOOL)checkVersionsSelfVerion:(NSString *)selfVerion onlineVersion:(NSString *)onlineVer updateType:(int *)returnType
{
    BOOL newFlag = NO;
    NSString *small  = selfVerion;
    NSString *larg  = onlineVer;

    DDLogInfo(@"this ver:%@, online ver:%@", selfVerion, onlineVer);
    NSArray *s = [small componentsSeparatedByString:@"."];
    NSArray *l = [larg componentsSeparatedByString:@"."];
    if (s.count == 3 && l.count == 3)
    {   //
        int vs1 = [[s objectAtIndex:0] intValue];
        int vs2 = [[s objectAtIndex:1] intValue];
        int vs3 = [[s objectAtIndex:2] intValue];
        
        int vl1 = [[l objectAtIndex:0] intValue];
        int vl2 = [[l objectAtIndex:1] intValue];
        int vl3 = [[l objectAtIndex:2] intValue];
        
        if (vl1 > vs1 )
        {
            *returnType = 1;
            newFlag = YES;
        }else if (vl1 == vs1 )
        {
            if (vl2 > vs2)
            {
                newFlag = YES;
            }else if (vl2 == vs2 )
            {
                if (vl3 > vs3 )
                {
                    newFlag = YES;
                }
            }
        }
        //
    }
    return newFlag;
}

- (NSTimeInterval)getTimeDifference:(BOOL)isCheck
{
    if (!isCheck)
    {
        return nowTimeInterval;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com/"]];
    NSHTTPURLResponse *response = nil;
    NSData *urlDate = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (urlDate && response.allHeaderFields)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
//        [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];//Tue, 16 Jun 2015 08:01:20 GMT  Wed, 17 Jun 2015 02:21:51 GMT
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDate *onLinedate = [df dateFromString:response.allHeaderFields[@"Date"]];
        NSDate *devDate = [NSDate date];
        NSLog(@"线上时间:%@ 设备时间:%@", onLinedate, devDate);
        if (onLinedate && devDate)
        {
            nowTimeInterval = [onLinedate timeIntervalSince1970] - [devDate timeIntervalSince1970];
        }
        return nowTimeInterval;
    }
    return nowTimeInterval;
}

- (NSDate *)getNowTimeIsCheck
{
    NSDate *date = [NSDate date];
    double t = [date timeIntervalSince1970] + [[GlobalData shareInstance] getTimeDifference:NO];
    date = [NSDate dateWithTimeIntervalSince1970:t]; //校准后的时间
    return date;
}

@end

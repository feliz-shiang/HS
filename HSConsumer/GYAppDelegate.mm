//
//  GYAppDelegate.m
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAppDelegate.h"
#import "Formatter.h"
#import "Network.h"
#import "GYencryption.h"
#import "TestViewController.h"

#import "GYHSAccountViewController.h"
#import "GYMyInfoViewController.h"

//test VCs
#import "GYGoodsDetailController.h"

#import "GYPointToCashViewController.h"
#import "GYNavigationController.h"
#import "GYNavigationWhiterController.h"
#import "GYEasyPurchaseMainViewController.h"
#import "GYMyEasyBuyViewController.h"
#import "GYARMainViewController.h"//周边逛
#import "GYHIMMainViewController.h"//消息
#import "GYForgotPasswdViewController.h"

#import "GYEasyBuyViewController.h"
#import "GlobalData.h"
#import "GYPersonalFileViewController.h"
#import "GYLoginView.h"
#import "GYEPOrderDetailViewController.h"
#import "GYInvestAccoutViewController.h"

#import "UPPayPlugin.h"
#import "GYMyInfoViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>
#import "XMPP.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//设置全局日志优先级 Log levels: off < error < warn < info < debug < verbose
#ifndef __OPTIMIZE__
int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
int ddLogLevel = LOG_LEVEL_OFF;
#endif

@interface GYAppDelegate()
{
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
}
//
@end

@implementation GYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    //////分享
    [ShareSDK registerApp:@"wx2f3b74a5c55acc63"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat), 
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline), 
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformSubTypeWechatFav)]
                 onImport:^(SSDKPlatformType platformType){
                     switch (platformType) {
                         case SSDKPlatformTypeWechat :
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ :
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"1634067607"
                                                appSecret:@"4554d69fa1fbc4db121e671d8b118b5a"
                                              redirectUri:@"http://www.hsxt.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1101128973" appKey:@"0i9VDLlPAHaYh1Hv" authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx2f3b74a5c55acc63" appSecret:@"04c5d9f41a529e33b51eb1664e07b93b"];
                      break;
                  default:
                      break;
              }
              
          }];
    
    
    
    
    _mapManager =[[BMKMapManager alloc]init];
    
    //kType 0：测试key ，1：生产环境key
    int kType = 1;//默认是生产环境（app store）
    if (kisReleaseTo == 2)  //企业证书发布用测试key
    {
        kType = 0;//测试key
    }
    BOOL ret = [_mapManager start:[GYencryption baiduMapKeyWithMode:kType] generalDelegate:self];
    if (!ret)
    {
        NSLog(@"启动成功!");
    }
    
    
    //全局日志设置
    [[DDTTYLogger sharedInstance] setLogFormatter:kLogFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    //暂时不打印日志文件
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
//    [fileLogger setMaximumFileSize:(1024 * 1024)];
//    [fileLogger setRollingFrequency:(3600.0 * 24.0)];
//    [[fileLogger logFileManager] setMaximumNumberOfLogFiles:7];//日志保存7天
//    [DDLog addLogger:fileLogger];//添加文件日志
//    DDLogInfo(@"日志文件目录:%@", [fileLogger.logFileManager logsDirectory]);
    
    //日志各级别打印方式 示例
    //    DDLogVerbose(@"%@: Verbose", THIS_FILE);
    //    DDLogError(@"Error");
    //    DDLogWarn(@"Warn");
    //    DDLogInfo(@"Info");
    //    DDLogDebug(@"Debug");
    //    DDLogVerbose(@"Verbose");
    
    
    GlobalData *data = [GlobalData shareInstance];

    ////////////////////////首页选项
    UIViewController *tmpRootVC = nil;
    
    //消息 Navigation
    tmpRootVC = kLoadVcFromClassStringName(NSStringFromClass([GYHIMMainViewController class]));
    tmpRootVC.navigationItem.title = kLocalized(@"tab_title_message");
    GYNavigationController *navVCMessage = [[GYNavigationController alloc] initWithRootViewController:tmpRootVC];
    UITabBarItem *navVCMMessageTabBarItem = [[UITabBarItem alloc] initWithTitle:kLocalized(@"tab_title_message") image:nil tag:0];
    [navVCMMessageTabBarItem setFinishedSelectedImage:kLoadPng(@"tab_btn_message_click") withFinishedUnselectedImage:kLoadPng(@"tab_btn_message_normal")];
    navVCMessage.tabBarItem = navVCMMessageTabBarItem;
    [navVCMessage.navigationBar setTranslucent:NO];
    [navVCMessage.navigationBar setTintColor:[UIColor whiteColor]];
    
    //周边逛 Navigation
    tmpRootVC = kLoadVcFromClassStringName(NSStringFromClass([GYARMainViewController class]));
    tmpRootVC.navigationItem.title = kLocalized(@"tab_title_around");
    GYNavigationController *navVCSurrounding = [[GYNavigationController alloc] initWithRootViewController:tmpRootVC];
    UITabBarItem *navVCSurroundingTabBarItem = [[UITabBarItem alloc] initWithTitle:kLocalized(@"tab_title_around") image:nil tag:1];
    [navVCSurroundingTabBarItem setFinishedSelectedImage:kLoadPng(@"tab_btn_around_click") withFinishedUnselectedImage:kLoadPng(@"tab_btn_around_normal")];
    navVCSurrounding.tabBarItem = navVCSurroundingTabBarItem;
    [navVCSurrounding.navigationBar setTranslucent:NO];
    [navVCSurrounding.navigationBar setTintColor:[UIColor whiteColor]];
    
    //轻松购 Navigation
    GYEasyPurchaseMainViewController *pc = [[GYEasyPurchaseMainViewController alloc] init];

    tmpRootVC.navigationItem.title = kLocalized(@"tab_title_easybuy");
    GYNavigationWhiterController *navVCEasyPurchase = [[GYNavigationWhiterController alloc] initWithRootViewController:pc];
  
    UITabBarItem *navVCEasyPurchaseTabBarItem = [[UITabBarItem alloc] initWithTitle:kLocalized(@"tab_title_easybuy") image:nil tag:2];
    [navVCEasyPurchaseTabBarItem setFinishedSelectedImage:kLoadPng(@"tab_btn_easybuy_click") withFinishedUnselectedImage:kLoadPng(@"tab_btn_easybuy_normal")];
    navVCEasyPurchase.tabBarItem = navVCEasyPurchaseTabBarItem;
    [navVCEasyPurchase.navigationBar setTranslucent:NO];
    [navVCEasyPurchase.navigationBar setTintColor:[UIColor whiteColor]];
    
    //我的互生 Navigation
    data =[GlobalData shareInstance];
    tmpRootVC = [[GYHSAccountViewController alloc] init];
    tmpRootVC.navigationItem.title = kLocalized(@"my_HS");
    GYNavigationController *navVCMyHS = [[GYNavigationController alloc] initWithRootViewController:tmpRootVC];
    UITabBarItem *navVCMyHSTabBarItem = [[UITabBarItem alloc] initWithTitle:kLocalized(@"my_HS") image:nil tag:3];
    [navVCMyHSTabBarItem setFinishedSelectedImage:kLoadPng(@"tab_btn_mine_click") withFinishedUnselectedImage:kLoadPng(@"tab_btn_mine_normal")];
    navVCMyHS.tabBarItem = navVCMyHSTabBarItem;
    [navVCMyHS.navigationBar setTranslucent:NO];
    [navVCMyHS.navigationBar setTintColor:[UIColor whiteColor]];
    
    //TabBar
    UITabBarController *topTabBarVC = [[UITabBarController alloc] init];
    
    NSArray *topTabBarVCs = [NSArray arrayWithObjects:navVCMessage, navVCSurrounding, navVCEasyPurchase, navVCMyHS, nil];
    [topTabBarVC setViewControllers:topTabBarVCs];
    
    
    [[UINavigationBar appearance] setBackgroundColor:kClearColor];
    
    //设置Navigation颜色
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        [[UINavigationBar appearance]setTintColor:kNavigationBarColor];
    }else
    {
        [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
        
        //设置Navigation字体颜色
        //        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
        //                                        kNavigationTitleColor,NSForegroundColorAttributeName,
        //                                        kNavigationTitleColor,NSBackgroundColorAttributeName,nil];
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        kNavigationTitleColor,NSForegroundColorAttributeName,
                                        kNavigationTitleColor,NSBackgroundColorAttributeName,
                                        [UIFont systemFontOfSize:19.0f], UITextAttributeFont, nil];
        
        [navVCMessage.navigationBar setTitleTextAttributes:textAttributes];
        [navVCSurrounding.navigationBar setTitleTextAttributes:textAttributes];
        [navVCEasyPurchase.navigationBar setTitleTextAttributes:textAttributes];
        [navVCMyHS.navigationBar setTitleTextAttributes:textAttributes];
    }
    
    if (kSystemVersionLessThan(@"7.0"))
    {
        //设置tabBar颜色
        topTabBarVC.tabBar.tintColor = kTabBarColor;
        //设置选中项字体颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           //                                                       [UIColor blueColor], UITextAttributeTextColor, nil]
                                                           kTabBarItemTextColor, UITextAttributeTextColor, nil]
                                                 forState:UIControlStateSelected];
    }else
    {
        //设置选中项字体颜色 ios > 7
        topTabBarVC.tabBar.tintColor = kNavigationBarColor;//字体颜色与导航条相同
    }
    
    //全局保存navVCMyHS
    data.navVCMyHS = navVCMyHS;
    data.topTabBarVC = topTabBarVC;
    
    //    self.window.rootViewController = [[GYPointDetailViewController alloc] init];
//    UIViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYInvestAccoutViewController class]));
//    UINavigationController *navv = [[UINavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = navv;
    self.window.rootViewController = topTabBarVC;
    topTabBarVC.selectedIndex = 0;//默认显示第n tab
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        //设置状态栏字体为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }

    
    data.ecDomain = [LoginEn sharedInstance].getDefaultEcDm;
    [self.window makeKeyAndVisible];
    
    [data queryUpdate];
    [data getTimeDifference:YES];//获取时间差

    return YES;
}



-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
       
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}

-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
  
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    GYXMPP *xmpp = [GYXMPP sharedInstance];
    [xmpp Logout];
    
       
    
//    if ([GlobalData shareInstance].isHdLogined)    //为互动申请后台运行时间
//    {
//        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//        if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
//        {
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
//                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
//        }
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //检查更新
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
//    [audioPlayer stop];
    GlobalData *data = [GlobalData shareInstance];
    if (kisReleaseTo == 2)      //每次都检查更新
    {
        [data queryUpdate];
    }else if (kisReleaseTo == 1)//app store，后台运行的话，24小时检测一次更新
    {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        static NSTimeInterval oneDay = 24.0 * 60 * 60;
        if (now > data.lastQueryUpdateTime + oneDay)
        {
            [data queryUpdate];
        }
    }
    [data getTimeDifference:YES];//获取时间差
    
    
    //登录
    GYXMPP *xmpp = [GYXMPP sharedInstance];
    [xmpp login:^(IMLoginState state, id error) {
      
    }];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DDLogInfo(@"didReceiveLocalNotification info:%@", notification.userInfo);
    if (notification.userInfo && [notification.userInfo[@"hsmsg"] isEqualToString:@"hsmsg"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            GlobalData *data = [GlobalData shareInstance];
            if (data.topTabBarVC.selectedIndex != 0)
            {
                data.topTabBarVC.selectedIndex = 0;
            }else
            {
                UINavigationController *nav = data.topTabBarVC.viewControllers[0];
                [nav popToRootViewControllerAnimated:NO];
            }
        });
    }
}

- (void)tick:(id)ti
{
//    DDLogInfo(@"正在检查后台在线....剩余时间:%f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
//    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0)
//    {
//        DDLogInfo(@"剩余60s,开始进入后台循环播放空白音乐");
//        [self playSound];
//        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    }
}

- (void)playSound
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    if (!audioPlayer)
//    {
//        audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
//        audioPlayer.numberOfLoops = -1;
//        audioPlayer.volume = 1.0;
//    }
//    
//    [audioPlayer prepareToPlay];
//    [audioPlayer play];
}

@end

//
//  Constant.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//宏定义

#import "Utils.h"
#import "MyLogging.h"
#import "MBProgressHUD.h"
#import "Network.h"
#import "GYXMPP.h"
#import "GlobalData.h"
#import "EasyPurchaseData.h"
#import "LoginEn.h"


#define kisReleaseTo [LoginEn isReleaseTo] //1:发布到appstore 2:企业级发布  主要用于更新检测；
#define kisReleaseEn [LoginEn isReleaseEn] //是否为生产发布环境 否：NO 是：YES

//国际化
#define kLocalized(key) [Utils localizedStringWithKey:key]

//无颜色
#define kClearColor [UIColor clearColor]

//10进制GRB转UIColor
#define kCorlorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//16进制GRB转UIColor
#define kCorlorFromHexcode(hexcode) [UIColor colorWithRed:((float)((hexcode & 0xFF0000) >> 16))/255.0 green:((float)((hexcode & 0xFF00) >> 8))/255.0 blue:((float)(hexcode & 0xFF))/255.0 alpha:1.0]

//加载viewcontroller，通过类名实例化viewcontroller,只适合带有同名的xib文件或没有xib文件的实例化。
#define kLoadVcFromClassStringName(classStringName) [Utils loadVcFromClassStringName:classStringName]

//加载UIImage图片
#define kLoadPng(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"png"]]//加载png图片
#define kLoadJpg(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"jpg"]]//加载jpg图片
#define kLoadImage(fileName,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:ext]]//加载指定扩展名图片

//iOS版本比较 用法：kSystemVersionEqualTo(@"6.0") 返回BOOL
#define kSystemVersionEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame) //等于
#define kSystemVersionGreaterThan(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending) //大于
#define kSystemVersionGreaterThanOrEqualTo(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) //大于等于
#define kSystemVersionLessThan(v)               ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending) //小于
#define kSystemVersionLessThanOrEqualTo(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending) //小于等于

//获取设备宽，高
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

/*
 以下定义系统常量
 */
//当前APP 默认Bundle
#define kDefaultBundle [NSBundle mainBundle]
// 积分字体颜色
#define KPointNumColor kCorlorFromRGBA(0, 143, 215, 1)
//默认控制器的背景色
#define kDefaultVCBackgroundColor kCorlorFromRGBA(240, 240, 240, 1)

//导航栏颜色
//#define kNavigationBarColor kCorlorFromRGBA(39, 159, 222, 1)
#define kNavigationBarColor kCorlorFromHexcode(0xef4136)//kCorlorFromRGBA(235, 90, 60, 1)//

//导航栏字体颜色
#define kNavigationTitleColor kCorlorFromRGBA(255, 255, 255, 1)

//TabBar 颜色
//#define kTabBarColor kCorlorFromRGBA(240, 240, 240, 1)
#define kTabBarColor kDefaultVCBackgroundColor //默认控制器的背景色

//TabBarItem 选中时的字体颜色
#define kTabBarItemTextColor kNavigationBarColor //与导航条背景相同 ios < 7使用

//cell主题灰色的字体颜色
#define kCellItemTitleColor kCorlorFromRGBA(70, 70, 70, 1)//如 现金账户  kCorlorFromRGBA(90, 90, 90, 1)

//cell内容灰色的字体颜色
#define kCellItemTextColor kCorlorFromRGBA(140, 140, 140, 1)//如 现金账户的余额数值

//现金账户的余额数值 使用红色
//#define kCashTextColor kCorlorFromRGBA(230, 80, 55, 1)//D by liangzm

//分割线条颜色
#define kDefaultViewBorderColor kCorlorFromRGBA(200, 200, 200, 1)//(230, 230, 230, 1)

//分割线宽度
#define kDefaultViewBorderWidth 0.5f

//我的资料下textfield点位符文本颜色
#define kTextFieldPlaceHolderColor kCorlorFromRGBA(200, 200, 200, 1)

//确认对话框背景色
#define kConfirmDialogBackgroundColor kCorlorFromRGBA(250, 245, 230, 1)

//金额，互生交易详情中 默认红色字体
#define kValueRedCorlor kCorlorFromRGBA(230, 80, 55, 1)

//默认cell 4inch高度
#define kDefaultCellHeight 64//4inch

//默认cell 3.5inch高度
#define kDefaultCellHeight3_5inch 50 //3.5inch

//默认cell图像Size
#define kDefaultIconSize CGSizeMake(40, 40)

//默认cell图像Size 3.5英寸
#define kDefaultIconSize3_5inch CGSizeMake(36, 36)

//常用CELL主标题字体大小
#define kCellTitleFont [UIFont systemFontOfSize:17]

//常用CELL主标题 粗体字体 大小
#define kCellTitleBoldFont [UIFont boldSystemFontOfSize:17]

//各填写，提示项默认字体大小
#define kDefaultFont [UIFont systemFontOfSize:17]

//确定，下一步按钮默认字体大小
#define kButtonTitleDefaultFont [UIFont systemFontOfSize:18]

//距离上、下、左、右 默认的距离
#define kDefaultMarginToBounds 16.0f

//文件管理器声明
#define kFileManager [NSFileManager defaultManager]

//获得AppDelegate
#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

//系统目录 宏
#define kAppDocumentDirectoryPath  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define kAppLibraryDirectoryPath   NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define kAppCachesDirectoryPath    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//id类型安全转换成字符串
#define kSaftToNSString(v)  [Utils saftToNSString:v]

//id类型安全转换成float or double
#define kSaftToCGFloat(v)   [Utils saftToCGFloat:v]

//id类型安全转换成Integer
#define kSaftToNSInteger(v) [Utils saftToNSInteger:v]

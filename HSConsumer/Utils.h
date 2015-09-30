//
//  Utils.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//公共方法，常用工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"
typedef enum
{
    IdentifierTypeKnown = 0,
    IdentifierTypeZipCode,      //1
    IdentifierTypeEmail,        //2
    IdentifierTypePhone,        //3
    IdentifierTypeUnicomPhone,  //4
    IdentifierTypeQQ,           //5
    IdentifierTypeNumber,       //6
    IdentifierTypeString,       //7
    IdentifierTypeIdentifier,   //8
    IdentifierTypePassort,      //9
    IdentifierTypeCreditNumber, //10
    IdentifierTypeBirthday,     //11
}IdentifierType;

@interface Utils : NSObject

/** zhangqy
 *  判断是否是合法的电话号码格式 +86-0755-83243415 0755-83243415 83243415 8324341
 *
 *  @param phoneNum 电话号码
 *
 *  @return 格式正确为YES
 */
+ (BOOL)isValidTelPhoneNum:(NSString *)phoneNum;

/**
 *检查银行卡是否合法
 *@param value 传入的字符串
 */
+ (BOOL) isValidCreditNumber:(NSString*)value;
 
/**
 *	国际化接口，内容国际化统一接口。【鉴于后续可能做对app内部国际化，故留此接口】
 *
 *	@param 	key 	内容在表中对应的键值
 *
 *	@return	国际化内容
 */
+ (NSString *)localizedStringWithKey:(NSString *)key;

/**
 *	 判断是否含有中文
 *
 *	@param 	 号码
 *	@return 是和否
 */
+(BOOL)isValidCH:(NSString*)mobileNum;

/**
 *	 判断是否含有特殊符号
 *
 *	@param 	 号码
 *	@return 是和否
 */
+(BOOL)isValidByTrimming:(NSString*)str;
/**
 *	获取指定长度的随机字符串(0~9,A~z)
 *
 *	@param 	length 	指定获取长度
 *
 *	@return	随机字符串
 */
+ (NSString *)getRandomString:(int)length;

/**
 *	格式化显示积分卡号：xx xxx xx xxxx
 *
 *	@param 	cardNo 	积分卡号
 *
 *	@return	格式化后的积分卡号
 */
+ (NSString *)formatCardNo:(NSString *)cardNo;

/**
 *	按国际货币显示数值，如：1,212,121.00
 *
 *	@param 	val 	要格式化的数值
 *
 *	@return	格式化后的显示字符
 */
+ (NSString *)formatCurrencyStyle:(double)val;

/**
 *	给view设置边框，圆角
 *
 *	@param 	view 	要设置的view
 *	@param 	width 	边框的宽度
 *	@param 	radius 	圆角半径
 *	@param 	color 	边框颜色
 */
+ (void)setBorderWithView:(UIView *)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color;

/**
 *	设置UITextField Placeholder 的字体大小，颜色。
 *
 *	@param 	textField 	要设置的UITextField
 *	@param 	fontSize 	字体大小
 *	@param 	color 	字体颜色（如使用默认的颜色，使用nil值）
 */
+ (void)setPlaceholderAttributed:(UITextField *)textField withSystemFontSize:(CGFloat)fontSize withColor:(UIColor *)color;

/**
 *	通过类名实例化viewcontroller,只适合带有同名的xib文件或没有xib文件的实例化。
 *
 *	@param 	className 	类名（string）
 *
 *	@return	创建好的viewcontroller
 */
+ (id)loadVcFromClassStringName:(NSString *)className;

/**
 *功能：判断字符串是否为null
 *@param
 *NSString     string    要判断的字符串
 *返回：字符串
 */
+(NSString*)formatNullString:(NSString*)string;

/**
 *功能：判断字符串是否为null
 *@param
 *NSString     string    要判断的字符串
 *返回：字符串
 */
+ (BOOL)isBlankString:(NSString *)string;
/**
 *功能：获取字体高度，用于动态计算label高度。
 *   @param  value 要计算高度的字符串
 *   @param  fontSize 设置字符串字体
 *   @param  width    设置label的宽度
 *   返回：高度值
 */
+(float) heightForString:(NSString*)value fontSize:(float)fontSize andWidth:(float)width;

/**
 *	验证输入是不是纯数字
 *
 *	@param 	手机号字符串
 *
 *
 *   返回：布尔型
 */
+(BOOL)isValidMobileNumber:(NSString*)number;

/**
 *	验证输入的是否是正确格式的手机号
 *
 *	@param 	手机号字符串
 *
 *
 *   返回：布尔型
 */
+(BOOL)isMobileNumber:(NSString*)mobileNum;

/**
 *	验证邮箱地址的支持格式xxx.xxx@xxx.xxx.xxx
 *
 *	@param 	邮箱字符串号字符串
 *
 *
 *   返回：布尔型
 */
+(BOOL)emailCheck:(NSString*) str;

/**
 *	 显示提示器 指定显示代理  父视图  提示内容 提示时间
 *
 *	@param 	sender    代理对象
 *  @param 	superview    superView
 *  @param 	msg          提示内容
 *  @param 	showtime     提示时间
 *   返回：  MBProgressHUD *
 */
+(MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;

/**
 *	 显示提示器 指定显示代理  父视图  提示内容 提示时间 提示器的左方向偏移量
 *
 *	@param 	sender    代理对象
 *  @param 	superview    superView
 *  @param 	msg          提示内容
 *  @param 	showtime     提示时间
 *   返回：  MBProgressHUD *
 */
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset;
/**
 *	 显示提示器 指定显示代理  父视图  提示内容  可见的矩形区域
 *
 *	@param 	sender    代理对象
 *  @param 	superview    superView
 *  @param 	msg          提示内容
 *  @param 	vRect        矩形区域
 *   返回：  MBProgressHUD *
 */
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect;

/**
 *	 显示提示器 指定显示代理  父视图  提示内容 左偏移量
 *
 *	@param 	sender    代理对象
 *  @param 	superview    superView
 *  @param 	msg          提示内容
 *
 *   返回：  MBProgressHUD *
 */
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset ;

/**
 *	 显示提示器 指定显示代理  父视图  提示内容
 *
 *	@param 	sender    代理对象
 *  @param 	superview    superView
 *  @param 	msg          提示内容
 *
 *   返回：  MBProgressHUD *
 */
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg;

/**
 *	 隐藏提示器 隐藏后 会从父试图中移除
 *

 *  @param 	superview    superView

 *   返回：  MBProgressHUD *
 */
+ (void) hideHudView:(MBProgressHUD *)hud;


/**
 *	 隐藏提示器    隐藏后 会从父试图中移除
 
 *  @param 	superview    superView通常为self.view self.view.window

 *   返回：  MBProgressHUD *
 */
+ (void) hideHudViewWithSuperView :(UIView *)superView;

/**
 *	 获取 返回jeson data字段的resultCode
 
 *  @param 	superview    superView通常为self.view self.view.window
 
 *   返回：  MBProgressHUD *
 */
+ (NSString *) GetResultCode :(NSDictionary *) JesonDict;

/**
 *	弹出提示框，只有一个确定按钮
 *
 *	@param 	title 	标题
 *	@param 	message 	提示信息
 */
+ (void)alertViewOKbuttonWithTitle:(NSString *)title message:(NSString *)message;


/**
 *	弹出提示框，只有一个确定按钮, isPopVC为nil时，不作弹出动作， isPopVC为UINavigationController 将弹出
 *
 *	@param 	title 	标题
 *	@param 	message 	提示信息
 *	@param 	nav 	isPopVC为nil时，不作弹出动作；isPopVC为UINavigationController 将弹出
 */
+ (void)showMessgeWithTitle:(NSString *)title message:(NSString *)message isPopVC:(UINavigationController *)nav;

/**
 *	NSDate 转换为字符串格式：yyyy-MM-dd HH:mm:ss
 *
 *	@param 	date 	要转换的NSDate
 *
 *	@return yyyy-MM-dd HH:mm:ss 格式的字符串时间
 */
+ (NSString *)dateToString:(NSDate *)date;

/**
 *	NSDate 转换为字符串格式
 *
 *	@param 	date 	要转换的NSDate
 *	@param 	dateFormat 	格式的字符串，如：yyyy-MM-dd HH:mm:ss 、yyyy-MM-dd
 *
 *	@return	格式化后的时间字符串
 */
+ (NSString *)dateToString:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 *	将string转换成字典
 *
 *	@param 	string  入参：字符串
 *
 *	@return	字典
 */
+ (NSDictionary *)stringToDictionary:(NSString *)string;

/**
 *	将字典转换成string
 *
 *	@param 	dic   入参：字典
 *
 *	@return	字符串
 */
+ (NSString *)dictionaryToString:(NSDictionary *)dic;

/**
 *	设置view自动缩小字体以适应宽高
 *
 *	@param 	view 	要设置的view
 *	@param 	lines 	行数
 */
+ (void)setFontSizeToFitWidthWithLabel:(id)view labelLines:(NSInteger)lines;

/**
 *	id类型安全转换成字符串
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的字符串
 */
+ (NSString *)saftToNSString:(id)idVaule;

/**
 *	id类型安全转换成float or double
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的CGFloat
 */
+ (CGFloat)saftToCGFloat:(id)idVaule;

/**
 *	id类型安全转换成Integer
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的Integer
 */
+ (NSInteger)saftToNSInteger:(id)idVaule;

/**
 *	 *
 *	@param Email 需要判断的邮箱字符串
 *
 *	@return	bool
 */
+ (BOOL)isValidateEmail:(NSString *)Email;


/**
 *	 *判断是否是邮编
 *	@param value 需要判断的邮编字符串
 *
 *	@return	bool
 */
+ (BOOL) isValidZipcode:(NSString*)value;

/**
 *	 *判断是否是护照号码
 *	@param value 需要判断的邮编字符串
 *
 *	@return	bool
 */
+ (BOOL) isValidPassport:(NSString*)value;

/**
 *	隐藏键盘
 */
+ (void)hideKeyboard;

/**
 *	获取文件大小（bit）,文件不存在，或获取不到文件大小，返回0
 *
 *	@param 	fileFullName 	文件的完整路径
 *
 *	@return	文件大小（bit）
 */
+ (unsigned long long)getFileSize:(NSString *)fileFullName;

/**
 *	基本上包含全部的手机号段
 *
 *	@param 	手机号码
 *
 *	@return bool
 */
+ (BOOL)checkTel:(NSString *)str;

/**
 *	创建本地通知
 *
 *	@param 	timeInterval 	延迟响应时间
 *	@param 	zone 	时区
 *	@param 	userDic 	传递的info信息，字典对象
 *	@param 	body 	显示推送的内容
 */
+(void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body;

/**
 *	判断是否为互生卡
 *
 *	@param 	cardNo 	要判断的互生号
 *
 *	@return	YES 是互生号 NO不是互生号
 */
+ (BOOL)isHSCardNo:(NSString *)cardNo;

/**
 *  判断是不是护照
 *
 *  @param pNo  护照号码
 *
 *  @return YES
 */


+ (BOOL)isPassportNo:(NSString *)pNo;

/**
 * 通过指定宽度裁剪图片
 * @param 要裁剪的图片
 * @param 定义的宽度
 *
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 * 通过指定string和字体和最大宽度得到size
 * @str string
 * @font 字体
 * @width 宽度
 *
 */
+(CGSize)sizeForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width;
/**
 *  拨打电话号码
 *
 *  @param phoneNumber 号码
 *  @param view        要将提示显示在哪个视图
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber showInView:(UIView *)view;
/**
 *  返货去掉jid中的_符号

 */
+(NSString *)getResNO:(NSString *)resNo;


+(BOOL)isBankCardNo:(NSString *)pNo;
/** add by songjk 根据id获取服务名称
 *
 *
 *  @param serviceCode 服务码
 *
 *  @return 服务名称
 */
+(NSString *)getServiceNameWithServiceCode:(NSString *)serviceCode;
/** add by songjk 根据字体和宽度返回高度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width;
@end

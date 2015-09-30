//
//  Utils.m
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "Utils.h"
#import "UIView+CustomBorder.h"
#import "GYDBCenter.h"
#import "JGActionSheet.h"

//#define HudTag 99
#define HUD_VIEW_WIDTH 320
#define HUD_VIEW_HEIGHT 160
#define TRIMSTRING(str)[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}
@implementation Utils

+ (NSString *)localizedStringWithKey:(NSString *)key
{
    
    return NSLocalizedString(key, nil); //当前随系统语言进行本地化
}

+ (NSString *)getRandomString:(int)length
{
    const char list[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    char sele[24],*p;
    p = sele;
    int len = (int)strlen(list);
    for(int i = 0; i < length; i++){
        *p++ = list[arc4random() % len];
    }
    *p = 0;
    NSString *str = [NSString stringWithFormat:@"%s", sele];
    return str;
}

+ (NSString *)formatCardNo:(NSString *)cardNo
{
    if (cardNo.length != 11) return cardNo;
    NSString *cardNo1 = [cardNo substringWithRange:NSMakeRange(0, 2)];
    NSString *cardNo2 = [cardNo substringWithRange:NSMakeRange(2, 3)];
    NSString *cardNo3 = [cardNo substringWithRange:NSMakeRange(5, 2)];
    NSString *cardNo4 = [cardNo substringWithRange:NSMakeRange(7, 4)];
    NSString *formatCardNo = [NSString stringWithFormat:@"%@ %@ %@ %@", cardNo1, cardNo2, cardNo3, cardNo4];
    return formatCardNo;    
}

+ (NSString *)formatCurrencyStyle:(double)val
{
    //自带方式
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
//    NSString *value = [formatter stringFromNumber:[NSNumber numberWithDouble:val]];
//    return value;
    
    //自定义方式
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"];//@"$#,###0.00"    format:12345678.987 =912,345,678.10
//    [numberFormatter setPositiveFormat:@"0,000.##"];//@"$#,###0.00"    format:12345678.987 =912,345,678.10
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:val]];
    
    //    NSString *formattedNumberString = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]
    //                                                                         numberStyle:NSNumberFormatterCurrencyStyle];//本地化货币显示
    return formattedNumberString;

    
    
}


+(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    if (width == 0)
    {
        [view removeAllBorder];
    }else
    {
        [view addAllBorder];
    }

    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}

+ (void)setPlaceholderAttributed:(UITextField *)textField withSystemFontSize:(CGFloat)fontSize withColor:(UIColor *)color
{
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
    {
        if (color)
        {
            textField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString: textField.placeholder ? textField.placeholder : @""
                                            attributes:@{
                                                         NSForegroundColorAttributeName : color,
                                                         NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                                         }
             ];
            
        }else
        {
            textField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:textField.placeholder ? textField.placeholder : @""
                                            attributes:@{
                                                         NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                                         }
             ];
        }

    }
}

+ (id)loadVcFromClassStringName:(NSString *)className
{
    if (className)
    {
        NSString *nibFilePath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        NSString *xibFilePath = [[NSBundle mainBundle] pathForResource:className ofType:@"xib"];
        if (nibFilePath || xibFilePath)
        {
            return [[NSClassFromString(className) alloc] initWithNibName:className bundle:[NSBundle mainBundle]];
        }
        else
        {
            return [[NSClassFromString(className) alloc] init];
        }
    }else
    {
        return [[NSClassFromString(className) alloc] init];
    }
}



//是否是空字符串
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




//验证字符串是不是空，返回不是空的字符串，否则返回@“”，主要是过滤字符串首位的空格
+(NSString*)formatNullString:(NSString*)string{
    NSString*strTemp =TRIMSTRING(string);
    if([strTemp isEqualToString:@"null"] || [strTemp isEqualToString:@"NULL"]) {
        return @"";
    }else{
        return strTemp;
    }
}

//银行卡是否合法！

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}


+ (BOOL) isValidCreditNumber:(NSString*)value
{
    BOOL result = YES;
    NSInteger length = [value length];
    if (length >= 13)
    {
        result = [Utils isValidNumber:value];
        if (result)
        {
                NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
                //CUP
                if ((begin >= 622126 && begin <= 622925) && (19 != length))
                {
                    result = NO;
                }
                //other
                else
                {
                    result = YES;
                }
        }
        if (result)
        {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2)
            {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else
            {
                index = 1;
                leftIndex = 0;
            }
            while (index < length)
            {
                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? YES:NO;
        }
    }
    else
    {
        result = NO;
    }
    return result;
}


//手机号码验证，现在只检查是数字
+(BOOL)isValidMobileNumber:(NSString*)number
{
    if(!number || number.length==0) {
        return NO;
    }
    else{
        for(int index =0; index<number.length; index++) {
            unichar curChar_f = [number characterAtIndex:index];
           
            
            if(!(curChar_f>='0'&& curChar_f<='9')) {
                
                return NO;
            }
        }
        return YES;
    }
}

+ (float) heightForString:(NSString*)value fontSize:(float)fontSize andWidth:(float)width
{
    //float fpadding=16.0;
//    if (!value.length>0 ||[value isEqualToString:@"null"]||[Utils isBlankString:value]) {
//        return 0;
//    }
    if (value == nil||!value.length>0||[value isEqualToString:@"null"]) {
        return 30;
    }
    CGSize sizeToFit;

    sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]constrainedToSize:CGSizeMake(width,2000)lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    
    
    return  sizeToFit.height;
}

+(BOOL)isValidByTrimming:(NSString*)str
{
    NSLog(@"%@",str);
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
   str = [[str componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    NSLog(@"%@",str);
    return NO;
}



//是否包含中文
+(BOOL)isValidCH:(NSString*)mobileNum
{
    for(int i=0; i< [mobileNum length];i++){ int a = [mobileNum characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
    {
        return YES;
    }
    }
    return NO;
}



//验证输入的是否是正确格式的手机号
+ (BOOL)isMobileNumber:(NSString*)mobileNum
{
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     */
    //NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString* MOBILE =@"^1\\d{10}$";//不需要配备这么多规则，只用验证11位且开头是1的数字即可
    
    /**
     10         *中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM =@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         *中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU =@"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         *中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* CT =@"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         *大陆地区固话及小灵通
     26         *区号：010,020,021,022,023,024,025,027,028,029
     27         *号码：七位或八位
     28         */
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * PHS1 = @"^0(10|2[0-5789]|\\d{3}-)\\d{7,8}$";
    NSString *phs2 = @"^(^0\\d{2}-?\\d{8}$)|(^0\\d{3}-?\\d{7}$)|(^0\\d2-?\\d{8}$)|(^0\\d3-?\\d{7}$)$";
    /**
     29         *国际长途中国区(+86)
     30         *区号：+86
     31         *号码：十一位
     32         */
    NSString* IPH =@"^\\+861(3|5|8)\\d{9}$";
    
    //判断是否为正确格式的手机号码
    NSPredicate* regextestmobile;
    NSPredicate* regextestcm;
    NSPredicate* regextestcu;
    NSPredicate* regextestct;
    NSPredicate* regextestiph;
    
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    regextestiph = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IPH];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestphs1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS1];
    NSPredicate *regextestphs2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phs2];
    if(([regextestmobile evaluateWithObject:mobileNum] ==YES)
       || ([regextestcm evaluateWithObject:mobileNum] ==YES)
       || ([regextestct evaluateWithObject:mobileNum] ==YES)
       || ([regextestcu evaluateWithObject:mobileNum] ==YES)
       || ([regextestiph evaluateWithObject:mobileNum] ==YES)
       ||([regextestphs evaluateWithObject:mobileNum]==YES)
       ||([regextestphs1 evaluateWithObject:mobileNum]==YES)
       ||([regextestphs2 evaluateWithObject:mobileNum]==YES))
    {
        return YES;
    }
    else
    {
        
        return NO;
    }
}

// 备用email验证支援格式xxx.xxx@xxx.xxx.xxx
+(BOOL)emailCheck:(NSString*) str
{
    
    if (([str rangeOfString:@".@"].length >0)||([str rangeOfString:@"@."].length>0))
        
    {
        return FALSE;
    }
    if(![str rangeOfString:@"@"].length  >0)
    {
        return FALSE;
    }else
    {
        NSString*headStr=[str substringToIndex:[str rangeOfString:@"@"].location];
        NSString*endStr=[str substringFromIndex:[str rangeOfString:@"@"].location];
        
        if([headStr length]==0)
        {
            return FALSE;
        }
        if([headStr characterAtIndex:0]=='.')
        {
            return FALSE;
        }
        if([endStr length]==0) {
            return FALSE;
        }
        if([endStr rangeOfString:@"."].length==0)
        {
            return FALSE;
        }
        if([endStr characterAtIndex:[endStr length]-1]=='.')
        {
            return FALSE;
        }
    }
    
    return TRUE;
}

//判断邮箱是否有效的方法
+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}


//判断是否是正确的邮编
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    if (len != 6) {
        return NO;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return NO;
        }
    }
    return YES;
}

//判断是否是正确的护照
+ (BOOL) isValidPassport:(NSString*)value
{
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G'))
    {
        return FALSE;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return FALSE;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = FALSE;
            break;
        }
    }
    return result;
}


/*隐藏ProgressView
 type:1,None(直接隐藏ProgressView) 2,success(请求成功提示后隐藏) 3,failed(请求失败提示后隐藏) 4,notification(特定隐藏)
 message:延后隐藏需要显示的信息
 delay:延后多少毫秒隐藏
 */
//+ (void)hideProgressViewForType:(ProgressViewHiddenType)type message:(NSString *)message afterDelay:(NSTimeInterval)delay{
//    GYAppDelegate *appDelegate = (GYAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [GYAppDelegate hideProgressViewForType:type message:message afterDelay:delay];
//}
//
//+ (void)showLoadingProgressViewWithText:(NSString *)string{
//     GYAppDelegate *appDelegate =( GYAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [GYAppDelegate showLoadingProgressViewWithText:string];
//}

+ (BOOL) isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
       
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
//    hudView.yOffset = 150.f;
     hudView.tag=1000;
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2 - leftOffset;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    hudView.tag=1000;
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    hudView.tag=1000;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //屏幕中心的y轴偏移量
//   hudView.yOffset = -100.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }else {
        NSLog(@"%@---------rect",NSStringFromCGRect(vRect));
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
         NSLog(@"%@---------rect",NSStringFromCGRect(hudView.frame));
        [superView addSubview:hudView];
    }
    hudView.delegate = sender;
    hudView.tag=1000;
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
//  hudView.yOffset = 150.f;
    
    
    [hudView show:YES];

    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50 - leftOffset;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }
    
    hudView.delegate = sender;
     hudView.tag=1000;
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    hudView.yOffset = 150.0f;
    
    [hudView show:YES];
    return hudView;
}


+ (void) hideHudView:(MBProgressHUD *)hud
{
    if (hud) {
        [hud hide:YES];
        hud=nil;
    }
}

//需指定 删除hub的父试图，通常是self.view self.view.window
+ (void) hideHudViewWithSuperView :(UIView *)superView
{
    MBProgressHUD * hud =(MBProgressHUD *)[superView viewWithTag:1000];
    if (hud) {
            [self hideHudView:hud];
    }
    
}

+ (NSString *) GetResultCode :(NSDictionary *) JesonDict
{
    if (JesonDict==nil||[JesonDict objectForKey:@"data"]==nil) {
        return nil;
    }
    NSString * str =[NSString stringWithFormat:@"%@",[[JesonDict objectForKey:@"data"] objectForKey:@"resultCode"]];
     return str;

}

+ (void)alertViewOKbuttonWithTitle:(NSString *)title message:(NSString *)message
{
    [self showMessgeWithTitle:title message:message isPopVC:nil];
}

+ (void)showMessgeWithTitle:(NSString *)title message:(NSString *)message isPopVC:(UINavigationController *)nav
{
    UIAlertView *alert = [UIAlertView showWithTitle:title message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (nav)
        {
            [nav popViewControllerAnimated:YES];
        }
    }];
    [alert show];
}

+ (NSString *)dateToString:(NSDate *)date
{
    return [self dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)dateToString:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDictionary *)stringToDictionary:(NSString *)string
{
    if (!string || string.length < 1) return nil;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
    if (error)
    {
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToString:(NSDictionary *)dic
{
    if (!dic) return nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (error)
    {
        return nil;
    }
    return string;
}

+ (void)setFontSizeToFitWidthWithLabel:(id)view labelLines:(NSInteger)lines
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *label = view;
        label.numberOfLines = lines;
        label.minimumFontSize = 8;
        label.adjustsFontSizeToFitWidth = YES;
    }else if([view isKindOfClass:[UITextField class]])
    {
        UITextField *textField = view;
        textField.minimumFontSize = 8;
        textField.adjustsFontSizeToFitWidth = YES;
    }
}

+ (NSString *)saftToNSString:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSString class]])
    {
        return idVaule;
    }else if (!idVaule || [idVaule isKindOfClass:[NSNull class]])//空
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", idVaule];
}

+ (CGFloat)saftToCGFloat:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]])
    {
        return [idVaule floatValue];
    }
    return [[self saftToNSString:idVaule] floatValue];
}

+ (NSInteger)saftToNSInteger:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]])
    {
        return [idVaule integerValue];
    }
    return [[self saftToNSString:idVaule] integerValue];
}

+ (void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (unsigned long long)getFileSize:(NSString *)fileFullName
{
    if ([GYDBCenter fileIsExists:fileFullName])
    {
        NSError *err = nil;
        NSDictionary *fileAttr = [kFileManager attributesOfItemAtPath:fileFullName error:&err];
        if (err)
        {
            DDLogInfo(@"获取文件大小失败：%@", fileFullName);
            return 0;
        }
        return (unsigned long long)([[fileAttr objectForKey:NSFileSize] longLongValue]);
    }
    return 0;
}

+ (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
     
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        
        return NO;
        
    }
    
    
    
    return YES;
    
}

+(void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body
{
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];//新建通知
    notification.soundName = UILocalNotificationDefaultSoundName;//
    
    notification.fireDate=[[NSDate date] dateByAddingTimeInterval:timeInterval];//距现在多久后触发代理方法
    notification.timeZone = zone;//设置时区
    notification.userInfo = userDic;//在字典用存需要的信息
    notification.alertBody = body;//提示信息弹出提示框
    notification.alertAction = @"open";  //提示框按钮
    //    notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];//将新建的消息加到应用消息队列中
}

+ (BOOL)isHSCardNo:(NSString *)cardNo
{
    NSString * regex = @"^[0-9]{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:cardNo];
    if (!isMatch) return NO;
    
    NSString *cardNo1 = [cardNo substringWithRange:NSMakeRange(0, 2)];
    NSString *cardNo2 = [cardNo substringWithRange:NSMakeRange(2, 3)];
    NSString *cardNo3 = [cardNo substringWithRange:NSMakeRange(5, 2)];
    NSString *cardNo4 = [cardNo substringWithRange:NSMakeRange(7, 4)];
    
    if ([cardNo1 intValue] <= 0 ||
        [cardNo2 intValue] <= 0 ||
        [cardNo3 intValue] <= 0 ||
        [cardNo4 intValue] <= 0)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isPassportNo:(NSString *)pNo
{
    NSString * regex = @"^[A-Z][0-9]{7,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pNo];
    
    return isMatch;
    
}


+ (BOOL)isBankCardNo:(NSString *)pNo
{
    NSString * regex = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pNo];
    
    return isMatch;
    
}

+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGSize)sizeForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width
{
    if (kSystemVersionGreaterThanOrEqualTo(@"7.00"))
    {
        return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    else
    {
        return [str sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    }
}


/**
 *  拨打号码
 *
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber showInView:(UIView *)view

{
       JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
    JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
    NSArray *asss = @[ass0, ass1];
    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0)
                {
                    NSLog(@"呼叫号码");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
                }else if (indexPath.row == 1)
                {
                    NSLog(@"复制号码");
                }
            }
                break;
            case 1:
            {
                NSLog(@"取消");
            }
                break;
                break;
                
            default:
                break;
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    [as setCenter:CGPointMake(100, 100)];
    
    [as showInView:view animated:YES];
  
}
+(NSString *)getResNO:(NSString *)resNo
{
    if (!resNo)
    {
        return @"";
    }
    NSRange range = [resNo rangeOfString:@"_"];
    NSString * result = resNo;
    if (range.location != NSNotFound)
    {
        result = [resNo substringFromIndex:range.location + 1];
        result = [self getResNO:result];
    }
    return result;
}
/** add by zhangqy
 *  判断是否是合法的电话号码格式 +86-0755-83243415 0755-83243415 83243415 8324341
 *
 *  @param phoneNum 电话号码
 *
 *  @return 格式正确为YES
 */
+ (BOOL)isValidTelPhoneNum:(NSString *)phoneNum
{
   // NSString *check = @"^([+]\\d{2}[-]?)?(\\d{4}[-]?)?\\d{7,8}$";
    NSString *check = @"^(\\+?\\d{2,3}\\-)?(0\\d{2,3}-?)?\\d{7,8}$";

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",check];
    return [predicate evaluateWithObject:phoneNum];
}
/** add by songjk 根据id获取服务名称
 *
 *
 *  @param serviceCode 服务码
 *
 *  @return 服务名称
 */
+(NSString *)getServiceNameWithServiceCode:(NSString *)serviceCode
{
    if (!serviceCode || serviceCode.length == 0)
    {
        return @"";
    }
    NSString * strName = @"";
    if ([serviceCode isEqualToString:@"2"])
    {
        strName = @"即时送达";
    }
    else if ([serviceCode isEqualToString:@"3"])
    {
        strName = @"送货上门";
    }
    else if ([serviceCode isEqualToString:@"4"])
    {
        strName = @"货到付款";
    }
    else if ([serviceCode isEqualToString:@"5"])
    {
        strName = @"门店自提";
    }
    else if ([serviceCode isEqualToString:@"6"])
    {
        strName = @"6";
    }
    return strName;
}
/** add by songjk 根据字体和宽度返回高度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width
{
    if (kSystemVersionGreaterThanOrEqualTo(@"7.00"))
    {
        return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    }
    else
    {
        return [str sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT)].height;
    }
    
}
@end

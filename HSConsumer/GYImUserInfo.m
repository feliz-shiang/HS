//
//  GYImUserInfo.m
//  HSConsumer
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYImUserInfo.h"

@implementation GYImUserInfo

- (void)setValuesFromDictionary:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])  return;
    
    NSString * accountid=[NSString stringWithFormat:@"%@_%@",kSaftToNSString(dic[@"card"]),kSaftToNSString(dic[@"accountNo"])];
    
    _strAccountId = accountid;
    _strAccountNo = kSaftToNSString(dic[@"accountNo"]);
    _strAddress = kSaftToNSString(dic[@"address"]);
    _strAge = kSaftToNSString(dic[@"age"]);
    _strArea = kSaftToNSString(dic[@"area"]);
    _strBirthday = kSaftToNSString(dic[@"birthday"]);
    _strBloodType = kSaftToNSString(dic[@"bloodType"]);
    _strCard = kSaftToNSString(dic[@"card"]);
    _strCity = kSaftToNSString(dic[@"city"]);
    _strCountry = kSaftToNSString(dic[@"country"]);
    _strEmail = kSaftToNSString(dic[@"email"]);
    _strHeadPic = kSaftToNSString(dic[@"headPic"]);
    _strId = kSaftToNSString(dic[@"id"]);
    _strInterest = kSaftToNSString(dic[@"interest"]);
    _strMobile = kSaftToNSString(dic[@"mobile"]);
    _strName = kSaftToNSString(dic[@"name"]);
    _strNickName = kSaftToNSString(dic[@"nickName"]);
    _strOccupation = kSaftToNSString(dic[@"occupation"]);
    _strProvince = kSaftToNSString(dic[@"province"]);
    _strQQNo = kSaftToNSString(dic[@"qqNo"]);
    _strResourceNo = kSaftToNSString(dic[@"resourceNo"]);
//    _strRows = kSaftToNSString(dic[@"rows"]);
    _strSchool = kSaftToNSString(dic[@"school"]);
    _strSex = kSaftToNSString(dic[@"sex"]);
    _strSign = kSaftToNSString(dic[@"sign"]);
    _strStart = kSaftToNSString(dic[@"start"]);
    _strTag = kSaftToNSString(dic[@"tag"]);
    _strTelNo = kSaftToNSString(dic[@"telNo"]);
    _strUserId = kSaftToNSString(dic[@"userId"]);
    _strWeixinNo = kSaftToNSString(dic[@"weixinNo"]);
    _strZipNo = kSaftToNSString(dic[@"zipNo"]);
    _strHeadBigPic = kSaftToNSString(dic[@"headBigPic"]);
}
-(NSString *)strHeadPic
{
    if (_strHeadPic == nil) {
        _strHeadPic = @"";
    }
    else
    {NSUInteger count = 0;
        NSString * string1 = _strHeadPic;
        NSString * string2 = @"http";
        NSString * string3 = @"";
        if (string2.length < string1.length)
        {
            for (int i = 0; i < string1.length - string2.length + 1; i++)
            {
                
                if ([[string1 substringWithRange:NSMakeRange(i, string2.length)] isEqualToString:string2])
                {
                    count++;
                    string3 = [string1 substringFromIndex:i];
                }
                
            }
            NSLog(@"httpcount ===== %zi",count);
            NSLog(@"http ===== %@",string3);
        }
        //        if (string3.length>0) {
        //            if ([string3 rangeOfString:@".png"].location == NSNotFound) {
        //                string3 = [string3 stringByAppendingString:@".png"];
        //            }
        //        }
        if (string3.length>0) {
            _strHeadPic = string3;
        }
        else
        {
            if (![_strHeadPic hasPrefix:@"http"])
            {
                _strHeadPic = [[GlobalData shareInstance].tfsDomain stringByAppendingString:_strHeadPic];
            }
        }
    }
    return _strHeadPic;
}
@end

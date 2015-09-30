//
//  UserData.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "UserData.h"
#import "GlobalData.h"

@implementation UserData

//- (NSArray *)bankInfoList
//{
//    if (!_bankInfoList)
//    {
//        GlobalData *data = [GlobalData shareInstance];
//        NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
//        NSDictionary *allParas = @{@"system": @"person",
//                                   @"cmd": @"get_bank_list",
//                                   @"params": subParas,
//                                   @"uType": kuType,
//                                   @"mac": kHSMac,
//                                   @"mId": data.midKey,
//                                   @"key": data.hsKey
//                                   };
//        
//        [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
//            if (!error)
//            {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                    options:kNilOptions
//                                                                      error:&error];
//                DDLogInfo(@"get_bank_list dic:%@", dic);
//                if (!error)
//                {
//                    if ([dic[@"code"] isEqualToString:kHSRequestSucceedCode] &&
//                        dic[@"data"] &&
//                        ([dic[@"data"][@"resultCode"] intValue] == kHSRequestSucceedSubCode))//返回成功数据
//                    {
//                        dic = dic[@"data"];
//                        
//                        
//                    }else//返回失败数据
//                    {
//                    }
//                }else
//                {
//                }
//                
//            }else
//            {
//            }
//        }];
//    }
//    return _bankInfoList;
//}
//
//- (NSDictionary *)getBankInfoFromBankInfoList:(NSArray *)bankList withBankID:(NSString *)bID
//{
//}

@end

//
//  GYNewFiendModel.m
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYNewFiendModel.h"

//http://192.168.228.97:9099/v1/tfs/http://192.168.228.97:9099/v1/tfs//T1IRWTBvYT1R4cSCrK

@implementation GYNewFiendModel
-(NSString *)strFriendIconURL
{
    if (_strFriendIconURL == nil) {
        _strFriendIconURL = @"";
    }
    else
    {NSUInteger count = 0;
        NSString * string1 = _strFriendIconURL;
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
            _strFriendIconURL = string3;
        }
        else
        {
            if (![_strFriendIconURL hasPrefix:@"http"])
            {
                _strFriendIconURL = [[GlobalData shareInstance].tfsDomain stringByAppendingString:_strFriendIconURL];
            }
        }
    }
    return _strFriendIconURL;
}
@end

//
//  GYMallBaseInfoModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/1.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYMallBaseInfoModel.h"

@implementation GYMallBaseInfoModel




#pragma mark 加载商城详情
+(void)loadBigShopDataWithVshopid:(NSString *)vShopID result:(dictResult)result
{
    if (!vShopID || vShopID.length==0) {
        result(nil,nil);
    }
    else
    {
        
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
        [dict setValue:vShopID forKey:@"vShopId"];
        [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getVShopIntroduction" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
            if (error)
            {
                result(nil,error);
            }
            else
            {
                NSDictionary * dictALL = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSInteger code = kSaftToNSInteger([dictALL objectForKey:@"retCode"]) ;
                if (code == 200)
                {
                    
                    NSDictionary * dictData = [dictALL objectForKey:@"data"];
                    if (dictData.count>0)
                    {
                        result(dictData,nil);
                    }
                    else
                    {
                        result(nil,nil);
                    }
                }
                else
                {
                    result(nil,nil);
                }
            }
        }];
    }
}

+(NSDictionary *)objectClassInArray
{
    
    return @{@"picList":@"GYMallBaseInfoPicListModel",@"shops":@"GYMallBaseInfoShopsModel"};
}
@end

@implementation GYMallBaseInfoPicListModel

@end


@implementation GYMallBaseInfoShopsModel

@end

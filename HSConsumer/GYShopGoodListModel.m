//
//  GYShopGoodListModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYShopGoodListModel.h"

@implementation GYShopGoodListModel


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (void)loadDataFromNetWorkWithParams:(NSDictionary *)params Complection:(CompletionBlock)block;
{
    NSString *requestUrl = [[GlobalData shareInstance].ecDomain stringByAppendingPathComponent:@"shops/searchShopItem"];
 
    Network *netwrok = [Network sharedInstance];
    [netwrok HttpGetForRequetURL:requestUrl parameters:params requetResult:^(NSData *jsonData, NSError *error) {
        NSError *jsonError;
        NSMutableArray * goodsList = [[NSMutableArray alloc]init];
        if (jsonData) {
            
            NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError==nil) {
                NSArray *datas = rootDict[@"data"];
                
                for (NSDictionary *item in datas) {
                    GYShopGoodListModel *model = [[GYShopGoodListModel alloc]initWithDictionary:item error:nil];
                    [goodsList addObject:model];
                }
                block(goodsList,nil);
            }
        }
        
    }];
}

@end

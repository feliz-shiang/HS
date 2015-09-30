//
//  UPPayPluginTest.m
//  HSConsumer
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "UPPayPluginTest.h"

@implementation UPPayPluginTest

+ (void)UPPayTest:(void (^)(NSString *tn, NSError *error))handler
{
    
    NSString *strURL = @"http://202.101.25.178:8080/sim/gettn";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString* tn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               handler(tn, error);
                           }];
}
@end

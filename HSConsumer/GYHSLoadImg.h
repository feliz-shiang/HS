//
//  GYUploadImg.h
//  HSConsumer
//
//  Created by 00 on 15-2-2.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GYHSLoadImgDelegate <NSObject>

-(void)didFinishUploadImg:(NSURL*)url;

@end


@interface GYHSLoadImg : NSObject<NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *recvData;
}

@property (strong ,nonatomic) UIImage *imgChat;

@property (assign ,nonatomic) id<GYHSLoadImgDelegate> delegate;


-(void)uploadImg:(UIImage *)image :(NSString *)name;

-(UIImage *)downloadImg:(NSURL *)url;


@end

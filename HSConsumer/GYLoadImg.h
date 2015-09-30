//
//  GYUploadImg.h
//  HSConsumer
//
//  Created by 00 on 15-2-2.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GYLoadImgDelegat <NSObject>

@optional
-(void)didFinishUploadImg:(NSURL*)url WithIndexPath:(NSIndexPath*)indexPath;
-(void)didFailUploadImg : (NSError *)error WithIndexPath:(NSIndexPath*)indexPath;//上传图片失败代理

@end


@interface GYLoadImg : NSObject<NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *recvData;
}

@property (strong ,nonatomic) UIImage *imgChat;
@property (strong ,nonatomic) NSIndexPath *indexPath;
@property (assign ,nonatomic) id<GYLoadImgDelegat> delegate;
-(void)uploadImg:(UIImage *)image WithIndexPath:(NSIndexPath *)indexPath;
-(UIImage *)downloadImg:(NSURL *)url;


@end

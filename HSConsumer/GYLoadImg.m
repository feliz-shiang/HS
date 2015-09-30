//
//  GYUploadImg.m
//  HSConsumer
//
//  Created by 00 on 15-2-2.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYLoadImg.h"
#import "GlobalData.h"
#import "Network.h"
#import "UIImageView+WebCache.h"
@implementation GYLoadImg


-(void)uploadImg:(UIImage *)image WithIndexPath:(NSIndexPath *)indexPath
{
    self.imgChat = image;
    self.indexPath = indexPath;
    [self postImage];
}

#define BOUNDARY @"ABC12345678"
-(void)postImage
{
    NSString * s = [NSString stringWithFormat:@"%@/hsim-img-center/upload/imageUpload?type=%@&fileType=%@&key=%@&id=%@&mid=%@",[GlobalData shareInstance].hdbizDomain,@"product",@"image",[GlobalData shareInstance].ecKey,[GlobalData shareInstance].user.cardNumber,[GlobalData shareInstance].midKey];
    
    NSURL *url = [NSURL URLWithString:s];
    DDLogInfo(@"Post上传图片URL：%@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    s = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    [request addValue:s
   forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"Submit\"\r\n"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendString:@"upload"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"3.png\"\r\n"];
    [bodyString appendString:@"Content-Type: image/png\r\n"];
    [bodyString appendString:@"\r\n"];
    
    //     NSData *imgData = UIImageJPEGRepresentation(self.imgChat, 0.7);
    NSData *imgData = UIImageJPEGRepresentation(self.imgChat, 0.8f);
    
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    [bodyData appendData:bodyStringData];
    [bodyData appendData:imgData];
    
    
    NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    NSString *len = [@(bodyData.length) stringValue];// [NSString stringWithFormat:@"%d", [bodyData length]];
    // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
    [request addValue:len forHTTPHeaderField:@"Content-Length"];
    // 设置请求体
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval:40.0f];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (recvData == nil) {
        recvData = [[NSMutableData alloc] init];
    }
    recvData.length = 0;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recvData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self didFailUploadImgErr:error];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error;
    NSLog(@"data:%@", [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding]);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableLeaves error:&error];
    if (!error)
    {
        if (kSaftToNSInteger(dic[@"state"]) == 200 && self.delegate)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@", dic[@"tfsServerUrl"], dic[@"bigImgUrl"]];
            if (![[urlStr lowercaseString] hasPrefix:@"http"])
            {
                [self didFailUploadImgErr:nil];
            }else
            {
                NSURL * url = [NSURL URLWithString:urlStr];
                if([self.delegate respondsToSelector:@selector(didFinishUploadImg:WithIndexPath:)] )
                    [self.delegate didFinishUploadImg:url WithIndexPath:self.indexPath];
            }
        }else
        {
            [self didFailUploadImgErr:nil];
        }
        
    }else
    {
        [self didFailUploadImgErr:nil];
    }
}

- (void)didFailUploadImgErr:(NSError *)err
{
    if (!err) {
        err = [NSError errorWithDomain:@"图片上传失败" code:-100 userInfo:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didFailUploadImg:WithIndexPath:)])
    {
        [_delegate didFailUploadImg:err WithIndexPath:self.indexPath];
    }
}

-(UIImage *)downloadImg:(NSURL *)url
{
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:url];
    UIImage *img = imgView.image;
    
    return img;
}

@end
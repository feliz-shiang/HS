//
//  GYUploadImg.m
//  HSConsumer
//
//  Created by 00 on 15-2-2.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYHSLoadImg.h"
#import "GlobalData.h"
#import "Network.h"
#import "UIImageView+WebCache.h"
@implementation GYHSLoadImg


-(void)uploadImg:(UIImage *)image :(NSString *)name
{
    self.imgChat = image;
    [self postImage: name];
}


#define BOUNDARY @"ABC123456789"
-(void)postImage :(NSString *)name
 {
     //ddr:port/phapi/easybuy/upload?type=product&fileType=image
     NSString * s = [NSString stringWithFormat:@"%@/easybuy/upload?type=%@&fileType=%@",[GlobalData shareInstance].ecDomain,@"refund",@"image"];//,[GlobalData shareInstance].ecKey,[GlobalData shareInstance].user.cardNumber,[GlobalData shareInstance].midKey

     NSURL *url = [NSURL URLWithString:s];
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
     [bodyString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.png\"\r\n",name]];
     [bodyString appendString:@"Content-Type: image/png\r\n"];
     [bodyString appendString:@"\r\n"];
     

     
     NSData *imgData = UIImageJPEGRepresentation(self.imgChat, 0.1);
     
     NSMutableData *bodyData = [[NSMutableData alloc] init];
     NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
     
     [bodyData appendData:bodyStringData];
     [bodyData appendData:imgData];

     
     NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
     NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
     [bodyData appendData:endData];
     NSString *len = [NSString stringWithFormat:@"%d", [bodyData length]];
     // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
     [request addValue:len forHTTPHeaderField:@"Content-Length"];
     // 设置请求体
     [request setHTTPBody:bodyData];
     
     NSLog(@" request ==== %@",request);
     
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
    NSLog(@"失败===================%@",error);
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请稍后再尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [av show];
    [self.delegate didFinishUploadImg:nil];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dic ==== %@",dic);
        
        NSString *retCode = dic[@"retCode"];
        
        if ([retCode integerValue] == 200) {
            NSString *strUrl = dic[@"data"];
            NSURL *url = [NSURL URLWithString:strUrl];
            [self.delegate didFinishUploadImg:url];
            
        }else{
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请稍后再尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
            [av show];
            [self.delegate didFinishUploadImg:nil];
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

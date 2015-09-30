//
//  GYPicDtVC.m
//  HSConsumer
//
//  Created by 00 on 15-3-19.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYPicDtVC.h"

@interface GYPicDtVC ()<UIWebViewDelegate>

@end

@implementation GYPicDtVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.picDetails]];
  
  
    // add by songjk
    _wv.scalesPageToFit = YES;
    _wv.delegate = self;
    [_wv loadRequest:request];
 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagMeta = document.createElement(\"meta\");"
     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];

}
@end

//
//  GYHSMsgBindHSCardVC.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYShowWebInfoViewController.h"
#import "UIAlertView+Blocks.h"

@interface GYShowWebInfoViewController ()<UIWebViewDelegate>
{
    IBOutlet UIWebView *wbBrowser;
    MBProgressHUD *hud;
}

@end

@implementation GYShowWebInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    if (self.strUrl && ([[self.strUrl lowercaseString] hasPrefix:@"http://"] || [[self.strUrl lowercaseString] hasPrefix:@"https://"]))
    {
        wbBrowser.backgroundColor = self.view.backgroundColor;
        wbBrowser.delegate = self;
        self.strUrl = [NSString stringWithFormat:@"%s",self.strUrl.UTF8String] ;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]];
        [wbBrowser loadRequest:request];
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        //    hud.dimBackground = YES;
        [self.view addSubview:hud];
        [hud show:YES];

    }else
    {
        [Utils showMessgeWithTitle:@"提示" message:@"网址有误。" isPopVC:self.navigationController];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webURL:%@", request.URL.absoluteString);
    if ([request.URL.absoluteString rangeOfString:@"/gyorderDetail"].location != NSNotFound)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (hud)
        [hud removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (hud)
        [hud removeFromSuperview];
}

@end

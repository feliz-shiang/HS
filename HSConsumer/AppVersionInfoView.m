//
//  AppVersionInfoView.m
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kIMDomain    @"im.gy.com" //默认的后缀
#define kIMResource  @"mobile_im" //移动终端固定使用此resource //[Utils getRandomString:5]
#define kIMCardUserPrefix    @"m_c_"    //卡用户前缀

#import "AppVersionInfoView.h"
#import "UIView+CustomBorder.h"
#import "GYGuestLoginViewController.h"
#import "GlobalData.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "GYencryption.h"
#import "GYForgotPasswdViewController.h"
#import "GYChangeLoginEN.h"
#import "GYNoCardForgotPasswdViewController.h"

@interface AppVersionInfoView()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    UINavigationController *nc;
    GlobalData *data;
    NSDictionary *dicLoginResponse;
    IBOutlet UIWebView *webView;
}
@end


@implementation AppVersionInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    self.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    self.vBackground.layer.masksToBounds = YES;
    self.vBackground.layer.cornerRadius = 4;
    self.vBackground.center = self.center;
    
    self.alpha = 0;
    [self.vBackground addAllBorder];
    self.lbTitle.textColor=kNavigationBarColor;
    self.lbTitle.text=kLocalized(@"user_login");
    
    UITapGestureRecognizer *closeAndRemoveSelfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAndRemoveSelf:)];
    [self addGestureRecognizer:closeAndRemoveSelfTap];

    UITapGestureRecognizer *closeKeyBoardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    [self.vBackground addGestureRecognizer:closeKeyBoardTap];
    if (kSystemVersionLessThan(@"6.0"))//解决 iOS5和iOS6+ 手势兼容问题
    {
        closeAndRemoveSelfTap.delegate = self;
        closeKeyBoardTap.delegate = self;
    }
    data = [GlobalData shareInstance];
}

- (void)closeAndRemoveSelf:(UITapGestureRecognizer *)tap
{
//    self.delegate = nil;
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

- (void)closeKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)showInView:(UIView *)view
{
    if (!view || ![view isKindOfClass:[UIView class]]) return;
    nc = (UINavigationController *)data.topTabBarVC.selectedViewController;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.2f;
        self.alpha = 0.8f;
        self.alpha = 0.6f;
        self.alpha = 1.0f;
    }];
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (!vc || !nc)
    {
        return;
    }
    
    UIViewController *topVc = [nc topViewController];
    [topVc setHidesBottomBarWhenPushed:YES];
    [nc pushViewController:vc animated:YES];
    
    if (nc.viewControllers.count <= 2)//主回到主界面时显示tabbar
    {
        [topVc setHidesBottomBarWhenPushed:NO];
    }
}

//解决 iOS5和iOS6 手势兼容问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

@end

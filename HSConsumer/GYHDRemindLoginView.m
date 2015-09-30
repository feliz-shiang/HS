//
//  GYHDRemindLoginView.m
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/13.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import "GYHDRemindLoginView.h"
#import "GYLoginController.h"

#define kBorder 16
#define kTitleFont [UIFont systemFontOfSize:17]
@interface GYHDRemindLoginView()


@property (weak, nonatomic)  UIView *vRemind;
@property (weak, nonatomic)  UILabel *lbTitle;
@property (weak, nonatomic)  UILabel *lbRemind;
@property (weak, nonatomic)  UIButton *btnCancel;
@property (weak, nonatomic)  UIButton *btnLogin;

@end

@implementation GYHDRemindLoginView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}
-(void)setup
{
    UIView * vBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vBack.backgroundColor = [UIColor lightGrayColor];
    vBack.alpha = 0.4;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAndRemoveSelf)];
    [vBack addGestureRecognizer:tap];
    [self addSubview:vBack];
    
    UIView *vRemind = [[UIView alloc] initWithFrame:CGRectMake(kBorder, 150, kScreenWidth-kBorder*2, 150)];
    vRemind.backgroundColor = [UIColor whiteColor];
    vRemind.layer.cornerRadius = 5;
    self.vRemind = vRemind;
    [self addSubview:vRemind];
    
    CGFloat titleY = kBorder;
    CGFloat titleW = self.vRemind.frame.size.width;
    CGFloat titleX = 0;
    CGFloat titleH = 25;
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    lbTitle.font = kTitleFont;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = @"提示";
    lbTitle.textColor = [UIColor blackColor];
    self.lbTitle = lbTitle;
    [self.vRemind addSubview:self.lbTitle];
    
    NSString * strImageName = [[NSBundle mainBundle] pathForResource:@"line_confirm_dialog_yellow" ofType:@"png"];
    UIImageView * ivLine = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:strImageName]];
    ivLine.frame = CGRectMake(20, CGRectGetMaxY(self.lbTitle.frame)+10, self.vRemind.frame.size.width-20*2, 1);
    [self.vRemind addSubview:ivLine];
    
    CGFloat lbRemindY = CGRectGetMaxY(ivLine.frame)+kBorder;
    CGFloat lbRemindW = self.vRemind.frame.size.width;
    CGFloat lbRemindX = 0;
    CGFloat lbRemindH = 25;
    UILabel *lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(lbRemindX, lbRemindY, lbRemindW, lbRemindH)];
    lbRemind.font = kTitleFont;
    lbRemind.backgroundColor = [UIColor clearColor];
    lbRemind.textAlignment = NSTextAlignmentCenter;
    lbRemind.text = @"您还未登录哦~";
    lbRemind.textColor = [UIColor blackColor];
    self.lbRemind = lbRemind;
    [self.vRemind addSubview:self.lbRemind];
    
    CGFloat btnMargin = 5;
    
    CGFloat btnCancelX = kBorder;
    CGFloat btnCancelY = CGRectGetMaxY(self.lbRemind.frame)+kBorder*2;
    CGFloat btnCancelW = (self.vRemind.frame.size.width - btnCancelX*2-btnMargin)*0.5;
    CGFloat btnCancelH = btnCancelW*0.25;
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnCancelX, btnCancelY, btnCancelW, btnCancelH)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.backgroundColor = [UIColor lightGrayColor];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(closeAndRemoveSelf) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel = btnCancel;
    [self.vRemind addSubview:self.btnCancel];
    
    CGFloat btnLoginX = CGRectGetMaxX(self.btnCancel.frame)+btnMargin;
    CGFloat btnLoginY = btnCancelY;
    CGFloat btnLoginW = btnCancelW;
    CGFloat btnLoginH = btnCancelH;
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(btnLoginX, btnLoginY, btnLoginW, btnLoginH)];
    btnLogin.backgroundColor = [UIColor redColor];
    btnLogin.layer.cornerRadius = 2;
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitle:@"立即登录" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin = btnLogin;
    [self.vRemind addSubview:self.btnLogin];
    
    CGFloat vHeight = CGRectGetMaxY(self.btnLogin.frame)+20;
    self.vRemind.frame = CGRectMake(kBorder, 150, kScreenWidth-kBorder*2, vHeight);
}
- (void)closeAndRemoveSelf
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (finished)
        {
            if (self.superview)
            {
                [self removeFromSuperview];
            }
            
        }
    }];
}
-(void)login
{
    GYLoginController * vc = [[GYLoginController alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    [self.superview addSubview:vc];
    vc.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        vc.alpha = 0.5;
        vc.alpha = 1;
        vc.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end

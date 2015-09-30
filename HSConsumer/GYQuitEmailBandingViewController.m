//
//  GYQuitEmailBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYQuitEmailBandingViewController.h"
#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
@interface GYQuitEmailBandingViewController ()

@end

@implementation GYQuitEmailBandingViewController
{
    __weak IBOutlet UIView *vUpBgView;
    
    __weak IBOutlet UILabel *lbTips;
    
    __weak IBOutlet UILabel *lbEmailDetail;
    
    __weak IBOutlet UILabel *lbEmailAddress;
    
    __weak IBOutlet UIView *vDownBgView;
    
    __weak IBOutlet UIButton *btnNextStep;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.view.backgroundColor=kDefaultVCBackgroundColor;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //国际化修改名称
    [self modifyName];
    //设置分割线
    [self setSeprator];
    
}

-(void)setSeprator
{
    [vDownBgView addAllBorder];
    
}

-(void)modifyName
{
    self.title=kLocalized(@"quit_email_binding");
    
    lbEmailAddress.text=kLocalized(@"banding_email");
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnNextStep setTitle:kLocalized(@"confirm")   forState:UIControlStateNormal];
    
    lbEmailDetail.textColor=kCellItemTitleColor;
    lbEmailAddress.textColor=kCellItemTitleColor;
    
    //设置提示信息
    lbTips.textColor=kCellItemTextColor;
    lbTips.text=kLocalized(@"quit_email_banding_tips");
    
}

- (IBAction)btnGotoNextPage:(id)sender
{
    
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定",nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
}

-(UIView *)createUI
{
    
    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 130)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;
    
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 50,50)];
    successImg.image=[UIImage imageNamed:@"img_email_banding.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 12, 200, 30)];
    lbTip.text=kLocalized(@"has_send_email");
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardNumberTmp =[[UILabel alloc]initWithFrame:CGRectMake(lbTip.frame.origin.x, lbTip.frame.origin.y+lbTip.frame.size.height+2, 160, 30)];
    lbCardNumberTmp.text=@"331374420@qq.com";
    lbCardNumberTmp.textColor=kCellItemTitleColor;
    lbCardNumberTmp.font=[UIFont systemFontOfSize:17.0];
    lbCardNumberTmp.backgroundColor=[UIColor clearColor];
    UILabel *  lbBandLocation =[[UILabel alloc]initWithFrame:CGRectMake(lbCardNumberTmp.frame.origin.x,lbCardNumberTmp.frame.origin.y+lbCardNumberTmp.frame.size.height, 180, 30)];
    lbBandLocation.text=kLocalized(@"login_your_email_finishBanding");
    lbBandLocation.textColor=kCellItemTitleColor;
    lbBandLocation.font=[UIFont systemFontOfSize:14.0];
    lbBandLocation.backgroundColor=[UIColor clearColor];
    [popView addSubview:successImg];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardNumberTmp];
    [popView addSubview:lbBandLocation];
    
    return popView;
}


-(void)disappearPopView
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}

@end

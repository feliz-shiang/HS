//
//  GYQuitPhoneBandingDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYQuitPhoneBandingDetailViewController.h"
#import "UIView+CustomBorder.h"

@interface GYQuitPhoneBandingDetailViewController ()

@end

@implementation GYQuitPhoneBandingDetailViewController
{
    
    __weak IBOutlet UIView *vUpBackgroundView;
    
    __weak IBOutlet UIView *vDownBackgroundView;
    
    __weak IBOutlet UILabel *lbBandingPhone;
    
    __weak IBOutlet UILabel *lbPhoneNumber;
    
    __weak IBOutlet UIButton *btnGetCode;
    
    __weak IBOutlet UILabel *lbCode;
    
    __weak IBOutlet UITextField *tfInputCode;
    
    __weak IBOutlet UIButton *btnGoNext;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"quit_phone_binding");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    [self setSprator];
    [self setTextColor];
    [self setBtnTitle];
    
}


-(void)setBtnTitle
{
    [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    [btnGoNext setTitle:kLocalized(@"quit_binding") forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnGoNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}


-(void)setTextColor
{
    lbBandingPhone.textColor=kCellItemTitleColor;
    lbCode.textColor=kCellItemTitleColor;
    lbPhoneNumber.textColor=kCellItemTitleColor;
    
    
}


-(void)setSprator
{
    [self setBorderWithView:btnGetCode WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
    [vUpBackgroundView addAllBorder];
    [vDownBackgroundView addAllBorder];
    tfInputCode.placeholder=kLocalized(@"input_validation_code");
    
}


- (IBAction)btnGoNext:(id)sender {
    
    DDLogInfo(@"发起网络请求");
    
}


- (IBAction)btnGetCode:(id)sender {
    
    DDLogInfo(@"获取验证码");
    
    
}

-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}

@end

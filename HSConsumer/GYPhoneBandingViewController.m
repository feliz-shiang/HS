//
//  GYPhoneBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPhoneBandingViewController.h"
#import "GYSecurityAuthViewController.h"
//#import "GYTestTableViewController.h"
//扩大button 点击范围的方法。
#import "UIButton+enLargedRect.h"
#import "UIView+CustomBorder.h"
@interface GYPhoneBandingViewController ()

@end

@implementation GYPhoneBandingViewController
{
    
    __weak IBOutlet UILabel *lbTitle;
    
    __weak IBOutlet UILabel *lbPhoneLocation;
    
    __weak IBOutlet UIButton *btnChooseLocation;
    
    __weak IBOutlet UILabel *lbPhoneNumber;
    
    __weak IBOutlet UITextField *tfPhoneNumber;
    
    __weak IBOutlet UIButton *btnGoNext;
    
    __weak IBOutlet UIImageView *imgMiddleSeprator;
    
    __weak IBOutlet UIView *vTopBgView;
    
}
- (IBAction)btnGoNext:(id)sender {
    if ([Utils isBlankString:tfPhoneNumber.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if (![Utils isMobileNumber:tfPhoneNumber.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    
    }else{

    GYSecurityAuthViewController * vcSecurity =[[GYSecurityAuthViewController alloc]initWithNibName:@"GYSecurityAuthViewController" bundle:nil];
    
    vcSecurity.phoneNum=tfPhoneNumber.text;
    
    [self.navigationController pushViewController:vcSecurity animated:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"cell_phone_number_binding");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    // Do any additional setup after loading the view from its nib.
    //设置分割线
    [self setSeprator];
    lbTitle.text=kLocalized(@"input_received_message_authentication_code");
    lbTitle.backgroundColor=[UIColor clearColor];
    lbPhoneNumber.text=kLocalized(@"cell_phone_number");
    lbPhoneLocation.text=@"中国大陆（86）";
    tfPhoneNumber.placeholder=kLocalized(@"input_phone_number");
    [self setTextColor];

    [btnGoNext setTitle:kLocalized(@"next") forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnChooseLocation setEnlargEdgeWithTop:20.0f right:20.0f bottom:20.0f left:10.0f];
    [tfPhoneNumber addTarget:self action:@selector(tfPhoneNumberEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tfPhoneNumberEditingChanged:(UITextField*)textField
{
    NSString *str = textField.text;
    if (str.length>=11) {
        textField.text = [str substringToIndex:11];
    }
}

//设置文本颜色
-(void)setTextColor
{
    lbPhoneLocation.textColor=kCellItemTitleColor;
    lbPhoneNumber.textColor=kCellItemTitleColor;
    lbTitle.textColor=kCellItemTitleColor;
    
}

//设置分割线
-(void)setSeprator
{
    [self setBorderWithView:imgMiddleSeprator WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:vTopBgView WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
}

-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}

- (IBAction)btnChangePhoneLocation:(id)sender {
    
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]initWithNibName:@"GYTestTableViewController" bundle:nil];
//
//    vcTest.marrDataSource=[@[@"中国大陆(86)"] mutableCopy];
//    vcTest.delegate=self;
//    [self.navigationController pushViewController:vcTest animated:YES];
    
}

-(void)senderStr:  (NSString   *)str
{
    lbPhoneLocation.text=str;
    
}

@end

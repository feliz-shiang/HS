//
//  GYNoAuthNoImportantChangeVC.m
//  HSConsumer
//
//  Created by apple on 15-4-21.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNoAuthNoImportantChangeVC.h"
#import "GYRealNameAuthViewController.h"
#import "UIButton+enLargedRect.h"
#import "GYRealNameRegisterViewController.h"

@interface GYNoAuthNoImportantChangeVC ()

@end

@implementation GYNoAuthNoImportantChangeVC
{

   IBOutlet UILabel *lbTips;
    __weak IBOutlet UIButton *btnToNameAuth;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       lbTips.textColor=kCellItemTitleColor;
       lbTips.text=@"   您尚未完成实名认证，请先进行实名认证后再办理此业务！";
    [btnToNameAuth setBorderWithWidth:1.0 andRadius:2 andColor:kDefaultViewBorderColor];
    [btnToNameAuth setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)btnActionToNameAuth:(id)sender {
    if ([GlobalData shareInstance].user.userName >0) {
        GYRealNameAuthViewController * realNameVC =[[GYRealNameAuthViewController alloc]initWithNibName:@"GYRealNameAuthViewController" bundle:nil];
        [self.navigationController pushViewController:realNameVC animated:YES];
    }else
    {
        GYRealNameRegisterViewController * vcNameBanding = [[GYRealNameRegisterViewController alloc]initWithNibName:@"GYRealNameRegisterViewController" bundle:nil];
        [self.navigationController pushViewController:vcNameBanding animated:YES];
    }
    
}


@end

//
//  GYNoRegisterViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-13.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNoRegisterViewController.h"

@interface GYNoRegisterViewController ()

@end

@implementation GYNoRegisterViewController
{

    __weak IBOutlet UIImageView *imgvLight;

    __weak IBOutlet UILabel *lbWarning;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    imgvLight.image=[UIImage imageNamed:@"imge_light.png"];
    lbWarning.textColor=kCellItemTitleColor;
    lbWarning.text=self.strContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

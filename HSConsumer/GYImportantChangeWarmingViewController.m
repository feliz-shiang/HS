//
//  GYImportantChangeWarmingViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-12.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYImportantChangeWarmingViewController.h"

@interface GYImportantChangeWarmingViewController ()

@end

@implementation GYImportantChangeWarmingViewController


{

    __weak IBOutlet UIImageView *vimgPicture;

    __weak IBOutlet UILabel *lbWarming;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"重要信息变更申请";
    
    
    // Do any additional setup after loading the view from its nib.

    [self modifyName];
}

- (void)modifyName
{
    lbWarming.textColor=kCellItemTextColor;
    lbWarming.text=@"温馨提示:\n目前您处于重要信息变更申请处理中，在此期间，本业务暂无法受理！";

}

@end

//
//  GYFinishAuthViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//  完成认证

#import "GYFinishAuthViewController.h"

@interface GYFinishAuthViewController ()

@end

@implementation GYFinishAuthViewController
{


    __weak IBOutlet UIImageView *imgvSmile;

    __weak IBOutlet UILabel *lbTips;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbTips.text=@"温馨提示，您已通过实名认证。";
    lbTips.textColor=kCellItemTitleColor;
    
}



@end

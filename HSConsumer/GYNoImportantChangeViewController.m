//
//  GYNoImportantChangeViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNoImportantChangeViewController.h"

@interface GYNoImportantChangeViewController ()

@end

@implementation GYNoImportantChangeViewController

{

    __weak IBOutlet UILabel *lbTips;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
    
}


- (void)modifyName
{
    
    lbTips.textColor=kCellItemTitleColor;
    lbTips.text=self.strSource;


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

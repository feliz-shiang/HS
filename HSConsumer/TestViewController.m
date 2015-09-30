//
//  TestViewController.m
//  company
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "TestViewController.h"
#import "GlobalData.h"
#import "Utils.h"
#import "Formatter.h"
#import "InputCellStypeView.h"

//#ifndef __OPTIMIZE__
//int ddLogLevel = LOG_LEVEL_VERBOSE;
//#else
//int ddLogLevel = LOG_LEVEL_OFF;
//#endif


@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet InputCellStypeView *row1;
    IBOutlet InputCellStypeView *row2;
    IBOutlet UILabel *plsWait;
    
    
    __weak IBOutlet UITableView *tbv;
    
    
}
@end

@implementation TestViewController

- (IBAction)pushVC:(id)sender {
    
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"testVC";
        
        // Custom initialization
    }
    return self;
}

//- (void)loadView
//{
//    [super loadView];
//    DDLogDebug(@"langType:%d", (int)[GlobalData getAppLanguage]);

//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view from its nib.
    
    //国际化调用
    [btnLogin setTitle:kLocalized(@"login") forState:UIControlStateNormal];
//    lbShowTip.text = kLocalized(@"login");
    
    //单例调用
    GlobalData *user = [GlobalData shareInstance];
//    DDLogDebug(@"是否已登录（是1/否0）:%d", (int)user.isLogined);
    
    [btnLogin addTarget:self action:@selector(openHomeVC) forControlEvents:UIControlEventTouchUpInside];
//    plsWait.text = @"敬請期待";
    plsWait.textColor = kCorlorFromRGBA(239, 239, 244, 1);

    
//    tbv.delegate = self;
//    tbv.dataSource = self;
    
}

- (void)openHomeVC
{
    
//    UIImage* selectedImage = [[UIImage imageNamed:@"settings-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.tabBarItem.selectedImage = selectedImage;

    //设置tabbar提醒
//    UITabBarItem *tabBarItem = [[[self.tabBarController tabBar] items] objectAtIndex:2];
//    [tabBarItem setBadgeValue:@"2"];//显示数字
//    [tabBarItem setFinishedSelectedImage:kLoadPng(@"tab_btn_home_click") withFinishedUnselectedImage:kLoadPng(@"tab_btn_home_normal")];//换图标
    

    DDLogDebug(@"AppLanguage:%d", (int)[GlobalData getAppLanguage]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
        
    }

    return cell;
}





@end

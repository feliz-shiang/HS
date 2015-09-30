//
//  GYNavigationController.m
//  HSConsumer
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYNavigationController.h"
#import "UIButton+enLargedRect.h"

@interface GYNavigationController ()

@end

@implementation GYNavigationController


-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton
{
    UIImage* image= kLoadPng(@"nav_btn_back");
//    CGRect backframe= CGRectMake(0, 0, 44, 44);
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
//    NSLog(@"nav_btn_back size:%@", NSStringFromCGRect(backframe));
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setEnlargEdgeWithTop:10 right:10 bottom:10 left:25];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1)
    {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
}



@end

//
//  GYNavigationWhiterController.m
//  HSConsumer
//
//  Created by appleliss on 15/8/20.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNavigationWhiterController.h"
#import "UIButton+enLargedRect.h"
@interface GYNavigationWhiterController ()

@end

@implementation GYNavigationWhiterController


-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton
{
    UIImage* image= kLoadPng(@"nav_btn_redback");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.3, image.size.height * 0.3);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setEnlargEdgeWithTop:10 right:10 bottom:10 left:25];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
}

-(UIBarButtonItem*) createwhileBackButton
{
    UIImage* image= kLoadPng(@"nav_btn_back");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
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
        if ([viewController.nibName isEqualToString:@"GYEasyBuySearchViewController"])
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        else
        viewController.navigationItem.leftBarButtonItem =[self createwhileBackButton];
    }
}


@end

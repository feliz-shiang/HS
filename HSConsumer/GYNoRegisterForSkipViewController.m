//
//  GYNoRegisterViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-13.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNoRegisterForSkipViewController.h"
#import "GYNameBandingViewController.h"

#import "GYRealNameRegisterViewController.h"
#import "GlobalData.h"

@interface GYNoRegisterForSkipViewController ()

@end

@implementation GYNoRegisterForSkipViewController
{

    __weak IBOutlet UIImageView *imgvLight;


    __weak IBOutlet UIButton *btnSkip;

    IBOutlet UILabel *lbContent;

    GlobalData *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"实名认证";
    
    imgvLight.image=[UIImage imageNamed:@"imge_light.png"];
    
    [btnSkip setTitle:@"实名注册" forState:UIControlStateNormal];
    
    btnSkip.layer.borderWidth=1;
    btnSkip.layer.borderColor=[UIColor grayColor].CGColor;
    
    CGSize lbSize=[self.strContent sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.view.bounds.size.width-40, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect lbRect=lbContent.frame;
    lbRect.size=lbSize;
    [lbContent setFrame:lbRect];
    [lbContent setText:self.strContent];
    
    btnSkip.frame=CGRectMake(btnSkip.frame.origin.x, lbContent.frame.origin.y+lbContent.frame.size.height, btnSkip.frame.size.width, btnSkip.frame.size.height);
 
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    data=[GlobalData shareInstance];
  
//    
//    if ([GlobalData shareInstance].user.isRealNameRegistration) {
//        
//        //[self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"%d",[GlobalData shareInstance].user.isRealNameRegistration);
//    }
//    else
//    {
//        NSLog(@"%d",[GlobalData shareInstance].user.isRealNameRegistration);
//        
//        for(UIViewController *vc in self.navigationController.viewControllers)
//        {
//            NSLog(@"%@   ==  %lu",self.navigationController.viewControllers,self.navigationController.viewControllers.count);
//        }
//
//    }


}





- (IBAction)btnSkipToRealnameBankding:(id)sender {
    
//    GYNameBandingViewController * vcNameBanding = [[GYNameBandingViewController alloc]initWithNibName:@"GYNameBandingViewController" bundle:nil];
    GYRealNameRegisterViewController * vcNameBanding = [[GYRealNameRegisterViewController alloc]initWithNibName:@"GYRealNameRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vcNameBanding animated:YES];
    
    
}



@end

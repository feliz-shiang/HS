//
//  GYApproveViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//  待审批

#import "GYApproveViewController.h"

#import "UIImageView+WebCache.h"
#import "UIView+CustomBorder.h"

@interface GYApproveViewController ()

@end

@implementation GYApproveViewController
{
    
    __weak IBOutlet UIView *vUpBackground;
    
    __weak IBOutlet UILabel *lbApplyStatus;
    
    __weak IBOutlet UILabel *lbApplyStatusDetail;
    
    __weak IBOutlet UIView *vDownBackground;
    
    __weak IBOutlet UIImageView *imgvPictureA;
    
    __weak IBOutlet UILabel *lbPictureA;
    
    __weak IBOutlet UIButton *btnSamplePictureA;
    
    __weak IBOutlet UIImageView *imgvPictureB;
    
    __weak IBOutlet UILabel *lbPictureB;
    
    __weak IBOutlet UIButton *btnSamplePictureB;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"实名认证";
        self.view.backgroundColor=kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
}

-(void)modifyName
{
    lbApplyStatus.text=@"申请状态";
    lbApplyStatusDetail.text=@"待审批";
    
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
        
        lbPictureA.text=@"护照证件照";
        lbPictureB.text=@"手持证件照";
        
    }else if ([ [GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
        lbPictureB.text=@"手持证件照";
        lbPictureA.text=@"营业执照证件照";
    }
    else
    { }
    lbApplyStatusDetail.textColor=kNavigationBarColor;
    lbApplyStatus.textColor=kCellItemTitleColor;
    lbPictureA.textColor=kCellItemTitleColor;
    lbPictureB.textColor=kCellItemTitleColor;
    [btnSamplePictureA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureB  setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureA setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnSamplePictureB setTitle:@"示例图片" forState:UIControlStateNormal];
    vUpBackground.backgroundColor=[UIColor whiteColor];
    vDownBackground.backgroundColor=[UIColor whiteColor];
    

    
    [vUpBackground addAllBorder];
    [vDownBackground addAllBorder];
    
    
    if ([[[GlobalData shareInstance].personInfo.creHoldImg lowercaseString] hasPrefix:@"http"]) {
        [imgvPictureB sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].personInfo.creHoldImg]    placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }else
    {
        [imgvPictureB sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creHoldImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }
    
    if ([[[GlobalData shareInstance].personInfo.creFaceImg  lowercaseString]  hasPrefix:@"http"]) {
        
        [imgvPictureA sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].personInfo.creFaceImg ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }else
    {
        [imgvPictureA sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creFaceImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
        
    }
    
    
}


@end

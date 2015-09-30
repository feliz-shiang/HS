//
//  GYRefuseAuthViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//  审批驳回

#import "GYRefuseAuthViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+CustomBorder.h"
#import "GYRealNameAuthViewController.h"
#import "UIView+CustomBorder.h"
@interface GYRefuseAuthViewController ()

@end

@implementation GYRefuseAuthViewController
{

    __weak IBOutlet UIView *vUpBackground;

    __weak IBOutlet UILabel *lbApplyStatus;

    __weak IBOutlet UILabel *lbApproveStatus;

    __weak IBOutlet UIView *vDownBackground;

    __weak IBOutlet UILabel *lbApproveReson;

    __weak IBOutlet UILabel *lbApproveResonDetail;

    __weak IBOutlet UIImageView *imgvPaperA;

    __weak IBOutlet UILabel *lbPaperPictureA;
    
    __weak IBOutlet UIButton *btnSamplePicA;
    
    __weak IBOutlet UIImageView *imgPaperB;
    
    __weak IBOutlet UILabel *lbPaperPictureB;

    __weak IBOutlet UIButton *btnSamplePicB;
    
    __weak IBOutlet UIView *vBottomBackground;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(reApply) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    [self modifyName];
    [self setTextColor];
}


-(void)reApply
{
    GYRealNameAuthViewController * vcRealName =[[GYRealNameAuthViewController alloc]initWithNibName:@"GYRealNameAuthViewController" bundle:nil];
    [self.navigationController pushViewController:vcRealName animated:YES];

}


-(void)modifyName
{
//    lbPaperPictureA.text=@"营业执照证件照";
//    lbPaperPictureB.text=@"手持证件照";
    lbApplyStatus.text=@"申请状态";
    lbApproveReson.text=@"驳回原因";
    lbApproveResonDetail.text=[GlobalData shareInstance].personInfo.verifyAppReason;
    lbApproveStatus.text=@"审批驳回";
    [btnSamplePicA setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnSamplePicB  setTitle:@"示例图片" forState:UIControlStateNormal];
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
        
        lbPaperPictureA.text=@"护照证件照";
        lbPaperPictureB.text=@"手持证件照";
        
    }else if ([ [GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
        lbPaperPictureB.text=@"手持证件照";
        lbPaperPictureA.text=@"营业执照证件照";
    }
    else
    { }
    
    [vUpBackground addAllBorder];
    [vDownBackground addAllBorder];
    [vBottomBackground addAllBorder];
    [btnSamplePicA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePicB setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    [self setBtn:btnSamplePicA WithColor:kNavigationBarColor WithWidth:1 WithIndex:1];
    [self setBtn:btnSamplePicB WithColor:kNavigationBarColor WithWidth:1 WithIndex:2];
  
}


-(void)setBtn:(UIButton *)sender  WithColor:(UIColor *)color WithWidth:(CGFloat )width WithIndex:(NSInteger)buttonTag
{
    sender.layer.cornerRadius=2.0f;
    sender.layer.borderWidth=width;
    sender.tag=buttonTag;
    sender.layer.borderColor=color.CGColor;
    sender.layer.masksToBounds=YES;
}

-(void)setTextColor
{
    vUpBackground.backgroundColor=[UIColor whiteColor];
    vDownBackground.backgroundColor=[UIColor whiteColor];
    lbApproveResonDetail.textColor=kNavigationBarColor;
    lbApproveStatus.textColor=kNavigationBarColor;
    lbPaperPictureA.textColor=kCellItemTextColor;
    lbPaperPictureB.textColor=kCellItemTextColor;
    lbApproveReson.textColor=kCellItemTitleColor;
    lbApplyStatus.textColor=kCellItemTitleColor;
    
    [vUpBackground addAllBorder];
    [vDownBackground addAllBorder];
    if ([[[GlobalData shareInstance].personInfo.creHoldImg lowercaseString] hasPrefix:@"http"]) {
        [imgvPaperA sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].personInfo.creFaceImg]    placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }else
    {
        [imgvPaperA sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creFaceImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }
    
    if ([[[GlobalData shareInstance].personInfo.creHoldImg lowercaseString] hasPrefix:@"http"]) {
        [imgPaperB sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].personInfo.creHoldImg]    placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }else
    {
        [imgPaperB sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creHoldImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    }
    
//    [imgvPaperA sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creFaceImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
//    [imgPaperB sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creBackImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
//    
}

@end

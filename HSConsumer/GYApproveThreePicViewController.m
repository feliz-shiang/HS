//
//  GYApproveViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//  待审批

#import "GYApproveThreePicViewController.h"

#import "UIImageView+WebCache.h"
#import "UIView+CustomBorder.h"

@interface GYApproveThreePicViewController ()

@end

@implementation GYApproveThreePicViewController
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
    
    __weak IBOutlet UIScrollView *scrMain;
    
    __weak IBOutlet UIImageView *imgvPictureC;
    
    __weak IBOutlet UILabel *lbPictureC;
    
    __weak IBOutlet UIButton *btnPictureC;
    
    
    
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
    lbPictureA.text=@"正面照";
    lbPictureB.text=@"背面照";
    lbPictureC.text=@"手持证件照";
    lbApplyStatusDetail.textColor=kNavigationBarColor;
    lbApplyStatus.textColor=kCellItemTitleColor;
    lbPictureA.textColor=kCellItemTitleColor;
    lbPictureB.textColor=kCellItemTitleColor;
    lbPictureC.textColor=kCellItemTitleColor;
    [btnSamplePictureA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureB  setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnPictureC  setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureA setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnSamplePictureB setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnPictureC setTitle:@"示例图片" forState:UIControlStateNormal];
    vUpBackground.backgroundColor=[UIColor whiteColor];
    vDownBackground.backgroundColor=[UIColor whiteColor];
    
    
    [vUpBackground addAllBorder];
    [vDownBackground addAllBorder];
    
    
    [self setBtn:btnPictureC WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    [self setBtn:btnSamplePictureA WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    [self setBtn:btnSamplePictureB WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    

    [imgvPictureB sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creBackImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    
    [imgvPictureA sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creFaceImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    
    [imgvPictureC sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GlobalData shareInstance].user.fileHttpUrl,[GlobalData shareInstance].personInfo.creHoldImg] ]   placeholderImage:[UIImage imageNamed:@"img_btn_bg.png"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBtn:(UIButton *)sender  WithColor:(UIColor *)color WithWidth:(CGFloat )width WithIndex:(NSInteger)buttonTag
{
    sender.layer.cornerRadius=2.0f;
    sender.layer.borderWidth=width;
    sender.tag=buttonTag;
    sender.layer.borderColor=color.CGColor;
    sender.layer.masksToBounds=YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    scrMain.contentSize=CGSizeMake(kScreenWidth, 568);
    
}
@end

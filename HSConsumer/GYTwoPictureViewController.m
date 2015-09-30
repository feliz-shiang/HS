//
//  GYTwoPictureViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYTwoPictureViewController.h"

#import "GYApproveViewController.h"
#import "UIView+CustomBorder.h"
#import "GYImgTap.h"

#import "Animations.h"
#import "CustomIOS7AlertView.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"

#import "GYHSAccountViewController.h"


#import "GYRegisterAuthViewController.h"
@interface GYTwoPictureViewController ()

@end

@implementation GYTwoPictureViewController
{

    __weak IBOutlet UILabel *lbTips;

    __weak IBOutlet UIView *vUpBackground;

    __weak IBOutlet UIImageView *imgvPictureA;

    __weak IBOutlet UILabel *lbPictureA;
    
    __weak IBOutlet UIButton *btnSampleA;

    __weak IBOutlet UIImageView *imgvPictureB;
    
    __weak IBOutlet UIButton *btnPictureB;
    
    __weak IBOutlet UILabel *lbPictureB;
    
    int tagIndex;
    
      UIImageView * imgv;
    
    
    
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
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
        
        lbPictureA.text=@"护照证件照";
        lbPictureB.text=@"手持证件照";
        
    }else if ([ [GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
        lbPictureB.text=@"手持证件照";
        lbPictureA.text=@"营业执照证件照";
    }
    
    [self modifyName];
    vUpBackground.backgroundColor=[UIColor whiteColor];
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 40, 40);
    [btnRight setTitle:@"提交" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
         [self addGestureToImgView];
    
   
    
}

-(void)submit
{
    

    switch (self.useType) {
        case useForAuth:
        {
            [self loadDataFromNetwork];
        }
            break;
            
        case useForImportantChange:
        {
            [self showAlertview:0];
            
        }
            break;
        default:
            break;
    }
    
    

    
    
    
}


-(void)showAlertview:(int )index
{
  
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    
    if (index==0) {
        [alertView setContainerView:[self createUI]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"cancel"),kLocalized(@"confirm"),nil]];
    }
    else
    {
        [alertView setContainerView:[self succeedTip]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    
    }
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        switch (buttonIndex) {
            case 1:
            {
              [self sendRequestForImportantChange];
            
            }
                break;
                
            default:
                break;
        }
        
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

}


-(UIView *)succeedTip
{

    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 50)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;

    UIImageView * imgvTip= [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
    imgvTip.image=[UIImage imageNamed:@"img_succeed.png"];
    UILabel * lbTip =[[UILabel alloc]init];
    lbTip.frame=CGRectMake(290/2-80, 0, 180, 30);
    lbTip.text=@"重要信息变更提交成功!";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];

    [popView addSubview:imgvTip];
    [popView addSubview:lbTip];
    return popView;
}

-(UIView *)createUI
{
    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 130)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;
    
    //开始添加弹出的view中的组件
    UILabel * lbTip =[[UILabel alloc]init];
    lbTip.frame=CGRectMake(290/2-40, 0, 80, 30);
    lbTip.text=@"温馨提示";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardNumberTmp =[[UILabel alloc]initWithFrame:CGRectMake(20   , lbTip.frame.origin.y+lbTip.frame.size.height+2, 290-40, 60)];
    lbCardNumberTmp.text=@"  重要信息变更申请提交处理期间，货币转银行账户业务暂无法受理，确认要提交申请？";
    lbCardNumberTmp.numberOfLines=0;
    lbCardNumberTmp.textColor=kCellItemTitleColor;
    lbCardNumberTmp.font=[UIFont systemFontOfSize:16.0];
    lbCardNumberTmp.backgroundColor=[UIColor clearColor];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardNumberTmp];
 
    return popView;
 
}


-(void)modifyName
{
    
  
    
    [btnSampleA setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnPictureB setTitle:@"示例图片" forState:UIControlStateNormal];
    
    lbTips.text=@"温馨提示:\n上传附件图片要求小于2M，格式为jpg/jpeg/bmp.";
    
    imgvPictureA.image=[UIImage imageNamed:@"img_btn_bg.png"];
    imgvPictureB.image=[UIImage imageNamed:@"img_btn_bg.png"];
    [btnPictureB setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSampleA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    lbPictureA.textColor=kCellItemTitleColor;
    lbPictureB.textColor=kCellItemTitleColor;
    lbTips.textColor=kCellItemTextColor;
    
    [vUpBackground addAllBorder];
    
}

-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [self.mdictParams setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [self.mdictParams setValue:_strCreFaceUrl forKey:@"cerPica"];
    [self.mdictParams setValue:_strCreBackUrl forKey:@"cerPich"];
    [dict setValue:self.mdictParams forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"apply_certification" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"]  parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
            [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
                
  
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                
                [UIAlertView showWithTitle:nil message:@"实名认证提交成功！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    GYRegisterAuthViewController * vc =self.navigationController.viewControllers[1];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                  
                }];
                
                
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"1"])
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }
            
        }
        
    }];
    
}

///重要信息变更的请求方法
-(void)sendRequestForImportantChange
{
    
    if (!_strCreFaceUrl>0||!_strCreBackUrl>0) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [self.mdictParams setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [self.mdictParams setValue:_strCreFaceUrl forKey:@"newCerPica"];
    [self.mdictParams setValue:@"" forKey:@"newCerPicb"];
    [self.mdictParams setValue:_strCreBackUrl forKey:@"newCerPich"];
    

    [dict setValue:self.mdictParams forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"apply_import_info_change" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {

                [GlobalData shareInstance].personInfo.importantInfoStatus=@"Y";

                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                [UIAlertView showWithTitle:nil message:@"重要信息变更提交成功！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    GYHSAccountViewController * vc =self.navigationController.viewControllers[0];
                    [self.navigationController popToViewController:vc
                                                          animated:YES];
                    
                }];
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"4"])
            {
                [Utils showMessgeWithTitle:nil message:@"您填写的身份信息已存在系统中！" isPopVC:nil];
            
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"变更失败，请重试！" isPopVC:nil];
                
                
            }

            
//            //成功
//            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
//                
//                
//                
//                [UIAlertView showWithTitle:nil message:@"重要信息变更提交成功。" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    
//                    GYHSAccountViewController * vc =self.navigationController.viewControllers[0];
//                    
//                    [self.navigationController popToViewController:vc animated:YES];
//                    
//                }];
//                //失败
//            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"4"])
//            {
//                [Utils showMessgeWithTitle:nil message:@"您填写的身份信息已存在系统中！" isPopVC:nil];
//                
//            }else
//            {
//                [Utils showMessgeWithTitle:nil message:@"变更失败，请重试！" isPopVC:nil];
//                
//                
//            }
            
            
            
            
            
        }
        
    }];
    
    
    
}


-(void)addGestureToImgView
{
    GYImgTap * tapForFront =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForFront.numberOfTapsRequired=1;
    tapForFront.tag=100;
    [imgvPictureA addGestureRecognizer:tapForFront];
    
    GYImgTap * tapForBack =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForBack.numberOfTapsRequired=1;
    tapForBack.tag=101;
    [imgvPictureB addGestureRecognizer:tapForBack];
    
  
}


-(void)popActionSheet:(GYImgTap *)tap;
{
    tagIndex=tap.tag;
    UIActionSheet *PicChooseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"take_photos"),kLocalized(@"my_ablum"), nil];
    PicChooseSheet.destructiveButtonIndex=2;
    PicChooseSheet.delegate=self;
    
    [PicChooseSheet showInView:self.tabBarController.view.window];
    
    
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0) {
        NSLog(@"12345");
        [self photocamera];
    }
    
    else if(buttonIndex == 1){
        
        NSLog(@"zxcvb");
        [self photoalbumr];
        
    }else if (buttonIndex==2){
        
        NSLog(@"wsxcde");
        
    }
    
}


//进入相册
-(void)photoalbumr{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker =
        
        [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
//        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error accessing photo library"
                              
                              message:@"Device does not support a photo library"
                              
                              delegate:nil
                              
                              cancelButtonTitle:@"Drat!"
                              
                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}

//进入拍照
-(void)photocamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        
        imagepicker.delegate = self;
        
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
        
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Sorry"
                              
                              message:@"设备不支持拍照功能"
                              
                              delegate:nil
                              
                              cancelButtonTitle:@"确定"
                              
                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}
//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//Pickerviewcontroller的代理方法。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //  ivCertificateFront.image=image;
    switch (tagIndex) {
            
        case 100:
            
        {
            //上传图片获取URL
            
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.index=0;
            uploadPic.urlType=2;
            
            
            
            [self saveImage:image withName:@"AuthimgCertificationFront.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationFront.png"];
            
            NSLog(@"%@",fullPath);
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            imgvPictureA.image = savedImage;
            
        }
            
            break;
            
        case 101:
            
        {
            //上传图片获取URL
            
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.index=1;
            uploadPic.urlType=2;
            
            [self saveImage:image withName:@"AuthimgCertificationback.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationback.png"];
            
            
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            imgvPictureB.image = savedImage;
            
        }
            
            break;
            
        case 102:
            
        {

            
        }
            
            break;
            
            
        default:
            
            break;
            
    }
    
    
}
//保存图片至沙盒

#pragma mark - save

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName

{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.6);
    
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    
}

#pragma mark 上传图片获取URL的代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag: (int) index
{
    

    switch (index) {
        case 0:
        {

            _strCreFaceUrl=[NSString stringWithFormat:@"%@",url];
            
    
        }
            break;
        case 1:
        {
            _strCreBackUrl=[NSString stringWithFormat:@"%@",url];
        }
            break;
   
            
        default:
            break;
    }

}

#pragma mark 上传图片失败
-(void)didFailUploadImg : (NSError *)error withTag:(int)index
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];

}

- (IBAction)btnSamplePictureA:(id)sender {
    

    UIView * backgroundView;
    if (imgv==nil) {
      imgv =[[UIImageView alloc]init];
    }
    if (backgroundView==nil) {
      backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }


    
//    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
//    {
    
//        lbPictureA.text=@"护照证件照";
//        lbPictureB.text=@"手持证件照";
     NSLog(@"%@------cretype",[GlobalData shareInstance].personInfo.creType);
         [ self setSamplePicture:[GlobalData shareInstance].personInfo.creType withTag:1];
        
//    }else if ([ [GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
//    {
//      
//    }
  
   

    backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];
    
    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];
        
    } completion:^(BOOL finished) {
    
    }];
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView:)];
     [backgroundView addGestureRecognizer:tap];

    
}


-(void)hidenView:(UITapGestureRecognizer * )tap
{
    

    [UIView animateWithDuration:0.24 animations:^{
         tap.view.alpha=0.0;
    } completion:^(BOOL finished) {
        [tap.view  removeFromSuperview];
    }];


}


- (IBAction)btnSamplePictureB:(id)sender {
    
   
    UIView * backgroundView;
    if (imgv==nil) {
        imgv =[[UIImageView alloc]init];
    }
    if (backgroundView==nil) {
        backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    NSLog(@"%@------cretype",[GlobalData shareInstance].personInfo.creType);
    
      [ self setSamplePicture:[GlobalData shareInstance].personInfo.creType withTag:2];

    
    
    backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];
    
    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView:)];
    [backgroundView addGestureRecognizer:tap];
    
    
    
    
}

-(void)setSamplePicture :(NSString * )picType withTag :(int)index
{
    if ([picType isEqualToString:@"2"]) {
        
        
        switch (index) {
            case 1:
            {
                imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-50);
                imgv.bounds=CGRectMake(0, 0, 245*0.9, 340*0.9);
                imgv.image=[UIImage imageNamed:@"cre_huzhao.jpg"];
            
            }
                break;
            case 2:
            {
                imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
                imgv.bounds=CGRectMake(0, 0, 140+140*0.9, 90+90*0.9);
                imgv.image=[UIImage imageNamed:@"passport_hold.jpg"];
                
            }
                break;
            default:
                break;
        }
    
    }else if ([picType isEqualToString:@"3"])
    {
        switch (index) {
            case 1:
            {
                imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
                imgv.bounds=CGRectMake(0, 0, 160+140*0.9, 110+110*0.9);
                imgv.image=[UIImage imageNamed:@"cre_yinye_zhizhao.jpg"];
                
            }
                break;
            case 2:
            {
                imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
                imgv.bounds=CGRectMake(0, 0, 300, 216);
                imgv.image=[UIImage imageNamed:@"orgnizationPaper_hold.jpg"];
                
            }
                break;
            default:
                break;
        }
    
    }


}


@end

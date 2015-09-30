//
//  GYRealNameAuthConfirmViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYRealNameAuthConfirmViewController.h"
#import "GYImgTap.h"
#import "GlobalData.h"

#import "UIImageView+WebCache.h"

#import "ClickImage.h"
#import "Animations.h"
#import "CustomIOS7AlertView.h"

#import "GYRegisterAuthViewController.h"
#import "GYHSAccountViewController.h"

@interface GYRealNameAuthConfirmViewController ()

@end

@implementation GYRealNameAuthConfirmViewController

{
    __weak IBOutlet UIImageView *ivCertificateFront;//imgv 证件正面
    
    __weak IBOutlet UIImageView *ivCertificateBack;//imgv  证件背面
    
    __weak IBOutlet UIImageView *ivCertificateWithMan;//imgv 手持证件照
    
    __weak IBOutlet UILabel *lbPicCommentFront;//lb 证件正面
    
    __weak IBOutlet UILabel *lbPicCommentBack;//lb证件背面
    
    __weak IBOutlet UILabel *lbPicCommentWithMan;//lb 手持证件照
    
    __weak IBOutlet UILabel *lbCertificateFront;//lb图片上传小于2MB
    
    __weak IBOutlet UILabel *lbCertificateBack;//lb图片上传小于2MB
    
    __weak IBOutlet UILabel *lbCertificateWithMan;//lb图片上传小于2MB
    
    __weak IBOutlet UIButton *btnSamplePic;
    
    __weak IBOutlet UIButton *btnSamplePic2;
    
    int tagIndex;
    
    __weak IBOutlet UIButton *btnSamplePic3;
    
    
    __weak IBOutlet UILabel *lbTips;
    
    
    ClickImage * tapedImagev;
    
    
    
    
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
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(Confirm)];
    [self getDataFromNetwork];
    [self modifyName];
    [self setTextColor];
    [self setDefaultBackground];
    [self setBtn];
    [self addGestureToImgView];
}


-(void)getDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    NSMutableDictionary * paramDict =[[NSMutableDictionary alloc]init];
    
    [paramDict setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dict  setValue:paramDict forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"get_certification_type_and_pic" forKeyPath:@"cmd"];
    

    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];

            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"1"])
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"123456" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }
            
        }
        
    }];

}


-(void)setTextColor
{
    lbPicCommentFront.textColor=kCellItemTitleColor;
    lbPicCommentBack.textColor=kCellItemTitleColor;
    lbPicCommentWithMan.textColor=kCellItemTitleColor;
    lbCertificateBack.textColor=kCellItemTextColor;
    lbCertificateFront.textColor=kCellItemTextColor;
    lbCertificateWithMan.textColor=kCellItemTextColor;
    lbTips.textColor=kCellItemTextColor;
}


-(void)Confirm
{
    NSLog(@"发送请求");
    
    if (!_strCreFaceUrl.length>0) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择图片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if (!_strCreFaceUrl.length>0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择图片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    
    }else if (!_strCreHoldUrl.length>0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择图片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    
    }
    
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


-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [self.dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [self.dictInside setValue:_strCreFaceUrl forKey:@"cerPica"];
    [self.dictInside setValue:_strCreBackUrl forKey:@"cerPicb"];
    [self.dictInside setValue:_strCreHoldUrl forKey:@"cerPich"];
    [dict setValue:self.dictInside forKey:@"params"];

    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"apply_certification" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"]  parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view.window];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                    [GlobalData shareInstance].personInfo.verifyStatus=@"W";
                
//                [GlobalData shareInstance].user.isRealName=YES;

                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                
                [UIAlertView showWithTitle:nil message:@"实名认证提交成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
            
                    GYRegisterAuthViewController * vc =self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:vc animated:YES];
                }];
          
            }else
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"提交实名认证失败！请检查输入信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
        }
        
    }];
    
}


-(void)sendRequestForImportantChange
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [self.dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [self.dictInside setValue:_strCreFaceUrl forKey:@"newCerPica"];
    [self.dictInside setValue:_strCreBackUrl forKey:@"newCerPicb"];
    [self.dictInside setValue:_strCreHoldUrl forKey:@"newCerPich"];

  
    [dict setValue:self.dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"apply_import_info_change" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
         [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
           
            
            //成功
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
               
                
                [UIAlertView showWithTitle:nil message:@"重要信息变更提交成功。" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    GYHSAccountViewController * vc =self.navigationController.viewControllers[0];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }];
            //失败
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"4"])
            {
                [Utils showMessgeWithTitle:nil message:@"您填写的身份信息已存在系统中！" isPopVC:nil];
                
            }else
            {
                  [Utils showMessgeWithTitle:nil message:@"变更失败，请重试！" isPopVC:nil];
            
            
            }
            
        }
        
    }];



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


-(UIView * )succeedTip
{

    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 50)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;
    
    UIImageView * imgv= [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
    imgv.image=[UIImage imageNamed:@"img_succeed.png"];
    UILabel * lbTip =[[UILabel alloc]init];
    lbTip.frame=CGRectMake(290/2-80, 0, 180, 30);
    lbTip.text=@"重要信息变更提交成功!";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    
    [popView addSubview:imgv];
    [popView addSubview:lbTip];
    return popView;
}

-(void)addGestureToImgView
{
    GYImgTap * tapForFront =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForFront.numberOfTapsRequired=1;
    tapForFront.tag=100;
    [ivCertificateFront addGestureRecognizer:tapForFront];
    
    
    
    GYImgTap * tapForBack =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForBack.numberOfTapsRequired=1;
    tapForBack.tag=101;
    [ivCertificateBack addGestureRecognizer:tapForBack];
    
    GYImgTap * tapForImgWithMan =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForImgWithMan.tag=102;
    tapForImgWithMan.numberOfTapsRequired=1;
    [ivCertificateWithMan addGestureRecognizer:tapForImgWithMan];
    //扩大BTN的点击范围
}

-(void)popActionSheet:(GYImgTap *)tap;
{
    tagIndex=tap.tag;
    UIActionSheet *PicChooseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"take_photos"),kLocalized(@"my_ablum"), nil];
    PicChooseSheet.destructiveButtonIndex=2;
    PicChooseSheet.delegate=self;
    
    [PicChooseSheet showInView:self.tabBarController.view.window];
    
    
}


-(void)setBtn
{
    
    [btnSamplePic setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePic2 setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePic3 setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    [self setBtn:btnSamplePic WithColor:kNavigationBarColor WithWidth:1 WithIndex:1];
    [self setBtn:btnSamplePic2 WithColor:kNavigationBarColor WithWidth:1 WithIndex:2];
    [self setBtn:btnSamplePic3 WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    
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
            uploadPic.urlType=2;
            uploadPic.index=0;
           
         
            
            
            [self saveImage:image withName:@"AuthimgCertificationFront.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationFront.png"];
 
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            ivCertificateFront.image = savedImage;
            
        }
            
            break;
            
        case 101:
            
        {
            //上传图片获取URL
            
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
             uploadPic.fatherView=self.view;
            uploadPic.delegate=self;
            uploadPic.index=1;
            uploadPic.urlType=2;
            [uploadPic uploadImg:image WithParam:nil];
            
            
            [self saveImage:image withName:@"AuthimgCertificationback.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationback.png"];
            
            
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            ivCertificateBack.image = savedImage;
            
        }
            
            break;
            
        case 102:
            
        {
            //上传图片获取URL
            
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.urlType=2;
            uploadPic.index=2;
            
            [self saveImage:image withName:@"AuthimgCertificationWithMan.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationWithMan.png"];
            
            NSLog(@"%@",fullPath);
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            ivCertificateWithMan.image = savedImage;
            
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
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    
}


-(void)setBtn:(UIButton *)sender  WithColor:(UIColor *)color WithWidth:(CGFloat )width WithIndex:(NSInteger)buttonTag
{
    sender.layer.cornerRadius=2.0f;
    sender.layer.borderWidth=width;
    sender.tag=buttonTag;
    sender.layer.borderColor=color.CGColor;
    sender.layer.masksToBounds=YES;
}


-(void)modifyName
{
    lbPicCommentFront.text=@"证件正面";
    lbPicCommentBack.text=@"证件背面";
    lbPicCommentWithMan.text=@"手持证件照";
    [btnSamplePic setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnSamplePic2 setTitle:@"示例图片" forState:UIControlStateNormal];
    [btnSamplePic3 setTitle:@"示例图片" forState:UIControlStateNormal];
    lbTips.text=[NSString stringWithFormat:@"温馨提示: \n上传附件图片要求小于2M,格式为jpg/jpeg/bmp。"];
    lbCertificateFront.text=[NSString stringWithFormat:kLocalized(@"Picture_less_than"),@"100K"];
    
    lbCertificateBack.text=[NSString stringWithFormat:kLocalized(@"Picture_less_than"),@"100K"];
    
    lbCertificateWithMan.text=[NSString stringWithFormat:kLocalized(@"Picture_less_than"),@"100K"];
}

-(void)setDefaultBackground
{
    ivCertificateBack.image=[UIImage imageNamed:@"img_btn_bg.png"];
    ivCertificateFront.image=[UIImage imageNamed:@"img_btn_bg.png"];
    ivCertificateWithMan.image=[UIImage imageNamed:@"img_btn_bg.png"];
    
}

- (IBAction)btnSamplePicA:(id)sender {
    
    UIImageView * imgv;
    UIView * backgroundView;
    if (imgv==nil) {
        imgv =[[UIImageView alloc]init];
    }
    if (backgroundView==nil) {
        backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
    imgv.bounds=CGRectMake(0, 0, 140+140*0.9, 90+90*0.9);
    imgv.image=[UIImage imageNamed:@"auth_sample_picture_a.jpg"];
    
    
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

- (IBAction)btnSamplePicB:(id)sender {
    UIImageView * imgv;
    UIView * backgroundView;
    if (imgv==nil) {
        imgv =[[UIImageView alloc]init];
    }
    if (backgroundView==nil) {
        backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
    imgv.bounds=CGRectMake(0, 0, 140+140*0.9, 90+90*0.9);
    imgv.image=[UIImage imageNamed:@"auth_sample_picture_b.jpg"];
    
    
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

- (IBAction)btnSamplePicC:(id)sender {
    UIImageView * imgv;
    UIView * backgroundView;
    if (imgv==nil) {
        imgv =[[UIImageView alloc]init];
    }
    if (backgroundView==nil) {
        backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    imgv.center=CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
    imgv.bounds=CGRectMake(0, 0, 140+140*0.9, 90+90*0.9);
    imgv.image=[UIImage imageNamed:@"auth_sample_picture_h.jpg"];
    
    
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

#pragma mark 上传图片代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{
  
    NSString * picUrlString =[NSString stringWithFormat:@"%@",url];
   
    switch (index) {
        case 0:
        {
            
          _strCreFaceUrl=picUrlString;
            
            NSLog(@"%@=======cccc",_strCreFaceUrl);
            
        }
            break;
        case 1:
        {
           _strCreBackUrl=picUrlString;
        }
            break;
        case 2:
        {
            _strCreHoldUrl=picUrlString;
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

@end

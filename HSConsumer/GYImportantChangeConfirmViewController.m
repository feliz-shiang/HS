//
//  GYRealNameAuthConfirmViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYImportantChangeConfirmViewController.h"
#import "GYImgTap.h"


#import "GlobalData.h"
#import "Animations.h"
@interface GYImportantChangeConfirmViewController ()

@end

@implementation GYImportantChangeConfirmViewController

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
    
    int index;
    
    __weak IBOutlet UIButton *btnSamplePic3;
    
    NSString * strCreFaceUrl;
    NSString * strCreBackUrl;
    NSString * strCreHoldUrl;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=@"重要信息变更申请";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(Confirm)];
    
    [self modifyName];
    [self setTextColor];
    [self setDefaultBackground];
    [self setBtn];
    [self addGestureToImgView];
}

-(void)setTextColor
{
    lbPicCommentFront.textColor=kCellItemTitleColor;
    lbPicCommentBack.textColor=kCellItemTitleColor;
    lbPicCommentWithMan.textColor=kCellItemTitleColor;
    lbCertificateBack.textColor=kCellItemTextColor;
    lbCertificateFront.textColor=kCellItemTextColor;
    lbCertificateWithMan.textColor=kCellItemTextColor;
}

-(void)Confirm
{
    NSLog(@"发送请求");
    
    [self loadDataFromNetwork];


}

-(void)loadDataFromNetwork
{
    if (!strCreHoldUrl.length>0||!strCreFaceUrl>0||!strCreBackUrl>0) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [self.dictInside setValue:strCreFaceUrl forKey:@"newCerPica"];
    [self.dictInside setValue:strCreBackUrl forKey:@"newCerPicb"];
    [self.dictInside setValue:strCreHoldUrl forKey:@"newCerPich"];
    
    [dict setValue:self.dictInside forKey:@"params"];

    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    [dict setValue:@"apply_import_info_change" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
          [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
          
            
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            
        }
        
    }];
    
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
    index=tap.tag;
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

- (IBAction)setSamplePictureA:(id)sender {
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


-(void)hidenView:(UITapGestureRecognizer * )tap
{
    
    
    [UIView animateWithDuration:0.24 animations:^{
        tap.view.alpha=0.0;
    } completion:^(BOOL finished) {
        [tap.view  removeFromSuperview];
    }];
    
    
}

- (IBAction)setSamplePictureB:(id)sender {
    
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

- (IBAction)setSamplePictureC:(id)sender {
    
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
        
//        picker.delegate = self;
        
        picker.allowsEditing = YES;
        
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
    switch (index) {
            
        case 100:
            
        {
            
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.urlType=2;
            uploadPic.index=0;
            
            
            [self saveImage:image withName:@"imgCertificationFront.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgCertificationFront.png"];
            
            NSLog(@"%@",fullPath);
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            ivCertificateFront.image = savedImage;
            
        }
            
            break;
            
        case 101:
            
        {
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.urlType=2;
            uploadPic.index=1;
            [self saveImage:image withName:@"imgCertificationback.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgCertificationback.png"];
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            ivCertificateBack.image = savedImage;
            
        }
            
            break;
            
        case 102:
            
        {
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
              uploadPic.fatherView=self.view;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self;
            uploadPic.urlType=2;
            uploadPic.index=2;
            [self saveImage:image withName:@"imgCertificationWithMan.png"];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgCertificationWithMan.png"];
            
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

#pragma mark 上传图片回调方法。
-(void)didFinishUploadImg:(NSURL*)url withTag: (int) picTag
{
    NSString * picUrlString =[NSString stringWithFormat:@"%@",url];

    switch (picTag) {
        case 0:
        {
            
            strCreFaceUrl=picUrlString;
            
         NSLog(@"%@=======cccc",strCreFaceUrl);
            
        }
            break;
        case 1:
        {
            strCreBackUrl=picUrlString;
        }
            break;
        case 2:
        {
            strCreHoldUrl=picUrlString;
        }
            break;
            
        default:
            break;
    }
    


}
@end

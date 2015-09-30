//
//  GYMedicalViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMedicalViewController.h"
#import "GYInstructionViewController.h"
#import "JGActionSheet.h"
#import "GYImgTap.h"
#import "GlobalData.h"
#import "GYHSLoadImg.h"
#import "UIImageView+WebCache.h"
#import "GYBigPic.h"
#import "GYUploadImage.h"

@interface GYMedicalViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,JGActionSheetDelegate,GYUploadPicDelegate>
{

    __weak IBOutlet UIScrollView *svMedical; //scrollView
    __weak IBOutlet UIButton *btnApply;//确定按钮
  
    __weak IBOutlet UIView *vMedicaCard;
     __weak IBOutlet UILabel *lbMedicalCard;//医保卡lable
     __weak IBOutlet UITextField *tfInputMedicalCardNum;//输入医保卡号
    
    __weak IBOutlet UILabel *lbAuthentication;//身份证明lable
    __weak IBOutlet UILabel *lbMedical;//医疗证明lable
    __weak IBOutlet UILabel *lbOther;//其他正面lable
    
    
    __weak IBOutlet UIView *vImage; //控件底图
    __weak IBOutlet UIImageView *imgAuthentication;//身份证背面图片
    __weak IBOutlet UIImageView *imgMedical;//医疗证明图片
    __weak IBOutlet UIImageView *imgOther;//其他证明图片
    
    
    __weak IBOutlet UIImageView *imgHSCard;//互生卡正面图片
    __weak IBOutlet UILabel *lbHSCard;//互生卡正面lable
    
    
    __weak IBOutlet UIImageView *imgHSCardBack;//互生卡正面图片
    __weak IBOutlet UILabel *lbHSCardBack;//互生卡正面lable
    
    __weak IBOutlet UIImageView *imgID;//互生卡正面图片
    __weak IBOutlet UILabel *lbID;//互生卡正面lable
    
    
    int index;//全局常量用于取手势控件tag值
    
//    GYHSLoadImg *uploadImg;

    NSString *urlPointCardFacePic ;
    NSString *urlPointCardBackPic ;
    NSString *urlLrcCardFacePic ;
    NSString *urlLrcCardBackPic ;
    NSString *urlMedicalCer ;
    NSString *urlElseCer ;
    
    
    GYBigPic *bigPic;
    
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    __weak IBOutlet UIButton *btn3;
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet UIButton *btn5;
    __weak IBOutlet UIButton *btn6;
    

}

@end

@implementation GYMedicalViewController

//点击示例图

- (IBAction)btnBigPicClick:(id)sender {
    
    if (sender == btn1) {
        [bigPic showView:[UIImage imageNamed:@"HSCFace.jpg"]];
    }
    if (sender == btn2) {
        [bigPic showView:[UIImage imageNamed:@"HSCBack.jpg"]];
    }
    if (sender == btn3) {
        [bigPic showView:[UIImage imageNamed:@"IDCFace.jpg"]];
    }
    if (sender == btn4) {
        [bigPic showView:[UIImage imageNamed:@"IDCBack.jpg"]];
    }
    if (sender == btn5) {
        [bigPic showView:[UIImage imageNamed:@"MedicalCer.jpg"]];
    }
    if (sender == btn6) {
//        [bigPic showView:[UIImage imageNamed:@"cre_huzhao.jpg"]];
    }
    
    
}




//提交资料说明按钮 点击事件
- (IBAction)btnInstructionClick:(id)sender {
    
    GYInstructionViewController *vcInstruction = [[GYInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"medical_insurance");
    vcInstruction.strTitle = kLocalized(@"apply_medical_insurance");
    vcInstruction.strContent = @"1、注册并经实名认证过的互生积分卡；\n2、申请人的法定身份证明；\n3、要求申请人所能提供的与确认保障事故的性质、原因、伤害程度等相关的其他证明和资料。\n4、本人的医保卡号；\n5、没有医保卡号的被保障人需要提交以下资料:\n1) 二级以上（含二级）医院或本平台认可的其他医疗机构出具的医疗费用原始结算凭证、诊断证明及病历等相关资料；\n2) 对于已经从当地社会基本医疗保险、公费医疗或其他途径获得补偿或给付的，需提供相应机构或单位出具的医疗费用结算证明；\n3) 若由代理人代为申请保障金，则还应提供授权委托书、代理人法定身份证明等文件。\n\n                                        [互生系统平台]\n                                        2013－07－22";
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

//立即申请按钮点击事件
- (IBAction)btnApplyClick:(id)sender {
    
    if ([[GlobalData shareInstance].personInfo.creType  isEqualToString:@"3"]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册证件类型为营业执照，不享受意外伤害保障!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    if (![[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"Y"] ) {
        [Utils showMessgeWithTitle:nil message:@"请完成实名认证！" isPopVC:nil];
        return;
    }
    if (![[GlobalData shareInstance].personInfo.phoneFlag isEqualToString:@"Y"])
    {
        [Utils showMessgeWithTitle:nil message:@"请完成手机号码绑定！" isPopVC:nil];
        return;
    }
    
//    // 校验医保卡号
//    if (!tfInputMedicalCardNum.text || tfInputMedicalCardNum.text.length > 10 || tfInputMedicalCardNum.text.length <6) {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"医保号码输入错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }

    // 校验医保卡号
    if ((tfInputMedicalCardNum.text && tfInputMedicalCardNum.text.length>0) && (tfInputMedicalCardNum.text.length > 10 || tfInputMedicalCardNum.text.length <6)) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"医保号码输入错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if(!tfInputMedicalCardNum.text || tfInputMedicalCardNum.text.length == 0)
    {
        tfInputMedicalCardNum.text = @"";
    }

    if (urlElseCer.length == 0|| urlLrcCardBackPic.length == 0|| urlLrcCardFacePic.length == 0|| urlMedicalCer.length == 0|| urlPointCardBackPic.length == 0|| urlPointCardFacePic.length == 0) {
        UIAlertView * avCode = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"please_enter_the_complete_information") delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [avCode show];
        return;
    }
    [self getNetData];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        uploadImg = [[GYHSLoadImg alloc] init];
//        uploadImg.delegate = self;
        
        urlPointCardFacePic = @"";
        urlPointCardBackPic = @"";
        urlLrcCardFacePic = @"";
        urlLrcCardBackPic = @"";
        urlMedicalCer = @"";
        urlElseCer = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"medical_insurance");
    lbMedicalCard.text = kLocalized(@"medicare_number");
    tfInputMedicalCardNum.placeholder = kLocalized(@"input_health_number");
    
    btn6.hidden=YES;
    lbAuthentication.text = kLocalized(@"proof_of_identity");
     lbAuthentication.text = @"身份证-背面";
    lbMedical.text = kLocalized(@"medical_papers");
    
    lbOther.text = kLocalized(@"other_supporting");
   
    [self setBorderWithView:vMedicaCard WithWidth:1 WithRadius:0 WithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor];
   
    [self setBorderWithView:vImage WithWidth:1 WithRadius:0 WithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor];
    
    
    //图片选择
    
    GYImgTap* tap1 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap1.tag = 1001;
    GYImgTap* tap2 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap2.tag = 1002;
    GYImgTap* tap3 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap3.tag = 1003;
    
    
    GYImgTap* tap4 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap4.tag = 1004;
    GYImgTap* tap5 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap5.tag = 1005;
    GYImgTap* tap6 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
    tap6.tag = 1006;
    
    
  
    
    [imgHSCard addGestureRecognizer:tap1];
    [imgHSCardBack addGestureRecognizer:tap2];
    [imgID addGestureRecognizer:tap3];
    
    [imgAuthentication addGestureRecognizer:tap4];
    [imgMedical addGestureRecognizer:tap5];
    [imgOther addGestureRecognizer:tap6];
    
    
    //立即申请按钮设置
    [self setBorderWithView:btnApply WithWidth:0 WithRadius:4 WithColor:nil];
    btnApply.titleLabel.text = kLocalized(@"Now_apply");
    [self setBorderWithView:vImage WithWidth:1 WithRadius:0 WithColor:kCorlorFromRGBA(230, 230, 230, 1).CGColor];
    
    bigPic = [[GYBigPic alloc] init];
    bigPic.vc = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    svMedical.contentSize = CGSizeMake(320, 580);

}


//设置边框函数
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(CGColorRef)color
{
    view.layer.borderWidth = width;
    view.layer.borderColor = color;
    view.layer.cornerRadius = radius;
}

-(void)selectImageWith:(GYImgTap *)tap
{
    
    index = tap.tag;
    JGActionSheetSection * ass ;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ass= [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[kLocalized(@"photo_album"),kLocalized(@"camera")] buttonStyle:JGActionSheetButtonStyleDefault];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 300, 1)];
        label.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
        [ass addSubview:label];
        
    }else{
        ass= [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[kLocalized(@"photo_album")] buttonStyle:JGActionSheetButtonStyleDefault];
    }
    NSArray *asss = @[ass, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[kLocalized(@"cancel")] buttonStyle:JGActionSheetButtonStyleCancel]];
    
    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
    as.delegate = self;
    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                    //图片来源 相册 相机
                    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    ipc.delegate = self;
                    [self presentViewController:ipc animated:YES completion:nil];
                    
                    
                }else{
                    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];

                    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                    ipc.delegate = self;
                    [self presentViewController:ipc animated:YES completion:nil];
                }
            }
                break;
            case 1:
            {

            // 取消按钮点击事件
            }
                break;
            default:
                break;
        }
        [sheet dismissAnimated:YES];
    }];
    [as setCenter:CGPointMake(100, 100)];
    [as showInView:self.view animated:YES];
    
}

#pragma mark - UIImagePickerControllerDelegate
//选择图片调用

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    // modify bu songjk
    // 获取图片名称
    NSURL * Url =[info objectForKey:UIImagePickerControllerReferenceURL];
    NSString * strUrl = [Url absoluteString];
    // 得到文件名称
    NSRange one = [strUrl rangeOfString:@"="];
    NSRange two = [strUrl rangeOfString:@"&"];
    NSString * name = [strUrl substringWithRange:NSMakeRange(one.location+1, two.location - one.location-1)];
    NSString * strType = [strUrl substringFromIndex:strUrl.length - 3];
    NSLog(@"%@,%@,%@",strType,strUrl,name);
    NSString * imageName = [NSString stringWithFormat:@"%@.%@",name,strType];
    // 保存到沙盒
    NSData *imageData = UIImageJPEGRepresentation(image1, 1);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent :imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    NSLog(@"%ld",(unsigned long)[imageData length]);
    // 检查文件大小 不能大于10M
    NSFileManager * fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    if (fSize > 10 * 1024 * 1024) {
        [Utils showMessgeWithTitle:@"友情提示" message:@"上传图片不能大于10M，上传失败，请重新选择图片" isPopVC:nil];
        [fm removeItemAtPath:fullPath error:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // 保存到沙盒
        [self saveImage:image1 withName:imageName];
        // 上传图片
        
        GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
        uploadPic.fatherView=self.view;
        [uploadPic uploadImg:image1 WithParam:nil];
        uploadPic.delegate=self;
        uploadPic.index=index;
        uploadPic.urlType=3;
        
//        [uploadImg uploadImg:image1 :[NSString stringWithFormat:@"%d",index]];
        NSLog(@"size = %lld,path = %@",fSize,fullPath);
        
        
    }
    
    
    //取得图片
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //回调函数
        
    }];
    
    
}

#pragma mark 上传图片代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag: (int) index2;//请求成功返回URL
{
    
    NSString * picUrlString =[NSString stringWithFormat:@"%@",url];
    NSString * hsPicName =[picUrlString lastPathComponent];
   
//    GYImgTap* tap1 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap1.tag = 1001;
//    GYImgTap* tap2 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap2.tag = 1002;
//    GYImgTap* tap3 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap3.tag = 1003;
//    
//    
//    GYImgTap* tap4 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap4.tag = 1004;
//    GYImgTap* tap5 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap5.tag = 1005;
//    GYImgTap* tap6 = [[GYImgTap alloc] initWithTarget:self action:@selector(selectImageWith:)];
//    tap6.tag = 1006;
    
//    [imgAuthentication addGestureRecognizer:tap1];
//    [imgMedical addGestureRecognizer:tap2];
//    [imgOther addGestureRecognizer:tap3];
//    
//    [imgHSCard addGestureRecognizer:tap4];
//    [imgHSCardBack addGestureRecognizer:tap5];
//    [imgID addGestureRecognizer:tap6];
    
//    [imgHSCard addGestureRecognizer:tap1];
//    [imgHSCardBack addGestureRecognizer:tap2];
//    [imgID addGestureRecognizer:tap3];
//    
//    [imgAuthentication addGestureRecognizer:tap4];
//    [imgMedical addGestureRecognizer:tap5];
//    [imgOther addGestureRecognizer:tap6];
    
    
    switch (index2) {
        case 1001:
        {
           
            [imgHSCard sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            urlPointCardFacePic = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
        case 1002:
        {
            
            [imgHSCardBack sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlPointCardBackPic = [NSString stringWithFormat:@"%@",hsPicName];
            
        }
            break;
        case 1003:
        {
            [imgID sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlLrcCardFacePic = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
            
        case 1004:
        {
            [imgAuthentication sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlLrcCardBackPic = [NSString stringWithFormat:@"%@",hsPicName];
            
        }
            break;
        case 1005:
        {
            [imgMedical sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlMedicalCer = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
        case 1006:
        {
            [imgOther sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlElseCer = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
        default:
            break;
            
            
            
            
    }
    


}


//点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

-(void)getNetData
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:tfInputMedicalCardNum.text forKey:@"healthCardNo"];
    
    [dictInside setValue:urlPointCardFacePic forKey:@"pointCardFacePic"];
    [dictInside setValue:urlPointCardBackPic forKey:@"pointCardBackPic"];
    [dictInside setValue:urlLrcCardFacePic forKey:@"lrcCardFacePic"];
    [dictInside setValue:urlLrcCardBackPic forKey:@"lrcCardBackPic"];
    [dictInside setValue:urlMedicalCer forKey:@"medicalCer"];
    [dictInside setValue:urlElseCer forKey:@"elseCer"];
    
   
    
    /*
     pointCardFacePic
     pointCardBackPic
     lrcCardFacePic
     lrcCardBackPic
     medicalCer
     elseCer
     */
  
    
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    //请求对应url的运行cmd
    
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"apply_free_accident_insurance" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
           [Utils hideHudViewWithSuperView:self.view.window];
        if (error)
        {
            NSLog(@"错误");
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        else
        {
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
//                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"申请意外伤害保障金提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//          
//                [av show];
                [Utils showMessgeWithTitle:nil message:@"申请意外伤害保障金提交成功" isPopVC:self.navigationController];
            }
            else
            {
                NSString * strMsg = ResponseDic[@"data"][@"resultMsg"];
                if (strMsg == nil || strMsg.length == 0) {
                    strMsg = @"提交申请失败.";
                }
                [Utils showMessgeWithTitle:nil message:strMsg isPopVC:self.navigationController];
            }
            //网络请求回调后弹窗
        }
    }];
    
    
}



@end

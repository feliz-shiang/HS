//
//  GYDieViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYDieViewController.h"
#import "GYInstructionViewController.h"
#import "GYImgTap.h"
#import "JGActionSheet.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "GYHSLoadImg.h"
#import "UIImageView+WebCache.h"
#import "GYBigPic.h"
#import "GYUploadImage.h"


@interface GYDieViewController ()<JGActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GYHSLoadImgDelegate,GYUploadPicDelegate>
{
    __weak IBOutlet UIScrollView *svDie;//scrollView
   
    
    
    __weak IBOutlet UIButton *btnInstruction;//提交资料说明
    __weak IBOutlet UIButton *btnApply;//申请按钮
    
    __weak IBOutlet UIView *vImg;
    
    
    __weak IBOutlet UIImageView *imgDeathCer;
    __weak IBOutlet UIImageView *imgAgentAccreditPic;
    __weak IBOutlet UIImageView *imgIdLogoutCer;
    __weak IBOutlet UIImageView *imgTrusteeIdCardPic;
    __weak IBOutlet UIImageView *imgElseCer;
    
    

    
    int index;
    
    GYHSLoadImg *uploadImg;
    
    
    __weak IBOutlet UITextField *tfDeathNum;
    
    __weak IBOutlet UILabel *lbLine;
    __weak IBOutlet UIView *vInput;
    
    __weak IBOutlet UITextField *tfDeathName;
    
    NSString *urlAgentAccreditPic ;
    NSString *urlTrusteeIdCardPic ;
    NSString *urlDeathCer ;
    NSString *urlIdLogoutCer ;
    NSString *urlElseCer ;
    
    
    
    
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    __weak IBOutlet UIButton *btn3;
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet UIButton *btn5;

    GYBigPic *bigPic;
    
}
@end

@implementation GYDieViewController

//示例图片点击事件


- (IBAction)btnBigPicClick:(id)sender {
    if (sender == btn1) {
        [bigPic showView:[UIImage imageNamed:@"DeathCer.jpg"]];
    }
    if (sender == btn2) {
        [bigPic showView:[UIImage imageNamed:@"AgentAccreditPic.jpg"]];
    }
    if (sender == btn3) {
        [bigPic showView:[UIImage imageNamed:@"IdLogoutCer.jpg"]];
    }
    if (sender == btn4) {
        [bigPic showView:[UIImage imageNamed:@"TrusteeIdCardPic.jpg"]];
    }
    if (sender == btn5) {
        // modify by songjk
//        [bigPic showView:[UIImage imageNamed:@"apple5.png"]];
        [bigPic showView:[UIImage imageNamed:@"MedicalCer.jpg"]];
    }
    
    
}









//提交资料说明按钮 点击事件
- (IBAction)btnInstructionClick:(id)sender {
    GYInstructionViewController *vcInstruction = [[GYInstructionViewController alloc] init];
    
    vcInstruction.title = kLocalized(@"death_benefits");
    vcInstruction.strTitle = kLocalized(@"apply_death_benefits");
    vcInstruction.strContent = @"1.  注册并经实名认证过的互生积分卡；\n2.  申请人的法定身份证明；\n3.  公安部门或二级以上(含二级)医院出具的被保障人死亡证明书；\n4.  如被保障人为宣告死亡，申请人须提供公安局出具的宣告死亡证明文件；\n5.  被保障人的户籍注销证明；\n6.  本平台要求的申请人所能提供的与确认保障事故的性质、原因、伤害程度等有关的其他证明和资料；\n7.  保障金作为被保障人遗产时，必须提供可证明合法继承权的相关权利文件。\n\n                                        [互生系统平台]\n                                        2013－07－22";
    
    [self.navigationController pushViewController:vcInstruction animated:YES];
    
}
//提交申请按钮 点击事件
- (IBAction)btnApplyClick:(id)sender {
    
    
    // modify by songjk+(BOOL)isValidMobileNumber:(NSString*)number;
    NSString * strName = [tfDeathName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * strNum = [tfDeathNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([[GlobalData shareInstance].personInfo.creType  isEqualToString:@"3"]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册证件类型为营业执照，不能办理本业务！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    if (![Utils isHSCardNo:tfDeathNum.text]) {
        UIAlertView * av  = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的身故人互生号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    

    if (strName.length == 0 ||
        strNum.length != 11 ||
        ![Utils isValidMobileNumber:strNum] ||
        urlAgentAccreditPic.length == 0||
        urlDeathCer.length == 0||
        urlElseCer.length == 0||
        urlIdLogoutCer.length == 0||
        urlTrusteeIdCardPic.length == 0)
    {
        UIAlertView * avCode = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"please_enter_the_complete_information") delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [avCode show];
    }else if ([tfDeathNum.text isEqualToString:[GlobalData shareInstance].user.cardNumber])
    {
    
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请勿自己申请身故保障金！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    else{
        
        
        [self getNetData];
        
    }

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [lbLine addTopBorder];
    [vInput addAllBorder];
    uploadImg = [[GYHSLoadImg alloc] init];
    uploadImg.delegate = self;
    
    urlAgentAccreditPic = @"";
    urlTrusteeIdCardPic = @"";
    urlDeathCer = @"";
    urlIdLogoutCer = @"";
    urlElseCer = @"";
    
    
    
//    self.title = kLocalized(@"death_benefits");
    
    
    
    [btnInstruction setTitle:kLocalized(@"disclose_information_instructions") forState:UIControlStateNormal];
    //立即申请按钮设置
    btnApply.layer.cornerRadius = 4.0;
    btnApply.titleLabel.text = kLocalized(@"Now_apply");
    //添加边框
    [vImg addAllBorder];
    
    
    //添加手势
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
    
    
    
    
    [imgDeathCer addGestureRecognizer:tap1];
    [imgAgentAccreditPic addGestureRecognizer:tap2];
    [imgIdLogoutCer addGestureRecognizer:tap3];
    [imgTrusteeIdCardPic addGestureRecognizer:tap4];
    [imgElseCer addGestureRecognizer:tap5];
    
    
    bigPic = [[GYBigPic alloc] init];
    bigPic.vc = self;
    
}

//设置边框函数


-(void)viewWillAppear:(BOOL)animated
{
    svDie.contentSize = CGSizeMake(320, 600);
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
                //取消按钮点击事件
            
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [uploadImg uploadImg:image :[NSString stringWithFormat:@"%d",index]];
    
    GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
    uploadPic.fatherView=self.view;
    [uploadPic uploadImg:image WithParam:nil];
    uploadPic.delegate=self;
    uploadPic.index=index;
    uploadPic.urlType=3;
    
    //取得图片
    [picker dismissViewControllerAnimated:YES completion:^{

    //回调函数
    
    }];
  
    
}

#pragma mark 上传图片代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag: (int) index2
{
    NSString * picUrlString =[NSString stringWithFormat:@"%@",url];
    NSString * hsPicName =[picUrlString lastPathComponent];
    
    switch (index) {
        case 1001:
        {
            
            [imgDeathCer sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            urlDeathCer = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
        case 1002:
        {
            
            [imgAgentAccreditPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlAgentAccreditPic = [NSString stringWithFormat:@"%@",hsPicName];
            
        }
            break;
        case 1003:
        {
            [imgIdLogoutCer sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlIdLogoutCer = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
            
        case 1004:
        {
            [imgTrusteeIdCardPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlTrusteeIdCardPic = [NSString stringWithFormat:@"%@",hsPicName];
            
        }
            break;
        case 1005:
        {
            [imgElseCer sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            urlElseCer = [NSString stringWithFormat:@"%@",hsPicName];
        }
            break;
            
            
        default:
            break;
            
            
    }
    




}

#pragma mark - GYLoadImgDelegate
//获取上传后的图片URL 发送图片消息体
-(void)didFinishUploadImg:(NSURL *)url
{
    NSLog(@"url========%@",url);
    
    
    
}

//点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getNetData
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
     [dictInside setValue:tfDeathName.text forKey:@"custName"];
     [dictInside setValue:tfDeathNum.text forKey:@"deathResNo"];
     [dictInside setValue:urlDeathCer forKey:@"deathCer"];
     [dictInside setValue:urlAgentAccreditPic forKey:@"agentAccreditPic"];
     [dictInside setValue:urlIdLogoutCer forKey:@"idLogoutCer"];
     [dictInside setValue:urlTrusteeIdCardPic forKey:@"trusteeIdCardPic"];
     [dictInside setValue:urlElseCer forKey:@"elseCer"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    //请求对应url的运行cmd
    
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"apply_dead_insurance" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
         [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"申请成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                 [self.navigationController popToRootViewControllerAnimated:YES];////跳转到根试图
                
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"-1"])
            {
            
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            
            }
            else{
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
                
            }
            //网络请求回调后弹窗
            
           
          
        }
    }];
    
    
}







@end

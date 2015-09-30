//
//  GYHealthUploadImgController.m
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYHealthUploadImgController.h"
#import "GYHealthUploadImgView.h"
#import "GYHealthUploadImgModel.h"

#import "GYInstructionViewController.h"
#import "JGActionSheet.h"
#import "GYImgTap.h"
#import "GlobalData.h"
#import "GYHSLoadImg.h"
#import "UIImageView+WebCache.h"
#import "GYBigPic.h"
#import "GYUploadImage.h"
@interface GYHealthUploadImgController ()<GYHealthUploadImgViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JGActionSheetDelegate,GYUploadPicDelegate>
{
    MBProgressHUD *hud; // 网络等待弹窗
}
@property (nonatomic,strong)UIView * vList;
@property(nonatomic,strong)NSMutableArray * marrData;
@property (nonatomic,assign)NSInteger height;
@property (nonatomic,weak)UIScrollView * svBack ;

@property (nonatomic,strong) GYBigPic *bigPic;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSString * HSCardFaceImg;
@property (nonatomic,strong) NSString * HSCardBackImg;
@property (nonatomic,strong) NSString * IDCardFaceImg;
@property (nonatomic,strong) NSString * IDCardBackImg;
@property (nonatomic,strong) NSString * socialProtectImg;
@property (nonatomic,strong) NSString * chargeListImg;
@property (nonatomic,strong) NSString * feeDetailImg;
@property (nonatomic,strong) NSString * hospitailHistoryImg;
@property (nonatomic,strong) NSString * liveInHospitailImg;
@property (nonatomic,strong) NSString * sicknessCheckBookImg;
@end

@implementation GYHealthUploadImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDate];
    UIScrollView * svBack = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    svBack.backgroundColor = kDefaultVCBackgroundColor;
    svBack.scrollEnabled = YES;
    [self.view addSubview:svBack];
    self.svBack = svBack;
    self.vList = [[UIView alloc] initWithFrame:CGRectMake(0, 16, self.view.bounds.size.width, self.height+30)];
    self.vList.backgroundColor = [UIColor whiteColor];
    [svBack addSubview:self.vList];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.vList.frame), self.view.bounds.size.width, 85)];
    footView.backgroundColor = [UIColor whiteColor];
    [svBack addSubview:footView];
    UIButton *btnSumit = [[UIButton alloc] initWithFrame:CGRectMake(16, 15, kScreenWidth - 16*2, 30)];
    [btnSumit addTarget:self action:@selector(confrim) forControlEvents:UIControlEventTouchUpInside];
    [btnSumit setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnSumit setTitle:@"立即申请" forState:UIControlStateNormal];
    [btnSumit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:btnSumit];
    UILabel * lbRemaind1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, kScreenWidth - 32, 20)];
    NSString * strShow = @"温馨提示：标注红色*的为必填选项";
    NSInteger length = strShow.length;
    NSRange posi = [strShow rangeOfString:@"*"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strShow];
    [str setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:posi];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, length)];
    lbRemaind1.attributedText = str;
    [footView addSubview:lbRemaind1];
    svBack.contentSize = CGSizeMake(0, CGRectGetMaxY(footView.frame)+64);
    
    [self setViewList];
    [self settings];
}
-(void)settings
{
    self.bigPic = [[GYBigPic alloc] init];
    self.bigPic.vc = self;
    self.index = 0;
    self.HSCardFaceImg = @"";
    self.HSCardBackImg = @"";
    self.IDCardFaceImg = @"";
    self.IDCardBackImg = @"";
    self.socialProtectImg = @"";
    self.chargeListImg = @"";
    self.feeDetailImg = @"";
    self.hospitailHistoryImg = @"";
    self.liveInHospitailImg = @"";
    self.sicknessCheckBookImg = @"";
}
-(void)confrim
{
    NSLog(@"提交申请");
    if (![self isAllDataRight]) {
        return;
    }
    [self commit];
}
-(void)setDate
{
    NSMutableArray * arrTitle = [NSMutableArray array];
    NSArray *arrList1 = @[@"互生卡正面",@"互生卡背面"];
    NSArray *arrList2 = @[@"身份证正面",@"身份证背面"];
    NSArray *arrList3 = @[@"消费者本人的社会保障卡复印件",@"原始收费收据复印件(一份)"];
    NSArray *arrList4 = @[@"费用明细清单复印件(一份)",@"门诊病历复印件(一份)"];
    NSArray *arrList5 = @[@"住院病历复印件(一份)",@"疾病诊断证明书复印件(一份)"];
    [arrTitle addObject:arrList1];
    [arrTitle addObject:arrList2];
    [arrTitle addObject:arrList3];
    [arrTitle addObject:arrList4];
    [arrTitle addObject:arrList5];
    
    self.height = 0;
    self.marrData = [NSMutableArray array];
    CGFloat height = 0;
    for (int i = 0; i<5; i++)
    {
        NSMutableArray * arrSection = [NSMutableArray array];
        for (int j = 0; j<2; j++)
        {
            GYHealthUploadImgModel * model = [[GYHealthUploadImgModel alloc] init];
            model.isNeed = YES;
            if (i == 4 && j==0) {
                model.isNeed = NO;
            }
            // 没有输入社保卡号 不用上传
            NSString * strHealtyNum = [self.dictBaseInfo objectForKey:@"healthCardNo"];
            if (!strHealtyNum || strHealtyNum.length == 0) {
                if (i == 2 && j==0) {
                    model.isNeed = NO;
                }
            }
            if (i<2)
            {
                model.isShow = YES;
            }
            else
            {
                model.isShow = NO;
            }
            model.strTitle = (arrTitle[i])[j];
            if (j==0)
            {
                height = model.mainFrame.size.height;
            }
            if (j==1)
            {
                if (height<model.mainFrame.size.height)
                {
                    height = model.mainFrame.size.height;
                }
            }
            [arrSection addObject:model];
        }
        self.height += height;
        [self.marrData addObject:arrSection];
    }
}
-(void)setViewList
{
    self.height = 0;
    CGFloat height = 0;
    CGFloat border = 30;
    self.height = border;
    for (int i = 0; i<5; i++)
    {
        for (int j = 0; j<2; j++)
        {
            GYHealthUploadImgModel * model = (self.marrData[i])[j];
            CGFloat viewX = (j==0)?0:(kScreenWidth*0.5-1);
            CGFloat viewY = self.height;
            GYHealthUploadImgView * view = [[GYHealthUploadImgView alloc] init];
            view.frame = CGRectMake(viewX, viewY, kScreenWidth*0.5, model.mainFrame.size.height);
            view.model = model;
            view.delegate = self;
            [view setShowTag:(i+1)*100+j chooseImageTag:(i+1)*10+j ];
            view.tag = ((i+1)*10+j)*100;
            [self.vList addSubview:view];
            if (j==0)
            {
                height = model.mainFrame.size.height;
            }
            if (j==1)
            {
                if (height<model.mainFrame.size.height)
                {
                    height = model.mainFrame.size.height;
                }
            }
        }
        self.height+=height;
    }
}
#pragma mark GYHealthUploadImgViewDelegate
-(void)HealthUploadImgViewShowExampleWithButton:(UIButton *)button
{
    if (button.tag == 100) {
        [self.bigPic showView:[UIImage imageNamed:@"HSCFace.jpg"]];
    }
    if (button.tag == 101) {
        [self.bigPic showView:[UIImage imageNamed:@"HSCBack.jpg"]];
    }
    if (button.tag == 200) {
        [self.bigPic showView:[UIImage imageNamed:@"IDCFace.jpg"]];
    }
    if (button.tag == 201) {
        [self.bigPic showView:[UIImage imageNamed:@"IDCBack.jpg"]];
    }
    // 后面的不要事例图片
    
}
-(void)HealthUploadImgViewChooseImgWithButton:(UIButton *)button
{
    self.index = button.tag;
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
        uploadPic.index=(int)self.index;
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
    NSString * hsPicName =kSaftToNSString([picUrlString lastPathComponent]) ;
    NSArray * arrViews = self.vList.subviews;
    GYHealthUploadImgView * huivView = nil;
    for (int i =0; i<arrViews.count; i++) {
        GYHealthUploadImgView * view = [arrViews objectAtIndex:i];
        if ([view getImgChooseTag] == index2) {
            huivView = view;
            break;
        }
    }
    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [huivView setImageWithImage:img];
    switch (index2) {
        case 10:
        {
            self.HSCardFaceImg = hsPicName;
        }
            break;
        case 11:
        {
            self.HSCardBackImg = hsPicName;
        }
            break;
        case 20:
        {
            self.IDCardFaceImg = hsPicName;
        }
            break;
            
        case 21:
        {
            self.IDCardBackImg = hsPicName;
        }
            break;
        case 30:
        {
            self.socialProtectImg = hsPicName;
        }
            break;
        case 31:
        {
            self.chargeListImg = hsPicName;
        }
            break;
        case 40:
        {
            self.feeDetailImg = hsPicName;
        }
            break;
        case 41:
        {
            self.hospitailHistoryImg = hsPicName;
        }
            break;
        case 50:
        {
            self.liveInHospitailImg = hsPicName;
        }
            break;
        case 51:
        {
            self.sicknessCheckBookImg = hsPicName;
        }
            break;
        default:
            break;
            
            
    }
    //
    
    
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
-(BOOL)isAllDataRight
{
    if (self.HSCardFaceImg.length == 0) {
        [Utils showMessgeWithTitle:@"友情提示" message:@"互生卡正面未上传" isPopVC:nil];
        return NO;
    }
    else if (self.HSCardBackImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"互生卡背面未上传" isPopVC:nil];
        return NO;
    }
    else if (self.HSCardBackImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"未上传" isPopVC:nil];
        return NO;
    }
    else if (self.IDCardFaceImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"身份证正面未上传" isPopVC:nil];
        return NO;
    }
    else if (self.IDCardBackImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"身份证背面未上传" isPopVC:nil];
        return NO;
    }
    else if (self.socialProtectImg.length == 0)
    {
        
        NSString * strHealtyNum = [self.dictBaseInfo objectForKey:@"healthCardNo"];
        if (strHealtyNum && strHealtyNum.length >0) {
            [Utils showMessgeWithTitle:@"友情提示" message:@"消费者本人的社会保障卡复印件未上传" isPopVC:nil];
            return NO;
        }
    }
    
    if (self.chargeListImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"原始收费收据复印件未上传" isPopVC:nil];
        return NO;
    }
    else if (self.feeDetailImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"费用明显清单复印件未上传" isPopVC:nil];
        return NO;
    }
    else if (self.hospitailHistoryImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"门诊病历复印件未上传" isPopVC:nil];
        return NO;
    }
    else if (self.sicknessCheckBookImg.length == 0)
    {
        [Utils showMessgeWithTitle:@"友情提示" message:@"疾病诊断证明书复印件未上传" isPopVC:nil];
        return NO;
    }
    return YES;
}
- (void)commit//
{
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    NSString * strHealtyNum = [self.dictBaseInfo objectForKey:@"healthCardNo"];
    if (!strHealtyNum || strHealtyNum.length ==0) {
        strHealtyNum = @"";
    }
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:strHealtyNum forKey:@"healthCardNo"];
    [dictInside setValue:[self.dictBaseInfo objectForKey:@"startDate"] forKey:@"startDate"];
    [dictInside setValue:[self.dictBaseInfo objectForKey:@"endDate"] forKey:@"endDate"];
    [dictInside setValue:[self.dictBaseInfo objectForKey:@"hospital"] forKey:@"hospital"];
    [dictInside setValue:[self.dictBaseInfo objectForKey:@"city"] forKey:@"city"];
    
    // 图片资料
    if (!self.socialProtectImg || self.socialProtectImg.length == 0) {
        self.socialProtectImg = @"";
    }
    [dictInside setValue:self.HSCardFaceImg forKey:@"hscFacePath"];
    [dictInside setValue:self.HSCardBackImg forKey:@"hscBackPath"];
    [dictInside setValue:self.IDCardFaceImg forKey:@"cerFacePath"];
    [dictInside setValue:self.IDCardBackImg forKey:@"cerBackPath"];
    [dictInside setValue:self.socialProtectImg forKey:@"sscPath"];
    [dictInside setValue:self.chargeListImg forKey:@"ofrPath"];
    [dictInside setValue:self.feeDetailImg forKey:@"cdlPath"];
    [dictInside setValue:self.hospitailHistoryImg forKey:@"omrPath"];
    [dictInside setValue:self.liveInHospitailImg forKey:@"imrPath"];
    [dictInside setValue:self.sicknessCheckBookImg forKey:@"ddcPath"];
    
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    //请求对应url的运行cmd
    
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"apply_free_medical" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    [Utils showMessgeWithTitle:nil message:@"提交申请成功." isPopVC:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else//返回失败数据
                {
                    NSString * strMsg = [dic objectForKey:@"message"];
                    if (strMsg && [strMsg rangeOfString:@"healthCardNo"].location != NSNotFound) {
                        strMsg = @"社保卡号未上传";
                    }
                    else
                    {
                        strMsg = @"提交申请失败.";
                    }
                    [Utils showMessgeWithTitle:nil message:strMsg isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"提交申请失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}
@end

//
//  GYEPSaleAfterApplyForOnlyReturnMoneyViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h"
#import "RTLabel.h"
#import "UIActionSheet+Blocks.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "GYImgTap.h"
#import "UIButton+enLargedRect.h"
#import "EasyPurchaseData.h"
#import "UIAlertView+Blocks.h"

@interface GYEPSaleAfterApplyForOnlyReturnMoneyViewController ()<UITextViewDelegate>
{
    IBOutlet UIScrollView *scvContainer;//滚动容器

    IBOutlet UIView *vRow1Bkg;
    IBOutlet UIView *vRow2Bkg;
    IBOutlet UIView *vRowLast;
    


    IBOutlet RTLabel *lbLabelMoney;
    IBOutlet RTLabel *lbMoneyAmount;

    IBOutlet UILabel *lbLabelInputTip;
    IBOutlet UITextView *tvInputContent;
    
    IBOutlet UIImageView *ivUploadPicture;
    IBOutlet UIButton *btnUploadPicture;
    IBOutlet UIButton *btnApplyFor;
    double total;//提交的总金额
    
    int index2;
    
    NSString * urlString;
    UIImageView *ivup;
    NSMutableArray *imageArr;
    
}
@property (assign,nonatomic)BOOL uploadedImgFlag;
@end

@implementation GYEPSaleAfterApplyForOnlyReturnMoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArr = [NSMutableArray array];
    urlString = @"";
    _uploadedImgFlag = NO;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setBackgroundColor:kClearColor];
    ivUploadPicture.userInteractionEnabled=YES;
//    
//    [lbStringSelected setTextColor:kCellItemTitleColor];
//    lbStringSelected.text = kLocalized(@"请选择是否收到货");
    NSString *str = [NSString stringWithFormat:@"<font size=13 color=red>* </font><font size=13 color='#8C8C8C'>%@</font>", kLocalized(@"是否收到货")];
//    lbLabelSelector.text = str;
//    [lbLabelSelector setTextAlignment:RTTextAlignmentCenter];

    str = [NSString stringWithFormat:@"<font size=13 color=red>* </font><font size=13 color='#8C8C8C'>%@</font>", kLocalized(@"退款金额")];
    lbLabelMoney.text = str;
    
//    str = [NSString stringWithFormat:@"<font size=13 color=red>%@</font>", [Utils formatCurrencyStyle:kSaftToCGFloat(self.dicDataSource[@"total"])]];
//    lbMoneyAmount.text = str;
    
    total = kSaftToCGFloat(self.dicDataSource[@"total"])//总额-运费
    - kSaftToCGFloat(self.dicDataSource[@"postAge"]);
//    - kSaftToCGFloat(self.dicDataSource[@"activityAmount"]);
    total = total >= 0 ? total : 0;
    str = [NSString stringWithFormat:@"<font size=13 color=red>%@</font>", [Utils formatCurrencyStyle:total]];
    lbMoneyAmount.text = str;

//    [btnSelector addTarget:self action:@selector(btnSelectPayMethodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [lbLabelInputTip setTextColor:kCellItemTextColor];
    lbLabelInputTip.text = kLocalized(@"退款说明 最多输入200字");
    
    ////新增一个 ScrollView 放上传图片
    CGFloat with;
    UIScrollView *scroll= [[UIScrollView alloc]init];
     CGFloat newwith=89;
    //////这里放循环5个图片
    for (int i=0; i<5; i++) {
        ivup=[[UIImageView alloc]initWithImage:kLoadPng(@"ep_img_upload_flag")];
        ivup.frame= CGRectMake(15+(newwith*i), 0, newwith, newwith);
        ivup.userInteractionEnabled=YES;
        ivup.tag=100+i;
        [imageArr addObject:ivup];
        [scroll addSubview:ivup]; 
        [ self addGestureToImgView:i ];/////给图片添加一个手势。
    }
    with=newwith*5+30;
    scroll.frame= CGRectMake(0, vRow2Bkg.bounds.size.height+vRow2Bkg.frame.origin.y+5, self.view.bounds.size.width, newwith);
    scroll.contentSize=CGSizeMake(with, newwith);
    scroll.showsHorizontalScrollIndicator=YES;
    scroll.showsVerticalScrollIndicator=NO;

    [ scvContainer addSubview:scroll ]; 
    [btnUploadPicture setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
//    [vRow0Bkg addAllBorder];
    [vRow1Bkg addAllBorder];
    [vRow2Bkg addAllBorder];
    [vRowLast addAllBorder];
    
    [btnApplyFor setBackgroundColor:kClearColor];
    [btnApplyFor setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnApplyFor setBorderWithWidth:1.0 andRadius:2.0 andColor:kNavigationBarColor];
    [btnApplyFor setTitle:kLocalized(@"提交申请") forState:UIControlStateNormal];
    
    //添加点击隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];
    
    //滚动容器的滚动范围
    [scvContainer setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(btnUploadPicture.frame) + 50)];
    
  
    DDLogInfo(@"dicDataSource:%@", self.dicDataSource);
    
    tvInputContent.delegate = self;

}

-(void)loadDataFromNetwork
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": kSaftToNSString(self.dicDataSource[@"id"]),
//                               @"orderDetailIds":orderDetailsIDs,
                               @"reasonDesc":tvInputContent.text,
                               @"refundType":@"2",//1 退货，2 仅退款， 3换货
                               @"price":[@(total) stringValue],// kSaftToNSString(self.dicDataSource[@"total"]),
                               @"points":kSaftToNSString(self.dicDataSource[@"totalPv"]),
                               @"picUrls":urlString
                               };
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    [Network HttpPostRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/refundOrSwapItem"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    [Utils showMessgeWithTitle:nil message:@"提交成功." isPopVC:self.navigationController];
                    
                }else if (kSaftToNSInteger(dic[@"retCode"]) == 504)//重复提交
                {
                    [Utils showMessgeWithTitle:nil message:@"请不要重复提交申请." isPopVC:nil];
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
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

-(void)addGestureToImgView:(int)i
{
    
    GYImgTap * tapForPic =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForPic.numberOfTapsRequired=1;///判断是几个手指触屏
    tapForPic.tag=100+i;
    NSLog(@"123456123456");
    [ivup addGestureRecognizer:tapForPic];
}

-(void)popActionSheet:(GYImgTap *)tap;
{
    index2=tap.tag;
    UIActionSheet *PicChooseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"take_photos"),kLocalized(@"my_ablum"), nil];
    PicChooseSheet.destructiveButtonIndex=2;
    PicChooseSheet.delegate=self;
    [PicChooseSheet showInView:self.tabBarController.view.window];
}

- (void)btnSelectPayMethodClick:(id)sender
{
    NSArray *arr = @[@"是", @"否"];
    [UIActionSheet presentOnView:self.view withTitle:@"是否收到货" otherButtons:arr onCancel:^(UIActionSheet *sheet) {
        
    } onClickedButton:^(UIActionSheet *sheet, NSUInteger index) {
        
//        lbStringSelected.text = arr[index];
    }];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)btnSubmitApply:(id)sender {
    
    if (tvInputContent.text.length < 1&&!_uploadedImgFlag) {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入退款说明并上传凭证." isPopVC:nil];
        return;
    }
    else if (tvInputContent.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入退款说明." isPopVC:nil];
        return;
    }
    else if (!_uploadedImgFlag)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请上传凭证." isPopVC:nil];
        return;
    }
    
//    if (!urlString || urlString.length < 1)//非必要
//    {
//        [Utils showMessgeWithTitle:@"提示" message:@"请上传凭证." isPopVC:nil];
//        return;
//    }
    
   [self  loadDataFromNetwork ];
    
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
    ivup=imageArr[index2-100];////里面存放的是循环放进去的imagview
    
    //  ivCertificateFront.image=image;
//    switch (index2) {////以前只有一个
//        case 100:
//        {
            [self saveImage:image withName:@"imgRefundReturnMoney.png"];
            //上传图片获取URL 
            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
            uploadPic.urlType = 3;
            [uploadPic uploadImg:image WithParam:nil];
            uploadPic.delegate=self; 
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgRefundReturnMoney.png"];
            NSLog(@"%@",fullPath);
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            ivup.image = savedImage;
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
    _uploadedImgFlag = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _commentSting = textView.text;
}


#pragma mark 上传图片代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{
//    urlString = [NSString stringWithFormat:@"%@",url];
    urlString=[NSString stringWithFormat:@"%@,%@",[url absoluteString],urlString!=nil?urlString:@""];////上传多张图片地址
//    urlString =[url absoluteString];
//    urlString = [urlString lastPathComponent];
    DDLogInfo(@"上传的图片url:%@", urlString);
}

#pragma mark 上传图片失败
-(void)didFailUploadImg : (NSError *)error withTag:(int)index
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    urlString = @"";
    [ivup setImage:kLoadPng(@"ep_img_upload_flag")];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    unsigned long len = textView.text.length + text.length;
    if(len > 200) return NO;
    return YES;
}

@end

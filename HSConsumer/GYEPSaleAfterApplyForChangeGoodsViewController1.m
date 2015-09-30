//
//  GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEPSaleAfterApplyForChangeGoodsViewController1.h"
#import "RTLabel.h"
#import "UIActionSheet+Blocks.h"
#import "UIView+CustomBorder.h"
#import "CellForReturnGoodsCell.h"
#import "GYImgTap.h"
#import "UIButton+enLargedRect.h"
#import "UIImageView+WebCache.h"
#import "EasyPurchaseData.h"

@interface GYEPSaleAfterApplyForChangeGoodsViewController1 ()<UITableViewDataSource, UITableViewDelegate, CellForReturnGoodsCellDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scvContainer;//滚动容器
    IBOutlet UIView *vRow2Bkg;
    IBOutlet UIView *vRowLast;
    
    IBOutlet UILabel *lbLabelInputTip;
    IBOutlet UITextView *tvInputContent;
    
    IBOutlet UIImageView *ivUploadPicture;
    IBOutlet UIButton *btnUploadPicture;
    IBOutlet UIButton *btnApplyFor;
    int index2;
    
    NSString *uploadPicReturnURL;
    NSString *strReturnAmount;
    NSString *strReturnPvAmount;
    NSString *orderDetailsIDs;
    NSString * urlString;
    UIImageView *ivup;
    NSMutableArray *imageArr;
     
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
}
@property (assign, nonatomic)BOOL isUploadedImgFlag;
@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GYEPSaleAfterApplyForChangeGoodsViewController1

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
    _isUploadedImgFlag = NO;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setBackgroundColor:kClearColor];
    ivUploadPicture.userInteractionEnabled=YES;
    NSString *str = [NSString stringWithFormat:@"<font size=13 color=red>* </font><font size=13 color='#8C8C8C'>%@</font>", kLocalized(@"是否收到货")];

    str = [NSString stringWithFormat:@"<font size=13 color=red>* </font><font size=13 color='#8C8C8C'>%@</font>", kLocalized(@"换货金额")];
    
    [lbLabelInputTip setTextColor:kCellItemTextColor];
    lbLabelInputTip.text = kLocalized(@"换货说明 最多输入200字");
    
//    [ivUploadPicture setBackgroundColor:[UIColor grayColor]];
    [ivUploadPicture setImage:kLoadPng(@"ep_img_upload_flag")];
    
    
    [btnUploadPicture setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
    [vRow2Bkg addAllBorder];
    [vRowLast addAllBorder];
    
    //过滤可以提交申请的商品
    self.arrDataSource = [NSMutableArray array];
    NSArray *arrItems = self.dicDataSource[@"items"];
    for (NSDictionary *dic in arrItems)
    {
        if (kSaftToNSInteger(dic[@"refundStatus"]) == -1 || kSaftToNSInteger(dic[@"refundStatus"]) == -2)
        {
            [self.arrDataSource addObject:dic];
        }
    }
//    self.arrDataSource = self.dicDataSource[@"items"];// [NSMutableArray arrayWithObjects:@"", @"", nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(vRow2Bkg.frame.origin.x,
                                                                  kDefaultMarginToBounds,
                                                                  vRow2Bkg.frame.size.width,
                                                                   [CellForReturnGoodsCell getHeight] * self.arrDataSource.count - 1) style:UITableViewStylePlain];
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setScrollEnabled:NO];
    [self.tableView addAllBorder];
    
    //添加边框
    [self.tableView addAllBorder];
    //显示下，右边框
    [self.tableView setBottomBorderInset:YES];
    [self.tableView setRightBorderInset:YES];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForReturnGoodsCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForReturnGoodsCellIdentifier];
    //移动位置＝＝＝＝＝＝＝＝＝
    CGFloat moveY = self.tableView.frame.size.height + kDefaultMarginToBounds;
    
    [vRow2Bkg moveX:0 moveY:moveY];
    [lbLabelInputTip moveX:0 moveY:moveY];
//    [ivUploadPicture moveX:0 moveY:moveY];
    [btnUploadPicture moveX:0 moveY:moveY];
    //＝＝＝＝＝＝＝＝＝
    [scvContainer addSubview:self.tableView];

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
    uploadPicReturnURL = @"";
//    [self   addGestureToImgView];
    
    if (self.arrDataSource.count < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"该订单没有可以进行换货的商品.") isPopVC:self.navigationController];
    }
    
//    activityIndicatorView.center = ivUploadPicture.center;
//    activityIndicatorView.hidesWhenStopped = YES;
//    [activityIndicatorView stopAnimating];
//    activityIndicatorView.hidden = YES;

    tvInputContent.delegate = self;
    ////新增一个 ScrollView 放上传图片
    CGFloat with;
    CGFloat newwith=89;
    UIScrollView *scroll= [[UIScrollView alloc]init];
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
    scroll.frame= CGRectMake(0, vRow2Bkg.frame.size.height+vRow2Bkg.frame.origin.y+5, self.view.bounds.size.width, newwith);
    scroll.contentSize=CGSizeMake(with, newwith);
    scroll.showsHorizontalScrollIndicator=YES;
    scroll.showsVerticalScrollIndicator=NO;
    [ scvContainer addSubview:scroll ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = kCellForReturnGoodsCellIdentifier;
    CellForReturnGoodsCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell)
    {
        cell = [[CellForReturnGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    NSInteger row = indexPath.row;
    NSString *imgUrl = self.arrDataSource[row][@"url"];
    [cell.ivGoodsPicture sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    cell.lbGoodsName.text = self.arrDataSource[row][@"title"];
    cell.lbGoodsPrice.text = [Utils formatCurrencyStyle:[self.arrDataSource[row][@"subTotal"] doubleValue]];
//    cell.lbGoodsCnt.text = [NSString stringWithFormat:@"x %@", self.arrDataSource[row][@"count"]];
//    cell.lbGoodsProperty.text = kSaftToNSString(self.arrDataSource[row][@"desc"]);
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CellForReturnGoodsCell getHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellForReturnGoodsCell *cell = (CellForReturnGoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.btnSelect sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)addGestureToImgView:(int)i
{
    GYImgTap * tapForPic =[[GYImgTap alloc]initWithTarget:self action:@selector(popActionSheet:)];
    tapForPic.numberOfTapsRequired=1;
    tapForPic.tag=100+i;
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
-(void)photoalbumr
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [Utils showMessgeWithTitle:nil message:@"访问相册失败." isPopVC:nil];
    }
}

//进入拍照
-(void)photocamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
    }else
    {
        [Utils showMessgeWithTitle:nil message:@"设备不支持拍照功能." isPopVC:nil];
    }
}

//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//Pickerviewcontroller的代理方法。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ivup=imageArr[index2-100];////里面存放的是循环放进去的imagview
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
////以前的老版本
    //  ivCertificateFront.image=image;
//    switch (index2)
//    {
//        case 100:
//        {
//            [self saveImage:image withName:@"imgRefundWithGood.png"];
//            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgRefundWithGood.png"];
//            
//            //上传图片获取URL
//            GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
//            uploadPic.urlType = 3;
//            [uploadPic uploadImg:image WithParam:nil];
//            uploadPic.delegate=self;
//            NSLog(@"%@",fullPath);
//            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//            ivUploadPicture.image = savedImage;
//            
////            activityIndicatorView.hidden = NO;
//            [activityIndicatorView startAnimating];
//            
//        }
//            break;
//        default:
//            break;
//    }
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
    _isUploadedImgFlag = YES;
}

#pragma mark 上传图片代理方法。
-(void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{
//    uploadPicReturnURL = [url absoluteString];
////    uploadPicReturnURL = [uploadPicReturnURL lastPathComponent];
//
//    [activityIndicatorView stopAnimating];
////    activityIndicatorView.hidden = YES;
    urlString=[NSString stringWithFormat:@"%@,%@",[url absoluteString],urlString!=nil?urlString:@""];////上传多张图片地址
    DDLogInfo(@"上传的图片url:%@", urlString);

}

#pragma mark 上传图片失败
-(void)didFailUploadImg : (NSError *)error withTag:(int)index
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    uploadPicReturnURL = @"";
//    [ivUploadPicture setImage:kLoadPng(@"ep_img_upload_flag")];
    [ivup setImage:kLoadPng(@"ep_img_upload_flag")];
    [activityIndicatorView stopAnimating];
}

#pragma mark - 提交申请
- (IBAction)btnApplyForClick:(id)sender
{
    if (!orderDetailsIDs || orderDetailsIDs.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请选择商品." isPopVC:nil];
        return;
    }
    if (tvInputContent.text.length < 1 && !_isUploadedImgFlag) {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入换货说明并上传凭证." isPopVC:nil];
        return;
    }
    else if (tvInputContent.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入换货说明." isPopVC:nil];
        return;
    }
    else if (!_isUploadedImgFlag) {
        [Utils showMessgeWithTitle:@"提示" message:@"请上传凭证." isPopVC:nil];
        return;
    }
//    if (!uploadPicReturnURL || uploadPicReturnURL.length < 1)//非必要
//    {
//        [Utils showMessgeWithTitle:@"提示" message:@"请上传凭证." isPopVC:nil];
//        return;
//    }
    
    [self applyFor];
    
}

#pragma mark - CellForReturnGoodsCellDelegate
- (void)selectChange:(id)sender
{
    [self updateAmountAndItemIdsBySelect];
}

- (void)updateAmountAndItemIdsBySelect
{
    CGFloat totalAmount = 0;
    CGFloat totalAmountPv = 0;
    NSMutableArray *arrIDs = [NSMutableArray array];
    CellForReturnGoodsCell *cell = nil;
    for (int i = 0; i < self.arrDataSource.count; i++)
    {
        cell = (CellForReturnGoodsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.selected)
        {
            totalAmount += kSaftToCGFloat(self.arrDataSource[i][@"price"]);
            totalAmountPv += kSaftToCGFloat(self.arrDataSource[i][@"pv"]);

            [arrIDs addObject:kSaftToNSString(self.arrDataSource[i][@"orderDetailId"])];
        }
    }
    if (arrIDs.count > 0)
    {
        orderDetailsIDs = [arrIDs componentsJoinedByString:@","];
    }else
    {
        orderDetailsIDs = @"";
    }
    strReturnPvAmount = [@(totalAmountPv) stringValue];
    strReturnAmount = [@(totalAmount) stringValue];
}

- (void)applyFor
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": kSaftToNSString(self.dicDataSource[@"id"]),
                               @"orderDetailIds":orderDetailsIDs,
                               @"reasonDesc":tvInputContent.text,
                               @"refundType":@"3",//1 退货，2 仅退款， 3换货 传金额 积分为0
                               @"price":@"0.00",
                               @"points":@"0.00",
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    unsigned long len = textView.text.length + text.length;
    if(len > 200) return NO;
    return YES;
}

@end

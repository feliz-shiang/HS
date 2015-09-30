//
//  GYRealNameAuthViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYRealNameAuthViewController.h"
#import "InputCellStypeView.h"

#import "GYRealNameAuthConfirmViewController.h"

//修改重要信息变更

//护照上传图片的页面
#import "GYTwoPictureViewController.h"
//身份证上传图片
#import "GYRealNameAuthConfirmViewController.h"

#import "FMDatabase.h"
#import "GYChooseAreaModel.h"
#import "UIActionSheet+Blocks.h"
#import "UIButton+enLargedRect.h"
#import "GYDatePiker.h"
@interface GYRealNameAuthViewController ()<GYDatePikerDelegate>

@end

@implementation GYRealNameAuthViewController
{
    
    __weak IBOutlet UIScrollView *scrMain;//背景滚动试图
    
    __weak IBOutlet InputCellStypeView *InputRealNameRow;//输入真实姓名
    
    __weak IBOutlet InputCellStypeView *InputSexRow;//输入性别
    
    __weak IBOutlet InputCellStypeView *InputNationaltyRow;//输入国籍
    
    __weak IBOutlet InputCellStypeView *InputCertificationType;//输入证件类型
    
    __weak IBOutlet InputCellStypeView *InputCerNumberRow;//输入证件号码
    
    __weak IBOutlet InputCellStypeView *InputCerDurationRow;//输入证件有效时间
    
    __weak IBOutlet UIView *vBackgroundDown;//下面的背景view
    
    __weak IBOutlet UILabel *lbPlaceHolder;//占位符
    
    __weak IBOutlet UILabel *lbTitle;//下面的标题
    
    
    __weak IBOutlet InputCellStypeView *InputRegAddressRow;//输入户籍地址
    
    __weak IBOutlet UITextView *tfInputRegAddress;
    
    __weak IBOutlet UILabel *lbRegAddressPlaceholder;
    
    __weak IBOutlet UITextView *tvInputText;
    
    __weak IBOutlet InputCellStypeView *InputJob;
    
    __weak IBOutlet InputCellStypeView *InputPaperOrganization;
    
     FMDatabase * dataBase;
    
    __weak IBOutlet UIButton *btnChangeSex;
    
    NSString * strCountry;
    
    NSString * strCountrydisplay;
    
    NSString * sexString;
    
    __weak IBOutlet UIButton *btnValidPeriod;
    
    BOOL islongPeriod;
    
    NSMutableDictionary * dictInside;
    
    GYDatePiker * datePiker;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=@"实名认证";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    islongPeriod=YES;
     dictInside =[[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(confirm)];

    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    
    [ self moveToDBFile ];
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }
    
    
    [self modifyName];
}

-(void)confirm
{
    
    UIViewController * vc;
    
    if(InputRealNameRow.tfRightTextField.text.length<2||InputRealNameRow.tfRightTextField.text.length>20){
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"姓名不能少于2个或大于20个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }  
   else if ([Utils isBlankString:InputSexRow.tfRightTextField.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入性别！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if ([Utils isBlankString:InputJob.tfRightTextField.text])
    {
        
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入职业！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    
    }
   else  if(InputJob.tfRightTextField.text.length<2||InputJob.tfRightTextField.text.length>20){
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"职业名称不能小于2个或大于20个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
//    else if ([Utils isBlankString:InputCerDurationRow.tfRightTextField.text])
//    {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }
//    else if ([Utils isBlankString:InputCerDurationRow.tfRightTextField.text])
//    {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }
    else if ([Utils isBlankString:InputPaperOrganization.tfRightTextField.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入发证机关！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if (InputPaperOrganization.tfRightTextField.text.length<2||InputPaperOrganization.tfRightTextField.text.length>20)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"发证机关名称不能小于2个或大于20个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
//    else if ([Utils isBlankString:InputPaperOrganization.tfRightTextField.text])
//    {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入发证机关！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }
    else if ([Utils isBlankString:tfInputRegAddress.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入户籍地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    } else if (tfInputRegAddress.text.length<2||tfInputRegAddress.text.length>128)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"户籍地址不能小于2个或大于128字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    // 附言可以不填
//    else if ([Utils isBlankString:tvInputText.text])
//    {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入认证附言" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }
    
   
    if (islongPeriod) {
         [dictInside setValue:InputCerDurationRow.tfRightTextField.text forKey:@"valid_date"];
        
        NSString *str = InputCerDurationRow.tfRightTextField.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:str];
        NSDate *currentDate = [NSDate date];
        NSDate *earlierDate = [date earlierDate:currentDate];
        
        if ([Utils isBlankString:str])
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    return;
                    
                }
        if (earlierDate==date) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return;
        }

    }

    [dictInside setValue:[GlobalData shareInstance].user.userName forKey:@"name"];
    [dictInside setValue:strCountry forKey:@"country"];
    [dictInside setValue:[GlobalData shareInstance].personInfo.creNo forKey:@"credentials_no"];
    [dictInside setValue:[GlobalData shareInstance].personInfo.creType forKey:@"cerType"];
    
    [dictInside setValue:sexString forKey:@"sex"];
    
    [dictInside setValue:tvInputText.text forKey:@"postscript"];
   
    [dictInside setValue:tfInputRegAddress.text forKey:@"birthAddress"];
    
    [dictInside setValue:InputJob.tfRightTextField.text forKey:@"profession"];
    [dictInside setValue:InputPaperOrganization.tfRightTextField.text forKey:@"licenceIssuing"];
    NSLog(@"-----------%@",[GlobalData shareInstance].personInfo.creType);
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"])
    {
        InputCertificationType.tfRightTextField.text=@"身份证";
        GYRealNameAuthConfirmViewController * vcAuthConfirm =[[GYRealNameAuthConfirmViewController alloc]initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
        vcAuthConfirm.dictInside=dictInside;
        vcAuthConfirm.title=@"实名认证";
        vcAuthConfirm.useType=useForAuth;
        vc=vcAuthConfirm;
        
        
    }
//    else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
//    {
//        GYTwoPictureViewController * vcPicture =[[GYTwoPictureViewController alloc]initWithNibName:@"GYTwoPictureViewController" bundle:nil];
//        vcPicture.mdictParams=dictInside;
//              vcPicture.title=@"实名认证";
//        vcPicture.useType=useForAuth;
//        
//        vc=vcPicture;
//        
//    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
//    {
//        GYTwoPictureViewController * vcPicture =[[GYTwoPictureViewController alloc]initWithNibName:@"GYTwoPictureViewController" bundle:nil];
//        vcPicture.mdictParams=dictInside;
//        vcPicture.useType=useForAuth;
//        vcPicture.title=@"实名认证";
//        vc=vcPicture;
//    }
    else
    {  GYTwoPictureViewController * vcPicture =[[GYTwoPictureViewController alloc]initWithNibName:@"GYTwoPictureViewController" bundle:nil];
        vcPicture.mdictParams=dictInside;
        vcPicture.title=@"实名认证";
        vcPicture.useType=useForAuth;
        
        vc=vcPicture;}
    
   
    [self.navigationController pushViewController:vc animated:YES];
    
}

//设置滚动区域
-(void)viewDidAppear:(BOOL)animated
{
    [scrMain setContentSize:CGSizeMake(320, 650)];
    
}

-(void)moveToDBFile
{
    //1、获得数据库文件在工程中的路径——源路径。
    NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"T_PUB_AREA"ofType:@"db"];

    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    //3、通过NSFileManager类，将工程中的数据库文件复制到沙盒中。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath])
    {
        NSError *error ;
        
        if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
            NSLog(@"数据库移动成功");
        }
        else {
            NSLog(@"数据库移动失败");
        }
        
    }
    
}


-(void)modifyName
{
    
    [btnChangeSex setEnlargEdgeWithTop:5 right:20 bottom:5 left:100];
    InputRealNameRow.lbLeftlabel.text=@"姓名";
    InputRealNameRow.tfRightTextField.text=[NSString stringWithFormat:@"%@ **",[[GlobalData shareInstance].user.userName substringToIndex:1]];
    InputSexRow.lbLeftlabel.text=@"性别";
    InputSexRow.tfRightTextField.enabled=NO;
    
    sexString = @"1";
    if ([[GlobalData shareInstance].personInfo.sex isEqualToString:@"1"]) {
        InputSexRow.tfRightTextField.text=@"男";
    }else if ([[GlobalData shareInstance].personInfo.sex isEqualToString:@"0"]){
        InputSexRow.tfRightTextField.text=@"女";
        sexString = @"0";
    }
    
    InputNationaltyRow.lbLeftlabel.text=@"国籍";
    InputNationaltyRow.tfRightTextField.text=[self selectFromDB].areaName;
    strCountry=[self selectFromDB].areaNo;
   
    InputCertificationType.lbLeftlabel.text=@"证件类型";

    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"])
    {
       InputCertificationType.tfRightTextField.text=@"身份证";
    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
       InputCertificationType.tfRightTextField.text=@"护照";
    }else if ([ [GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
       InputCertificationType.tfRightTextField.text=@"营业执照";
    }
    else
    { }
    
    InputCerNumberRow.lbLeftlabel.text=@"证件号码";
    InputCerDurationRow.lbLeftlabel.text=@"证件有效期";
    InputRegAddressRow.lbLeftlabel.text=@"户籍地址";
    InputPaperOrganization.lbLeftlabel.text=@"发证机关";
    InputJob.lbLeftlabel.text=@"职业";
    
    [btnValidPeriod setImage:[UIImage imageNamed:@"long_period_nomal.png"] forState:UIControlStateNormal];
    [btnValidPeriod setImage:[UIImage imageNamed:@"long_period_selected"] forState:UIControlStateSelected];
    [btnValidPeriod setTitle:@"长期" forState:UIControlStateNormal];
  
    [btnValidPeriod setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
   
    
    btnValidPeriod.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 35);
    btnValidPeriod.titleEdgeInsets=UIEdgeInsetsMake(5,-15, 5,3);
    

    NSRange r = {[GlobalData shareInstance].personInfo.creNo.length-4 ,4};

    if ([GlobalData shareInstance].personInfo.creNo.length>0) {
         InputCerNumberRow.tfRightTextField.text=[NSString stringWithFormat:@"%@ **** %@",[[GlobalData shareInstance].personInfo.creNo  substringToIndex:4],[[GlobalData shareInstance].personInfo.creNo substringWithRange:r]];
    }
    
 
    //未认证的，进来是输入信息
    // U表示未认证
    if ([[GlobalData shareInstance].personInfo.regStatus isEqualToString:@"N"]) {
        InputCerDurationRow.tfRightTextField.placeholder=@"输入有效期";
        InputPaperOrganization.tfRightTextField.placeholder=@"输入发证机关";
        InputJob.tfRightTextField.placeholder=@"输入职业";
        lbRegAddressPlaceholder.text=@"输入户籍地址";

    }else//经过认证之后，性别职业发证机关等都有信息，可以复制
    {
      
        
        
        //未认证
        if ([[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"U"]) {
            
            InputCerDurationRow.tfRightTextField.placeholder=@"输入有效期";
            InputPaperOrganization.tfRightTextField.placeholder=@"输入发证机关";
            InputJob.tfRightTextField.placeholder=@"输入职业";
            lbRegAddressPlaceholder.text=@"输入户籍地址";
            InputSexRow.tfRightTextField.placeholder=@"选择性别";
    
        }else
        {
            
            InputCerDurationRow.tfRightTextField.text=[GlobalData shareInstance].personInfo.creExpiryDate;
            tfInputRegAddress.text=[GlobalData shareInstance].personInfo.birthAddress;
            InputPaperOrganization.tfRightTextField.text=[GlobalData shareInstance].personInfo.creVerifyOrg;
            InputJob.tfRightTextField.text=[GlobalData shareInstance].personInfo.profession;

            if ([GlobalData shareInstance].personInfo.birthAddress.length>0) {
                tfInputRegAddress.text=[GlobalData shareInstance].personInfo.birthAddress;
            }else
            {
                lbRegAddressPlaceholder.text=@"输入户籍地址";
            }
        
        }
        
      
    }
    

    lbRegAddressPlaceholder.textColor=kCellItemTextColor;
    tfInputRegAddress.textColor=kCellItemTitleColor;
    lbTitle.text=@"认证附言";
    lbTitle.textColor=kCellItemTitleColor;
    lbPlaceHolder.text=@"请输入留言";
    lbPlaceHolder.textColor=kCellItemTextColor;
    tvInputText.backgroundColor=kDefaultVCBackgroundColor;
    tvInputText.textColor=kCellItemTitleColor;
    
}


-(GYChooseAreaModel *)selectFromDB
{
    GYChooseAreaModel * model;
    
    FMResultSet * set = [dataBase executeQuery:@"select * from T_PUB_AREA"];
    while ([set next]) {
        
        GYChooseAreaModel * m = [[GYChooseAreaModel alloc] init];
        
        m.areaId = [NSString stringWithFormat:@"%d",[set intForColumn:@"area_id"]];
        
        m.parentIdstring = [NSString stringWithFormat:@"%@",[set stringForColumn:@"parent_id"]];
        m.hiberarchy = [NSString stringWithFormat:@"%@",[set stringForColumn:@"hiberarchy"]];
        m.areaName = [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_name"]];
        m.fullName = [NSString stringWithFormat:@"%@",[set stringForColumn:@"full_name"]];
        m.isbnCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"isbn_code"]];
        m.code = [NSString stringWithFormat:@"%@",[set stringForColumn:@"code"]];
        m.areaNo= [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_no"]];
        m.areaCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_code"]];
        m.phonePrefix = [NSString stringWithFormat:@"%@",[set stringForColumn:@"phone_prefix"]];
        m.langCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"lang_code"]];
        m.dateFmtCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"date_fmt_code"]];
        m.treeLevel = [NSString stringWithFormat:@"%@",[set stringForColumn:@"tree_level"]];
        m.currencyId = [NSString stringWithFormat:@"%@",[set stringForColumn:@"currency_id"]];
        m.populations = [NSString stringWithFormat:@"%@",[set stringForColumn:@"populations"]];
        m.isParent = [NSString stringWithFormat:@"%@",[set stringForColumn:@"is_parent"]];
        m.internationalCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"international_code"]];
        m.zoneNo= [NSString stringWithFormat:@"%@",[set stringForColumn:@"zone_no"]];
        
        if ([m.areaNo isEqualToString:[GlobalData shareInstance].personInfo.country]) {
            
            model=m;
        }
        
        
    }
    return model;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==15) {

        if (!datePiker) {
            datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) WithType:0];
            datePiker.delegate = self;
            [datePiker noMaxTime];
        
            [self.view addSubview:datePiker];
            datePiker = nil;
        }
        return NO;
    }
    
    return YES;
}

#pragma mark  datepiker 代理方法
-(void)getDate:(NSString *)date WithDate:(NSDate *)date1
{

    InputCerDurationRow.tfRightTextField.text=date;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 10:
        {
            _strRealName=textField.text;
            
        }
            break;
        case 11:
        {
            _strSex=textField.text;
            
        }
            break;
        case 12:
        {
            _strNationality=textField.text;
            
        }
            break;
            
        case 13:
        {
            _strCerType=textField.text;
            
        }
            break;
        case 14:
        {
            _strCerNumber=textField.text;
            
        }
            break;
            
        case 15:
        {
            _strCerduration=textField.text;
            
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark textview delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    lbPlaceHolder.text=@"";
    if (textView.tag==17) {
        _strRegAddress=textView.text;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.tag==20) {
        lbPlaceHolder.text=@"";
    }else {
        lbRegAddressPlaceholder.text=@"";
        
    }
    
}

- (IBAction)btnChangeSexAction:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSArray  * arrSex= @[@"女",@"男"];
    
    [UIActionSheet presentOnView:self.view withTitle:@"请选择性别" otherButtons:arrSex onCancel:^(UIActionSheet *sheet) {
        
    } onClickedButton:^(UIActionSheet *sheet, NSUInteger index) {
        InputSexRow.tfRightTextField.text = arrSex[index];

        switch (index) {
            case 0:
            {
              sexString=@"0";
            }
                break;
            case 1:
            {
              sexString=@"1";
            }
                break;
            default:
                break;
        }

    }];
    
    
}
- (IBAction)btnSetValidPeriod:(id)sender {
    
    UIButton * ValidPeriod = sender;
   
    if (islongPeriod) {
        islongPeriod=!islongPeriod;
        ValidPeriod.selected=YES;
        InputCerDurationRow.tfRightTextField.enabled=NO;
        InputCerDurationRow.tfRightTextField.placeholder=@"";
         InputCerDurationRow.tfRightTextField.text=@"";
        [dictInside setValue:@"long_term" forKey:@"valid_date"];
        
        
    }else
    {
        islongPeriod=!islongPeriod;
        InputCerDurationRow.tfRightTextField.enabled=YES;
         InputCerDurationRow.tfRightTextField.placeholder=@"输入有效期";
        ValidPeriod.selected=NO;
    }
}


@end

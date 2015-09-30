//
//  GYRealNameAuthViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
#import "UIButton+enLargedRect.h"
#import "Utils.h"
#import "GYImportantChangeViewController.h"
#import "InputCellStypeView.h"
//选择国家
#import "GYCountrySelectionViewController.h"
//选择三张图片
#import "GYRealNameAuthConfirmViewController.h"

//修改重要信息变更
//#import "GYImportantChangeConfirmViewController.h"
#import "GlobalData.h"
#import "GYChooseAreaModel.h"


#import "FMDatabase.h"
//两个图片的上传
#import "GYTwoPictureViewController.h"
#import "GYDatePiker.h"
#import "CustomIOS7AlertView.h"
#import "UIActionSheet+Blocks.h"
@interface GYImportantChangeViewController ()<GYDatePikerDelegate,UITextFieldDelegate>

@end

@implementation GYImportantChangeViewController
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
    
    __weak IBOutlet InputCellStypeView *InputJob;//职业
    
    __weak IBOutlet InputCellStypeView *InputPaperOrganization;//发证机关
    
    NSMutableDictionary * dictInside;
    
    FMDatabase * dataBase;
    
    GYDatePiker * datePiker;
    
    __weak IBOutlet UIButton *btnChangeCountry;
    
    NSString * sexString;
    
    NSString * countryString;
    
    __weak IBOutlet UIButton *btnLongPeriod;
    
    BOOL islongPeriod;
    
    NSMutableDictionary * dicParams;
    
    BOOL isSelect;
    
    __weak IBOutlet UIButton *sexbutton;
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
    
    islongPeriod=YES;
    
    [sexbutton setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    [btnChangeCountry setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    dicParams =[[NSMutableDictionary alloc]init];
    
    InputCertificationType.tfRightTextField.enabled=NO;
    
    //1、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    //2、移动数据库到沙盒
    [ self moveToDBFile ];
    
    //3、打开数据库
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }
    
    [self modifyName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(confirm)];
    
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
//__weak IBOutlet InputCellStypeView *InputRealNameRow;//输入真实姓名
//
//__weak IBOutlet InputCellStypeView *InputSexRow;//输入性别
//
//__weak IBOutlet InputCellStypeView *InputNationaltyRow;//输入国籍
//
//__weak IBOutlet InputCellStypeView *InputCertificationType;//输入证件类型
//
//__weak IBOutlet InputCellStypeView *InputCerNumberRow;//输入证件号码
//
//__weak IBOutlet InputCellStypeView *InputCerDurationRow;//输入证件有效时间
//
//__weak IBOutlet UIView *vBackgroundDown;//下面的背景view
//
//__weak IBOutlet UILabel *lbPlaceHolder;//占位符
//
//__weak IBOutlet UILabel *lbTitle;//下面的标题
//
//
//__weak IBOutlet InputCellStypeView *InputRegAddressRow;//输入户籍地址
//
//__weak IBOutlet UITextView *tfInputRegAddress;
-(void)alerViewByString:(NSString*)string
{
    UIAlertView *at=[[UIAlertView alloc]initWithTitle:@"提示：" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [at show];
    return;
}

-(void)confirm
{
    // modify by songjk
    BOOL bCheck = true;
    NSString * name = kSaftToNSString(InputRealNameRow.tfRightTextField.text);
    NSString * job = kSaftToNSString(InputJob.tfRightTextField.text);
    NSString * identCode = kSaftToNSString(InputCerNumberRow.tfRightTextField.text);
    NSString * officeDepartment = kSaftToNSString(InputPaperOrganization.tfRightTextField.text);
    NSString * reason = kSaftToNSString(tvInputText.text);
    NSString * Certification = kSaftToNSString(InputCertificationType.tfRightTextField.text);
    NSString * address = kSaftToNSString(tfInputRegAddress.text);
    NSString * Valid_date = kSaftToNSString(InputCerDurationRow.tfRightTextField.text);
    if ([Certification rangeOfString:@"证件类型"].location != NSNotFound)
    {
        Certification = @"";
        if (name.length == 0 && job.length == 0 &&identCode.length == 0 &&officeDepartment.length == 0 && countryString.length ==0 && sexString.length ==0 && Certification.length == 0 && address.length == 0 && Valid_date.length == 0)
        {
            bCheck = false;
        }
    }
    else
    {
        if (name.length == 0 && job.length == 0 &&identCode.length == 0 &&officeDepartment.length == 0 && countryString.length ==0 && sexString.length ==0 && address.length == 0 && Valid_date.length == 0)
        {
            bCheck = false;
        }
    }
    if (!bCheck)
    {
        [self alerViewByString:@"情填写至少一个变更项！"];
    }
    else if (name.length>0 &&( InputRealNameRow.tfRightTextField.text.length<2|| InputRealNameRow.tfRightTextField.text.length>20)) {
            [self alerViewByString:@"姓名字符长度为2-20之间，请按要求填写！"];
    }
   else if (job.length>0 &&( InputJob.tfRightTextField.text.length<2||InputJob.tfRightTextField.text.length>20)) {
            [self alerViewByString:@"职业字符长度为2-20之间，请按要求填写！"];
       
    }
   else if (identCode.length>0 &&( InputCerNumberRow.tfRightTextField.text.length<9||InputCerNumberRow.tfRightTextField.text.length>18)) {
            [self alerViewByString:@"证件号字符长度为9-18之间，请按要求填写！"];
  
    }
   else if (officeDepartment.length>0 &&( InputPaperOrganization.tfRightTextField.text.length<2||InputPaperOrganization.tfRightTextField.text.length>20)) {
            [self alerViewByString:@"发证机关字符长度为2-20之间，请按要求填写！"];
        
    }
    //modify by zhangqy
   else  if  (address.length>0 &&( tfInputRegAddress.text.length<2||tfInputRegAddress.text.length>128)) {
            [self alerViewByString:@"地址字符长度为2-128之间，请按要求填写！"];
    
    }
   else if(reason.length == 0)
   {
       [self alerViewByString:@"变更原因未填写！"];
   }
   else {
        [self showCustomAlertView];
    }
}


-(void)checkData
{
    UIViewController * vc;
    
    if (InputRealNameRow.tfRightTextField.text.length>0) {
       [dicParams setValue:InputRealNameRow.tfRightTextField.text forKey:@"newName"];
    }
    else
    {
        
    }
    if (tvInputText.text.length>0) {
       [dicParams setValue:tvInputText.text forKey:@"appReason"];
    }
    if (countryString.length>0) {
         [dicParams setValue:countryString forKey:@"newCountry"];
    }
    
    if (InputCerNumberRow.tfRightTextField.text.length>0) {
        [dicParams setValue:InputCerNumberRow.tfRightTextField.text forKey:@"newCredentials_no"];
    }
   

    if (InputCertificationType.tfRightTextField.text.length>0) {
          [dicParams setValue:[GlobalData shareInstance].personInfo.creType forKey:@"newCerType"];
    }
    
    if (sexString.length>0) {
      [dicParams setValue:sexString forKey:@"newSex"];
    }
  
    if (tfInputRegAddress.text.length>0) {
         [dicParams setValue:tfInputRegAddress.text forKey:@"newBirthAddress"];
    }
    
    
  
    
    if (InputJob.tfRightTextField.text.length>0) {
        [dicParams setValue:InputJob.tfRightTextField.text forKey:@"newProfession"];

    }
    
    [dicParams setValue:InputPaperOrganization.tfRightTextField.text forKey:@"newLicenceIssuing"];
  
    if (islongPeriod) {
        if (InputCerDurationRow.tfRightTextField.text.length>0) {
            [dicParams setValue:InputCerDurationRow.tfRightTextField.text forKey:@"newValid_date"];
        }
       
//        if ([Utils isBlankString:InputCerDurationRow.tfRightTextField.text])
//        {
//            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入有效时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [av show];
//            return;
//            
//        }
        
    }
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"])
    {
        InputCertificationType.tfRightTextField.text=@"身份证";
        GYRealNameAuthConfirmViewController * vcAuthConfirm =[[GYRealNameAuthConfirmViewController alloc]initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
        vcAuthConfirm.dictInside=dicParams;
        vcAuthConfirm.title=@"重要信息变更";
        
        vcAuthConfirm.useType=useForImportantChange;
        vc=vcAuthConfirm;
        
    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
        GYTwoPictureViewController * vcPicture =[[GYTwoPictureViewController alloc]initWithNibName:@"GYTwoPictureViewController" bundle:nil];
        vcPicture.mdictParams=dicParams;
        vcPicture.useType=useForImportantChange;
         vcPicture.title=@"重要信息变更";
        vc=vcPicture;
        
    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
        GYTwoPictureViewController * vcPicture =[[GYTwoPictureViewController alloc]initWithNibName:@"GYTwoPictureViewController" bundle:nil];
        vcPicture.mdictParams=dicParams;
        vcPicture.useType=useForImportantChange;
         vcPicture.title=@"重要信息变更";
        vc=vcPicture;
    }
    else
    { }
    
    [self.navigationController pushViewController:vc animated:YES];
    

}


-(void)showCustomAlertView
{
    [self.view endEditing:YES];
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    alertView.lineView.hidden=NO;
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        
        [self checkData];
        
        [alertView close];
        
       
    }];
    
    [alertView setUseMotionEffects:true];
    
    
    [alertView show];
    
    
    
    
}

-(UIView *)createUI
{
    
    UIView *  popView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, 290, 120)];
    popView.backgroundColor=kConfirmDialogBackgroundColor;
    //开始添加弹出的view中的组件
    UILabel * lbTip =[[UILabel alloc]init];
    lbTip.center=CGPointMake(290/2, 15);
    lbTip.bounds=CGRectMake(0, 0, 75, 30);
    
    lbTip.text=@"温馨提示";
    lbTip.font=[UIFont systemFontOfSize:18.0];
    lbTip.backgroundColor=[UIColor  clearColor];
    UILabel *  lbBandLocation =[[UILabel alloc]initWithFrame:CGRectMake(30,lbTip.frame.origin.y+lbTip.frame.size.height, 250, 70)];
    lbBandLocation.text=@"重要信息变更申请提交处理期间，货币转银行账户业务将暂时无法受理。";
    lbBandLocation.numberOfLines=3;
    lbBandLocation.textColor=kCellItemTitleColor;
    lbBandLocation.font=[UIFont systemFontOfSize:15.0];
    lbBandLocation.backgroundColor=[UIColor clearColor];

    [popView addSubview:lbTip];
    [popView addSubview:lbBandLocation];
    
    return popView;
}

//设置滚动区域
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [scrMain setContentSize:CGSizeMake(320, 640)];
    
}

-(void)modifyName
{
    InputRealNameRow.lbLeftlabel.text=@"真实姓名";
    
    InputRealNameRow.tfRightTextField.placeholder=@"输入姓名";
    
    InputCerNumberRow.tfRightTextField.placeholder=@"输入证件号码";
    // add by songjk
    [InputCerNumberRow.tfRightTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    InputSexRow.lbLeftlabel.text=@"性别";
    
    [btnLongPeriod setImage:[UIImage imageNamed:@"long_period_nomal.png"] forState:UIControlStateNormal];
    
    [btnLongPeriod setImage:[UIImage imageNamed:@"long_period_selected"] forState:UIControlStateSelected];
    
    [btnLongPeriod setTitle:@"长期" forState:UIControlStateNormal];
    
    [btnLongPeriod setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    
    btnLongPeriod.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 35);
    
    btnLongPeriod.titleEdgeInsets=UIEdgeInsetsMake(5,-15, 5,3);
    
    
    if ([[GlobalData shareInstance].personInfo.sex isEqualToString:@"0"]) {
//            InputSexRow.tfRightTextField.text=@"男";
        
        
    }else
    {
//            InputSexRow.tfRightTextField.text=@"女";
    }

    InputNationaltyRow.lbLeftlabel.text=@"国籍";
    
//   InputNationaltyRow.tfRightTextField.text=[self selectFromDB].areaName;;

    InputCertificationType.lbLeftlabel.text=@"证件类型";
    
    if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"])
    {
        InputCertificationType.tfRightTextField.text=@"身份证";
        
    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
    {
        InputCertificationType.tfRightTextField.text=@"护照";
        
    }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
    {
        
        InputCertificationType.tfRightTextField.text=@"营业执照";
        
    }
    else
    { }
    
    
    if ([[GlobalData shareInstance].personInfo.importantInfoStatus isEqualToString:@"N"]) {
        InputSexRow.tfRightTextField.placeholder=@"请选择性别";
        InputPaperOrganization.tfRightTextField.placeholder=@"输入发证机关";
        InputJob.tfRightTextField.placeholder=@"输入职业";
        InputCerDurationRow.tfRightTextField.placeholder=@"输入有效期";
        lbRegAddressPlaceholder.text=@"输入户籍地址";
    }
    else
    {

        InputCerNumberRow.tfRightTextField.placeholder=@"输入证件号码";
        InputCerDurationRow.tfRightTextField.placeholder=@"输入证件有效期";
        InputJob.tfRightTextField.placeholder=@"输入职业";
        InputPaperOrganization.tfRightTextField.placeholder=@"输入发证机关";
    }
    
    InputCerNumberRow.lbLeftlabel.text=@"证件号码";
   
    InputCerDurationRow.lbLeftlabel.text=@"证件有效期";
   
    InputRegAddressRow.lbLeftlabel.text=@"户籍地址";
    
    InputPaperOrganization.lbLeftlabel.text=@"发证机关";
   
    InputJob.lbLeftlabel.text=@"职业";

    lbRegAddressPlaceholder.textColor=kCellItemTextColor;
    tfInputRegAddress.textColor=kCellItemTitleColor;
    lbTitle.text=@"变更理由";
    lbTitle.textColor=kCellItemTitleColor;
    lbPlaceHolder.text=@"输入变更理由";
    lbPlaceHolder.textColor=kCellItemTextColor;
    tvInputText.backgroundColor=kDefaultVCBackgroundColor;
    tvInputText.textColor=kCellItemTitleColor;
    
}
// add by songjk
-(void)valueChange:(UITextField *)sender
{
    NSLog(@"%@",sender.text);
    if ([InputCertificationType.tfRightTextField.text isEqualToString:@"身份证"])
    {
        sender.text = [sender.text uppercaseString];
    }
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
   
    
    
    return YES;
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


-(void)getDate:(NSString *)date WithDate:(NSDate *)date1
{

    
    InputCerDurationRow.tfRightTextField.text=date;
    
    NSLog(@"%@------date",date);
    
}


- (IBAction)btnChangeCoutryAction:(id)sender {
    
    GYCountrySelectionViewController * vcCountry =[[GYCountrySelectionViewController alloc]initWithNibName:@"GYCountrySelectionViewController" bundle:nil];
    vcCountry.Delegate=self;
    [self.navigationController pushViewController:vcCountry animated:YES];
    
    
    
}


- (IBAction)btnChangeSex:(id)sender {
    
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


//选择国家代理方法
-(void)selectNationalityModel:(GYChooseAreaModel *)CountryInfo
{
    InputNationaltyRow.tfRightTextField.text=CountryInfo.areaName;
    countryString=CountryInfo.areaNo;

}

- (IBAction)btnLongPeriodAction:(id)sender {
    
    UIButton * ValidPeriod = sender;
    
    if (islongPeriod) {
        islongPeriod=!islongPeriod;
        ValidPeriod.selected=YES;
        InputCerDurationRow.tfRightTextField.enabled=NO;
        InputCerDurationRow.tfRightTextField.placeholder=@"";
        InputCerDurationRow.tfRightTextField.text=@"";
        [dicParams setValue:@"long_term" forKey:@"valid_date"];
        
        
    }else
    {
        islongPeriod=!islongPeriod;
        InputCerDurationRow.tfRightTextField.enabled=YES;
          InputCerDurationRow.tfRightTextField.placeholder=@"输入有效期";
        ValidPeriod.selected=NO;
    }
    
}

@end

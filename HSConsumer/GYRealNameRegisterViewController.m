//
//  GYRealNameRegisterViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYRealNameRegisterViewController.h"
#import "InputCellStypeView.h"
#import "GYRealNameRegisterConfirmViewController.h"

#import "GlobalData.h"
#import "CustomIOS7AlertView.h"
//选择证件
#import "GYCertificationTypeViewController.h"
#import "GYCertificationType.h"
#import "UIButton+enLargedRect.h"
#import "GYNameBandingViewController.h"


@interface GYRealNameRegisterViewController ()<GYSenderTestDataDelegate>

@end

@implementation GYRealNameRegisterViewController

{
    
    __weak IBOutlet InputCellStypeView *vUserName;//姓名

    __weak IBOutlet UIScrollView *scrMainScrollView;
    
    __weak IBOutlet InputCellStypeView *vNationaltyRow;//国籍
    
    __weak IBOutlet InputCellStypeView *vCertificationTypeRow;//证件类型
    
    __weak IBOutlet InputCellStypeView *vCertificationNumberRow;//证件号码
    
    __weak IBOutlet UIButton *btnRegisterNow;//立即注册
    
    __weak IBOutlet UIButton *btnChangeNationality;//改变国籍BTN
    
    __weak IBOutlet UIButton *btnChangeType;//改变证件类型
    
    __weak IBOutlet UIView *vTip;//温馨提醒
    
    NSString * creTypeString;
    
    NSString * CountryareaCode;
    
    FMDatabase * dataBase;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"real_name_register");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    creTypeString=@"1";

    [self getCountry];
    // add by songjk
    [vCertificationNumberRow.tfRightTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    // modify by songjk
//    if ([[GlobalData shareInstance].personInfo.regStatus isEqualToString:@"Y"])
    if ([GlobalData shareInstance].user.userName && [GlobalData shareInstance].user.userName.length>0)
    {
        vNationaltyRow.tfRightTextField.enabled=NO;
        vUserName.tfRightTextField.enabled=NO;
        vCertificationNumberRow.tfRightTextField.enabled=NO;
        btnChangeNationality.hidden=YES;
        btnChangeType.hidden=YES;
        btnRegisterNow.hidden=YES;
        //zhangqy 禁用修改按钮
        btnChangeNationality.enabled=NO;
        btnChangeType.enabled=NO;
        btnRegisterNow.enabled=NO;
        
        vNationaltyRow.tfRightTextField.placeholder=@"";
        vUserName.tfRightTextField.placeholder=@"";
        vCertificationNumberRow.tfRightTextField.placeholder=@"";
        vCertificationTypeRow.tfRightTextField.placeholder=@"";
        NSString * strName =[NSString stringWithFormat:@"%@ **** ",[[GlobalData shareInstance].user.userName  substringToIndex:1 ] ];
        vUserName.tfRightTextField.text=strName;
        if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"])
        {
            vCertificationTypeRow.tfRightTextField.text=@"身份证";
        }
        else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
        {
            vCertificationTypeRow.tfRightTextField.text=@"护照" ;       }
        else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
        {
            vCertificationTypeRow.tfRightTextField.text=@"营业执照";
        }
        
        //要通过 code 来 查询 国家名称， 当服务器返回的是中文，就回显示不出来
        vNationaltyRow.tfRightTextField.text=[self selectFromDB].areaName;
        
//        NSString * numberString =[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:3],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-3]];
       NSString * numberString =  [self  setStarMarkCount:6 WithType:[GlobalData shareInstance].personInfo.creType.integerValue WithCerNumber:[GlobalData shareInstance].personInfo.creNo];
        
        vCertificationNumberRow.tfRightTextField.text=numberString;
    }
    else
    {
        
        vUserName.tfRightTextField.text=[GlobalData shareInstance].user.userName;
        vNationaltyRow.tfRightTextField.placeholder=@"选择国籍";
        vUserName.tfRightTextField.placeholder=@"输入姓名";
        vCertificationNumberRow.tfRightTextField.placeholder=@"输入证件号码";
        vCertificationTypeRow.tfRightTextField.text=@"身份证";
    }
    [self modifyName];
    [self setTextColor];
  
    
}

// add by songjk
-(void)valueChange:(UITextField *)sender
{
    NSLog(@"%@",sender.text);
    if ([vCertificationTypeRow.tfRightTextField.text isEqualToString:@"身份证"])
    {
        sender.text = [sender.text uppercaseString];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //add by zhangqy   取消实名绑定
#if 0
    if (![GlobalData shareInstance].personInfo.custName.length>0) {
        UIView * BackgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        BackgroundView.backgroundColor=kDefaultVCBackgroundColor;
        self.view=BackgroundView;
        
        UIImageView * imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
        imgv.frame=CGRectMake(121, 96, 52, 59);
        UILabel * lbTips = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 286, 60)];
        lbTips.numberOfLines=0;
        lbTips.textColor=kCellItemTextColor;
        lbTips.text=@"您未完成实名绑定，无法进行实名注册";
        
        UIButton * btnToRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        btnToRegister.center=CGPointMake(kScreenWidth/2, kScreenHeight/3+30);
        btnToRegister.bounds=CGRectMake(0, 0, 80, 30);
        [btnToRegister setTitle:@"实名绑定" forState:UIControlStateNormal];
        [btnToRegister setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
        [btnToRegister addTarget:self action:@selector(btnGotoNamebanding) forControlEvents:UIControlEventTouchUpInside];
        [btnToRegister setBorderWithWidth:1 andRadius:1 andColor:kDefaultViewBorderColor];
        [BackgroundView addSubview:btnToRegister];
        [BackgroundView addSubview:imgv];
        [BackgroundView addSubview:lbTips];
        
    }else{

   
    
    }
#endif
}
//zhangqy
//-(void)btnGotoNamebanding
//{
//    GYNameBandingViewController * vc = [[GYNameBandingViewController alloc]initWithNibName:@"GYNameBandingViewController" bundle:nil];
//    vc.title=@"实名绑定";
//    vc.fromWhere=1;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}


-(void)setTextColor
{

    [btnRegisterNow setTitle:kLocalized(@"register_rightnow") forState:UIControlStateNormal];
    [btnRegisterNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnRegisterNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChangeNationality setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    [btnChangeType setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    
}


-(void)modifyName
{

    vUserName.lbLeftlabel.text=kLocalized(@"name");
    vNationaltyRow.lbLeftlabel.text=kLocalized(@"nationality");
    vCertificationTypeRow.lbLeftlabel.text=kLocalized(@"papers_type");
    vCertificationNumberRow.lbLeftlabel.text=kLocalized(@"papers_number");
  
    [btnRegisterNow setTitle:kLocalized(@"register_rightnow") forState:UIControlStateNormal];
    [btnRegisterNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    //扩大Button点击范围。
    [btnChangeNationality setEnlargEdgeWithTop:5 right:20 bottom:5 left:20];
    [btnChangeType setEnlargEdgeWithTop:5 right:20 bottom:5 left:20];
}


-(NSString *)setStarMarkCount :(NSInteger) count WithType :(NSInteger)type WithCerNumber :(NSString *)number
{
    
    NSString * cerNumber ;
    if (![GlobalData shareInstance].personInfo.creNo.length>0) {
        return @"";
    }
    // modify by songjk 之前是返回空
    if (number.length<7) {
        return number;
    }
    switch (type) {
        case 1://身份证
        {
            if (number.length==15) {
                cerNumber =[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:6],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-3]];
            }else if (number.length==18)
            {
                 cerNumber=[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:6],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-4]];
            
            
            }else
            {
            
                cerNumber=[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:1],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-2]];
            
            }
            
            
        }
            break;
        case 2://护照
            
        {
            if ([GlobalData shareInstance].personInfo.creNo.length>5) {
                cerNumber=[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:3],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-2]];
            }
            
            
            
        }
            break;
        case 3://营业执照
            
        {
            
            if ([GlobalData shareInstance].personInfo.creNo.length>9) {
                 cerNumber=[NSString stringWithFormat:@"%@  ****  %@",[[GlobalData shareInstance].personInfo.creNo substringToIndex:6],[[GlobalData shareInstance].personInfo.creNo  substringFromIndex:[GlobalData shareInstance].personInfo.creNo.length-3]];
            }
            
           
            
        }
            break;
        default:
            break;
    }
   
    return cerNumber;
}

- (IBAction)btnRegister:(id)sender {
    // add by songjk 检查姓名
    NSString * name = kSaftToNSString(vUserName.tfRightTextField.text);
    if (name.length<2|| name.length>20) {
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:nil message:@"姓名字符长度为2-20之间，请按要求填写！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    else if ([Utils isBlankString:vNationaltyRow.tfRightTextField.text]) {
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:nil message:@"请选择国籍！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }else if ([Utils isBlankString:vCertificationTypeRow.tfRightTextField.text])
    {
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:nil message:@"请选择证件类型！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        
        return ;
        //判断是不是数字
    }
    // songjk 营业执照为20位
    if ([creTypeString isEqualToString:@"3"]) {
        if (vCertificationNumberRow.tfRightTextField.text.length>20 || vCertificationNumberRow.tfRightTextField.text.length<7) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的营业执照！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return ;
        }
    }
    else if ([creTypeString isEqualToString:@"2"]) {
        if (![Utils isPassportNo:vCertificationNumberRow.tfRightTextField.text]) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的护照！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return ;
        }
    }
    else if (!(vCertificationNumberRow.tfRightTextField.text.length>=9&&vCertificationNumberRow.tfRightTextField.text.length<=18))
    {
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的证件号码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        
        return ;
    }
    
    [self showCustomIOSAlertView];
}


-(void)loadDataFromNetwork
{
    
    
    
    
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
   
    [dictInside setValue:[NSString stringWithFormat:@"%@",creTypeString] forKey:@"certype"];
    
    [dictInside setValue:CountryareaCode forKey:@"country"];
    // modify by songjk
    NSString * name = kSaftToNSString(vUserName.tfRightTextField.text);
    [dictInside setValue:name forKey:@"name"];
    //[dictInside setValue:[GlobalData shareInstance].personInfo.custName forKey:@"name"];
    
    [dictInside setValue:vCertificationNumberRow.tfRightTextField.text forKey:@"credentials_no"];
    
    [dictInside setValue:[GlobalData shareInstance].midKey forKey:@"mid"];
  
      [dictInside setValue:[GlobalData shareInstance].ecKey forKey:@"ecKey"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    
    [dict setValue:@"real_name_registration" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            [Utils hideHudViewWithSuperView:self.view];
            NSLog(@"%@----error",error);
            
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                [GlobalData shareInstance].personInfo.regStatus=@"Y";
                [GlobalData shareInstance].user.isRealNameRegistration=YES;
                [GlobalData shareInstance].personInfo.country=CountryareaCode;
                [GlobalData shareInstance].personInfo.creNo=vCertificationNumberRow.tfRightTextField.text;
                [GlobalData shareInstance].personInfo.creType=creTypeString;
                // add by songjk
               [GlobalData shareInstance].user.userName = @"";
                
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                [UIAlertView showWithTitle:nil message:@"实名注册成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    
                }];
                
               

                
            }else if
                 ([[Utils GetResultCode:ResponseDic] isEqualToString:@"3"])
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"您填写的身份信息已存在系统中！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
            
            
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"-1"])
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"实名注册失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
            
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"实名注册失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
        }
        
    }];
    
    
}


-(void)getCountry
{
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    
    [ self moveToDBFile ];
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
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


- (IBAction)btnChangeNationality:(id)sender {
    GYCountrySelectionViewController * vcChangeCountry =[[GYCountrySelectionViewController alloc]initWithNibName:@"GYCountrySelectionViewController" bundle:nil];
    vcChangeCountry.Delegate=self;
    [self.navigationController pushViewController:vcChangeCountry animated:YES];
    
}


- (IBAction)btnChangeCertificationType:(id)sender {
    GYCertificationTypeViewController * vcTest =[[GYCertificationTypeViewController alloc]initWithNibName:@"GYCertificationTypeViewController" bundle:nil];
    vcTest.delegate=self;
    [self.navigationController pushViewController:vcTest animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrMainScrollView.contentSize=CGSizeMake(320, 568);

    
}

#pragma mark textfield Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 10:
        {
            _strUserName=textField.text;
            
        }
            break;
            
            
        case 13:
        {
            _strUserNationlilty=textField.text;
            
        }
            break;
        case 14:
        {
            _strUserCertificationType=textField.text;
            
        }
            break;
        case 15:
        {
            _strUserCertificationNumber=textField.text;
            
        }
            
        default:
            break;
    }
    
}


-(void)showCustomIOSAlertView
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),kLocalized(@"cancel"),nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
              buttonIndex, (int)[alertView tag]);
        
        switch (buttonIndex) {
            case 0:
            {
                
                [self loadDataFromNetwork];

            }
                break;
            case 1:
            {
                
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
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290,120)];
    //开始添加弹出的view中的组件
    // modify by songjk 提示确认注册信息
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 25,25)];
    successImg.image=[UIImage imageNamed:@"img_succeed.png"];
    
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 2, 200, 30)];
    lbTip.text=@"确认注册信息";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    
    UILabel * lbTradeNumber=[[UILabel alloc]initWithFrame:CGRectMake(25, 50, 160, 20)];
    lbTradeNumber.text=@"姓名";
    lbTradeNumber.textColor=kCellItemTitleColor;
    lbTradeNumber.font=[UIFont systemFontOfSize:14.0];
    lbTradeNumber.backgroundColor=[UIColor clearColor];
    
    UILabel * lbTradeNumberDetail=[[UILabel alloc]initWithFrame:CGRectMake(270-160, lbTradeNumber.frame.origin.y, 160, 20)];
    lbTradeNumberDetail.text=vUserName.tfRightTextField.text;
    lbTradeNumberDetail.textColor=kCellItemTitleColor;
    lbTradeNumberDetail.textAlignment=NSTextAlignmentRight;
    lbTradeNumberDetail.font=[UIFont systemFontOfSize:14.0];
    lbTradeNumberDetail.backgroundColor=[UIColor clearColor];
    
    UILabel * lbToolName=[[UILabel alloc]initWithFrame:CGRectMake(lbTradeNumber.frame.origin.x, lbTradeNumberDetail.frame.origin.y+lbTradeNumberDetail.frame.size.height+5, 160, 20)];
    lbToolName.text=@"证件号码";
    lbToolName.textColor=kCellItemTitleColor;
    lbToolName.font=[UIFont systemFontOfSize:14.0];
    lbToolName.backgroundColor=[UIColor clearColor];
    
    UILabel * lbToolNameDetail=[[UILabel alloc]initWithFrame:CGRectMake(270-160, lbToolName.frame.origin.y, 160, 20)];
    lbToolNameDetail.text=vCertificationNumberRow.tfRightTextField.text;
    lbToolNameDetail.textColor=kCellItemTitleColor;
    lbToolNameDetail.textAlignment=NSTextAlignmentRight;
    lbToolNameDetail.font=[UIFont systemFontOfSize:14.0];
    lbToolNameDetail.backgroundColor=[UIColor clearColor];
    
    
    [popView addSubview:successImg];
    [popView addSubview:lbTip];
    [popView addSubview:lbTradeNumber];
    [popView addSubview:lbTradeNumberDetail];
    [popView addSubview:lbToolName];
    [popView addSubview:lbToolNameDetail];
    return popView;
}

#pragma mark 测试数据代理方法
-(void)selectNationalityModel:(GYChooseAreaModel *)CountryInfo
{
   
    vNationaltyRow.tfRightTextField.text=CountryInfo.areaName;
    
    CountryareaCode=CountryInfo.areaNo;

}

#pragma mark 选择证件类型代理方法。
-(void)sendSelectDataWithMod :(GYCertificationType *)model
{
    vCertificationTypeRow.tfRightTextField.text=model.strCretype;
    
    creTypeString=model.strCretIdstring;
   
}

@end

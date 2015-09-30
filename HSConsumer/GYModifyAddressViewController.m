//
//  GYAddAddressViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYModifyAddressViewController.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "UIAlertView+Blocks.h"
#import "UIButton+enLargedRect.h"
@interface GYModifyAddressViewController ()

@end

@implementation GYModifyAddressViewController
{
    
    
    __weak IBOutlet UIScrollView *mainSroView;//背景的滚动试图
    
    __weak IBOutlet UILabel *lbProvince;//省
    
    __weak IBOutlet UILabel *lbCity;//城市
    
    __weak IBOutlet UILabel *lbarea;//区
    
    __weak IBOutlet UITextField *tfDetailArea;//输入区
    
    __weak IBOutlet UILabel *lbDetailAddress;//详细地址
    
    __weak IBOutlet UITextField *tfInputProvince;//输入省
    
    __weak IBOutlet UITextField *tfDetailCity;//输入城市
    
    __weak IBOutlet UITextView *tvDetailAddress;//输入详细地址
    
    __weak IBOutlet UILabel *lbReceivePerson;//收货人
    
    __weak IBOutlet UILabel *lbCellPhoneNumber;//手机号码
    
    __weak IBOutlet UILabel *lbTelphone;//固定电话
    
    __weak IBOutlet UILabel *lbPostCode;//邮编
    
    __weak IBOutlet UITextField *tfReceivePerson;//输入收货人
    
    __weak IBOutlet UITextField *tfCellPhoneNumber;//输入手机号码
    
    __weak IBOutlet UITextField *tfTelphone;//输入固定电话
    
    __weak IBOutlet UITextField *tfPostcode;//输入邮编
    
    __weak IBOutlet UIButton *btnDeleteAddress;//删除地址BTN
    
    __weak IBOutlet UIImageView *imgUnderProvince;//分割线
    
    __weak IBOutlet UIImageView *imgUnderAccpetPerson;//分割线
    
    __weak IBOutlet UIImageView *imgUnderArea;//分割线
    
    __weak IBOutlet UIImageView *imgUnderCity;//分割线
    
    __weak IBOutlet UIImageView *imgUnderCellPhone;//分割线
    
    __weak IBOutlet UIImageView *imgUnderTelphone;//分割线
    
    __weak IBOutlet UIView *vBottomBgView;//下面的背景VIEW
    
    __weak IBOutlet UIView *vUpBgView;//上面的背景view
    
    NSString * strTempTextView;//临时的字符串，显示PLACEHOHER
    
    __weak IBOutlet UILabel *lbTempLabel;//显示临时字符串的LABEL
    
    
    __weak IBOutlet UIButton *btnChangeProvince;
    
    __weak IBOutlet UIButton *btnChangeCity;
    
    __weak IBOutlet UIButton *btnChangeArea;
    
    NSString * strParentCode;
    
    NSString *  strParentAreaCode;
    
}
//初始化方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.marrAddModel=[NSMutableArray array];
        
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=kLocalized(@"modify_address");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [btnChangeArea setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    [btnChangeCity setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    [btnChangeProvince setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    tfDetailArea.enabled=NO;
    tfInputProvince.enabled=NO;//输入省
    tfDetailCity.enabled=NO;//输入城市
    
    //设置国际化名称
    [self  modifyName];
    //设置分割线
    [self setSeprator];
    //设置文本颜色和占位符
    [self setTextFieldPlaceHoderText];

    
    
}

-(void)initdataInChangeGetGood
{
    tfCellPhoneNumber.text=self.AddModel.CustomerPhone;
    tvDetailAddress.text=self.AddModel.DetailAddress;
    tfInputProvince.text=self.AddModel.Province;
    tfDetailCity.text=self.AddModel.City;
    tfDetailArea.text=self.AddModel.Area;
    tfReceivePerson.text=self.AddModel.CustomerName;
    tfTelphone.text=self.AddModel.TelphoneNumber;
    tfPostcode.text=self.AddModel.PostCode;
    
    
}
//设置分割线
-(void)setSeprator
{
    [vBottomBgView addAllBorder];
    [vUpBgView addAllBorder];
    [self setBorderWithView:imgUnderProvince WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgUnderCity WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgUnderArea WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgUnderAccpetPerson WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgUnderTelphone WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgUnderCellPhone WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //用户判断是从何处push 过来的，此页面是 “收件地址” “修改收件地址”同一页面。不同页面不同的title
    
    
    if (self.boolstr ) {
        
        self.title=kLocalized(@"my_receive_addresss");
    }else{
        self.title=kLocalized(@"shipping_address");
        [btnDeleteAddress setHidden:YES];
        
    }
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:kLocalized(@"save") style:  UIBarButtonItemStyleBordered target:self action:@selector(mysaveData)];
    
    
    lbTempLabel.text=@"";
    [self initdataInChangeGetGood];


    
}

-(BOOL)strfengg
{
    BOOL TT=YES;
    NSArray *arr=[tfTelphone.text componentsSeparatedByString:@"-"];
    for (int j=0;j<[arr count];j++) {
        NSLog(@"%@",arr[j]);
        NSString *te=arr[j];
        if([Utils isValidMobileNumber:te]){
            TT=YES;
        }else{
            TT=NO;
            return TT;
        }
    }
    return TT;
}
//点击保存调用的方法。
-(void)mysaveData
{
    DDLogInfo(@"aaaaa aaaaaaaaaaa");
 
    NSLog(@"%@",tvDetailAddress.text);
    
   if ([Utils isBlankString:tvDetailAddress.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入详细地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }
    else if ( tvDetailAddress.text.length<2||tvDetailAddress.text.length>128)
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"详细地址不能小于2个或大于128个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }
    else if ([Utils isBlankString:tfReceivePerson.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入收货人！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if (tfReceivePerson.text.length<2||tfReceivePerson.text.length>20)
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"收货人不能小于2个或大于20个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    else if ([Utils isBlankString: tfCellPhoneNumber.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
//    }else if ([[self strfengg ]isEqualToString:@"2"]){
//        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的固定电话！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return ;
    }
//    else if (([Utils isValidCH:tfTelphone.text])||tfTelphone .text.length>20||tfTelphone.text.length>20||[self strfengg]==NO)
    else if (![Utils isValidTelPhoneNum:tfTelphone.text])
    {
        
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的固定电话！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:tfPostcode.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮编！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
   else  if (![Utils isMobileNumber:tfCellPhoneNumber.text]) {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if (![Utils isValidZipcode:tfPostcode.text])
    {
        
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮编！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }

    [self saveDataRequest];
    
}


-(void)saveDataRequest
{
    
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: tfInputProvince.text forKey:@"province" ];
    [ dict setValue: tfDetailCity.text forKey:@"city" ];
    [ dict setValue: tfDetailArea.text   forKey:@"area" ];
    [ dict setValue: tvDetailAddress.text forKey:@"address" ];
    [ dict setValue: tfReceivePerson.text forKey:@"receiverName" ];
    [ dict setValue: tfCellPhoneNumber.text forKey:@"phone" ];
    [ dict setValue:tfPostcode.text  forKey:@"postcode" ];
      [ dict setValue:tfTelphone.text  forKey:@"fixedTelephone" ];
     [ dict setValue:self.AddModel.idString  forKey:@"id" ];

    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/updateDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
             
                NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                
                    [UIAlertView showWithTitle:nil message:@"修改成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [self.navigationController   popToViewController:self.navigationController.viewControllers[2] animated:YES];
                    }];
                    
                    
                }else if ([retCode isEqualToString:@"201"])
                {  UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                }
            }
        }
        
    }]; 
}


//设置名称
-(void)modifyName
{
    lbProvince.text=kLocalized(@"provinces");
    lbCity.text=kLocalized(@"city");
    lbarea.text=kLocalized(@"district/county");
    lbDetailAddress.text=kLocalized(@"detailed_address");
    lbReceivePerson.text=kLocalized(@"receive_person");
    lbCellPhoneNumber.text=kLocalized(@"cell_phone_number");
    lbTelphone.text=kLocalized(@"telphone");
    lbPostCode.text=kLocalized(@"zip_code");
    tfInputProvince.placeholder=kLocalized(@"input_province");
    tfDetailCity.placeholder=kLocalized(@"input_city");
    tfDetailArea.placeholder=kLocalized(@"input_area");
    tfReceivePerson.placeholder=kLocalized(@"input_receive_name");
    tfCellPhoneNumber.placeholder=kLocalized(@"cell_phone_number");
    tfTelphone.placeholder=kLocalized(@"input_telphone");
    tfPostcode.placeholder=kLocalized(@"input_postCode");
//    //设置删除button的字体颜色  /////2015-9-14 要求将删除功能放到收货地址管理页面 这里就将按钮给隐藏了  by liss
//    [btnDeleteAddress setTitle:kLocalized(@"delete_get_good_address") forState:UIControlStateNormal];
//    [btnDeleteAddress setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    //修改label的字体颜色
    lbProvince.textColor=kCellItemTitleColor;
    lbCity.textColor=kCellItemTitleColor;
    lbarea.textColor=kCellItemTitleColor;
    lbDetailAddress.textColor=kCellItemTitleColor;
    lbReceivePerson.textColor=kCellItemTitleColor;
    lbCellPhoneNumber.textColor=kCellItemTitleColor;
    lbTelphone.textColor=kCellItemTitleColor;
    lbPostCode.textColor=kCellItemTitleColor;
    tvDetailAddress.textColor=kCellItemTitleColor;
    
    
}

-(void)setTextFieldPlaceHoderText
{
    [Utils setPlaceholderAttributed:tfInputProvince withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfDetailCity withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfDetailArea withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfReceivePerson withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfCellPhoneNumber withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfTelphone withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [Utils setPlaceholderAttributed:tfPostcode withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    
    //设置textfiled字体颜色
    tvDetailAddress.textColor=kCellItemTitleColor;
    tfCellPhoneNumber.textColor=kCellItemTitleColor;
    tfInputProvince.textColor=kCellItemTitleColor;
    tfDetailCity.textColor=kCellItemTitleColor;
    tfDetailArea.textColor=kCellItemTitleColor;
    tfReceivePerson.textColor=kCellItemTitleColor;
    tfTelphone.textColor=kCellItemTitleColor;
    tfPostcode.textColor=kCellItemTitleColor;
    lbTempLabel.textColor=kTextFieldPlaceHolderColor;
    
    
}

//设置分割线方法。
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}


#pragma mark textview 代理方法



#pragma mark textview delegate
-(void)textViewDidChange:(UITextView *)textView
{
    lbTempLabel.text=@"";
    
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    _strDetailAddress=textView.text;

}


//删除地址
- (IBAction)btnDeleteAddress:(id)sender {
   
  
    
    [UIAlertView showWithTitle:nil message:@"是否删除收货地址？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex != 0)
            
        {
           [self loadDataFromNetwork];
            
        }
        
    }];
    

    
    
    
    
}


-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: self.AddModel.AddressId forKey:@"id" ];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/deleteDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){

        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSLog(@"%@--------dict",responseDic);
                
                [UIAlertView showWithTitle:nil message:@"删除地址成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                   
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
            
                
            }
        }
        
    }];
    
    
}

//XIb拉的srollview 需要在这里设置滚动区域，并且要取消自动布局。
-(void)viewDidAppear:(BOOL)animated
{
    mainSroView.contentSize=CGSizeMake(320, 568);
    
}

- (IBAction)btnChangeProvinceAction:(id)sender {
    
    GYProvinceChooseViewController * vcChangeProvince = [[GYProvinceChooseViewController alloc]initWithNibName:@"GYProvinceChooseViewController" bundle:nil];
    vcChangeProvince.delegate=self;
    
    [self.navigationController pushViewController:vcChangeProvince animated:YES];
    
}

- (IBAction)btnChangeCityAction:(id)sender {
    
    GYCityChooseViewController * vcChangeCity = [[GYCityChooseViewController alloc]initWithNibName:@"GYCityChooseViewController" bundle:nil];
    vcChangeCity.parentCode=strParentCode;
    vcChangeCity.delegate=self;
    
    [self.navigationController pushViewController:vcChangeCity animated:YES];
    
}


- (IBAction)btnChangeAreaAction:(id)sender {
    
    GYAreaChooseViewController * vcChangeArea = [[GYAreaChooseViewController alloc]initWithNibName:@"GYAreaChooseViewController" bundle:nil];
    vcChangeArea.delegate=self;
    vcChangeArea.parentCode=strParentAreaCode;
    
    [self.navigationController pushViewController:vcChangeArea animated:YES];
  
    
}



-(void)selectOneProvince :(GYCityInfo *)model
{
    self.AddModel.Province=model.strAreaName;

    strParentCode=model.strAreaCode;
    

}


-(void)selectOneCity :(GYCityInfo *)model
{

    self.AddModel.City=model.strAreaName;

    strParentAreaCode=model.strAreaCode;
    

}


-(void)selectOneArea :(GYCityInfo *)model
{
    
    self.AddModel.Area=model.strAreaName;
    tfDetailArea.text=model.strAreaName;
  

}


@end

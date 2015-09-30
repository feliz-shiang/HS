//
//  GYAddAddressSroViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYAddAddressSroViewController.h"
#import "InputCellStypeView.h"
#import "UIView+CustomBorder.h"
#import "GYModifyAddressViewController.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "FMDatabase.h"
#import "GYChooseAreaModel.h"
#import "GYProvinceViewController.h"
#import "UIButton+enLargedRect.h"
@interface GYAddAddressSroViewController ()

@end

@implementation GYAddAddressSroViewController
{

    __weak IBOutlet InputCellStypeView *InputProvinceRow;

    __weak IBOutlet InputCellStypeView *InputCityRow;

    __weak IBOutlet InputCellStypeView *InputAreaRow;

    __weak IBOutlet InputCellStypeView *InputDetailAddress;

    __weak IBOutlet InputCellStypeView *InputReceivePerson;

    __weak IBOutlet InputCellStypeView *InputPhoneNumber;
    
    __weak IBOutlet InputCellStypeView *InputTelPhone;
    
    __weak IBOutlet InputCellStypeView *InputPostCode;
    
    
    __weak IBOutlet UIScrollView *mainSroview;
    
    NSString * strParentCode;
    
    NSString * strParentAreaCode;
    
    
    __weak IBOutlet UIButton *btnChangeAreaRef;
    
    __weak IBOutlet UIButton *btnChangeProvince;
    
    __weak IBOutlet UIButton *btnChangeCityRef;
    
    __weak IBOutlet UILabel *lbPlaceholder;
    
    __weak IBOutlet UIButton *btnDeleteAddress;
    
    __weak IBOutlet UITextView *tvDetailAddress;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mainSroview.backgroundColor=kDefaultVCBackgroundColor;
    self.title=@"新增地址";
    
    
    [btnChangeAreaRef setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];
    [btnChangeCityRef setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];
    [btnChangeProvince setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];
    
    // Do any additional setup after loading the view from its nib.
    
    [self modifyName];
    
    //add by zhangqy
    [InputPhoneNumber.tfRightTextField addTarget:self action:@selector(tfRightTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [InputPostCode.tfRightTextField addTarget:self action:@selector(tfRightTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)tfRightTextFieldEditingChanged:(UITextField*)textField
{
    NSString *str = textField.text;
    if (textField==InputPhoneNumber.tfRightTextField) {
        if (str.length>=11) {
            textField.text = [str substringToIndex:11];
        }
    }
    if (textField==InputPostCode.tfRightTextField) {
        if (str.length>=6) {
            textField.text = [str substringToIndex:6];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (self.boolstr ) {
 
        self.title=kLocalized(@"my_receive_addresss");
        //显示收货地址时，禁止输入。
        InputAreaRow.tfRightTextField.enabled=NO;
        InputCityRow.tfRightTextField.enabled=NO;
        InputPostCode.tfRightTextField.enabled=NO;
        InputProvinceRow.tfRightTextField.enabled=NO;
        InputPhoneNumber.tfRightTextField.enabled=NO;
        InputReceivePerson.tfRightTextField.enabled=NO;
        InputTelPhone.tfRightTextField.enabled=NO;
        
        tvDetailAddress.editable=NO;
        btnChangeProvince.hidden=YES;
        btnChangeAreaRef.hidden=YES;
        btnChangeCityRef.hidden=YES;
        btnDeleteAddress.hidden=NO;// modify by songjk 修改为显示
        // add bysongjk
        [btnDeleteAddress setTitle:@"删除收货地址" forState:UIControlStateNormal];
        [btnDeleteAddress setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        self.title=kLocalized(@"shipping_address");
        [btnDeleteAddress setHidden:YES];
        
    }
    if (self.boolstr ) {
        //导航栏右边按钮的名称
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:kLocalized(@"modify") style: UIBarButtonItemStyleBordered target:self action:@selector(saveData)];
    }else {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:kLocalized(@"save") style:  UIBarButtonItemStyleBordered target:self action:@selector(saveData)];
        
    }
    if (self.AddModel) {
        lbPlaceholder.text=@"";
       [self initdataInChangeGetGood];
    }else{
    
        
    }


}
//修改完成需要重新刷新
 

-(void)initdataInChangeGetGood
{
    
    InputPhoneNumber.tfRightTextField.text=self.AddModel.CustomerPhone;
    tvDetailAddress.text=self.AddModel.DetailAddress;
    InputProvinceRow.tfRightTextField.text=self.AddModel.Province;
    InputCityRow.tfRightTextField.text=self.AddModel.City;
    InputAreaRow.tfRightTextField.text=self.AddModel.Area;
    InputReceivePerson.tfRightTextField.text=self.AddModel.CustomerName;
  
    InputPostCode.tfRightTextField.text=self.AddModel.PostCode;
    InputTelPhone.tfRightTextField.text=self.AddModel.TelphoneNumber;
    
}

-(void)modifyName
{
    InputProvinceRow.lbLeftlabel.text=@"省份";
    InputProvinceRow.tfRightTextField.placeholder=@"输入省份";
    InputCityRow.lbLeftlabel.text=@"城市";
    InputCityRow.tfRightTextField.placeholder=@"输入市";
    InputAreaRow.lbLeftlabel.text=@"区/县";
    InputAreaRow.tfRightTextField.placeholder=@"输入区/县";
    InputDetailAddress.lbLeftlabel.text=@"详细地址";
    
    
    InputReceivePerson.lbLeftlabel.text=@"收货人";
    InputReceivePerson.tfRightTextField.placeholder=@"输入姓名";
    InputPhoneNumber.lbLeftlabel.text=@"手机号码";
    InputPhoneNumber.tfRightTextField.placeholder=@"输入手机号码";
    InputTelPhone.lbLeftlabel.text=@"固定电话";
    InputTelPhone.tfRightTextField.placeholder=@"输入固定电话";
    InputPostCode.lbLeftlabel.text=@"邮编";
    InputPostCode.tfRightTextField.placeholder=@"输入邮编";
    
    lbPlaceholder.textColor=kCellItemTextColor;
    tvDetailAddress.textColor=kCellItemTitleColor;
    lbPlaceholder.text=@"输入详细地址";
    
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     mainSroview.contentSize=CGSizeMake(320, 568);

}


//点击保存调用的方法。
-(void)saveData
{
      
    //boolstr 为真 是从 didselect push过来 目的是修改地址model
    if (self.boolstr) {
        
        GYModifyAddressViewController * vcModifyAddress =[[GYModifyAddressViewController alloc]initWithNibName:@"GYModifyAddressViewController" bundle:nil];

        vcModifyAddress.AddModel=self.AddModel;

        vcModifyAddress.boolstr=YES;
        [self.navigationController pushViewController:vcModifyAddress animated:YES];
        
    }else{
        //新增 地址model
        
       [self addAddressRequest];
    }
 
}

-(BOOL)strfengg
{
    BOOL TT=YES;
    NSArray *arr=[InputTelPhone.tfRightTextField.text componentsSeparatedByString:@"-"];
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

-(void)addAddressRequest
{
    if ([Utils isBlankString:InputProvinceRow.tfRightTextField.text]) {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入省份！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:InputCityRow.tfRightTextField.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入城市！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }else if ([Utils isBlankString:InputAreaRow.tfRightTextField.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入区/县！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }
    else if ([Utils isBlankString:tvDetailAddress.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入详细地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }
    else if ( tvDetailAddress.text.length>128||tvDetailAddress.text.length<2)
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"详细地址不能小于2个或大于128个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }
    else if ([Utils isBlankString:InputReceivePerson.tfRightTextField.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入收件人！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if (InputReceivePerson.tfRightTextField.text.length>20||InputReceivePerson.tfRightTextField.text.length<2)
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"收件人不能小于2个或大于20个字符！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if (![Utils isMobileNumber:InputPhoneNumber.tfRightTextField.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
//    }else if (![Utils isBlankString:InputTelPhone.tfRightTextField.text]){
//        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的固定电话！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return ;
    }
//    else if (([Utils isValidCH:InputTelPhone.tfRightTextField.text])||InputTelPhone.tfRightTextField.text.length>20||[self strfengg]==NO)
    
    //modify by shiang
//    else if (![Utils isValidTelPhoneNum:InputTelPhone.tfRightTextField.text])
//    {
//        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的固定电话！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return ;
//    }
    else if ([Utils isBlankString:InputPostCode.tfRightTextField.text])
    {
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮编！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
//     
//    if (![Utils checkTel:InputPhoneNumber.tfRightTextField.text]) {
//        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return ;
//    }
    else if (![Utils isValidZipcode:InputPostCode.tfRightTextField.text])
    {
       
        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮编！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    
    }
//    else if (![Utils isMobileNumber:InputTelPhone.tfRightTextField.text])
//    {
//        UIAlertView  * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的固定电话！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//        return ;
//    
//    }
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: InputProvinceRow.tfRightTextField.text forKey:@"province" ];
    [ dict setValue: InputCityRow.tfRightTextField.text forKey:@"city" ];
    [ dict setValue: InputAreaRow.tfRightTextField.text   forKey:@"area" ];
    [ dict setValue: tvDetailAddress.text forKey:@"address" ];
    [ dict setValue: InputReceivePerson.tfRightTextField.text forKey:@"receiverName" ];
    [ dict setValue: InputPhoneNumber.tfRightTextField.text forKey:@"phone" ];
    [ dict setValue: InputPostCode.tfRightTextField.text  forKey:@"postcode" ];
        [ dict setValue: InputTelPhone.tfRightTextField.text  forKey:@"fixedTelephone" ];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/saveDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                if ([[responseDic[@"retCode"] stringValue] isEqualToString:@"200"]) {
                    [UIAlertView showWithTitle:nil message:@"恭喜你，添加地址成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        
                        
                        [self.navigationController   popViewControllerAnimated:YES];
                    }];
                }
                
            }
        }
        
    }];
    
    
}


-(void)loadDeleteAddressFromNetwork
{
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: self.AddModel.AddressId forKey:@"id" ];
    
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/deleteDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"删除成功！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
                
            }else
            {
                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"删除失败，请重试！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        
    }];
  
    
}



#pragma mark 选择省的代理方法
-(void)selectOneProvince :(GYCityInfo *)model
{
    InputProvinceRow.tfRightTextField.text=model.strAreaName;
    strParentCode=model.strAreaCode;
    
}

#pragma mark 选择城市代理方法
-(void)selectOneCity :(GYCityInfo *)model
{
    InputCityRow.tfRightTextField.text=model.strAreaName;
    strParentAreaCode=model.strAreaCode;
    
}

#pragma mark 选择区代理方法
-(void)selectOneArea :(GYCityInfo *)model
{
    InputAreaRow.tfRightTextField.text=model.strAreaName;
    
}
- (IBAction)btnChangeProvince:(id)sender {
    GYProvinceChooseViewController * vcChangeProvince = [[GYProvinceChooseViewController alloc]initWithNibName:@"GYProvinceChooseViewController" bundle:nil];
    vcChangeProvince.delegate=self;
    
    [self.navigationController pushViewController:vcChangeProvince animated:YES];
}

- (IBAction)btnChangeCity:(id)sender {
    
    GYCityChooseViewController * vcChangeCity = [[GYCityChooseViewController alloc]initWithNibName:@"GYCityChooseViewController" bundle:nil];
    vcChangeCity.parentCode=strParentCode;
    
    vcChangeCity.delegate=self;
    
    [self.navigationController pushViewController:vcChangeCity animated:YES];
    

    
}

- (IBAction)btnChangeArea:(id)sender {
    
    GYAreaChooseViewController * vcChangeArea = [[GYAreaChooseViewController alloc]initWithNibName:@"GYAreaChooseViewController" bundle:nil];
    vcChangeArea.delegate=self;
    vcChangeArea.parentCode=strParentAreaCode;
    
    [self.navigationController pushViewController:vcChangeArea animated:YES];
}


#pragma mark textview代理方法
- (void)textViewDidChange:(UITextView *)textView
{
    lbPlaceholder.text=@"";

}


#pragma mark textfield代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==10) {
        
        [self btnChangeProvince:nil];
//        return NO;
        
    }else if (textField.tag==11)
    {
        [self btnChangeCity:nil];
//         return NO;
        
    }else if (textField.tag==12)
    {
        
        [self btnChangeArea:nil];
//         return NO;
    }else{
        
        return YES;
        
    }
     return NO;
    
    
}

- (IBAction)btnDeleteAddressAction:(id)sender {
    // add by songjk
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: self.AddModel.AddressId forKey:@"id" ];
    [Utils showMBProgressHud:self SuperView:self.view Msg:nil];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/deleteDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view];
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


@end

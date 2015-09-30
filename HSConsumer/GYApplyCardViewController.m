//
//  GYRealNameRegisterViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYApplyCardViewController.h"
#import "InputCellStypeView.h"
@interface GYApplyCardViewController ()

@end

@implementation GYApplyCardViewController

{

    __weak IBOutlet InputCellStypeView *vUserName;//姓名

    __weak IBOutlet InputCellStypeView *vSexRow;//性别

    __weak IBOutlet InputCellStypeView *vJobRow;//职业

    __weak IBOutlet UIScrollView *scrMainScrollView;
    
    __weak IBOutlet InputCellStypeView *vNationaltyRow;//国籍

    __weak IBOutlet InputCellStypeView *vCertificationTypeRow;//证件类型
    
    __weak IBOutlet InputCellStypeView *vCertificationNumberRow;//证件号码
    
    __weak IBOutlet InputCellStypeView *vCertificationValidDate;//证件有效期
    
    __weak IBOutlet InputCellStypeView *vFamilyRegisterAddress;//户籍地址
    
    __weak IBOutlet UIButton *btnRegisterNow;//立即注册
    
    __weak IBOutlet UIButton *btnChangeSex;//改变性别BTN
    
    __weak IBOutlet UIButton *btnChangeNationality;//改变国籍BTN
    
    __weak IBOutlet UIButton *btnChangeType;//改变证件类型
    
    __weak IBOutlet UITextView *tvInputFamliyAddress;
    
    __weak IBOutlet UILabel *lbPlaceholder;

    __weak IBOutlet InputCellStypeView *contactRow;

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"apply_Hs_card");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    // Do any additional setup after loading the view from its nib.
    //国际化
    [self modifyName];
    [self setTextColor];
    
}


-(void)setTextColor
{
    lbPlaceholder.textColor=kCellItemTitleColor;
    [btnRegisterNow setTitle:kLocalized(@"Now_apply") forState:UIControlStateNormal];
    [btnRegisterNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnRegisterNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChangeNationality setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    [btnChangeSex setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    [btnChangeType setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];

}


-(void)modifyName
{
    vUserName.lbLeftlabel.text=kLocalized(@"name");
    vUserName.tfRightTextField.text=@"王伟民";
    vSexRow.lbLeftlabel.text=kLocalized(@"sex");
    vSexRow.tfRightTextField.text=@"男";
    vJobRow.lbLeftlabel.text=kLocalized(@"professional");
    vJobRow.tfRightTextField.text=@"打酱油";
    vNationaltyRow.lbLeftlabel.text=kLocalized(@"nationality");
    vNationaltyRow.tfRightTextField.text=@"日本";
    vCertificationTypeRow.lbLeftlabel.text=kLocalized(@"papers_type");
    vCertificationTypeRow.tfRightTextField.text=@"身份证";
    vCertificationNumberRow.lbLeftlabel.text=kLocalized(@"papers_number");
    vCertificationNumberRow.tfRightTextField.text=@"5265 4151 3255 685";
    vCertificationValidDate.lbLeftlabel.text=kLocalized(@"certification_valid_date");
    vCertificationValidDate.tfRightTextField.text=@"20年";
    vFamilyRegisterAddress.lbLeftlabel.text=kLocalized(@"address");

    lbPlaceholder.text=@"输入现住地址";
    [btnRegisterNow setTitle:kLocalized(@"register_rightnow") forState:UIControlStateNormal];
    [btnRegisterNow setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    contactRow.lbLeftlabel.text=kLocalized(@"ep_contact_phone");
    contactRow.tfRightTextField.text=@"15813815125";


}

- (IBAction)btnRegister:(id)sender {
    
    
    
}




- (IBAction)btnChangeSex:(id)sender {
    
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]initWithNibName:@"GYTestTableViewController" bundle:nil];
//    vcTest.delegate=self;
//    vcTest.marrDataSource=[@[@"男",@"女"] mutableCopy];
//    vcTest.tag=5;
//    [self.navigationController pushViewController:vcTest animated:YES];
}

- (IBAction)btnChangeNationality:(id)sender {
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]initWithNibName:@"GYTestTableViewController" bundle:nil];
//    vcTest.delegate=self;
//    vcTest.marrDataSource=[@[@"中国",@"美国",@"澳大利亚",@"日本"] mutableCopy];
//    vcTest.tag=6;
//    [self.navigationController pushViewController:vcTest animated:YES];
    
}

- (IBAction)btnChangeCertificationType:(id)sender {
    
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]initWithNibName:@"GYTestTableViewController" bundle:nil];
//    vcTest.delegate=self;
//    vcTest.marrDataSource=[@[@"身份证",@"护照",@"企业执照"] mutableCopy];
//    vcTest.tag=7;
//    [self.navigationController pushViewController:vcTest animated:YES];
//    
}

-(void)viewDidAppear:(BOOL)animated
{
    scrMainScrollView.contentSize=CGSizeMake(320, 568);
}

#pragma mark Textview Delegate
- (void)textViewDidChange:(UITextView *)textView
{
   lbPlaceholder.text=@"";



}


#pragma mark 测试数据代理方法
-(void)senderStr:  (NSString   *)str withTag:(int)tag
{
    if (tag==5) {
        vSexRow.tfRightTextField.text=str;
    }else if (tag==6){
        
        vNationaltyRow.tfRightTextField.text=str;
    }else if (tag==7){
        
        vCertificationTypeRow.tfRightTextField.text=str;
    }
    
}
#pragma mark  textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{



}


@end

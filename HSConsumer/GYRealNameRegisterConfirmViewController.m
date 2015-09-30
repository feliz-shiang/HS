//
//  GYRealNameRegisterViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYRealNameRegisterConfirmViewController.h"
#import "InputCellStypeView.h"
//护照的图片选择页面
#import "GYTwoPictureViewController.h"
@interface GYRealNameRegisterConfirmViewController ()

@end

@implementation GYRealNameRegisterConfirmViewController

{

    __weak IBOutlet InputCellStypeView *vUserName;//姓名

    __weak IBOutlet UIScrollView *scrMainScrollView;
    
    __weak IBOutlet InputCellStypeView *vNationaltyRow;//国籍

    __weak IBOutlet InputCellStypeView *vCertificationTypeRow;//证件类型
    
    __weak IBOutlet InputCellStypeView *vCertificationNumberRow;//证件号码
    
    __weak IBOutlet UIButton *btnChangeNationality;//改变国籍BTN
    
    __weak IBOutlet UIButton *btnChangeType;//改变证件类型
    

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
    // Do any additional setup after loading the view from its nib.
    //国际化
    [self modifyName];
    [self setTextColor];
    
}


-(void)setTextColor
{

    [btnChangeType setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];

}


-(void)modifyName
{
    
    vUserName.lbLeftlabel.text=kLocalized(@"name");
    vUserName.tfRightTextField.text=@"王伟民";
    vNationaltyRow.lbLeftlabel.text=kLocalized(@"nationality");
    vNationaltyRow.tfRightTextField.text=@"日本";
    vCertificationTypeRow.lbLeftlabel.text=kLocalized(@"papers_type");
    vCertificationTypeRow.tfRightTextField.text=@"身份证";
    vCertificationNumberRow.lbLeftlabel.text=kLocalized(@"papers_number");
    vCertificationNumberRow.tfRightTextField.text=@"5265 4151 3255 685";


}

- (IBAction)btnRegister:(id)sender {
    
    
    
}


- (IBAction)btnChangeSex:(id)sender {
    

}

- (IBAction)btnChangeNationality:(id)sender {

}

- (IBAction)btnChangeCertificationType:(id)sender {

    
}

-(void)viewDidAppear:(BOOL)animated
{
    scrMainScrollView.contentSize=CGSizeMake(320, 568);
}

#pragma mark Textview Delegate
- (void)textViewDidChange:(UITextView *)textView
{


}
- (void)textViewDidEndEditing:(UITextView *)textView
{

    _strUserFamliyAddress=textView.text;
  

}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 10:
        {
            _strUserName=textField.text;
            
        }
            break;
        case 11:
        {
            _strUserSex=textField.text;
            
        }
            break;
        case 12:
        {
            _strUserJob=textField.text;
            
        }
        case 13:
        {
            _strUserNationlilty=textField.text;
            
        }
        case 14:
        {
            _strUserCertificationType=textField.text;
            
        }
        case 15:
        {
            _strUserCertificationNumber=textField.text;
            
        }
        case 16:
        {
            _strUserValidDuration=textField.text;
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 测试数据代理方法
-(void)senderStr:  (NSString   *)str withTag:(int)tag
{
    if (tag==5) {

    }else if (tag==6){
        
        vNationaltyRow.tfRightTextField.text=str;
        
    }else if (tag==7){
        
        vCertificationTypeRow.tfRightTextField.text=str;
    }
    
}



@end

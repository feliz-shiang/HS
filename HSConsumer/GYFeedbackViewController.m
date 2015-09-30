//
//  GYFeedbackViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYFeedbackViewController.h"
#import "GlobalData.h"
#import "Utils.h"
#import "UIAlertView+Blocks.h"
#import "GYEasyPurchaseMainViewController.h"
@interface GYFeedbackViewController ()

@end

@implementation GYFeedbackViewController
{
    Utils *uti;
    NSString *alarttext;
    __weak IBOutlet UIView *vFeedbackBackground;//反馈的背景view
    
    __weak IBOutlet UILabel *lbPlaceHolderText;//lb 用户placeholder
    
    __weak IBOutlet UITextView *tvInputFeedback;//tv输入返回fdsaf
    
    __weak IBOutlet UIView *vMailBackground;//输入账号或邮箱的背景view
    
    __weak IBOutlet UITextField *tfInputMail;//输入邮箱TF
    
    __weak IBOutlet UIButton *btnCommit;//提交btn
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=kDefaultVCBackgroundColor;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=kLocalized(@"feedback");
    alarttext=@"";
    tvInputFeedback.delegate=self;
  
    // Do any additional setup after loading the view from its nib.
    [self setText];
    [self setTextColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    
 
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)textChange
{
    if ([tvInputFeedback hasText]) {
        lbPlaceHolderText.hidden = YES;
    }else{
        lbPlaceHolderText.hidden = NO;
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setTextColor
{
    vFeedbackBackground.backgroundColor=[UIColor whiteColor];
    vMailBackground.backgroundColor=[UIColor whiteColor];
    [btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lbPlaceHolderText.textColor=kCellItemTextColor;
    [btnCommit setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    
}



-(void)setText
{
    [btnCommit setTitle:kLocalized(@"submit") forState:UIControlStateNormal];
    tfInputMail.placeholder=kLocalized(@"phonenumber_email");
    lbPlaceHolderText.text=kLocalized(@"feedback_placeholder");
    tvInputFeedback.userInteractionEnabled=YES;
    vFeedbackBackground.userInteractionEnabled=YES;
    
}

#pragma mark textview 代理方法
- (void)textViewDidChange:(UITextView *)textView
{

}

 

////////////
//-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
// 
//    return YES;
//
//}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _strContent=textView.text;

}

#pragma mark textFiled

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([Utils isMobileNumber:textField.text]&&textField.text.length<12) {
        
        _strContact=textField.text;
        
    }
    else if ([Utils isValidateEmail:textField.text]&& textField.text.length>5 &&textField.text.length<31) {
        _strContact =textField.text;
    }
    else{
        alarttext=@"请输入正确的电话号码或邮箱！";
    }
    
    
}

- (IBAction)btnSubmit:(id)sender {
    [Utils hideKeyboard];
    NSString *message;
    if ( [Utils isBlankString:_strContent]) {
        message= @"请输入反馈内容！";
    }else if (tvInputFeedback.text.length>300){
        message=@"内容请不要超过300字符！";
    }
    else if ([Utils isBlankString:_strContact])
    {
       message= @"请输入正确的电话号码或邮箱";
       
    }else{
        message =@"是否要提交？";
        [UIAlertView showWithTitle:nil message:message cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != 0)
            {
                DDLogDebug(@"取消");
                [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中..."];
                [self   loadDataFromNetwork];
            }
        }];
        return;
    }
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}


-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue:_strContact forKey:@"contact" ];
    [ dict setValue:_strContent forKey:@"content" ];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/feedback"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view.window];
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
          
            if (!error) {

                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                av.tag=100;
                [self.navigationController popViewControllerAnimated:YES];
                [av show];
                
            } else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                [av show];
            }
            
        }else
        {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
            [av show];
        }
    }];
    
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//       [self.navigationController popViewControllerAnimated:YES];

}

@end

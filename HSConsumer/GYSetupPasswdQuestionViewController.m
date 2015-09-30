//
//  GYSetupPasswdQuestionViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSetupPasswdQuestionViewController.h"

//#import "GYTestTableViewController.h"
#import "UIButton+enLargedRect.h"
#import "UIView+CustomBorder.h"
#import  "GlobalData.h"


@interface GYSetupPasswdQuestionViewController ()

@end

@implementation GYSetupPasswdQuestionViewController
{
    
    __weak IBOutlet UILabel *lbQuestion;
    
    __weak IBOutlet UILabel *lbAnswer;
    
    __weak IBOutlet UITextField *tfQuestion;
    
    __weak IBOutlet UITextField *tfAnswer;
    
    __weak IBOutlet UIButton *btnChoose;
    
    __weak IBOutlet UIView *vUpBgView;
    
    __weak IBOutlet UILabel *lbTips;
    
    __weak IBOutlet UIView *vDownBgView;
    
    
    GYQuestionModel * Globalmodel;
    
}

- (IBAction)btnChooseMethod:(id)sender {
    
    GYChooseQuestionTableViewController *vcChooseQuestion =[[GYChooseQuestionTableViewController alloc]initWithNibName:@"GYChooseQuestionTableViewController" bundle:nil];
  vcChooseQuestion.Delegate=self;

    [self.navigationController pushViewController:vcChooseQuestion animated:YES];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=kLocalized(@"pwd_prompt_question");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [btnChoose setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu1.png"] forState:UIControlStateNormal];
    [self modifyName];
    [self setSeprator];
    [self setTextColor];
    //修改导航栏右边按钮
    UIButton * btnRight =[UIButton buttonWithType: UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 44, 44);
    [btnRight setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    tfAnswer.placeholder=kLocalized(@"input_your_answer");
    tfQuestion.placeholder=kLocalized(@"input_your_question");
    [Utils setPlaceholderAttributed:tfAnswer withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [btnChoose setEnlargEdgeWithTop:20.0 right:20.0 bottom:20.0 left:10.0];

  
}
-(void)LoadDataFromNetwork
{
    
    
 
    
    if ([Utils isBlankString: tfAnswer.text] ) {
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:@"输入问题为空，请重新输入" delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [alertV show];
        return ;
    }else if([Utils isBlankString:_strAnswer])
    {
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:@"输入答案为空，请重新输入" delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [alertV show];
        return ;

    }else {
        
       
        
    }
     [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:[NSString stringWithFormat:@"%@",Globalmodel.strQuestionId] forKey:@"id"];
   
    [dictInside setValue:tfAnswer.text forKey:@"content"];
     [dictInside setValue:tfQuestion.text forKey:@"answer"];

    
     NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
 
    [dict setValue:@"save_password_hint_answer" forKeyPath:@"cmd"];


    //测试get
    
     [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
         NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [ Utils  hideHudViewWithSuperView :self.view] ;
         NSLog(@"%@----dic",ResponseDic);
         if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
             
          
             NSString * message =[[ResponseDic objectForKey:@"data"] objectForKey:@"resultMsg"];
             
             
             [UIAlertView showWithTitle:nil message:message cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             
         }
     }];


}



#pragma mark textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==10) {
        _strContent=textField.text;
    }else
    {
        _strAnswer=textField.text;
    }

}

-(void)modifyName
{
    tfQuestion.backgroundColor=[UIColor whiteColor];
    tfAnswer.backgroundColor=[UIColor whiteColor];
    lbQuestion.text=kLocalized(@"problem");
    lbAnswer.text=kLocalized(@"answer");
    lbTips.text=kLocalized(@"question_and_answer_comment");
    
}

//设置label的字体颜色
-(void)setTextColor
{
    lbTips.textColor=kCellItemTextColor;
    lbAnswer.textColor=kCellItemTitleColor;
    lbQuestion.textColor=kCellItemTitleColor;
    tfAnswer.textColor=kCellItemTitleColor;
    tfAnswer.enabled=NO;
    tfQuestion.textColor=kCellItemTitleColor;
    
}

//设置分割线
-(void)setSeprator
{
    [vUpBgView addAllBorder];
    [vDownBgView addAllBorder];
}

-(void)confirmAction
{
    DDLogInfo(@"确定按钮被点击");
    [Utils hideKeyboard];
[self LoadDataFromNetwork];
    
}


#pragma mark 选择问题的回调方法。
-(void)selectedOneQuestion:(GYQuestionModel *)Model
{
    tfAnswer.text=Model.strQuestion;
    Globalmodel=Model;
}


@end

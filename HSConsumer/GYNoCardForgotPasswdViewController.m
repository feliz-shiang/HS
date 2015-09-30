//
//  GYNoCardForgotPasswdViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-23.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYNoCardForgotPasswdViewController.h"
#import "MenuTabView.h"
#import "UIView+CustomBorder.h"
#import "GYGetPasswordHitViewController.h"
#import "LoginEn.h"
#import "GYReSetPasswordViewController.h"
#import "CustomIOS7AlertView.h"
@interface GYNoCardForgotPasswdViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>

@end

@implementation GYNoCardForgotPasswdViewController

{
    __weak IBOutlet UIScrollView *scrollV;

   
    NSArray * menuTtles;
    
    MenuTabView *menu;      //菜单视图
    
    UIView *   vBigBackgroundInFirst;
    
    UIView * vBigBackgroundInSecond;
    
    UIView * vBackgroundInFirst;
    
    UILabel * lbInputCardNoInFirst;
    
    UITextField * tfTextInputInFirst ;
    
    UIView * vBackgroundInThird;

    UITextField * tfTextInputInThird;
    
    UIView *   vBigBackgroundInThird;
    
    UILabel *  lbInputCardNoInThird;
    
    NSMutableArray * marrTextFieldTwo;
    
    NSMutableArray * marrTextFieldOne;
    
    NSInteger btnIndex;
    
    NSString * strEmail;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题数组
    menuTtles = @[kLocalized(@"cell_Phone_retrieve_pwd"),
              
                   kLocalized(@"email")];
    
    CGRect scrFrame = scrollV.frame;
    marrTextFieldOne=[NSMutableArray array];
    marrTextFieldTwo=[NSMutableArray array];
    scrFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    [scrollV setFrame:scrFrame];
    
    [scrollV setPagingEnabled:YES];
    [scrollV setBounces:NO];
    [scrollV setShowsHorizontalScrollIndicator:NO];
    
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.tag=1;
    btnRight.frame=CGRectMake(0, 0, 40, 40);
    
    [btnRight setTitle:@"确认" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];

    
    scrollV.delegate = self;
    //    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [_scrollV setUserInteractionEnabled:YES];
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * menuTtles.count, 0)];
    [scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
    
//    CGRect vFrame = scrollV.bounds;
//    vFrame.origin.y=vFrame.origin.y+kDefaultMarginToBounds;
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTtles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;

    [self.view addSubview:menu];
    
    CGRect vFrame = scrollV.bounds;
    vFrame.origin.y=vFrame.origin.y+kDefaultMarginToBounds+40;
    
    vBigBackgroundInFirst =[[UIView alloc]init];
    vBigBackgroundInFirst.frame=vFrame;

    for (int i=0; i<2; i++) {
        
        vBackgroundInFirst=[[UIView alloc]init];
        
        lbInputCardNoInFirst=[[UILabel alloc]init];
        
        tfTextInputInFirst =[[UITextField alloc]init];

        [marrTextFieldOne addObject:tfTextInputInFirst];
        
        //默认显示手机号码找回。
        [self firstBtnClicked:i];
    }

    vFrame.origin.x += vFrame.size.width;
    [scrollV addSubview:vBigBackgroundInFirst];
    vBigBackgroundInThird =[[UIView alloc]init];
    vBigBackgroundInThird.frame=vFrame;

    for(int i=0; i<1; i++) {
        lbInputCardNoInThird=[[UILabel alloc]init];
        
        vBackgroundInThird =[[UIView alloc]init];
        tfTextInputInThird =[[UITextField alloc]init];
        [marrTextFieldTwo addObject:tfTextInputInThird];
        [self thirdBtnClicked:i];
        
    }
    
        [scrollV addSubview:vBigBackgroundInThird];
    
}


-(void)btnClicked:(UIButton * )sender
{
    switch (btnIndex) {
        case 0:
        {
            [self    findPasswordByPhone];
        }
            break;
        case 1:
        {
            [self    findPasswdByEmailRequest];
        }
            break;
        default:
            break;
    }



}

//第一个btn调用的方法
-(void)firstBtnClicked:(int)i
{
    vBackgroundInFirst.frame=CGRectMake(0,0, 320, 44);
    [vBackgroundInFirst addAllBorder];
    CGRect rect =vBackgroundInFirst.frame;
    rect.origin.y=0+(44-1)*i;
    vBackgroundInFirst.frame=rect;
    vBackgroundInFirst.backgroundColor=[UIColor whiteColor];
    lbInputCardNoInFirst.frame =CGRectMake(15, 7, 100, 30);
    lbInputCardNoInFirst.textColor=kCellItemTitleColor;
    
    if (kSystemVersionGreaterThan(@"7.0")) {
        tfTextInputInFirst.frame =CGRectMake(lbInputCardNoInFirst.frame.origin.x+lbInputCardNoInFirst.frame.size.width, lbInputCardNoInFirst.frame.origin.y, 120, 30);
    }
    else
    {
          tfTextInputInFirst.frame =CGRectMake(lbInputCardNoInFirst.frame.origin.x+lbInputCardNoInFirst.frame.size.width+10, lbInputCardNoInFirst.frame.origin.y+5, 120, 30);
    
    }

   

     if (i==0){
        
        lbInputCardNoInFirst.text=kLocalized(@"cell_phone_number");
        tfTextInputInFirst.placeholder=kLocalized(@"input_phone_number");

         [tfTextInputInFirst addTarget:self action:@selector(tfPhoneNumDidEditing:) forControlEvents:UIControlEventEditingChanged];
         
    }else {
        
        lbInputCardNoInFirst.text=kLocalized(@"verification_code");
        tfTextInputInFirst.placeholder=kLocalized(@"input_validation_code");
        
        UIButton * btnGetCode =[UIButton buttonWithType:UIButtonTypeCustom];
        btnGetCode.frame=CGRectMake(tfTextInputInFirst.frame.origin.x+tfTextInputInFirst.frame.size.width-20, tfTextInputInFirst.frame.origin.y
                                    , 90, 30) ;
        btnGetCode.titleLabel.font=[UIFont systemFontOfSize:17.0f];
        [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
        [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        
        [self setBorderWithView:btnGetCode WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
        [btnGetCode addTarget:self action:@selector(btnGetCode) forControlEvents:UIControlEventTouchUpInside];
        
        [vBackgroundInFirst addSubview:btnGetCode];
    }
    
    [vBackgroundInFirst addSubview:lbInputCardNoInFirst];
    [vBackgroundInFirst addSubview:tfTextInputInFirst];
    [vBigBackgroundInFirst addSubview:vBackgroundInFirst];
 
    
}

//通过手机号码找回密码
-(void)findPasswordByPhone
{
    UITextField * tfPhone = marrTextFieldOne[0];
    UITextField * tfCode = marrTextFieldOne[1];

    if ([Utils isBlankString:tfPhone.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }else if ([Utils isBlankString:tfCode.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入验证码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    
    if (![Utils isMobileNumber:tfPhone.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    if (![Utils isValidMobileNumber:tfCode.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的验证码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }

    
    NSDictionary *allParas = @{@"account": tfPhone.text,
                               @"code": tfCode.text
                               };
    
    NSString *urlString = [[GlobalData shareInstance]ecDomain];
    urlString = [urlString stringByAppendingString:@"/user/checkMobileCode"];
 
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    
    [Network HttpGetForRequetURL:urlString parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
           
            
            if (!error) {
                
                NSString * retCode =  kSaftToNSString(ResponseDic [@"retCode"]);
                
                if ([retCode isEqualToString:@"200"]) {
             
                    
                    GYReSetPasswordViewController * ResetVC =[[GYReSetPasswordViewController alloc]initWithNibName:@"GYReSetPasswordViewController" bundle:nil];
                    ResetVC.resourceNumber=tfPhone.text;
                    ResetVC.fromNocard=YES;
                    [self.navigationController pushViewController:ResetVC animated:YES];
                    

                }else if ([retCode isEqualToString:@"617"])
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"验证码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];

                }
                else
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    
                }

            }
            
        }
        
    }];
    
}

-(void)btnGetCode
{
    UITextField * textField = marrTextFieldOne[0];
    
    if (![Utils checkTel:textField.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    

    NSString *urlString = [[GlobalData shareInstance]ecDomain];
    urlString = [urlString stringByAppendingString:@"/user/sendShortMsg"];
    

    NSDictionary *allParas = @{@"accountNo": textField.text,
                               @"isCheck": @"1"
                               };

    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    
    [Network HttpGetForRequetURL:urlString parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * retCode = kSaftToNSString(ResponseDic[@"retCode" ]);
            if (!error) {
                if ([retCode isEqualToString:@"200"]) {
                    NSLog(@"成功获取有效数据");
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }else
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    
                }
 
            }
            
            
        }
        
    }];
    
    
}

-(void)findPasswdByEmailRequest
{
    
   UITextField * tfEmail = marrTextFieldTwo [0];
    strEmail=tfEmail.text;
    if ([Utils isBlankString:tfEmail.text])
    {
        
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"输入邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    if (![Utils isValidateEmail:tfEmail.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"输入邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    NSString *urlString = [[GlobalData shareInstance]ecDomain];
    urlString = [urlString stringByAppendingString:@"/user/sendEmail"];
    
    
    NSDictionary *allParas = @{@"email": tfEmail.text  };

    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * code =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            if ([code isEqualToString:@"200"]) {

                [self showAlertview];
                
            }else if ([code isEqualToString:@"654"])
            {
                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱不存在！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
            
            else
            {
                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            
        }
        
    }];
    
}


-(void)showAlertview
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
              buttonIndex, (int)[alertView tag]);
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [alertView close];
        
        
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    alertView.lineView.hidden=YES;
    
    alertView.lineView1.hidden=YES;
    
    
}

-(UIView *)createUI
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 110)];
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 52   ,52)];
    successImg.image=[UIImage imageNamed:@"img_email_banding.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 20, 160, 25)];
    lbTip.text=@"验证邮件已经发送";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardComment =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, lbTip.frame.origin.y+lbTip.frame.size.height, 160, 25)];
    lbCardComment.text=strEmail;
    lbCardComment.textColor=[UIColor orangeColor];
    lbCardComment.font=[UIFont systemFontOfSize:17.0];
    lbCardComment.backgroundColor=[UIColor clearColor];
    
    UILabel *  lbBandNumber =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10,lbCardComment.frame.origin.y+lbCardComment.frame.size.height, 200, 25)];
    lbBandNumber.text=@"请及时登录邮箱找回密码。";
    lbBandNumber.textColor=kCellItemTitleColor;
    lbBandNumber.font=[UIFont systemFontOfSize:16.0];
    lbBandNumber.backgroundColor=[UIColor clearColor];
    [popView addSubview:successImg];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardComment];
    [popView addSubview:lbBandNumber];
    return popView;
}


//第三个btn调用的方法
-(void)thirdBtnClicked: (int)i
{
    //第三个btn对应的view  只有两行。按照之前的逻辑，会在把之前遗留的第三行显示出来，所以需要添加一个大的背景view覆盖之前的view
    
    vBigBackgroundInThird.backgroundColor=kDefaultVCBackgroundColor;
    vBackgroundInThird.frame=CGRectMake(0,0, 320, 44);
    vBackgroundInThird.backgroundColor=[UIColor whiteColor];
    [vBackgroundInThird addAllBorder];
    
    lbInputCardNoInThird.textColor=kCellItemTitleColor;
      lbInputCardNoInThird.frame=CGRectMake(15, 7, 50, 30);

    if (kSystemVersionGreaterThan(@"7.0")) {
     tfTextInputInThird.frame=CGRectMake(lbInputCardNoInThird.frame.origin.x+lbInputCardNoInThird.frame.size.width+10, lbInputCardNoInThird.frame.origin.y, 180, 30);
    }else
    {
    
       tfTextInputInThird.frame=CGRectMake(lbInputCardNoInThird.frame.origin.x+lbInputCardNoInThird.frame.size.width+10, lbInputCardNoInThird.frame.origin.y+5, 180, 30);
    }
    
    
    CGRect rect =vBackgroundInThird.frame;
    tfTextInputInThird.font=[UIFont systemFontOfSize:15.0];
    rect.origin.y=0+(44-1)*i;//-1是因为从边框向后加view时，上面的view和下面的view两个边框会使中间的分割线变粗。
    vBackgroundInThird.frame=rect;

    lbInputCardNoInThird.text=kLocalized(@"email");
    tfTextInputInThird.placeholder=kLocalized(@"input_email");
    [vBackgroundInThird addSubview:lbInputCardNoInThird];
    [vBackgroundInThird addSubview:tfTextInputInThird];
    [vBigBackgroundInThird addSubview:vBackgroundInThird];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrollV)//因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
    {
        CGFloat _x = scrollView.contentOffset.x;//滑动的即时位置x坐标值
        btnIndex = (NSInteger)(_x / self.view.frame.size.width);//所偶数当前视图
        
        //设置滑动过渡位置
        if (btnIndex < menu.selectedIndex)
        {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:btnIndex];
                //                [self.navigationItem setTitle:menuTitles[index]];
            }
        }else if (btnIndex == menu.selectedIndex)
        {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:btnIndex + 1];
                //                [self.navigationItem setTitle:menuTitles[index + 1]];
            }
        }else
        {
            [menu updateMenu:btnIndex];
            //            [self.navigationItem setTitle:menuTitles[index]];
        }
    }
}





-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    if (width == 0)
    {
        [view removeAllBorder];
    }else
    {
        [view addAllBorder];
    }
  
    
}
#pragma mark phoneNumEditing
- (void)tfPhoneNumDidEditing:(UITextField*)field
{
    NSString *str = field.text;
    
    if (str&&str.length>=11) {
        
        field.text = [str substringToIndex:11];
    }
}

@end

//
//  GYForgotPasswdViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYForgotPasswdViewController.h"
#import "MenuTabView.h"

#import "UIView+CustomBorder.h"
#import "GYReSetPasswordViewController.h"
#import "GYGetPasswordHitViewController.h"
#import "GYQuestionModel.h"
#import "LoginEn.h"
#import "CustomIOS7AlertView.h"
#import "GYencryption.h"
#import "NSData+Base64.h"

@interface GYForgotPasswdViewController ()<UIScrollViewDelegate, MenuTabViewDelegate,selectQuestionForNoLoginDelegate>
{
//    GlobalData *data;   //全局单例
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
//    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view

    UIView * vBackgroundInFirst;
    
    UILabel * lbInputCardNoInFirst;
    
    UITextField * tfTextInputInFirst ;
    
    UIView * vBackgroundInSecond;
    
    UILabel * lbInputCardNoInSecond ;
    
    UITextField * tfTextInputInSecond ;
    
    UIView *   vBigBackgroundInThird;
    
    UIView * vBackgroundInThird;
    
    UILabel * lbInputCardNoInThird;
    
    UITextField * tfTextInputInThird;
    
    UIView *   vBigBackgroundInFirst;
    
    UIView * vBigBackgroundInSecond;
    
    NSMutableArray * marrDataSource;
    
    UILabel * lbfavoriteBook;
    
    NSString * strQuestionId;
    
    NSInteger btnIndex;
    
    NSMutableArray * marrTextFieldOne;
    
    NSMutableArray * marrTextFieldTwo;
    
    NSMutableArray * marrTextFieldThree;
    
    NSString * strEmail ;
    
    NSString * keyForGetPwd;
    
    NSString * cKey;

}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYForgotPasswdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    marrTextFieldOne=[NSMutableArray array];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    marrDataSource = [NSMutableArray array];
    marrTextFieldTwo = [NSMutableArray array];
    marrTextFieldThree = [NSMutableArray array];
    
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.tag=1;
    btnRight.frame=CGRectMake(0, 0, 40, 40);
    
    [btnRight setTitle:@"确认" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    

    //设置标题数组
    menuTitles = @[kLocalized(@"cell_Phone_retrieve_pwd"),
                   kLocalized(@"pwd_prompt_question"),
                   kLocalized(@"email")];
    
    CGRect scrFrame = _scrollV.frame;
    scrFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    [_scrollV setFrame:scrFrame];
    
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    
    _scrollV.delegate = self;
    //    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [_scrollV setUserInteractionEnabled:YES];
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 0)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
    //添加要加入的VIEWS==============================================================
    //    arrParentViews = [NSMutableArray array];
    CGRect vFrame = _scrollV.bounds;
    vFrame.origin.y=vFrame.origin.y+kDefaultMarginToBounds;
    
    vBigBackgroundInFirst =[[UIView alloc]init];
    vBigBackgroundInFirst.frame=vFrame;
    //    vBigBackgroundInFirst.backgroundColor=[UIColor redColor];
    for (int i=0; i<3; i++) {
        
        vBackgroundInFirst=[[UIView alloc]init];
        
        lbInputCardNoInFirst=[[UILabel alloc]init];
        
        tfTextInputInFirst =[[UITextField alloc]init];
        tfTextInputInFirst.keyboardType=UIKeyboardTypeNumberPad;
        tfTextInputInFirst.delegate=self;
        tfTextInputInFirst.tag=i;
        tfTextInputInFirst.textColor=kCellItemTitleColor;
        [tfTextInputInFirst becomeFirstResponder];
        [marrTextFieldOne addObject:tfTextInputInFirst];
        //默认显示手机号码找回。
        [self firstBtnClicked:i];
    }
    //    [self firstBtnClicked:3];
    [_scrollV addSubview:vBigBackgroundInFirst];
    
    vFrame.origin.x += vFrame.size.width;
    
    vBigBackgroundInSecond =[[UIView alloc]init];
    vBigBackgroundInSecond.frame=vFrame;
    for(int i=0; i<3; i++) {
        vBackgroundInSecond =[[UIView alloc]init];
        lbInputCardNoInSecond =[[UILabel alloc]init];
        tfTextInputInSecond =[[UITextField alloc]init];
        tfTextInputInSecond.textColor=kCellItemTitleColor;
        tfTextInputInThird.delegate=self;
        if (i==0) {
            tfTextInputInSecond.keyboardType=UIKeyboardTypeNumberPad;
        }
        tfTextInputInSecond.tag=10+i;
        [marrTextFieldTwo addObject:tfTextInputInSecond];
      
        [self secondBtnClicked:i];
    }
    [_scrollV addSubview:vBigBackgroundInSecond];
    
    vFrame.origin.x += vFrame.size.width;
    
    vBigBackgroundInThird =[[UIView alloc]init];
    vBigBackgroundInThird.frame=vFrame;
    for(int i=0; i<2; i++) {
        
        vBackgroundInThird =[[UIView alloc]init];
        tfTextInputInThird =[[UITextField alloc]init];
        tfTextInputInThird.keyboardType=UIKeyboardTypeNumberPad;
          tfTextInputInThird.autocorrectionType = UITextAutocorrectionTypeNo;
        if (i==1) {
            tfTextInputInThird.keyboardType = UIKeyboardTypeEmailAddress;
            tfTextInputInThird.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        tfTextInputInThird.delegate=self;
        tfTextInputInThird.tag=i+20;
        [marrTextFieldThree addObject:tfTextInputInThird];
        [self thirdBtnClicked:i];
        
    }
    [_scrollV addSubview:vBigBackgroundInThird];
    
    //==============================================================

    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
//    [menu setDefaultItem:1];//设置默认选项
    [self.view addSubview:menu];
    
    [self getDefaultKey];
    
    
}


///点击屏幕收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.view endEditing:YES];
    }
}
-(void)loadDataFromNetwork
{
    
//    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
//    [dictInside setValue:@"" forKey:@"resource_no"];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    NSString *str = [NSString stringWithFormat:@"{resource_no=%@}", @""];

    str = [GYencryption h2:str k:cKey];
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    str = [strData base64EncodedString];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [Network urlEncoderParameter:str];

    [dict setValue:str forKey:@"params"];

    [dict setValue:keyForGetPwd forKey:@"key"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[Utils getRandomString:6] forKey:@"mId"];
    [dict setValue:@"get_password_hint" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            NSString * code =[NSString stringWithFormat:@"%@",ResponseDic[@"code"]];
            if ([code isEqualToString:@"SVC0000"]) {
                for (NSDictionary * tempDict in ResponseDic[@"data"][@"questions"]) {
                    GYQuestionModel * model = [[GYQuestionModel alloc]init];
                    model.strQuestion=tempDict[@"question"];
                    model.strQuestionId=tempDict[@"questionId"];
                    
                    [marrDataSource addObject:model];
                    
                }
           [self setFavoriteBook];
                
            }
            
        }
        
    }];
    
}



-(void)comfirm
{
    GYReSetPasswordViewController * vcResetPWD =[[GYReSetPasswordViewController alloc]initWithNibName:@"GYReSetPasswordViewController" bundle:nil];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vcResetPWD animated:YES];

}

#pragma mark - pushVC

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    //add by zhangqy 直接切换到密码问题或者邮箱页面显示为空白
    [self.view endEditing:YES];
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index ) return;
    
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                             _scrollV.frame.origin.y,
                                             _scrollV.frame.size.width,
                                             _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
//    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //add by zhangqy 直接切换到密码问题或者邮箱页面显示为空白
    [self.view endEditing:YES];
//    if (scrollView == _scrollV)//因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
//    {
        CGFloat _x = scrollView.contentOffset.x;//滑动的即时位置x坐标值
        btnIndex = (NSInteger)(_x / self.view.frame.size.width);//所偶数当前视图
        NSLog(@"%d-------index",btnIndex);
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
//    }
}

//第一个btn调用的方法
-(void)firstBtnClicked:(int)i
{
    vBackgroundInFirst.frame=CGRectMake(0,0, 320, 44);
    CGRect rect =vBackgroundInFirst.frame;
    rect.origin.y=0+(44-1)*i;
    vBackgroundInFirst.frame=rect;
    vBackgroundInFirst.backgroundColor=[UIColor whiteColor];
    lbInputCardNoInFirst.frame =CGRectMake(15, 5, 100, 30);
    lbInputCardNoInFirst.textColor=kCellItemTitleColor;
    tfTextInputInFirst.frame =CGRectMake(lbInputCardNoInFirst.frame.origin.x+lbInputCardNoInFirst.frame.size.width, lbInputCardNoInFirst.frame.origin.y, 120, 30);
   
    [self setBorderWithView:vBackgroundInFirst WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
    if (i==0) {
        
        lbInputCardNoInFirst.text=kLocalized(@"points_card_number");
        tfTextInputInFirst.placeholder=kLocalized(@"input_points_card_number");
                [tfTextInputInFirst addTarget:self action:@selector(tfPhoneNumDidEditing:) forControlEvents:UIControlEventEditingChanged];
       
    }else if (i==1){
        
        lbInputCardNoInFirst.text=kLocalized(@"cell_phone_number");
        tfTextInputInFirst.placeholder=kLocalized(@"input_phone_number");
        /**
         *  zhangqy
         */
        [tfTextInputInFirst addTarget:self action:@selector(tfPhoneNumDidEditing:) forControlEvents:UIControlEventEditingChanged];
    }else {
        
        lbInputCardNoInFirst.text=kLocalized(@"verification_code");
        tfTextInputInFirst.placeholder=kLocalized(@"input_validation_code");
        tfTextInputInFirst.secureTextEntry=YES;
        
        UIButton * btnGetCode =[UIButton buttonWithType:UIButtonTypeCustom];
        btnGetCode.frame=CGRectMake(tfTextInputInFirst.frame.origin.x+tfTextInputInFirst.frame.size.width-20, tfTextInputInFirst.frame.origin.y
                                    , 90, 30) ;
        btnGetCode.titleLabel.font=[UIFont systemFontOfSize:17.0f];
        [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
        [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
            btnGetCode.layer.borderColor = kNavigationBarColor.CGColor;
            btnGetCode.layer.cornerRadius = 3;
            btnGetCode.layer.masksToBounds=YES;
            btnGetCode.layer.borderWidth=1;
        
        [self setBorderWithView:btnGetCode WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
        [btnGetCode addTarget:self action:@selector(btnGetCode) forControlEvents:UIControlEventTouchUpInside];
        
        [vBackgroundInFirst addSubview:btnGetCode];
    }
    
    [vBackgroundInFirst addSubview:lbInputCardNoInFirst];
    [vBackgroundInFirst addSubview:tfTextInputInFirst];
    [vBigBackgroundInFirst addSubview:vBackgroundInFirst];

    
    
}


//第二个btn调用的方法
-(void)secondBtnClicked:(int)i
{    //每次循环都 分别创建对应的控件
    
    vBackgroundInSecond.frame=CGRectMake(0,0, 320, 44);
    vBackgroundInSecond.backgroundColor=[UIColor whiteColor];
    lbInputCardNoInSecond.frame=CGRectMake(15, 5, 100, 30);
    lbInputCardNoInSecond.textColor=kCellItemTitleColor;
    tfTextInputInSecond.frame=CGRectMake(lbInputCardNoInSecond.frame.origin.x+lbInputCardNoInSecond.frame.size.width+5, lbInputCardNoInSecond.frame.origin.y, 180, 30);
    [self setBorderWithView:vBackgroundInSecond WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
    CGRect rect =vBackgroundInSecond.frame;//每次变化的是vbackground.frame 需要动态指定
    rect.origin.y=0+(44-1)*i;//44-1 是行高－1 边框是在view的范围的。所以－1让下一个view和上面一个view的边框重合，避免边框过宽（2像素）
    vBackgroundInSecond.frame=rect;
    
    if (i==0) {
        lbInputCardNoInSecond.text=kLocalized(@"points_card_number");//设置文本
        tfTextInputInSecond.placeholder=kLocalized(@"input_points_card_number");//设置文本占位符
    }else if (i==1){
        //设置第二行的内容。
        lbInputCardNoInSecond.text=kLocalized(@"problem");
        CGRect rect =tfTextInputInSecond.frame;
        rect.origin.y=rect.origin.y-5;
        rect.size.width=rect.size.width+50;

        tfTextInputInSecond.hidden=NO;
        [vBackgroundInSecond addSubview:lbfavoriteBook];
        UIButton * btnQuestion =[UIButton buttonWithType:UIButtonTypeCustom];
        btnQuestion.frame=CGRectMake(305, 12, 10 , 16);
        [btnQuestion setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu1.png"] forState:UIControlStateNormal];
        [btnQuestion addTarget:self action:@selector(getQuestion) forControlEvents:UIControlEventTouchUpInside];
        [vBackgroundInSecond addSubview:btnQuestion];
        
        
    }else {
        lbInputCardNoInSecond.text=kLocalized(@"answer");
        tfTextInputInSecond.placeholder=@"输入答案";
    }
    [vBackgroundInSecond addSubview:lbInputCardNoInSecond];
    [vBackgroundInSecond addSubview:tfTextInputInSecond];
    //添加到 父试图中。
    [vBigBackgroundInSecond addSubview:vBackgroundInSecond];
   

    
}

//第三个btn调用的方法
-(void)thirdBtnClicked: (int)i
{
    //第三个btn对应的view  只有两行。按照之前的逻辑，会在把之前遗留的第三行显示出来，所以需要添加一个大的背景view覆盖之前的view
    
    
    vBigBackgroundInThird.backgroundColor=kDefaultVCBackgroundColor;
    vBackgroundInThird.frame=CGRectMake(0,0, 320, 44);
    vBackgroundInThird.backgroundColor=[UIColor whiteColor];
    
    lbInputCardNoInThird.frame=CGRectMake(15, 5, 100, 30);
    lbInputCardNoInThird.textColor=kCellItemTitleColor;
    
    tfTextInputInThird.frame=CGRectMake(lbInputCardNoInThird.frame.origin.x+lbInputCardNoInThird.frame.size.width+10, lbInputCardNoInThird.frame.origin.y+5, 180, 30);
    [self setBorderWithView:vBackgroundInThird WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
    CGRect rect =vBackgroundInThird.frame;
    rect.origin.y=0+(44-1)*i;//-1是因为从边框向后加view时，上面的view和下面的view两个边框会使中间的分割线变粗。
    vBackgroundInThird.frame=rect;
    if (i==0) {
        lbInputCardNoInThird.text=kLocalized(@"points_card_number");
        tfTextInputInThird.placeholder=kLocalized(@"input_points_card_number");
    }else if (i==1){
        lbInputCardNoInThird.text=kLocalized(@"email");
        tfTextInputInThird.placeholder=kLocalized(@"input_email");
    }
    [vBackgroundInThird addSubview:lbInputCardNoInThird];
    [vBackgroundInThird addSubview:tfTextInputInThird];
    [vBigBackgroundInThird addSubview:vBackgroundInThird];
    
}


-(void)btnGetCode
{
    UITextField * tfResourceNum = marrTextFieldOne[0];
    UITextField * tfPhone = marrTextFieldOne[1];
    if (![Utils checkTel:tfPhone.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    if (![Utils isHSCardNo:tfResourceNum.text])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入11位合法的互生号." isPopVC:nil];
        return;
    }
    
    if ([Utils isBlankString:tfResourceNum.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入互生号." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    if ([Utils isBlankString:tfPhone.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    NSString *params = [NSString stringWithFormat:@"{resource_no=%@,mobile=%@}", tfResourceNum.text, tfPhone.text];
    params = [GYencryption h2:params k:cKey];
    NSData *strData = [params dataUsingEncoding:NSUTF8StringEncoding];
    params = [strData base64EncodedString];
    params = [params stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    params = [params stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    params = [Network urlEncoderParameter:params];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:params forKey:@"params"];

    [dict setValue:keyForGetPwd forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [Utils getRandomString:6]}];
    
    [dict setValue:@"get_mobile_verification_code" forKeyPath:@"cmd"];
    
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        if (error) {
            NSLog(@"%@----",error);
        }else{
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
    }];
}

-(void)getQuestion
{
    GYGetPasswordHitViewController * vcChooseQuestion =[[GYGetPasswordHitViewController alloc]initWithNibName:@"GYGetPasswordHitViewController" bundle:nil];
    self.hidesBottomBarWhenPushed=YES;
    vcChooseQuestion.delegate=self;
    vcChooseQuestion.marrQuestion=marrDataSource;
    [self.navigationController pushViewController:vcChooseQuestion animated:YES];
}

-(void)btnClicked:(UIButton * )sender
{
    switch (btnIndex) {
        case 0:
        {
            [self findPasswordByPhone];
        }
            break;
        case 1:
        {
            [self submitWithQuestionRequest];
        }
            break;
        case 2:
        {
            [self findPasswdByEmailRequest];
        }
            break;
        default:
            break;
    }
    
}

//通过手机号码找回密码
-(void)findPasswordByPhone
{
    UITextField * tfResourceNum = marrTextFieldOne[0];
    UITextField * tfPhone = marrTextFieldOne[1];
    UITextField * tfCode = marrTextFieldOne[2];

    [tfResourceNum resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tfCode resignFirstResponder];
    
    if (![Utils isHSCardNo:tfResourceNum.text])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入11位合法的互生号." isPopVC:nil];
        return;
    }
    
    
    if ([Utils isBlankString:tfResourceNum.text]) {
        NSLog(@"%@--------aaaaa",tfResourceNum.text);
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入互生号." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if ([Utils isBlankString:tfPhone.text])
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
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    NSString *params = [NSString stringWithFormat:@"{resource_no=%@,mobile=%@,verification_code=%@}", tfResourceNum.text, tfPhone.text,tfCode.text];
    params = [GYencryption h2:params k:cKey];
    NSData *strData = [params dataUsingEncoding:NSUTF8StringEncoding];
    params = [strData base64EncodedString];
    params = [params stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    params = [params stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    params = [Network urlEncoderParameter:params];
   [dict setValue:params forKey:@"params"];
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];
    [dict setValue:keyForGetPwd forKey:@"key"];
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [Utils getRandomString:6]}];
    [dict setValue:@"check_mobile_and_verification_code" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        if (error) {
            NSLog(@"%@----",error);
            
        }else{
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view.window];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                _strResourceNum=tfResourceNum.text;
                [self resetPassword];
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        
    }];

}


-(void)resetPassword
{
    GYReSetPasswordViewController * vcReset = [[GYReSetPasswordViewController alloc]initWithNibName:@"GYReSetPasswordViewController" bundle:nil];
    vcReset.hidesBottomBarWhenPushed=YES;
    vcReset.resourceNumber=_strResourceNum;
    [self.navigationController pushViewController:vcReset animated:YES];
}


-(void)getDefaultKey
{
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/hs/login"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:@"0000" forKey:@"loginId"];
    
    [dict setValue:@"0000" forKey:@"pwd"];
    
    [dict setValue:@"00000000000" forKey:@"acc"];
    
    [dict setValue:@"00000000000" forKey:@"custId"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:@"4a3290d0-0a85-4c29-a62f-8009403e30c3" forKey:@"mId"];
    
    [dict setValue:@"check_password_hint_answer" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
        }
        else
        {
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * code =ResponseDic[@"code"];
            if ([code isEqualToString:@"SVC0000"]) {
                keyForGetPwd = ResponseDic[@"data"];
                cKey = ResponseDic [@"cKey"];
                
                [self loadDataFromNetwork];
            }
            
        }
        
    }];
    
}

-(void)submitWithQuestionRequest
{
    UITextField * tfResource = marrTextFieldTwo[0];
    UITextField * tfQuestion = marrTextFieldTwo[1];
    UITextField * tfAnswer = marrTextFieldTwo[2];
    
    if (![Utils isHSCardNo:tfResource.text])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入11位合法的互生号." isPopVC:nil];
        return;
    }
    
    if ([Utils isBlankString:tfResource.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入互生号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if ([Utils isBlankString:tfQuestion.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择问题。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }else if ([Utils isBlankString:tfAnswer.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入答案" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    NSString *params = [NSString stringWithFormat:@"{resource_no=%@,id=%@,content=%@,answer=%@}", tfResource.text,[NSString stringWithFormat:@"%@",strQuestionId], tfQuestion.text,tfAnswer.text];

    params = [GYencryption h2:params k:cKey];
    NSData *strData = [params dataUsingEncoding:NSUTF8StringEncoding];
    params = [strData base64EncodedString];
    params = [params stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    params = [params stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    params = [Network urlEncoderParameter:params];
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:params forKey:@"params"];
    
    [dict setValue:keyForGetPwd forKey:@"key"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[Utils getRandomString:6] forKey:@"mId"];
    [dict setValue:@"check_password_hint_answer" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
         [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * code =[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"resultCode"]];
            if ([code isEqualToString:@"0"]) {
                _strResourceNum=tfResource.text;
                GYReSetPasswordViewController * vcReset = [[GYReSetPasswordViewController alloc]initWithNibName:@"GYReSetPasswordViewController" bundle:nil];
                vcReset.hidesBottomBarWhenPushed=YES;
                vcReset.resourceNumber=tfResource.text;
                NSLog(@"%@-----resource",vcReset.resourceNumber);
                [self.navigationController pushViewController:vcReset animated:YES];
            }else
            {
                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"输入的答案有误，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
    }];
}


-(void)findPasswdByEmailRequest
{
    UITextField * tfResourceNumber = marrTextFieldThree [0];
    UITextField * tfEmail = marrTextFieldThree [1];
    strEmail=tfEmail.text;
    if (![Utils isHSCardNo:tfResourceNumber.text])
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请输入11位合法的互生号." isPopVC:nil];
        return;
    }
    if ([Utils isBlankString:tfResourceNumber.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"输入资源号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:tfEmail.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"输入邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    NSString *params = [NSString stringWithFormat:@"{resource_no=%@,email=%@}", tfResourceNumber.text,tfEmail.text];
    params = [GYencryption h2:params k:cKey];
    NSData *strData = [params dataUsingEncoding:NSUTF8StringEncoding];
    params = [strData base64EncodedString];
    params = [params stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    params = [params stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    params = [Network urlEncoderParameter:params];
    [dict setValue:params forKey:@"params"];
    NSString *urlString = [[LoginEn sharedInstance] getDefaultHsDm];
    urlString = [urlString stringByAppendingString:@"/gy/api"];

    [dict setValue:keyForGetPwd forKey:@"key"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[Utils getRandomString:6] forKey:@"mId"];
    [dict setValue:@"send_find_password_mail" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:urlString parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
         [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * code =[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"resultCode"]];
            if ([code isEqualToString:@"0"]) {
                [self showAlertview];
            }else
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

-(void)setFavoriteBook
{
    GYQuestionModel * model = marrDataSource[0];
    UITextField * tfQuestion = marrTextFieldTwo[1];
    tfQuestion.enabled=NO;
    tfQuestion.text=model.strQuestion;
    _strQuestion=model.strQuestion;
    strQuestionId=model.strQuestionId;
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



#pragma mark 选择问题的代理方法
-(void)selectedOneQuestion:(GYQuestionModel *)Model
{
    UITextField * tfQuestion = marrTextFieldTwo[1];
    tfQuestion.enabled=NO;
    tfQuestion.text=Model.strQuestion;
    _strQuestion=Model.strQuestion;
    strQuestionId=Model.strQuestionId;
    
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

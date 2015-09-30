//
//  GYPersonalFileViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPersonDetailFileViewController.h"
#import "GYPersonalWithpictureTableViewCell.h"
#import "GYPersonalInfoTableViewCell.h"
#import "GYDateChooseTableViewCell.h"

//修改签名
#import "GYSignViewController.h"
#import  "GYDatePiker.h"
#define kFooterHeight 30
//修改性别
#import "GYChooseInfoViewController.h"
//选择地址
#import "GYAddressCountryViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIImageView+WebCache.h"
//#import "GYLoginView.h"
#import "Animations.h"
#import "GYLoginController.h"
#import "GYUserInfoTool.h"
// 修改登录  GYLoginViewDelegate


@interface GYPersonDetailFileViewController ()<GYPersonalInfoTableViewCellDelegate,GYDatePikerDelegate,GYLoginControllerDelegate >

@end

@implementation GYPersonDetailFileViewController
{
    
    __weak IBOutlet UITableView *tvPersonalFile;
    
    NSMutableArray * arrPlaceHolder;
    NSMutableArray * arrTest;
    GYDateChooseTableViewCell * DateCell;
    GYDatePiker * datePiker;
    
    NSMutableArray * arrTestText;
    
    UIImage * avtarImage;
    
    GYPersonalWithpictureTableViewCell * cell ;
    NSString * PicturePath;
    
    NSURL * BigImgUrl;
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=kLocalized(@"person_detail_info");
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrPlaceHolder=[NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    UIView * backgroundView =[[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, kScreenWidth, kScreenHeight)];
    
    backgroundView.backgroundColor=kDefaultVCBackgroundColor;
    
    tvPersonalFile.backgroundView=backgroundView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"getAddress" object:nil];
    
    tvPersonalFile.separatorStyle=UITableViewCellSeparatorStyleNone;
    //数据源  左边显示的文本
    self.arrDataSource=@[
                         @[kLocalized(@"avatar"),
                           kLocalized(@"nickname"),
                           kLocalized(@"sign")],
                         @[kLocalized(@"name"),
                           kLocalized(@"sex"),
                           kLocalized(@"sex"),
                           kLocalized(@"ep_hobby"),
                           kLocalized(@"professional"),
                           kLocalized(@"ar_telephone_prefix"),
                           kLocalized(@"area")],
                         ];
    //textfield  占位符
    arrPlaceHolder=[@[[@[@"",
                         kLocalized(@"input_nickname"),
                         kLocalized(@"input_sign")] mutableCopy],
                      [@[kLocalized(@"name"),
                         kLocalized(@"input_sex"),
                         kLocalized(@"sex"),
                         kLocalized(@"ep_enter_hobby"),
                         kLocalized(@"input_job"),
                         kLocalized(@"ep_input_contact_phone"),
                         kLocalized(@"choose_area")
                         ] mutableCopy],
                      
                      ] mutableCopy];
    
    
    
    arrTest= [[NSMutableArray alloc] init];
    NSMutableArray *arrTmp=nil;
    
    for (int i = 0; i < arrPlaceHolder.count; i++)
    {
        arrTmp = [NSMutableArray array];
        for (int cellCount = 0; cellCount < [arrPlaceHolder[i] count]; cellCount++)
        {
            [arrTmp addObject:@""];
        }
        [arrTest addObject:arrTmp];
    }
    
    tvPersonalFile.delegate = self;
    tvPersonalFile.dataSource = self;
    
    [tvPersonalFile registerNib:[UINib nibWithNibName:@"GYPersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"mostcell"];
    [tvPersonalFile registerNib:[UINib nibWithNibName:@"GYPersonalWithpictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kFooterHeight)];
    footer.backgroundColor=kDefaultVCBackgroundColor;
    tvPersonalFile.tableFooterView=footer;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // add by songjk
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self loadDataFromNetwork];

}


-(void)loadDataFromNetwork
{
    
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/queryPersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
  
        if (!error) {
            
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    
                    if ([responseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
                        data.IMUser.strAddress= kSaftToNSString(responseDic[@"data"][@"address"]);
                        data.IMUser.strAge= kSaftToNSString(responseDic[@"data"][@"age"]);
                        data.IMUser.strArea= kSaftToNSString(responseDic[@"data"][@"area"]);
                       
                        data.IMUser.strBirthday= kSaftToNSString(responseDic[@"data"][@"birthday"]);
                        data.IMUser.strBloodType= kSaftToNSString(responseDic[@"data"][@"bloodType"]);
                        data.IMUser.strCard= kSaftToNSString(responseDic[@"data"][@"card"]);
                        data.IMUser.strCity= kSaftToNSString(responseDic[@"data"][@"city"]);
                        data.IMUser.strCountry= kSaftToNSString(responseDic[@"data"][@"country"]);
                        data.IMUser.strEmail= kSaftToNSString(responseDic[@"data"][@"email"]);
                        data.IMUser.strHeadPic= kSaftToNSString(responseDic[@"data"][@"headPic"]);
                        data.IMUser.strHeadBigPic =kSaftToNSString(responseDic[@"data"][@"headBigPic"]);
                        
                        if (data.IMUser.strHeadBigPic.length>0) {
                                BigImgUrl=[NSURL URLWithString: data.IMUser.strHeadBigPic];
                        }else
                        {
                         BigImgUrl=[NSURL URLWithString: data.IMUser.strHeadPic];
                        }
                   
                        
                        data.IMUser.strId= kSaftToNSString(responseDic[@"data"][@"id"]);
                        data.IMUser.strInterest= kSaftToNSString(responseDic[@"data"][@"interest"]);
                        data.IMUser.strMobile= kSaftToNSString(responseDic[@"data"][@"mobile"]);
                        data.IMUser.strName= kSaftToNSString(responseDic[@"data"][@"name"]);
                        data.IMUser.strNickName= kSaftToNSString(responseDic[@"data"][@"nickName"]);
                        data.IMUser.strOccupation= kSaftToNSString(responseDic[@"data"][@"occupation"]);
                        data.IMUser.strQQNo= kSaftToNSString(responseDic[@"data"][@"qqNo"]);
                        data.IMUser.strResourceNo= kSaftToNSString(responseDic[@"data"][@"resourceNo"]);
                        
                        data.IMUser.strSchool= kSaftToNSString(responseDic[@"data"][@"school"]);
                        data.IMUser.strSex= kSaftToNSString(responseDic[@"data"][@"sex"]);
                        data.IMUser.strSign= kSaftToNSString(responseDic[@"data"][@"sign"]);
                        data.IMUser.strStart= kSaftToNSString(responseDic[@"data"][@"start"]);
                        data.IMUser.strTelNo= kSaftToNSString(responseDic[@"data"][@"telNo"]);
                        data.IMUser.strUserId= kSaftToNSString(responseDic[@"data"][@"userId"]);
                        data.IMUser.strWeixinNo= kSaftToNSString(responseDic[@"data"][@"weixinNo"]);
                        data.IMUser.strZipNo= kSaftToNSString(responseDic[@"data"][@"zipNo"]);
                        
                        
                        NSMutableArray * sectionOneArray =arrTest[0];
                        [sectionOneArray replaceObjectAtIndex:1 withObject:data.IMUser.strNickName];
                        [sectionOneArray replaceObjectAtIndex:2 withObject:data.IMUser.strSign];
                        
                        
                        NSMutableArray * tempArr = arrTest[1];
                        [tempArr replaceObjectAtIndex:0 withObject:data.IMUser.strName];
                        NSString * sexString;
                        if ([data.IMUser.strSex isEqualToString:@"1"]) {
                            sexString=@"男";
                        }else{
                            sexString=@"女";
                        }
                        
                        [tempArr replaceObjectAtIndex:1 withObject:sexString];
                        [tempArr replaceObjectAtIndex:2 withObject:data.IMUser.strBirthday];
                        [tempArr replaceObjectAtIndex:3 withObject:data.IMUser.strInterest];
                        [tempArr replaceObjectAtIndex:4 withObject:data.IMUser.strOccupation];
                        [tempArr replaceObjectAtIndex:5 withObject:data.IMUser.strMobile];
                        [tempArr replaceObjectAtIndex:6 withObject:data.IMUser.strAddress];
                        [arrTest replaceObjectAtIndex:1 withObject:tempArr];
                        
                        [tvPersonalFile reloadData];
                    }
                    
                    
                }
            }
        }
        
        
    }];
    
    
}

-(void)getAddress:(NSNotification *)notification
{
    NSMutableArray * tempArr = arrTest[1];
    
   
    
    [tempArr replaceObjectAtIndex:6 withObject:[notification object]];
    
    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
   
    
    [tvPersonalFile reloadData];
    
 
    
    
}


#pragma mark DataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.arrDataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.arrDataSource[section] count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0&&indexPath.row==0) {
        
        return 72.f;
        
    }
    return 43.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kDefaultMarginToBounds;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeader =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * mostCellIdentifier=@"mostcell";

    
    GYPersonalInfoTableViewCell * maincell =[tableView dequeueReusableCellWithIdentifier:mostCellIdentifier];
    
    //cell的初始化
    if (indexPath.section==0&&indexPath.row==0) {
        
        if (cell==nil) {
            
            cell=[[[NSBundle mainBundle]loadNibNamed:@"GYPersonalWithpictureTableViewCell" owner:self options:nil]lastObject];
        }
        //获取沙盒路径
//        NSString * path =NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString * PicturePath = [path stringByAppendingPathComponent:@"UserIcon.png"];
//        
//        
//        //根据路径读取图片
//        UIImage * temImg =[UIImage imageWithData:[NSData dataWithContentsOfFile:PicturePath]];
//        
//        
//        if (temImg) {
//            
//            cell.imgAvater.image=temImg;
//            
//        }
//        if ([GlobalData shareInstance].IMUser.strHeadPic) {
//            [cell.imgAvater sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].IMUser.strHeadPic]];
//        }
        
        [cell.imgAvater sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].IMUser.strHeadPic] placeholderImage:[UIImage imageNamed:@"defaultheadimg.png"]];
        cell.imgAvater.userInteractionEnabled=YES;
    
        cell.inputPictureInfoRow.lbLeftlabel.text=@"头像";
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkBigImg)];
        [cell.imgAvater addGestureRecognizer:tap];
        
        
    }else{
        
        
        if (maincell==nil) {
            
            maincell=[[GYPersonalInfoTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:mostCellIdentifier];
            
        } 
        
    }
    
    //cell内容的赋值
    switch (indexPath.section) {
        case 0:
        {
//            cell.inputPictureInfoRow.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
            if (indexPath.row>0) {
                maincell.InputCellInfo.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
                maincell.InputCellInfo.tfRightTextField.text=arrTestText[indexPath.section][indexPath.row];
                maincell.InputCellInfo.tfRightTextField.text = arrTest[indexPath.section][indexPath.row];
            }
            
        }
            break;
        case 1:
        {
            
            if (indexPath.row==2&&indexPath.section==1)
            {
                
                DateCell = [[[NSBundle mainBundle] loadNibNamed:@"GYDateChooseTableViewCell" owner:self options:nil] lastObject];
                
            }
            NSRange range ;
            range.length=2;
            range.location=4;
            if ([GlobalData shareInstance].IMUser.strBirthday.length>0&&![[GlobalData shareInstance].IMUser.strBirthday isKindOfClass:[NSNull class]]) {
                 DateCell.lbYearDetail.text=[NSString stringWithFormat:@"%@-%@-%@",[[GlobalData shareInstance].IMUser.strBirthday substringToIndex:4],[[GlobalData shareInstance].IMUser.strBirthday substringWithRange:range],[[GlobalData shareInstance].IMUser.strBirthday  substringFromIndex:6]];
            }else
            {
            
               DateCell.lbYearDetail.text=@"选择日期";
            }
           
            [DateCell.btnChooseDate addTarget:self action:@selector(ChooseDate:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            
        case 2:
        {
            
            maincell.InputCellInfo.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
            maincell.InputCellInfo.tfRightTextField.text=arrTestText[indexPath.section][indexPath.row];
            maincell.InputCellInfo.tfRightTextField.text = arrTest[indexPath.section][indexPath.row];
        
            
        }
            break;
        default:
            break;
    }
    
    if (indexPath.section==0&&indexPath.row==0) {
        return cell;
    }
    maincell.section = indexPath.section;
    maincell.row = indexPath.row;
    maincell.delegate = self;
    if (indexPath.section==1&&indexPath.row==2) {
        return DateCell;
    }
    
    return maincell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![GlobalData shareInstance].isHdLogined)
    {
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }

        
        return;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self chooseAvater];
                    
                }
                    break;
            
                case 1:
                {
                    [self GoToPresentVc:indexPath];
                    
                }
                    break;
                    
                case 2:
                {
                    GYSignViewController * vcChooseSex =[[GYSignViewController alloc]initWithNibName:@"GYSignViewController" bundle:nil];
                    self.hidesBottomBarWhenPushed=YES;
                    vcChooseSex.delegate=self;
                    vcChooseSex.title=@"个性签名";
                    vcChooseSex.strSign=[GlobalData shareInstance].IMUser.strSign ;
                    [self.navigationController pushViewController:vcChooseSex animated:YES];
                
                    
                }
                    break;
                default:
                    break;
            }
            
            
        }
            break;
            
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    [self GoToPresentVc:indexPath];
                    
                }
                    break;
                case 1:
                {
                    GYChooseInfoViewController * vcChooseSex =[[GYChooseInfoViewController alloc]initWithNibName:@"GYChooseInfoViewController" bundle:nil];
                    self.hidesBottomBarWhenPushed=YES;
                    vcChooseSex.delegate=self;
                    
                    if ([GlobalData shareInstance].IMUser.strSex) {
                        vcChooseSex.strSex=[GlobalData shareInstance].IMUser.strSex;
                        
                    }else
                    {
                        vcChooseSex.strSex=@"3";
                        
                    }
                    [self.navigationController pushViewController:vcChooseSex animated:YES];
  
                    
                }
                    break;
                    
                case 2:
                {
                    id dateCell = [tableView cellForRowAtIndexPath:indexPath];
                    if ([dateCell isKindOfClass:[GYDateChooseTableViewCell class]])
                    {
                        GYDateChooseTableViewCell *cll = dateCell;
                        [cll.btnChooseDate sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                    break;
                case 3:
                {
//                    [self GoToPresentVc:indexPath];
                    GYSignViewController * vcChangehob =[[GYSignViewController alloc]initWithNibName:@"GYSignViewController" bundle:nil];
                    self.hidesBottomBarWhenPushed=YES;
                    vcChangehob.delegate=self;
                    vcChangehob.useType=1;
                    vcChangehob.title=@"爱好";
                    vcChangehob.strSign=[GlobalData shareInstance].IMUser.strInterest ;
                    [self.navigationController pushViewController:vcChangehob animated:YES];
                    
                }
                    break;
                case 4:
                {
                    [self GoToPresentVc:indexPath];
                    
                    
                }
                    break;
                case 5:
                {
                    [self GoToPresentVc:indexPath];
                    
                    
                }
                    break;
                case 6:
                {
                    GYAddressCountryViewController * vcChooseAdd =[[GYAddressCountryViewController alloc]initWithNibName:@"GYAddressCountryViewController" bundle:nil];
                    vcChooseAdd.addressType=noLocationfunction;
                    self.hidesBottomBarWhenPushed=YES;
                    vcChooseAdd.strSelectedArea=[GlobalData shareInstance].IMUser.strAddress;
                    
                    [self.navigationController pushViewController:vcChooseAdd animated:YES];
                  
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}

-(void)checkBigImg
{
    NSLog(@"bbbbbbbbbbbbbbb");
    
    if (![GlobalData shareInstance].isHdLogined)
    {
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        
        
        return;
    }
    
 
        self.navigationController.navigationBarHidden = YES;
    UIView * vImgBackground =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView * imgvBig =[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-100)];
    [imgvBig setContentMode:UIViewContentModeScaleAspectFit];
    [imgvBig setBackgroundColor:kClearColor];
    vImgBackground.backgroundColor=[UIColor blackColor];
    
    [imgvBig sd_setImageWithURL:BigImgUrl placeholderImage:[UIImage imageNamed:@"image_default_person"]];
    [vImgBackground addSubview:imgvBig];
    
    [self.view addSubview:vImgBackground];
    [Animations fadeIn: vImgBackground andAnimationDuration: 0.24 andWait:NO];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenImgBackground:)];
    [vImgBackground addGestureRecognizer:tap];
    
    
}

-(void)hidenImgBackground:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = NO;
    UIView * v =tap.view;
    [v removeFromSuperview];

}
-(void)GoToPresentVc:(NSIndexPath * )indexPath
{
    NSString * titileString =nil;
    NSString * placeHolderString=nil;
    
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
            {
                
                titileString=@"更改姓名";
                placeHolderString =[GlobalData shareInstance].IMUser.strName;
                
            }
                break;
            case 3:
            {
                titileString=@"爱好";
                placeHolderString =[GlobalData shareInstance].IMUser.strInterest;
                            }
                
                break;
            case 4:
                
                titileString=@"职业";
                placeHolderString =[GlobalData shareInstance].IMUser.strOccupation;
                
                break;
            case 5:
                
                titileString=@"联系电话";
                placeHolderString =[GlobalData shareInstance].IMUser.strMobile;
                
                break;
            default:
                break;
        }
        
        
    }
    
    
    if (indexPath.section==0&&indexPath.row==1) {
        titileString=@"更改昵称";
        placeHolderString =[GlobalData shareInstance].IMUser.strNickName;
    }
    
    GYModifyNameViewController * vcModifyName =[[GYModifyNameViewController alloc]initWithNibName:@"GYModifyNameViewController" bundle:nil];
    vcModifyName.title=titileString;
    vcModifyName.strPlaceHolder=placeHolderString;
    
    vcModifyName.delegate=self;
    vcModifyName.indexPath=indexPath;
    
    UINavigationController * navModifyName =[[UINavigationController alloc]initWithRootViewController:vcModifyName];
    
    [navModifyName.navigationBar setTranslucent:NO];
    [navModifyName.navigationBar setTintColor:[UIColor whiteColor]];
    //设置Navigation颜色
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        
        navModifyName.navigationBar.backgroundColor=kNavigationBarColor;
        [navModifyName.navigationBar setBackgroundImage:[UIImage imageNamed:@"cell_make_evalutation_default"]
                                          forBarMetrics:UIBarMetricsDefault];
        
    }else
    {
        [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
        
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        kNavigationTitleColor,NSForegroundColorAttributeName,
                                        kNavigationTitleColor,NSBackgroundColorAttributeName,
                                        [UIFont systemFontOfSize:19.0f], UITextAttributeFont, nil];
        
        [navModifyName.navigationBar setTitleTextAttributes:textAttributes];
        [navModifyName.navigationBar setTitleTextAttributes:textAttributes];
        [navModifyName.navigationBar setTitleTextAttributes:textAttributes];
        [navModifyName.navigationBar setTitleTextAttributes:textAttributes];
    }
    
    
    [self.navigationController presentViewController:navModifyName animated:YES completion:^{
        nil;
    }];
    
}

-(void)ChooseDate:(UIButton *)sender
{
    if (![GlobalData shareInstance].isHdLogined)
    {
//        [UIAlertView showWithTitle:nil message:@"请先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex != 0)
//            {
//                [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
//            }
//        }];
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        
        return;
    }
    if (!datePiker) {
        datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) WithType:0];
        datePiker.delegate = self;
        [self.view addSubview:datePiker];
        datePiker = nil;
    }
    
}

-(void)getDate:(NSString *)date WithDate:(NSDate *)date1
{
    DateCell.lbYearDetail.text=date;
    NSString * dateString =[[date componentsSeparatedByString:@"-"]  componentsJoinedByString:@""];
    [self saveBirthdayRequest:(NSString *)dateString];
    
    
}


-(void)saveBirthdayRequest:(NSString *)date
{
    
    GlobalData * data =[GlobalData shareInstance];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:@(date.longLongValue) forKey:@"birthday"];
    
    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
    
        if ([retCode isEqualToString:@"200"]) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
        else
        {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        
        }
        
        
        
        
    }];
    
    
    
    
    
}

#pragma mark textfiled delegate
- (void)didEndEditing:(NSInteger)section inRow:(NSInteger)row object:(id)sender
{
    
    GYPersonalInfoTableViewCell *cellInfo = sender;
    
    [arrTest[section] replaceObjectAtIndex:row withObject:cellInfo.InputCellInfo.tfRightTextField.text];
    
    [tvPersonalFile reloadData];
    
}


-(void)chooseAvater
{
    NSLog(@"123456");
    [self  addButtonImg];
}


-(void)addButtonImg
{
    if (![GlobalData shareInstance].isHdLogined)
    {
//        [UIAlertView showWithTitle:@"提示" message:@"请先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex != 0)
//            {
//                [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
//            }
//        }];
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        return;
    }
    
    UIActionSheet *HeaderIconSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"take_photos"),kLocalized(@"my_ablum"), nil];
    HeaderIconSheet.destructiveButtonIndex=2;
    
    [HeaderIconSheet showInView:self.tabBarController.view.window];
    
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0) {
        
        [self photocamera];
    }
    
    else if(buttonIndex == 1){
        
        NSLog(@"zxcvb");
        [self photoalbumr];
        
    }else if (buttonIndex==2){
        
        NSLog(@"wsxcde");
        
    }
    
}

//进入相册
-(void)photoalbumr{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker =
        
        [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error accessing photo library"
                              
                              message:@"Device does not support a photo library"
                              
                              delegate:nil
                              
                              cancelButtonTitle:@"Drat!"
                              
                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}

//进入拍照
-(void)photocamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        
        imagepicker.delegate = self;
//        imagepicker.showsCameraControls=YES;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagepicker.allowsEditing = YES;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
        
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Sorry"
                              
                              message:@"设备不支持拍照功能"
                              
                              delegate:nil
                              
                              cancelButtonTitle:@"确定"
                              
                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}

//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//Pickerviewcontroller的代理方法。
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{


    //获取图片
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImageToSandbox:image];
    
    long long  PicSize=  [Utils getFileSize:PicturePath];
    
    NSLog(@"%lld---------size",PicSize);
    
    if (PicSize/1024/1024>10) {
        [Utils showMessgeWithTitle:nil message:@"图片大于10Mb,请重试！" isPopVC:nil];
        return;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        //上传图片获取URL
        
        [Utils showMBProgressHud:self SuperView:self.view Msg:@"上传图片..."];
        
        [self modifyHeadpicRequest:(UIImage *)image];
        
        
        
        nil;
    }];


}

-(void)saveIconRequest:(NSString *)iconUrlString
{
    GlobalData * data =[GlobalData shareInstance];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:data.ecKey forKey:@"key"];
    
    [dict setValue:data.midKey forKey:@"mid"];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:iconUrlString forKey:@"headPic"];
    
    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
        
        if ([retCode isEqualToString:@"200"]) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
        
    }];
    
    
    
}


-(void)saveImageToSandbox:(UIImage *)image
{
    
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    GYPersonalWithpictureTableViewCell * imgCell = ( GYPersonalWithpictureTableViewCell *)[tvPersonalFile cellForRowAtIndexPath:indexPath];
    
    imgCell.imgAvater.image=image;
    
    //获取沙盒路径
    NSString * path =NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES)[0];
    PicturePath = [path stringByAppendingPathComponent:@"UserIcon.png"];
    NSData * data =UIImageJPEGRepresentation(image, 1);
    //将DATA 存入沙盒
    [data writeToFile:PicturePath atomically:NO];
    


}




#pragma mark 修改签名代理方法
-(void)sendSignTextString:(NSString *)sign
{

    if (sign==nil) {
        return;
    }
    NSMutableArray * tempArr = arrTest[0];
    [tempArr replaceObjectAtIndex:2 withObject:sign];
    
    [arrTest replaceObjectAtIndex:0 withObject:tempArr];
    NSLog(@"123456");
    [tvPersonalFile reloadData];
    
}

#pragma mark 选择性别代理方法
-(void)sendSelectSex:(NSString *)sex
{

    NSMutableArray * tempArr = arrTest[1];
    [tempArr replaceObjectAtIndex:1 withObject:sex];
    
    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
    
    [tvPersonalFile reloadData];
    
}

#pragma mark 弹出导航控制器，获取输入信息。回调方法。
-(void)getInputedText:(NSString *)text WithIndexPath:(NSIndexPath *)path
{

    if (text==nil) {
        return;
    }
    
    switch (path.section) {
        case 0:
        {
            if (path.row==1)
            {
                NSMutableArray * tempArr = arrTest[0];
                [tempArr replaceObjectAtIndex:1 withObject:text];
                
                [arrTest replaceObjectAtIndex:0 withObject:tempArr];
              
                [tvPersonalFile reloadData];
                
                
            }
            
        }
            break;
            
        case 1:
        {
            switch (path.row) {
                case 0:
                {
                    NSMutableArray * tempArr = arrTest[1];
                    [tempArr replaceObjectAtIndex:0 withObject:text];
                    
                    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
                  
                    [tvPersonalFile reloadData];
                    
                    
                }
                    break;
                    
                case 1:
                {
                    NSMutableArray * tempArr = arrTest[1];
                    [tempArr replaceObjectAtIndex:1 withObject:text];
                    
                    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
                  
                    [tvPersonalFile reloadData];
                }
                    break;
                case 3:
                {
                    NSMutableArray * tempArr = arrTest[1];
                    [tempArr replaceObjectAtIndex:3 withObject:text];
                    
                    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
                
                    [tvPersonalFile reloadData];
                }
                    break;
                case 4:
                {
                    NSMutableArray * tempArr = arrTest[1];
                    [tempArr replaceObjectAtIndex:4 withObject:text];
                    
                    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
            
                    [tvPersonalFile reloadData];
                }
                    break;
                case 5:
                {
                    NSMutableArray * tempArr = arrTest[1];
                    [tempArr replaceObjectAtIndex:5 withObject:text];
                    
                    [arrTest replaceObjectAtIndex:1 withObject:tempArr];
                   
                    [tvPersonalFile reloadData];
                }
                    break;
                    
                default:
                 
                    [tvPersonalFile reloadData];
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark 修改头像
-(void)modifyHeadpicRequest:(UIImage *)image
{
    GlobalData * data =[GlobalData shareInstance];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:data.ecKey forKey:@"key"];
    
    [dict setValue:data.midKey forKey:@"mid"];
    
    [dict setValue:@"image" forKey:@"fileType"];
  
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [dict setValue:accountId forKey:@"id"];
    
    GYUploadImage * uploadPic =[[GYUploadImage alloc]init];
    uploadPic.urlType=1;
    [uploadPic uploadImg:image WithParam:dict];
    uploadPic.delegate=self;
    


}

#pragma mark 获取上传图片Url
-(void)didFinishUploadImg:(NSURL*)url withBigImg:(NSURL *)bigUrl withTag:(int)index
{
    
    BigImgUrl=bigUrl;
    // 保存头像信息
    NSString * strUrl =@"";
    if (!url)
    {
       strUrl = [NSString stringWithFormat:@"%@",url];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@",bigUrl];
    }
    GYUserInfoTool * tool = [GYUserInfoTool shareInstance];
    [tool updataUserHeadPic:strUrl userID:[GlobalData shareInstance].user.cardNumber];
    NSString * urlString =[NSString stringWithFormat:@"%@",url];

      NSLog(@"%@-------bigUrl",bigUrl);
    if (url&&[urlString hasPrefix:@"http:"]) {
        [Utils hideHudViewWithSuperView:self.view];
        
        [cell.imgAvater sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultheadimg.png"]];
        [GlobalData shareInstance].IMUser.strHeadPic=urlString;

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [tvPersonalFile reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"上传图片成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }else{
        
        cell.imgAvater.image=[UIImage imageNamed:@"defaultheadimg.png"];
        [Utils hideHudViewWithSuperView:self.view];
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }   
    
}

#pragma mark 上传图片失败
-(void)didFailUploadImg : (NSError *)error withTag:(int)index
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    
}

#pragma mark - GYLoginViewDelegate
- (void)loginDidSuccess:(NSDictionary *)response sender:(id)sender
{
    [self loadDataFromNetwork];
}

@end

//
//  GYPersonDetailInfoViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPersonDetailInfoViewController.h"
#import "InputCellStypeView.h"
//互动入口   个人资料详情
#import "GYPersonDetailFileViewController.h"
//添加新朋友
#import "GYNewFriendViewController.h"
//添加好友
#import "GYAddFriendViewController.h"
//好友管理
#import "GYFriendManageViewController.h"

#import "UIImageView+WebCache.h"

#import "GYImUserInfo.h"
#import "GYChatViewController.h"

#import "GYAddFriendViewController.h"

#import "GYDBCenter.h"
#import "Animations.h"
#import "UIView+CustomBorder.h"
#define rowHeight 42
@interface GYPersonDetailInfoViewController ()

- (IBAction)chatClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;

@end

@implementation GYPersonDetailInfoViewController
{
    __weak IBOutlet UIScrollView *scrMain;
    
    __weak IBOutlet UIImageView *imgIcon; //头像
    
    __weak IBOutlet UILabel *lbName;//用户名
    __weak IBOutlet UILabel *lbNickname;
    
    __weak IBOutlet UILabel *lbNameNumber;//用户名
    
    __weak IBOutlet UIImageView *imgRealAuth;//是否实名认证的ICON
    
    __weak IBOutlet InputCellStypeView *AreaRow;//地区ROW
    
    __weak IBOutlet InputCellStypeView *hobbyRow;//兴趣爱好row
    
    __weak IBOutlet InputCellStypeView *SignRow;//个性签名row
    
    __weak IBOutlet UIButton *btnAddToFriend;//添加到好友
    
   
    
    GYPopView * pv;
    
    GYImUserInfo * personInfo;
    
    NSString * urlBigImg;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        
        self.title=kLocalized(@"detail_information");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIImage* image = [UIImage imageNamed:@"ep_add_to_cart.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2);
    image = [image resizableImageWithCapInsets:insets];
    [self.btnChat setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.btnChat setTitle:kLocalized(@"send_message") forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [imgIcon sd_setImageWithURL:[NSURL URLWithString:self.model.strFriendIconURL] placeholderImage:[UIImage imageNamed:@"image_default_person.png"]];
    
    // songjk
    switch (self.useType) {
        case kPersonInfoFromChat:
        {
            self.btnChat.hidden = NO;// add by songjk
            btnAddToFriend.hidden=NO;

               btnAddToFriend.hidden=YES;
            AreaRow.tfRightTextField.enabled=NO;
            hobbyRow.tfRightTextField.enabled=NO;
            SignRow.tfRightTextField.enabled=NO;
            AreaRow.tfRightTextField.placeholder=@"";
            hobbyRow.tfRightTextField.placeholder=@"";
            SignRow.tfRightTextField.placeholder=@"";
          
            if (self.isAdded) {
                [btnAddToFriend setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
                btnAddToFriend.enabled=NO;
            }
            // add by songjk 使之可以设置备注或者删除
            UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"msg_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
            
            self.navigationItem.rightBarButtonItem = rb;
                [self loadDataFromNetworkForPersonInfo];
            
        }
            break;
        case KPersonInfoFromCheck:
        {
            self.btnChat.hidden = YES;// add by songjk
            btnAddToFriend.hidden=YES;

            AreaRow.tfRightTextField.enabled=NO;
            hobbyRow.tfRightTextField.enabled=NO;
            SignRow.tfRightTextField.enabled=NO;
            AreaRow.tfRightTextField.placeholder=@"";
            hobbyRow.tfRightTextField.placeholder=@"";
            SignRow.tfRightTextField.placeholder=@"";
            
            // modify by songjk  添加好友时 不显示删除和备注
//            UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"msg_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
//            
//            self.navigationItem.rightBarButtonItem = rb;
            
            [self loadDataFromNetworkForPersonInfo];
            
        }
            break;
        case KPersonInfoFromFriendList:
        {
            self.btnChat.hidden = NO;// add by songjk
            btnAddToFriend.hidden=NO;
            
            btnAddToFriend.hidden=YES;
            AreaRow.tfRightTextField.enabled=NO;
            hobbyRow.tfRightTextField.enabled=NO;
            SignRow.tfRightTextField.enabled=NO;
            AreaRow.tfRightTextField.placeholder=@"";
            hobbyRow.tfRightTextField.placeholder=@"";
            SignRow.tfRightTextField.placeholder=@"";
            
            if (self.isAdded) {
                [btnAddToFriend setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
                btnAddToFriend.enabled=NO;
            }
            // add by songjk 使之可以设置备注或者删除
            UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"msg_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
            
            self.navigationItem.rightBarButtonItem = rb;
            [self loadDataFromNetworkForPersonInfo];
            
        }
            break;
        default:
            break;
    }
    
    
    [self modifyName];
    imgIcon.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigHeadPic:)];
    [imgIcon addGestureRecognizer:tap];
    
}

-(void)showBigHeadPic:(UITapGestureRecognizer *)tap
{

    self.navigationController.navigationBarHidden = YES;
    UIView * vImgBackground =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView * imgvBig =[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-100)];
    vImgBackground.backgroundColor=[UIColor blackColor];
    if (!urlBigImg || urlBigImg.length==0) { // add by songjk 当没有请求道头像的时候用传入的头像
        urlBigImg = self.model.strFriendIconURL;
    }
    [imgvBig sd_setImageWithURL: [NSURL URLWithString:urlBigImg] placeholderImage:[UIImage imageNamed:@"image_default_person"]];
    [vImgBackground addSubview:imgvBig];
    
    [self.view addSubview:vImgBackground];
    [Animations fadeIn: vImgBackground andAnimationDuration: 0.24 andWait:NO];
    UITapGestureRecognizer * tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenImgBackground:)];
    [vImgBackground addGestureRecognizer:tap1];


}


-(void)hidenImgBackground:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = NO;
    UIView * v =tap.view;
    [v removeFromSuperview];
    
}

-(void)loadDataFromNetworkForPersonInfo
{
    
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    
    [insideDict setValue:self.model.strAccountID forKey:@"accountId"];
    [insideDict setValue:data.IMUser.strAccountId forKey:@"friendId"];
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/queryPersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
        
        if ([retCode isEqualToString:@"200"]) {
            
            if ([responseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                personInfo =[[GYImUserInfo alloc]init];
                
                personInfo.strAddress= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"address"]];
                
                personInfo.strArea= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"area"]];
                
                personInfo.strAccountNo= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"accountNo"]];

                personInfo.strCity= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"city"]];
                
                personInfo.strCountry= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"country"]];
                
                personInfo.strHeadPic= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"headPic"]];

                personInfo.strInterest= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"interest"]];
                
                personInfo.strName= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"name"]];
                
                personInfo.strNickName= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"nickName"]];

                personInfo.strSign= [NSString stringWithFormat:@"%@",responseDic[@"data"][@"sign"]];
                
                personInfo.strHeadBigPic =[NSString stringWithFormat:@"%@",responseDic[@"data"][@"headBigPic"]];
                
                NSString * strRemark = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"remark"]];
                personInfo.strRemark = strRemark;
                if (strRemark.length>0 ) {
                    personInfo.strRemark=strRemark;
                    [self saveRemark];
                }
                
                if (personInfo.strHeadBigPic.length>0) {
                    urlBigImg=personInfo.strHeadBigPic;
                }else
                {
                    urlBigImg=personInfo.strHeadPic;
                }
                
                [self fillInfoForUI];
                
                
            }
            
            
        }
        
    }];
    
    
}
// 保存备注
-(void)saveRemark
{
    NSString * myID = [GlobalData shareInstance].IMUser.strAccountNo;
    NSString *resNO = [Utils getResNO:personInfo.strAccountNo];
    NSDictionary * dict = @{@"friend_id":resNO,@"my_id":myID,@"msg_type":@"1",@"res_no":resNO};
    [GYChatItem setRemark:personInfo.strRemark dictData:dict];
}
//请求返回后，填充页面信息
-(void)fillInfoForUI
{
    //计算文本高度
    CGFloat addressStringHeight =[Utils heightForString:personInfo.strAddress fontSize:16.0 andWidth:191.0] ;
    CGFloat friendInerestHeight = [Utils heightForString:personInfo.strInterest fontSize:16.0 andWidth:191.0];
    if (friendInerestHeight<rowHeight) {
        friendInerestHeight=rowHeight;
    }
    CGFloat friendSignHeight =[Utils heightForString:personInfo.strSign fontSize:16.0 andWidth:191.0];
    if (friendSignHeight<rowHeight) {
        friendSignHeight=rowHeight;
    }

    CGRect frameArea=AreaRow.tfRightTextField.frame;
    frameArea.size.height=addressStringHeight>rowHeight?60:rowHeight;
    frameArea.origin.y=1;
    UILabel * lbAddress =[[UILabel alloc]initWithFrame:frameArea];
     lbAddress.backgroundColor=[UIColor clearColor];
    CGRect frameHobby =hobbyRow.tfRightTextField.frame;
    int a=0;
    if ((int)friendInerestHeight%rowHeight!=0) {
        a=friendInerestHeight/rowHeight+1;
    }else
    {
        a=friendInerestHeight/rowHeight;
    }
    frameHobby.origin.y=1;
    frameHobby.size.height=rowHeight*a;
    UILabel * lbHobby =[[UILabel alloc]initWithFrame:frameHobby];
    CGRect frameHobbyView =hobbyRow.frame;
        lbHobby.backgroundColor=[UIColor clearColor];
    
//    float YstartHobby=0;
    float HobbyViewTotalHeight=rowHeight*a;
    frameHobbyView.size.height=HobbyViewTotalHeight;
    hobbyRow.frame=frameHobbyView;
    
//开始计算签名View高度
    int b=0;
    if ((int)friendSignHeight%rowHeight!=0) {
        b=friendSignHeight/rowHeight+1;
    }else
    {
        b=friendSignHeight/rowHeight;
    }
 
    CGRect frameSignView = SignRow.frame;
    frameSignView.origin.y=hobbyRow.frame.origin.y+hobbyRow.frame.size.height;
    frameSignView.size.height=rowHeight*b+2;
    SignRow.frame=frameSignView;

    CGRect frameSign =SignRow.tfRightTextField.frame;
    frameSign.size.height=rowHeight*b;
    frameSign.origin.y=1;
    UILabel * lbSign =[[UILabel alloc]initWithFrame:frameSign];
 //重新设置btnchat 高度和位置
    CGRect frameChat =self.btnChat.frame;
    frameChat.origin.y=SignRow.frame.origin.y+SignRow.frame.size.height+10;
    lbSign.backgroundColor=[UIColor clearColor];
    self.btnChat.frame=frameChat;
    
    
    lbAddress.text=personInfo.strAddress;
    lbAddress.numberOfLines=0;
    lbHobby.numberOfLines=0;
    lbSign.numberOfLines=0;
    lbAddress.textColor=kCellItemTitleColor;
    lbHobby.textColor=kCellItemTitleColor;
    lbSign.textColor=kCellItemTitleColor;
    [hobbyRow removeBottomBorder];
    [SignRow removeBottomBorder];
    [SignRow addBottomBorder];
    lbHobby.text=personInfo.strInterest;
    lbSign.text=personInfo.strSign;
    
   
    
    
    [AreaRow addSubview:lbAddress];
    [hobbyRow addSubview:lbHobby];
    [SignRow addSubview:lbSign];
    
    //将uitextField隐藏
    AreaRow.tfRightTextField.hidden = YES;
    hobbyRow.tfRightTextField.hidden = YES;
    SignRow.tfRightTextField.hidden = YES;
 

    if (personInfo.strRemark && personInfo.strRemark.length>0) {
        lbName.text=personInfo.strRemark;
        self.model.strFriendName=personInfo.strRemark;
    }else{
        lbName.text=personInfo.strNickName;
        self.model.strFriendName = personInfo.strNickName;
    }
    

    lbNickname.text=[NSString stringWithFormat:@"昵称：%@",personInfo.strNickName];
    lbNameNumber.text=[NSString stringWithFormat:@"互生号:%@",personInfo.strAccountNo];
    [imgIcon sd_setImageWithURL:[NSURL URLWithString:personInfo.strHeadPic] placeholderImage:[UIImage imageNamed:@"image_default_person.png"]];
 
    
}

// modify by songjk  去掉删除按钮
-(void)rightBtnAction
{
    NSArray *arrSel = @[@"备注",@"删除"];
    
    NSArray *arrImg = @[@"setting_right_bar",@"delete_friend"];
    
    CGRect bigFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 90, [UIScreen mainScreen].bounds.size.height/2 - 22* arrSel.count, 180, rowHeight* arrSel.count);
    //设置弹窗tableView 缩少Frame
    CGRect smallFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
    //设置弹窗背景颜色
    UIColor *bgColor = kCorlorFromRGBA(0,0,0,0.5);
    
    pv = [[GYPopView alloc] initWithCellType:5 WithArray:arrSel  WithImgArray:arrImg WithBigFrame:bigFrame WithSmallFrame:smallFrame WithBgColor:bgColor];
    pv.delegate = self;
    
    [self.view.window addSubview:pv];
    pv = nil;
    
    
}

#pragma mark 弹出框的代理方法
-(void)didSelWithIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
//             [self delelteFriendRequest];
            [self  pushToUpdateNicknameVC];
        }
            break;
        case 1:
        {
            [self delelteFriendRequest];
        }
            break;
        default:
            break;
    }
    
    
    
    
}

-(void )pushToUpdateNicknameVC
{
    GYupdateNicknameViewController * vcUpdateNickName =[[GYupdateNicknameViewController alloc]initWithNibName:@"GYupdateNicknameViewController" bundle:nil];
 
    vcUpdateNickName.friendId=self.model.strFriendID;
    UINavigationController * navModifyName =[[UINavigationController alloc]initWithRootViewController:vcUpdateNickName];
    
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
       [self.navigationController presentViewController:navModifyName animated:YES completion:nil];

}


#warning delete
-(void)delelteFriendRequest
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];

    [insideDict setValue:data.IMUser.strNickName forKey:@"accountNickname"];
    
    [insideDict setValue:data.IMUser.strHeadPic forKey:@"accountHeadPic"];
    
    [insideDict setValue:self.model.strFriendID forKey:@"friendId"];
    
    [insideDict setValue:personInfo.strNickName forKey:@"friendNickname"];
    
    [insideDict setValue:@"4" forKey:@"friendStatus"];
    
    [insideDict setValue:personInfo.strHeadPic  forKey:@"friendHeadPic"];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"请稍后..."];
    
    [Network HttpPostForImRequetURL:  [[GlobalData shareInstance].hdbizDomain  stringByAppendingString:@"/hsim-bservice/addFriend"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
  
            if (!error) {
                
                if ([ResonpseDict[@"retCode"] isEqualToString:@"200"]) {
                    
                    if([GYDBCenter deleteUserAllMessageWithUserAccount:self.model.strFriendID])
                    {

                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
                    }
#warning deleteFriend
//                    for (UIViewController *vc in self.navigationController.viewControllers) {
//                        if ([vc isMemberOfClass:[GYFriendManageViewController class]]) {
//                            
//                        }
//                    }
                    
                    
                    [UIAlertView showWithTitle:nil message:@"好友删除成功！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if ([self.delegate respondsToSelector:@selector(refreshTableAfterDeleteFriend:)]) {
                            [self.delegate refreshTableAfterDeleteFriend:self.model];
                        }
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    
                }else if ([ResonpseDict[@"retCode"] isEqualToString:@"201"])
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"删除好友失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
                
                
            }
            
        }
        
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrMain.contentSize=CGSizeMake(kScreenWidth, 568);
    scrMain.scrollEnabled = YES;
   
}


-(void)modifyName
{
    AreaRow.lbLeftlabel.text=kLocalized(@"area");
    AreaRow.tfRightTextField.text=self.model.strFriendAddress;
    hobbyRow.lbLeftlabel.text=kLocalized(@"hobby");
    hobbyRow.tfRightTextField.text=self.model.strFriendInterest;
    SignRow.lbLeftlabel.text=kLocalized(@"sign");
    SignRow.tfRightTextField.text=self.model.strFriendSign;
    lbNickname.textColor=kCellItemTextColor;
    
    
//   
//    CGFloat addressStringHeight =[Utils heightForString:self.model.strFriendAddress fontSize:16.0 andWidth:191.0] ;
//    CGFloat friendInerestHeight = [Utils heightForString:self.model.strFriendInterest fontSize:16.0 andWidth:191.0];
//    CGFloat friendSignHeight =[Utils heightForString:self.model.strFriendSign fontSize:16.0 andWidth:191.0];
////    NSLog(@"%f------bbbbb",friendInerestHeight);
//    CGRect frameArea=AreaRow.tfRightTextField.frame;
//    frameArea.size.height=addressStringHeight>rowHeight?addressStringHeight:rowHeight;
//    UILabel * lbAddress =[[UILabel alloc]initWithFrame:frameArea];
//
//    CGRect frameHobby =hobbyRow.tfRightTextField.frame;
//    frameHobby.size.height=friendInerestHeight>rowHeight?friendInerestHeight:rowHeight;
//    UILabel * lbHobby =[[UILabel alloc]initWithFrame:frameHobby];
//    
//    CGRect frameSign =SignRow.tfRightTextField.frame;
//    frameSign.size.height=friendSignHeight>rowHeight?friendSignHeight:rowHeight;
//    UILabel * lbSign =[[UILabel alloc]initWithFrame:SignRow.tfRightTextField.frame];
//    lbAddress.text=self.model.strFriendAddress;
////    lbAddress.backgroundColor=[UIColor blueColor];
//    lbHobby.text=self.model.strFriendInterest;
//    lbSign.text=self.model.strFriendSign;
    
    
    
    [btnAddToFriend setTitle:kLocalized(@"add_to_friend") forState:UIControlStateNormal];
    lbName.text=self.model.strFriendName;
    
    lbName.textColor=kCellItemTitleColor;

    lbNameNumber.textColor=kCellItemTextColor;
    
    [btnAddToFriend setBackgroundImage:[UIImage imageNamed:@"alert_btn_confirm_bg"] forState:UIControlStateNormal];

    
}

- (IBAction)btnSeeMore:(id)sender {
    
    GYPersonDetailFileViewController * vcDetailInfo =[[GYPersonDetailFileViewController alloc]initWithNibName:@"GYPersonDetailFileViewController" bundle:nil];
    [self.navigationController pushViewController:vcDetailInfo animated:YES];
    
}


-(void)loadDataFromNetwork
{
    GlobalData *data = [GlobalData shareInstance];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    
    NSString * strNickName = data.IMUser.strNickName;
    NSString * strHeadPic = data.IMUser.strHeadPic;
    if (data.IMUser.strNickName.length>0) {
        strNickName = data.IMUser.strNickName;
        
    }else
    {
        strNickName = data.IMUser.strAccountNo;
        
    }

   if (data.IMUser.strHeadPic.length>0) {
       strHeadPic=data.IMUser.strHeadPic;
       
    }else
   {
       strHeadPic=@"";
    
    }
    
    [insideDict setValue:strNickName forKey:@"accountNickname"];
    
    [insideDict setValue:@"1" forKey:@"friendStatus"];
    
    

    [insideDict setValue:self.model.strFriendID forKey:@"friendId"];
    
    [insideDict setValue:self.model.strFriendName forKey:@"friendNickname"];
    
    [insideDict setValue:strHeadPic forKey:@"accountHeadPic"];
    
    [insideDict setValue:self.model.strFriendIconURL  forKey:@"friendHeadPic"];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    

    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"请稍后..."];
    [Network HttpPostForImRequetURL: [[GlobalData shareInstance].hdbizDomain stringByAppendingString:@"/hsim-bservice/addFriend"]parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                
                if ([ResonpseDict[@"retCode"] isEqualToString:@"200"]) {
                    self.model.friendStatus = kAskForAuth;
                    [self.vcFriend refresdData];
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"添加成功,等待对方验证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }else if ([ResonpseDict[@"retCode"] isEqualToString:@"201"])
                {
                    [Utils showMBProgressHud:self SuperView:self.view Msg:@"好友已经存在" ShowTime:2.0];
                }
                
                btnAddToFriend.enabled = NO;
            }
            
        }
        
    }];
    
    
}

#pragma mark 设置备注的代理方法
-(void)getUserRemark:(NSString *)strRemark
{
    self.model.strFriendName=strRemark;
    lbName.text=self.model.strFriendName;       

}

- (IBAction)btnAddToFriend:(id)sender {
    
    [self loadDataFromNetwork];
    
    
}
// add by songjk 进入聊天页面
- (IBAction)chatClick:(UIButton *)sender
{
    switch (_useType) {
        case kPersonInfoFromChat:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case KPersonInfoFromFriendList:
        case KPersonInfoFromCheck:
        {
            GYChatViewController * vcChat =[[GYChatViewController alloc]initWithNibName:@"GYChatViewController" bundle:nil];
            vcChat.model=self.model;
//            vcChat.title=self.model.strFriendName;
            if (personInfo.strNickName.length>0)
            {
                vcChat.title=personInfo.strNickName;
            }
            else
            {
                vcChat.title=personInfo.strName;
            }
            NSString * strRemark = [GYChatItem getRemarkWithFriendId:[Utils getResNO:self.model.strFriendID] myID:[GlobalData shareInstance].IMUser.strAccountNo];
            if (strRemark.length>0)
            {
                vcChat.title=strRemark;
            }
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcChat animated:YES];
  
        }
            break;
        default:
            break;
    }
    
    
   }
@end

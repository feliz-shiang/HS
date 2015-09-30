//
//  GYRootViewController.m
//  searchBar
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "GYFriendManageViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "GYFriendManageTableViewCell.h"
#import "GlobalData.h"
//添加好友
#import "GYAddFriendViewController.h"

#import "GYNewFriendViewController.h"
//聊天界面
#import "GYChatViewController.h"
#import "UIImageView+WebCache.h"
#import "GYPopView.h"
#import "UITableView+GYExtendSeparator.h"
#import "UIAlertView+Blocks.h"
#import "GYPersonDetailInfoViewController.h"
#import "GYDBCenter.h"

#import "GYupdateNicknameViewController.h"

#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define FILTEREDKEYS [self.filterDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"1234567", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil]
#define DEFAULTKEYSTest [dataArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@interface GYFriendManageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GYPopViewDelegate,UIAlertViewDelegate,UISearchDisplayDelegate>

@end

@implementation GYFriendManageViewController
{
    //    NSArray * keys;
    NSArray * arrTest;
    NSUInteger indexDel;
    GYPopView * pv;
    BOOL isShowRedPoint;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的好友";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameDictionary = [[NSMutableDictionary alloc]init];
    self.filterDictionary = [[NSMutableDictionary alloc]init];
    self.marrDatasource=[[NSMutableArray alloc]init];
    
    if ([GlobalData shareInstance].isHdLogined)
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(pushToAddFriend)];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索好友"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    
   
    CGRect rect =self.tableView.frame;
    UIView * background =[[UIView alloc]initWithFrame:rect];
    background.backgroundColor=kDefaultVCBackgroundColor;
    self.tableView.backgroundView=background;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = mySearchBar;
    self.tableView.tableFooterView=[[UIView alloc]init];
//    self.tableView.sectionHeaderHeight=20;
    

    [self.tableView   tableviewExtendSeparator];
    
    
//    
//    [self.tableView registerNib:[UINib nibWithNibName:@"GYFriendManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"GYFriendManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![GlobalData shareInstance].isHdLogined)
    {
        if (![GlobalData shareInstance].isEcLogined)
        {
//            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex != 0)
//                {
//                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
//                }
//            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        return;
    }
#warning first
    [self loadDataFromNetwork];
}


-(void)pushToAddFriend
{
    GYAddFriendViewController * vcAddFriend =[[GYAddFriendViewController alloc]initWithNibName:@"GYAddFriendViewController" bundle:nil];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vcAddFriend animated:YES];
    
}

-(void)addDataWithSouces:(NSArray *)array :(NSMutableDictionary *)dictionary
{
    if ([dictionary.allKeys count]!=0)
    {
        [dictionary removeAllObjects];
    }
    
    for (NSString * string in ALPHA_ARRAY)
    {
        NSMutableArray * tempEnglish =[[NSMutableArray alloc] init];
        for (GYNewFiendModel * mod in array)
        {
            NSString * tempStr=mod.strFriendName;
            // add by songjk
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            //检查用户nickname 是否有中文
            if ([ChineseInclude isIncludeChineseInString:mod.strFriendName])
            {
                tempStr =[PinYinForObjc chineseConvertToPinYinHead:mod.strFriendName];
            }
            NSString *firstLetter;
            if (tempStr.length>=1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }else
            {
                NSLog(@"%@-------bbbbb",tempStr);
            }
          
           
            if (![ALPHA_ARRAY containsObject:firstLetter])
            {
                tempStr = [@"#" stringByAppendingString:tempStr];

                firstLetter = [[tempStr substringToIndex:1] uppercaseString];

               
            }
            
            if([firstLetter isEqualToString:string])
            {
                [tempEnglish addObject:mod];
            }
        }
        if (tempEnglish.count > 0)
        {
            [dictionary setObject:tempEnglish forKey:string];
        }
    }
    NSLog(@"%@-------bbbb",dictionary);
    [self.tableView reloadData];
}


#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView== searchDisplayController.searchResultsTableView) {
        
        
        return 1;
    }
    NSLog(@"%lu========有多少个Section",ALPHA_ARRAY.count);
    return ALPHA_ARRAY.count;
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView * headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel  * lbSectionTtile = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, 60, 15)];
    lbSectionTtile.backgroundColor=[UIColor clearColor];
    
    
    if (tableView==self.tableView) {
        //通过section中得字母取出对应的数据
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[section]];
        
        if (arr) {
            
            
            lbSectionTtile.text=ALPHA_ARRAY[section];
      
        }
        else{
            
            return nil;
            
        }
    }
    
    [headerInSection addSubview:lbSectionTtile];
    return headerInSection;


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat  sectionHeight;
    if (tableView==self.tableView) {
        
        //通过section中得字母取出对应的数据
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[section]];
        
        if (arr) {
            
            
            sectionHeight=30.f;
            
        }
        else{
            
            sectionHeight=0;
            
        }
    }
    
    return sectionHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (searchDisplayController.searchResultsTableView) {
        return 44;
    }
    return 44.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == searchDisplayController.searchResultsTableView) {
        
        
        return searchResults.count;
    }
    else {
        
        
        
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[section]];
        
        if (section==0) {
            return 1;
        }else
        {
            if (arr) {
                
                NSLog(@"%lu-------arr.count",arr.count);
                return arr.count;
            }
            else{
                
                
                return 0;
                
            }
            
        }
        
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //modify by zhanglei 2015.09.22 IOS消费者 我的好友页面无法通过昵称、备注搜索到好友

    static NSString *CellIdentifier = @"cell";
    GYFriendManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // cell = [[GYFriendManageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"GYFriendManageTableViewCell" owner:self options:nil]lastObject];
        [tableView registerNib:[UINib nibWithNibName:@"GYFriendManageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    if (tableView == searchDisplayController.searchResultsTableView) {
        
        GYNewFiendModel * mod=searchResults[indexPath.row];
        
        [cell refreshUIWithModel:mod index:1 withShowRedPoint:isShowRedPoint];
        
    }
    else {
        
        if (indexPath.section==0) {
            GYNewFiendModel * mod=[[GYNewFiendModel alloc]init];
            
            mod.strFriendName=@"新的朋友";

            // modify by songjk
            mod.strFriendIconURL = @"icon_im_new_friend.png";
            [cell refreshUIWithModel:mod index:0 withShowRedPoint:isShowRedPoint];
        }else
        {
//            NSLog(@"%d-------11111",self.marrDatasource.count);
            
             NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
            if (arr.count>0)
            {
                
                NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
                
                UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deletefriend:)];
                [cell addGestureRecognizer:longPress];
                
                GYNewFiendModel * mod=arr[indexPath.row];
 
                [cell refreshUIWithModel:mod index:1 withShowRedPoint:isShowRedPoint];
   
            }
  
        }
   
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
//    
//}
#pragma mark 左滑添加备注
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0)
    {
        return NO;
    }
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    //    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete)//删除
    {
        GYNewFiendModel * mod = nil;
        if (tableView == searchDisplayController.searchResultsTableView)
        {
            mod=searchResults[indexPath.row];
            
        }
        else
        {
            
            
            if (indexPath.section==0)
            {
                return;
            }
            else
            {
                NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
                if (arr.count>0)
                {
                    
                    NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
                    mod=arr[indexPath.row];
                }
            }
        }
        NSLog(@"备注");
        [self pushToUpdateNicknameVCWithFriendID:mod.strFriendID];
    }
    else
    {
        NSLog(@"其它");
    }
    
}
-(void )pushToUpdateNicknameVCWithFriendID:(NSString *)friendID;
{
    GYupdateNicknameViewController * vcUpdateNickName =[[GYupdateNicknameViewController alloc]initWithNibName:@"GYupdateNicknameViewController" bundle:nil];
    
    vcUpdateNickName.friendId=friendID;
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
//修改编辑按钮文字

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return @"备注";
    
}
#pragma mark 长按删除好友
-(void)deletefriend:(UILongPressGestureRecognizer *)longPress
{
    
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        indexDel = indexPath.row;
        
        //设置弹窗tableView
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
        GYNewFiendModel * mod=arr[indexPath.row];
        
        NSString *  strShield;
        //根据model中得数据，显示屏蔽消息
        if ([mod.isShield isEqualToString:@"1"]) {
            strShield=@"取消屏蔽";
        }
        else{
            strShield=@"屏蔽消息";
            
        }
        
        
        NSArray *arrSel = @[mod.strFriendName,strShield,@"删除好友"];
        
        
        
        CGRect bigFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 140, [UIScreen mainScreen].bounds.size.height/2 - 22* arrSel.count, 280, 44* arrSel.count);
        //设置弹窗tableView 缩少Frame
        CGRect smallFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
        //设置弹窗背景颜色
        UIColor *bgColor =  kCorlorFromRGBA(0,0,0,0.5);
        
        
        pv = [[GYPopView alloc] initWithCellType:2 WithArray:arrSel  WithImgArray:nil WithBigFrame:bigFrame WithSmallFrame:smallFrame WithBgColor:bgColor];
        pv.indexPath = indexPath;
        pv.cellType=3;
        pv.delegate = self;
        
        [self.view.window addSubview:pv];
        pv = nil;
    }
    
}


#pragma mark 弹出窗口的代理方法。
-(void)deleteDataWithIndex:(NSIndexPath *)indexPath WithSelectRow:(int)row

{
    NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
    GYNewFiendModel * mod=arr[indexPath.row];
    
    switch (row) {
        case 0:
        {
   
        }
            break;
        case 1:
        {
            if ([mod.isShield isEqualToString:@"1"]) {
                
                [self shieldFriendRequest:mod WithShieldStatus:@"0"];
                
            }
            else
            {
                [self shieldFriendRequest:mod WithShieldStatus:@"1"];
                
            }
            
        }
            break;
        case 2:
        {
            
                        [UIAlertView showWithTitle:@"提示" message:@"删除好友同事会删除和该好友的所有聊天记录。" cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex==0) {
                                
                            [self delelteFriendRequest:mod];

                            }
                        }];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}


//屏蔽消息，或者取消屏蔽
-(void)shieldFriendRequest:( GYNewFiendModel *) mod WithShieldStatus :(NSString *)shieldStatus
{
    
    GlobalData *data = [GlobalData shareInstance];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    
    
    [insideDict setValue:mod.strAccountID forKey:@"friendId"];
    
    [insideDict setValue:shieldStatus forKey:@"isShield"];
    
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"请稍后..."];
    
    [Network HttpPostForImRequetURL:  [[GlobalData shareInstance].hdbizDomain  stringByAppendingString:@"/hsim-bservice/shieldFriendMsg"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                
                if ([ResonpseDict[@"retCode"] isEqualToString:@"200"]) {
                    
                    NSString * message;
                    if ([shieldStatus isEqualToString:@"0"]) {
                        message=@"取消屏蔽成功！";
                    }else{
                        
                        message=@"屏蔽消息成功！";
                    }
                    
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

- (void)refreshTableAfterDeleteFriend:(GYNewFiendModel *)deleteFriend
{
    [self.marrDatasource removeObject:deleteFriend];
    [self addDataWithSouces:self.marrDatasource :self.nameDictionary];
    [self.tableView reloadData];
}

//删除好友的请求
-(void)delelteFriendRequest:( GYNewFiendModel *) mod
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    
    [insideDict setValue:data.IMUser.strNickName forKey:@"accountNickname"];
    
    [insideDict setValue:data.IMUser.strHeadPic forKey:@"accountHeadPic"];
    
    [insideDict setValue:mod.strAccountID forKey:@"friendId"];
    
    [insideDict setValue:mod.strFriendName forKey:@"friendNickname"];
    
    [insideDict setValue:@"4" forKey:@"friendStatus"];
    
    [insideDict setValue:mod.strFriendIconURL  forKey:@"friendHeadPic"];
    
    
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
                    if([GYDBCenter deleteUserAllMessageWithUserAccount:mod.strAccountID])
                    {
                        
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
                        
                    }
#warning third

                    
                    [self refreshTableAfterDeleteFriend:mod];
                    
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"好友删除成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }else
                {
                    
                }
                
                
            }
            
        }
        
    }];
    
    
}

#pragma mark uialertview Delegate
#warning second
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    //[self.tableView reloadData];
   // [self  loadDataFromNetwork];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![GlobalData shareInstance].isHdLogined)
        return;
    
    if (indexPath.section==0 && indexPath.row==0 && tableView != searchDisplayController.searchResultsTableView) {
        
        GYNewFriendViewController * vcNewFriend =[[GYNewFriendViewController alloc]initWithNibName:@"GYNewFriendViewController" bundle:nil];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vcNewFriend animated:YES];
        
    }else {
        // modify by songjk 进入详情界面
//        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
//        
//        GYNewFiendModel * mod=arr[indexPath.row];
//        GYChatViewController * vcChat =[[GYChatViewController alloc]initWithNibName:@"GYChatViewController" bundle:nil];
//        vcChat.model=mod;
//        vcChat.title=mod.strFriendName;
//        
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vcChat animated:YES];
        GYPersonDetailInfoViewController * vcPersonInfo =[[GYPersonDetailInfoViewController alloc]initWithNibName:@"GYPersonDetailInfoViewController" bundle:nil];
        vcPersonInfo.delegate = self;
        
        //2015.09.24 IOS消费者 通过搜索框搜索好友，点击好友，资料详情为空 modify by zhanglei 增加搜索后的判断，从searchResults搜索结果中加载数据
        if (tableView == searchDisplayController.searchResultsTableView) {
            GYNewFiendModel * mod=searchResults[indexPath.row];
            vcPersonInfo.model=mod;
            vcPersonInfo.useType=KPersonInfoFromFriendList;
        }else{
        
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
        GYNewFiendModel * mod=arr[indexPath.row];
        vcPersonInfo.model=mod;
            vcPersonInfo.useType=KPersonInfoFromFriendList;
        }
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vcPersonInfo animated:YES];
      
    }
}
#warning loadDataFromNetwork
#if 1
//获取好友列表
-(void)loadDataFromNetwork
{
    [self.marrDatasource removeAllObjects];
    GlobalData *data = [GlobalData shareInstance];
    
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:insideDict forKey:@"data"];
    [dict setValue:data.midKey forKey:@"mid"];
    [Network HttpPostForImRequetURL: [[GlobalData shareInstance].hdbizDomain stringByAppendingString:@"/hsim-bservice/queryFriendList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {

        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            
            if (!error) {
                if ([[ResonpseDict objectForKey:@"retCode"] isEqualToString:@"200"]) {
                    
                     isShowRedPoint=[[ResonpseDict objectForKey:@"verifyFlag"] boolValue];
                    
                    for (NSDictionary * dic in [ResonpseDict objectForKey:@"rows"]) {
                        GYNewFiendModel * model =[[GYNewFiendModel alloc]init];
 
                        model.strFriendIconURL=[dic objectForKey:@"headPic"];
                        
                        model.strAccountID=[dic objectForKey:@"accountId"];
                        
                        model.isShield =kSaftToNSString([dic objectForKey:@"isShield"]);
                        
                        model.strFriendID=[dic objectForKey:@"accountId"] ;

                        NSString *str = dic[@"nickname"];
                        
                        if (str.length > 0)
                        {
                            model.strFriendName=[dic objectForKey:@"nickname"];
                        }
                        else
                        {
                        NSString * nickName =[model.strFriendID substringFromIndex:[model.strFriendID rangeOfString:@"c_"].location+2];
                            
                        model.strFriendName=nickName;
                            
                        }

                        model.friendStatus=(int)[[dic objectForKey:@"friendStatus"] integerValue];
                      
                        [self.marrDatasource addObject:model];           
                        
                    }
       
                    [self addDataWithSouces:self.marrDatasource :self.nameDictionary ];
                    
                }else if ([[ResonpseDict objectForKey:@"retCode"] isEqualToString:@"204"])
                {
                    
                    isShowRedPoint=[[ResonpseDict objectForKey:@"verifyFlag"] boolValue];
                    //                    [self addDataWithSouces:self.marrDatasource :self.nameDictionary ];
                    ////                        [self.tableView reloadData];
                    //                    [Utils showMBProgressHud:self SuperView:self.view  Msg:@"查询无数据" ShowTime:3.0f];
                    //
                }else
                {
                    
                    
                    
                    
                }
                 //  [self.tableView reloadData];
                
            }
            
        }
        
    }];
    
    
  //  [self addDataWithSouces:self.marrDatasource :self.nameDictionary];
}
#endif

// 保存备注
-(void)saveRemark
{
    for (GYNewFiendModel * model in self.marrDatasource)
    {
        NSString * myID = [GlobalData shareInstance].IMUser.strAccountNo;
        NSString *resNO = [Utils getResNO:model.strAccountID];
        NSDictionary * dict = @{@"friend_id":resNO,@"my_id":myID,@"msg_type":@"1",@"res_no":resNO};
        [GYChatItem setRemark:model.strFriendName dictData:dict];
    }
}
#pragma UISearchDisplayDelegate
//modify by zhanglei 2015.09.21 用06112110001 111111  搜索“一” 是无搜过结果的，在好友的昵称中是有一的好友
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    searchResults = [[NSMutableArray alloc]init];
    // modify by songjk
    if ([Utils isBlankString:searchText]) {
        return ;
    }
    
    if (mySearchBar.text.length>0)
    {
        
        NSMutableArray * marrtest = [NSMutableArray array];
        [marrtest addObjectsFromArray:[self.nameDictionary allValues]];
        for (NSArray * arr in marrtest) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GYNewFiendModel * model = obj;
                
                if ([ChineseInclude isIncludeChineseInString:mySearchBar.text]){
                    //把中文转换为拼音
                    //                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strFriendName];
                    //                    NSString *searchBarPinYinStr = [PinYinForObjc chineseConvertToPinYinHead:mySearchBar.text];
                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
                    NSString *searchBarPinYinStr = [PinYinForObjc chineseConvertToPinYin:mySearchBar.text];
                    
                    if (datasourcePinYinStr.length>=searchBarPinYinStr.length) {
                        NSRange titleResult=[datasourcePinYinStr rangeOfString:searchBarPinYinStr options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0 && [model.strFriendName rangeOfString:searchText].location != NSNotFound) {
                            
                            [searchResults addObject:model];
                        }
                    }
                    if (searchText.length<= model.strFriendName.length)
                    {
                        if ([model.strFriendName rangeOfString:searchText].location != NSNotFound &&![searchResults containsObject:model]) {
                            [searchResults addObject:model];
                        }
                    }
                    
                }
                //没有中文来到这里
                else {
                    //                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strFriendName];
                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
                    if (datasourcePinYinStr==nil || datasourcePinYinStr.length == 0) {
                        datasourcePinYinStr = model.strFriendName;
                    }
                    //                    NSRange titleResult=[[datasourcePinYinStr substringToIndex:1 ] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    NSRange titleResult=[datasourcePinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:model];
                    }
                    else if (searchText.length<= model.strFriendName.length)
                    {
                        if ([model.strFriendName rangeOfString:searchText].location != NSNotFound) {
                            [searchResults addObject:model];
                        }
                    }
                }
                
            }];
            
        }
    }
    //    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text])
    //    {
    //
    //        NSMutableArray * marrtest = [NSMutableArray array];
    //        [marrtest addObjectsFromArray:[self.nameDictionary allValues]];
    //        for (NSArray * arr in marrtest) {
    //            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //                GYNewFiendModel * model = obj;
    //
    //                if ([ChineseInclude isIncludeChineseInString:model.strFriendName]){
    //                    //把中文转换为拼音
    //                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
    //                    NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
    //                    if (titleResult.length>0) {
    //                        [searchResults addObject:model];
    //                    }
    //                }
    //                //没有中文来到这里
    //                else {
    //                    NSRange titleResult=[model.strFriendName rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
    //                    if (titleResult.length>0) {
    //
    //                        [searchResults addObject:model];
    //                    }
    //                }
    //
    //            }];
    //
    //        }
    //    }
    //    else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
    //        for (NSString *tempStr in dataArray) {
    //            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
    //            if (titleResult.length>0) {
    //                [searchResults addObject:tempStr];
    //            }
    //        }
    //    }
    if (kSystemVersionLessThan(@"7.0")) {
        [searchDisplayController.searchResultsTableView reloadData];
    }
    
}

@end

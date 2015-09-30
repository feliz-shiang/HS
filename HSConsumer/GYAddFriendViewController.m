//
//  GYAddFriendViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAddFriendViewController.h"
#import "GYNewFriendCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "GYNewFiendModel.h"
#import "GlobalData.h"
#import "GYPersonDetailInfoViewController.h"
#import "GYChatViewController.h"
#import "MJRefresh.h"

@interface GYAddFriendViewController ()<UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,weak) UITableView * tvSelected;
@end

@implementation GYAddFriendViewController


{
    
    
    __weak IBOutlet UITableView *tvNewFriend;
    NSArray * arr;
    NSMutableArray * searchResults;
    
    BOOL isUpFresh;
    int currentStart;
    int totalPage;
    NSString * inputText;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=kLocalized(@"add_friend");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    currentStart=0;
    [mySearchBar setPlaceholder:@"互生号/昵称"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.tableFooterView=[[UIView alloc]init];
    searchDisplayController.delegate = self;
//    if (kSystemVersionGreaterThanOrEqualTo(@"7.0")) {
//        searchDisplayController.searchResultsTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
//    }
    
    if ([searchDisplayController.searchResultsTableView respondsToSelector:@selector(setSeparatorInset:)]||[tvNewFriend respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [searchDisplayController.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if (kSystemVersionGreaterThanOrEqualTo(@"8.0"))
    {
//        [searchDisplayController.searchResultsTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    
    tvNewFriend.tableHeaderView=mySearchBar;
    tvNewFriend.dataSource = self;
    tvNewFriend.delegate = self;
    tvNewFriend.tableFooterView=[[UIView alloc]init];
//      [tvNewFriend addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//    [tvNewFriend registerNib:[UINib nibWithNibName:@"GYNewFriendCell" bundle:nil]forCellReuseIdentifier:NewFriendCellIdent];
    tvNewFriend.tableFooterView=[[UIView alloc]init];
//    [self.searchDisplayController.searchResultsTableView registerNib: [UINib nibWithNibName:@"GYNewFriendCell" bundle:nil]forCellReuseIdentifier:NewFriendCellIdent];
//    
//     [self loadDataFromNetwork];
    

}

#pragma mark 开始进入刷新状态
//- (void)headerRereshing
//{
//    currentPage=1;
//    isUpFresh=YES;
//    [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%d",sortType] Witharea:areaString];
//    
//}



- (void)footerRereshing
{
    
    isUpFresh=NO;
//    if (currentPage<=totalPage) {
        // modify by songjk
       [self QueryFriendRequest:inputText];
//        
//    }
    
    
    
}



-(void)loadDataForQueryFromNetwork
{
    
    GlobalData *data = [GlobalData shareInstance];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"resource_no"];
    
    [insideDict setValue:@"" forKey:@"nickname"];
    [insideDict setValue:@"" forKey:@"name"];
    [insideDict setValue:@"5" forKey:@"start"];
    [insideDict setValue:@"10" forKey:@"rows"];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"tookenid"];
    [dict setValue:insideDict forKey:@"data"];
    
  
   
    [Network HttpPostForImRequetURL: [[GlobalData shareInstance].hdbizDomain stringByAppendingString:@"/hsim-bservice/queryPersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                NSLog(@"%@--------responsedict",ResonpseDict);
            }
            
        }
        
    }];
    
    
}
// 刷新数据
-(void)refresdData
{
    if (self.tvSelected == self.searchDisplayController.searchResultsTableView) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else
    {
        [tvNewFriend reloadData];
    }
}
#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return searchResults.count;
    }
    
    return self.marrDatasource.count;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //modify by zhanglei 2015.09.22IOS消费者 添加好友时，搜索框输入“但” 提示已经全部加载完毕。当点击取消时就可以显示查询结果
    self.tvSelected = tableView;
    static NSString *myCell = NewFriendCellIdent;
    GYNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell==nil) {
        
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"GYNewFriendCell" owner:self options:nil]lastObject];
        
        [tableView registerNib:[UINib nibWithNibName:@"GYNewFriendCell" bundle:nil] forCellReuseIdentifier:myCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell = [tableView dequeueReusableCellWithIdentifier:myCell];
     }
    [cell.btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAdd.tag=indexPath.row;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        GYNewFiendModel * model =searchResults[indexPath.row];
        [cell refreshUIWith:model];
        
   }else{
        
        GYNewFiendModel * model =self.marrDatasource[indexPath.row];
        
        [cell refreshUIWith:model];
    }
    return cell;
}
// 添加好友
-(void)btnClicked:(UIButton *)sender
{
    
    __block GYNewFiendModel * model = searchResults[sender.tag];
    
    if ([sender.currentTitle isEqualToString:@""]) {
        [self loadDataFromNetworkWithModel:model];
    }
    else if([sender.currentTitle isEqualToString:@"添加"])
    {
        
        GlobalData *data = [GlobalData shareInstance];
        NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
        [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
        
        NSString * strNickName;
        
        if (data.user.userName.length>0) {
            strNickName = data.IMUser.strNickName;
            
        }else
        {
            if (data.IMUser.strAccountNo.length>=11) {
                strNickName = [NSString stringWithFormat:@"%@****%@",[data.IMUser.strAccountNo  substringToIndex:3],[data.IMUser.strAccountNo substringFromIndex:(data.IMUser.strAccountNo.length-4)]];
            }else
            {
                 strNickName = data.IMUser.strAccountNo;
            }
            
        }
        [insideDict setValue:strNickName forKey:@"accountNickname"];
        [insideDict setValue:data.user.useHeadPictureURL forKey:@"accountHeadPic"];
        
        [insideDict setValue:model.strFriendID forKey:@"friendId"];
        [insideDict setValue:model.strFriendName forKey:@"friendNickname"];
        [insideDict setValue:model.strFriendIconURL forKey:@"friendHeadPic"];
        [insideDict setValue:@"2" forKey:@"friendStatus"];
        NSMutableDictionary * dict =[NSMutableDictionary dictionary];
        [dict setValue:@"2" forKey:@"channel_type"];
        [dict setValue:@"1.0" forKey:@"version"];
        [dict setValue:data.ecKey forKey:@"key"];
        [dict setValue:data.midKey forKey:@"mid"];
        [dict setValue:insideDict forKey:@"data"];
        
        
        [Network HttpPostForImRequetURL: [[GlobalData shareInstance].hdbizDomain  stringByAppendingString:@"/hsim-bservice/addFriend"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
            
            if (!error) {
                
                NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                NSLog(@"%@   resopsedict",ResonpseDict);
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResonpseDict[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    model.friendStatus = kAgreeForAdd;
                    if (self.tvSelected == self.searchDisplayController.searchResultsTableView) {
                        [self.searchDisplayController.searchResultsTableView reloadData];
                    }
                    else
                    {
                        [tvNewFriend reloadData];
                    }
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
                else
                {
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
            }
            
        }];
    }
}
// 主动添加好友
-(void)loadDataFromNetworkWithModel:(GYNewFiendModel *)model
{
    __block GYNewFiendModel * friendModel = model;
    GlobalData *data = [GlobalData shareInstance];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    
    NSString * strNickName ;
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
    
    [insideDict setValue:model.strFriendID forKey:@"friendId"];
    
    [insideDict setValue:model.strFriendName forKey:@"friendNickname"];
    
    [insideDict setValue:strHeadPic forKey:@"accountHeadPic"];
    
    [insideDict setValue:model.strFriendIconURL  forKey:@"friendHeadPic"];
    
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
                    friendModel.friendStatus = kAskForAuth;
                    if (self.tvSelected == self.searchDisplayController.searchResultsTableView) {
                        [self.searchDisplayController.searchResultsTableView reloadData];
                    }
                    else
                    {
                        [tvNewFriend reloadData];
                    }
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"添加成功,等待对方验证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }else if ([ResonpseDict[@"retCode"] isEqualToString:@"201"])
                {
                    [Utils showMBProgressHud:self SuperView:self.view Msg:@"好友已经存在" ShowTime:2.0];
                }
                
                
            }
            
        }
    }];
    
    
}

#pragma mark TableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYNewFiendModel * model = searchResults[indexPath.row];
    if (model.friendStatus == 0) {
        GYPersonDetailInfoViewController *vcPersonInfo =[[GYPersonDetailInfoViewController alloc]initWithNibName:@"GYPersonDetailInfoViewController" bundle:nil];
        self.hidesBottomBarWhenPushed=YES;
        vcPersonInfo.model=model;
 
        if (vcPersonInfo.model.friendStatus==2) {
            vcPersonInfo.isAdded=YES;
        }
        
        vcPersonInfo.vcFriend = self;
        vcPersonInfo.useType = KPersonInfoFromCheck;
        [self.navigationController pushViewController:vcPersonInfo animated:YES];
    }
    else if (model.friendStatus == 2)
    {
        [self beginChatWithModel:model];
    }
}

// 进入聊天界面
- (void)beginChatWithModel:(GYNewFiendModel *)model
{
    GYChatViewController * vcChat =[[GYChatViewController alloc]initWithNibName:@"GYChatViewController" bundle:nil];
    vcChat.model=model;
    vcChat.title=model.strFriendName;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcChat animated:YES];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
    
}




#pragma UISearchDisplayDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    currentStart=0;
     isUpFresh=YES;
    self.marrDatasource = searchResults;
    [tvNewFriend reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!searchResults) {
        searchResults = [[NSMutableArray alloc]init];
        arr =[NSMutableArray array];
    }

    
    if ([Utils isBlankString:searchText]) {
        currentStart=0;
        return ;
    }
    
    
    if (mySearchBar.text.length>0) {
        NSMutableArray * marrData = [NSMutableArray array];
        for (GYNewFiendModel * model in searchResults)
        {
            if ([ChineseInclude isIncludeChineseInString:model.strFriendName]){
                //把中文转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [marrData addObject:model];
                }
            } //没有中文来到这里
            else {
                NSRange titleResult=[model.strFriendName rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    
                    [marrData addObject:model];
                }
            }
            
        }
        if (marrData.count>0) {
            searchResults = marrData;
        }
    }
    [self.searchDisplayController.searchResultsTableView reloadData];

    
    
//    &&![ChineseInclude isIncludeChineseInString:mySearchBar.text]
//    if (mySearchBar.text.length>0) {
//        for (GYNewFiendModel * model in self.marrDatasource)
//        {
//            if ([ChineseInclude isIncludeChineseInString:model.strFriendName]){
//                //把中文转换为拼音
//                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
//                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//                if (titleResult.length>0) {
//                    [searchResults addObject:model];
//                }
//            } //没有中文来到这里
//                else {
//                    NSRange titleResult=[model.strFriendName rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//                    if (titleResult.length>0) {
//                     
//                        [searchResults addObject:model];
//                    }
//                }
//                
//            }
//        
//    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
    
//        for (NSString *tempStr in arr) {
//            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                [searchResults addObject:tempStr];
//            }
//        }
        
//        if ([ChineseInclude isIncludeChineseInString:model.strFriendName]){
//            //把中文转换为拼音
//            NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strFriendName];
//            NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                [searchResults addObject:model];
//            }
//        } //没有中文来到这里
//        else {
//            NSRange titleResult=[model.strFriendName rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                
//                [searchResults addObject:model];
//            }
//        }
        
//    }
//    }

}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//  
//    return YES;
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//
//    currentStart=0;
//    
//    inputText =searchBar.text;
//    
//    //请求之前清空数组。避免数据重复。
//    //输入有内容 ，才发请求。
//    isUpFresh=YES;
//    if (searchBar.text.length>0) {
//        
//        [self QueryFriendRequest:searchBar.text];
//    }
//
//}



- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

     inputText =searchBar.text;
    
    //请求之前清空数组。避免数据重复。
    //输入有内容 ，才发请求。
    isUpFresh=YES;
    if (searchBar.text.length>0) {
    
        [self QueryFriendRequest:searchBar.text];
    }


}


-(void)QueryFriendRequest:(NSString * )resourceNo
{
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isHdLogined)
    {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    

    [self.marrDatasource removeAllObjects];
    
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];

    [insideDict setValue:resourceNo forKey:@"resourceNo"];
    [insideDict setValue:[NSString stringWithFormat:@"%d",currentStart] forKey:@"start"];
    [insideDict setValue:@"20" forKey:@"rows"];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain stringByAppendingString:@"/userc/queryPersonInfoList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {

        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error&&[ResonpseDict[@"data"] isKindOfClass:[NSArray class]]) {
             
                [searchDisplayController.searchResultsTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                NSMutableArray * dataSource =[NSMutableArray array];
                currentStart+=20;
                if ([ResonpseDict[@"data"] count]>0) {
                    
                    
                    for (NSDictionary * tempDic in ResonpseDict[@"data"]) {
                        GYNewFiendModel * model =[[GYNewFiendModel alloc]init];
                        model.strFriendName=tempDic[@"nickName"];
                        model.strFriendIconURL=tempDic[@"headPic"];
                        model.strUserId=tempDic[@"userId"];
                        model.strFriendOccupation=tempDic[@"occupation"];
                        model.strFriendAddress=tempDic[@"address"];
                        model.strFriendMobile=tempDic[@"mobile"];
                        model.strFriendSign=tempDic[@"sign"];
                        model.strFriendInterest=tempDic[@"interest"];
                        model.strAccountNo=kSaftToNSString(tempDic[@"accountNo"]);
                        
                        model.strFriendID=tempDic[@"accountId"];
                        if ([model.strFriendID hasPrefix:@"c_"]) {
                            model.strAccountNo= [model.strFriendID substringFromIndex:2];
                        }else
                        {
                            model.strAccountNo= [model.strFriendID substringFromIndex:3];
                        }
                        model.strAccountID = model.strFriendID;// add by songjk 查询资料用到
                        if (tempDic[@"friendStatus"])
                        {
                            if ([tempDic[@"friendStatus"]  isEqualToString:@"0"]) {
                                model.friendStatus=kCanBeAdd;
                                
                            }else if ([tempDic[@"friendStatus"]  isEqualToString:@"1"]) {
                                model.friendStatus=kAskForAdd;
                                
                            }else if([tempDic[@"friendStatus"]  isEqualToString:@"2"]){
                                
                                model.friendStatus=kAgreeForAdd;
                                
                            }else if ([tempDic[@"friendStatus"]  isEqualToString:@"3"])
                            {
                                
                                model.friendStatus=kRefuseForAdd;
                                
                            }else if ([tempDic[@"friendStatus"]  isEqualToString:@"4"])
                            {
                                model.friendStatus=kDeleteFriend;
                                
                                
                            }else if ([tempDic[@"friendStatus"]  isEqualToString:@"5"])
                            {
                                model.friendStatus=kAskForAuth;
                                
                            }
                        }
                        
                        if (isUpFresh) {
                            [dataSource addObject:model];
                        }
                        else
                        {
                       [searchResults addObject:model];
                            
                        }
          
                    }
                    
                    if (isUpFresh) {
                        searchResults=dataSource;
                    }

                     [self.searchDisplayController.searchResultsTableView reloadData];
                    
                    if ([ResonpseDict[@"data"] count]!=20) {
                        [searchDisplayController.searchResultsTableView.footer noticeNoMoreData];
                    }
                    
                    
                }else
                {
                 [self.searchDisplayController.searchResultsTableView reloadData];
                    [searchDisplayController.searchResultsTableView.footer noticeNoMoreData];
                
                }
               
               
            }else
            {
                //modify by zhanglei 2015.09.22IOS消费者 添加好友时，搜索框输入“但” 提示已经全部加载完毕。当点击取消时就可以显示查询结果
                [searchResults removeAllObjects];
                [self.marrDatasource removeAllObjects];
                [searchDisplayController.searchResultsTableView reloadData];
                [searchDisplayController.searchResultsTableView.footer endRefreshing];
                [searchDisplayController.searchResultsTableView.footer noticeNoMoreData];
                
            }
            
        }
        
    }];
}

@end

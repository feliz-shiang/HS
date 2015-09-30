//
//  GYBankListViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYBankListViewController.h"
#import "GlobalData.h"


#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define FILTEREDKEYS [self.filterDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA_ARRAY [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]
#define DEFAULTKEYSTest [dataArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
@interface GYBankListViewController ()

@end

@implementation GYBankListViewController
{
    __weak IBOutlet UITableView *tvBankList;
    
    UISearchBar * mySearchBar;
    
    UISearchDisplayController * searchDisplayController;
    
    NSMutableArray *searchResults;
    
    NSMutableArray *dataArray;
    
    GlobalData * data;
    
    NSDictionary * bankDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"选择银行";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    data =[GlobalData shareInstance];
    self.marrBankList=[NSMutableArray array];
    self.nameDictionary=[NSMutableDictionary dictionary];
    searchResults=[NSMutableArray array];
    self.filterDictionary =[NSMutableDictionary dictionary];
    
       bankDict = [data getDictionaryOfBank];
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索银行"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    tvBankList.tableHeaderView=mySearchBar;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadBankDictFromNetworkRequest];

}


-(void)addDataWithSouces:(NSArray *)array :(NSMutableDictionary *)dictionary
{
    if ([dictionary.allKeys count]!=0) {
        [dictionary removeAllObjects];
    }
    
    for (NSString * string in ALPHA_ARRAY) {
        NSMutableArray * temp = [[NSMutableArray alloc]  init];
        BOOL realExist = NO;
        
        
        for (GYBankListModel * mod in array) {
            
            NSString * tempStr=[NSString string];

            if ([ChineseInclude isIncludeChineseInString:mod.strBankName]) {
                tempStr =[PinYinForObjc chineseConvertToPinYinHead:mod.strBankName];
                
                if ([tempStr hasPrefix:string]||[tempStr hasPrefix:[string lowercaseString]]) {
                    [temp addObject:mod];
                    
                    realExist = YES;
                }
            }
            
            else

            {
                 tempStr =[PinYinForObjc chineseConvertToPinYinHead:mod.strBankName];
                
                if ([tempStr hasPrefix:string]||[tempStr hasPrefix:[string lowercaseString]]) {
                    [temp addObject:mod];
                    
                    realExist = YES;
                }
                

            }
        }
        if (realExist) {
            [dictionary setObject:temp forKey:string];
            
            if ([string isEqualToString:@"A"]) {
                NSLog(@"%@------ AAAA",temp);
            }
            
        }
    }
    
//    [Utils hideHudViewWithSuperView:self.view];
//    [tvBankList reloadData];
}


-(void)loadBankDictFromNetworkRequest
{

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([bankDict[@"data"][@"resultCode"] isEqualToString:@"0"]) {
            for (NSDictionary * tempDic in bankDict[@"data"][@"bankList"]) {
                
                GYBankListModel * model =[[GYBankListModel alloc]init];
                model.strBankCode=tempDic[@"bankCode"];
                model.strBankAddress=tempDic[@"address"];
                model.strCreated=tempDic[@"created"];
                model.strEnName=tempDic[@"enName"];
                model.strFullName=tempDic[@"fullName"];
                model.strBankNo=tempDic[@"bankNo"];
                model.strIsPage=tempDic[@"isPage"];
                model.strSettleCode=tempDic[@"settleCode"];
                model.strBankName=tempDic[@"bankName"];
                model.strIsDisplayStart=tempDic[@"iDisplayStart"];
                model.strUpdated=tempDic[@"updated"];
                [self.marrBankList addObject:model];
                
            }
            
            [self addDataWithSouces:self.marrBankList :self.nameDictionary ];
            
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            
            [Utils hideHudViewWithSuperView:self.view];
            [tvBankList reloadData];
        });

    });
  
    
    
}



#pragma mark tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView== self.searchDisplayController.searchResultsTableView) {
        
        
        return 1;
    }
    return ALPHA_ARRAY.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return 1.0;
        
    }
    
    return 30.0;
    
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==tvBankList) {
        
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[section]];
        
        
        if (arr) {
            
            if (section==0) {
                NSLog(@"%d========bbbbb",arr.count);
            }

            return ALPHA_ARRAY[section];
        }
        else{
            
            return nil;
            
        }
    }
    return nil;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return searchResults.count;
    }
    else {
        
        
        
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[section]];
        
            if (arr) {
                return arr.count;
            }
            else{
                return 0;
                
            }
        
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifer =@"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        GYBankListModel * mod=searchResults[indexPath.row];
        
        cell.textLabel.text=mod.strBankName;
        
    }else{
        
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
        
        GYBankListModel * mod=arr[indexPath.row];
        
        cell.textLabel.text=mod.strBankName;
        
    }
    return cell;
    
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    searchResults = [[NSMutableArray alloc]init];
    
    
    if ([Utils isBlankString:searchText]) {
        return ;
    }

    if (mySearchBar.text.length>0)
    {
        
        NSMutableArray * marrtest = [NSMutableArray array];
        [marrtest addObjectsFromArray:[self.nameDictionary allValues]];
        for (NSArray * arr in marrtest) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GYBankListModel * model = obj;
                
                if ([ChineseInclude isIncludeChineseInString:mySearchBar.text]){
                    //把中文转换为拼音
                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strBankName];
                     NSString *searchBarPinYinStr = [PinYinForObjc chineseConvertToPinYinHead:mySearchBar.text];

                    if (datasourcePinYinStr.length>=searchBarPinYinStr.length) {
                        NSRange titleResult=[datasourcePinYinStr rangeOfString:searchBarPinYinStr options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            
                            [searchResults addObject:model];
                        }
                    }
                    
                   
                }
                //没有中文来到这里
                else {
                    NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strBankName];
                    NSRange titleResult=[[datasourcePinYinStr substringToIndex:1 ] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:model];
                    }
                }
                
            }];
            
        }
    }
        if (kSystemVersionLessThan(@"7.0")) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        GYBankListModel * mod =searchResults[indexPath.row];
        
        if (_delegate&&[_delegate respondsToSelector:@selector(getSelectBank:)]) {
            
            [_delegate getSelectBank:mod];
        }
        
    }
    else{
        NSArray * arr =[self.nameDictionary objectForKey:ALPHA_ARRAY[indexPath.section]];
        

        
        if (_delegate&&[_delegate respondsToSelector:@selector(getSelectBank:)]) {
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"seletedBank.plist"];
            
            
            GYBankListModel * mod =arr[indexPath.row];
            
            NSMutableData * data =[NSMutableData data];
            
            NSKeyedArchiver * archiver =[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            
            [archiver encodeObject:mod forKey:@"SelectBank"];
            
            [archiver finishEncoding];
            
            [data writeToFile:path atomically:YES];
            
            
            [_delegate getSelectBank:mod];
            
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end

//
//  GYCitySelectViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCitySelectViewController.h"
#import "GYCityInfo.h"
#import "MMLocationManager.h"
#import "GYCitySelectTvHeader.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "GYseachhistoryModel.h"
#import "ChineseStringModel.h"
#import "pinyin.h"
#define kKeyForsearchHistoryCity @"searchHistoryCity"
@interface GYCitySelectViewController ()

@end

@implementation GYCitySelectViewController

{
    
    __weak IBOutlet UIView *vTopView;//顶端View
    
    // __weak IBOutlet UITableView *tvCityTableView; //城市tableview
    
    IBOutlet UITableView *tvCityTableView;
    __weak IBOutlet UIButton *btnSearch;
    
    __weak IBOutlet UITextField *tfInputCityName;
    
    GYCitySelectTvHeader * header;
    
    UIView * vTemp;
    
    UISearchBar *mySearchBar;
    
    UISearchDisplayController *searchDisplayController;
    
    NSMutableArray * searchResults;
    
    NSArray * arr;
    NSMutableArray *mutabArrhisty;
    //    //字母
    //    NSArray *letterArr;
    NSMutableDictionary *dichity;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//      mutabArrhisty=[[NSMutableArray alloc]init];
//    mutabArrhisty =[self loadBrowsingHistoryandType];
//
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dichity = [NSMutableDictionary dictionary];
//    [self deleteBrowsingHistory:nil andForKey:kKeyForsearchHistoryCity andAll:YES];
    mutabArrhisty=[[NSMutableArray alloc]init];
    //数组初始化
    self.indexMarr=[[NSMutableArray alloc]init];
    if([UIScreen mainScreen].bounds.size.height==480)
    {
        tvCityTableView.frame=CGRectMake(0, 55, self.view.bounds.size.width, self.view.bounds.size.height-64-55-30-30-10);
    }
    else
    {
        tvCityTableView.frame=CGRectMake(0, 55, self.view.bounds.size.width, self.view.bounds.size.height-64-55);
    }
    
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    //self.title=@"选择城市";
    arr=[NSMutableArray array];
    self.marrDatasource=[NSMutableArray array];
    header =[GYCitySelectTvHeader headerView];
    mutabArrhisty =[self loadBrowsingHistoryandType];
    header.histyArry=mutabArrhisty;
    tvCityTableView.tableHeaderView= header;
    
    vTopView.hidden=YES;
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
    
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"请输入城市名或拼音"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:mySearchBar];
    NSArray * arrBtn =[NSArray arrayWithObjects:header.btn1,header.Btn2,header.Btn3,header.Btn4,header.Btn5,header.Btn6,header.Btn7,header.Btn8,header.Btn9,header.BtnLocationCity, nil];
    for (int i=0; i<10; i++) {
        [arrBtn[i] addTarget:self action:@selector(btnHotCity:) forControlEvents:UIControlEventTouchUpInside]; 
    }
    /////循环
    NSArray *arrhithBtn= [NSArray arrayWithObjects:header.Btn10,header.Btn11,header.Btn12,header.Btn13,header.Btn14, nil];
    if (mutabArrhisty.count>0) {
        for (int j=0; j<mutabArrhisty.count; j++) {
            [arrhithBtn[j] addTarget:self action:@selector(btnHotCity:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"正在定位..."];
    
    [[MMLocationManager shareLocation]getCity:^(NSString *countryString) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if ([countryString hasSuffix:@"市"]) {
            countryString =  [countryString substringToIndex:countryString.length-1];
            
            CGSize sizeToFit;
            
            sizeToFit = [countryString sizeWithFont:[UIFont systemFontOfSize:16.0]constrainedToSize:CGSizeMake(69,2000)lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
            CGRect btnFrame = header.BtnLocationCity.frame;
            btnFrame.size.width=sizeToFit.width>69?sizeToFit.width:69;
            header.BtnLocationCity.frame=btnFrame;
        }
        if ([countryString hasSuffix:@"市辖区"]) {
            NSRange  range = [countryString rangeOfString:@"市"];
            if (range.location!=NSNotFound) {
                countryString =  [countryString substringToIndex:range.location];
            }
        }
        [header setLocationBtn:countryString];
        
    } error:^(NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"定位失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }];
    [self modifyName];
    [self readLocalData];
}

-(void)modifyName
{
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"image_search_front"] forState:UIControlStateNormal];
    tfInputCityName.placeholder=@"请输入城市名或拼音";
}

-(void)setBtnWithTitle:(NSString *)titile WithBackgroundColor :(UIColor *)color WithBoderWidth:(CGFloat) width WithButton:(UIButton *)sender
{
    [sender setTitle:titile forState:UIControlStateNormal];
    [sender setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    
    sender.layer.masksToBounds=YES;
    sender.layer.borderWidth=width;
    sender.layer.cornerRadius=1.0;
    sender.layer.borderColor=kCellItemTitleColor.CGColor;
    
}



- (void)readLocalData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist"ofType:@"txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary * tempDic in dict[@"data"]) {
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=tempDic[@"parentCode"];
        cityModel.strAreaSortOrder=tempDic[@"sortOrder"];
        [self.marrDatasource addObject:cityModel];
        
    }
    
    //获取索引
    NSMutableArray *result=[[NSMutableArray alloc]initWithArray:[self getIndexArr:self.marrDatasource]];
    [self.marrDatasource removeAllObjects];
    self.marrDatasource=result;
    
}

//返回索引数组
-(NSArray *)getIndexArr:(NSArray *)marr
{
    NSMutableArray *nameMarr=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<marr.count; i++) {
        GYCityInfo *cityModel=marr[i];
        [nameMarr addObject:cityModel.strAreaName];
    }
    NSMutableArray *stringsToSort=[[NSMutableArray alloc]initWithArray:nameMarr];
    
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        ChineseStringModel *chineseString=[[ChineseStringModel alloc]init];
        chineseString.string=[NSString stringWithString:[stringsToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    //
    self.chineseString=[NSMutableArray arrayWithArray:chineseStringsArray];
    
    NSString *firstLetter;
    NSMutableArray *data=[[NSMutableArray alloc]init];
    NSMutableArray *section;
    for (NSInteger i=0;i<chineseStringsArray.count;i++) {
        NSString *string=[[chineseStringsArray[i] pinYin] substringToIndex:1];
        if([firstLetter isEqualToString:string])
        {
            if (section==nil)
            {
                section=[[NSMutableArray alloc]init];
            }
            else
            {
                
            }
            [section addObject:[chineseStringsArray[i] string]];
            
        }
        else
        {
            if(section!=nil&&section.count!=0)
            {
                [data addObject:section];
            }
            else
            {
                
            }
            section=[[NSMutableArray alloc]init];
            firstLetter=string;
            [section addObject:[chineseStringsArray[i] string]];
            [self.indexMarr addObject:string];
            
        }
        if (i==chineseStringsArray.count-1) {
            [data addObject:section];
        }else
        {
            
        }
        
    }
    for (NSInteger i=0; i<data.count; i++) {
        for (NSInteger j=0; j<[data[i] count]; j++) {
            for (NSInteger m=0; m<marr.count; m++) {
                GYCityInfo *cityModel=marr[m];
                if ([data[i][j] isEqualToString:cityModel.strAreaName]) {
                    data[i][j]=cityModel;
                    break;
                }
            }
            
        }
    }
    
    
    return data;
    
}


-(void)btnHotCity:(id)sender {

    
    UIButton * btnTemp =(UIButton *)sender;
    
    if (_delegate&&[_delegate respondsToSelector:@selector(getCity:WithType:)]) {
        NSString *city = btnTemp.titleLabel.text;
        if (![city hasSuffix:@"市"]) {
            city = [city stringByAppendingString:@"市"];
        }
        
        //add by zhangqy 保存用户选择的城市
        GlobalData *data = [GlobalData shareInstance];
        data.selectedCityName = city;
        
        [_delegate getCity:city WithType:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



#pragma mark DataSourceDelegate
//添加
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return self.marrDatasource.count;
}

//索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    return self.indexMarr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    return [self.marrDatasource[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    return self.indexMarr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        GYCityInfo * cityModel =searchResults[indexPath.row];
        cell.textLabel.text=cityModel.strAreaName;
    }else{
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        GYCityInfo * cityModel =self.marrDatasource[indexPath.section][indexPath.row];
        cell.textLabel.text=cityModel.strAreaName;
        cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tvCityTableView) {
        GYCityInfo * cityModel =self.marrDatasource[indexPath.section][indexPath.row];
        [self saveBrowsingHistory:cityModel.strAreaName];
        if (_delegate&&[_delegate respondsToSelector:@selector(getCity:WithType:)]) {
            [_delegate getCity:cityModel.strAreaName WithType:1];
            //add by zhangqy 保存用户选择的城市
            GlobalData *data = [GlobalData shareInstance];
            data.selectedCityName = cityModel.strAreaName;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        GYCityInfo * cityModel = searchResults[indexPath.row];
        [self saveBrowsingHistory:cityModel.strAreaName];
        if (_delegate&&[_delegate respondsToSelector:@selector(getCity:WithType:)]) {
            [_delegate getCity:cityModel.strAreaName WithType:1];
            //add by zhangqy 保存用户选择的城市
            GlobalData *data = [GlobalData shareInstance];
            data.selectedCityName = cityModel.strAreaName;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark 查询所有的历史记录
- (NSMutableArray *)loadBrowsingHistoryandType
{
    NSString *key=kKeyForsearchHistoryCity;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   dichity =[NSMutableDictionary dictionaryWithDictionary: [userDefault objectForKey:key]];
    NSLog(@"%@",dichity);
    NSMutableArray *arrgg=[[NSMutableArray alloc]init];
    for (NSString *key in [dichity allKeys])
    {
        NSDictionary *dic = dichity[key];
        GYseachhistoryModel *model=[[GYseachhistoryModel alloc]init];
        model.name= [dic objectForKey:@"name"];
        model.time = [dic objectForKey:@"time"];
        [arrgg addObject:model];
    }
    NSMutableArray *sortedArray =(NSMutableArray*) [arrgg sortedArrayUsingComparator:^NSComparisonResult(GYseachhistoryModel *p1, GYseachhistoryModel *p2){//倒序
        return [p2.time compare:p1.time];
    }];
    return sortedArray;
}

#pragma mark 保存搜索历史记录
- (void)saveBrowsingHistory:(NSString *)name
{
    if([name isEqualToString:@""]||[name isKindOfClass:[NSNull class]]){
        
    }else{
        NSString *key=kKeyForsearchHistoryCity;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        dichity = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
        /////先查询当前的值是否已存在
//        NSDictionary *dicname = [userDefault objectForKey:key];
        for (NSString *keyname in [dichity allKeys])
        {
            if ([keyname isEqualToString:name]) {
                [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
            }
        }
        if(mutabArrhisty.count==3)
        {
                GYseachhistoryModel *model=[[GYseachhistoryModel alloc]init];
                model=[mutabArrhisty lastObject];
                NSString *keyname=model.name;
                [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
        }
        
        GYseachhistoryModel *model= [[GYseachhistoryModel alloc]init];
        model.time= @([[NSDate date] timeIntervalSince1970]);
        model.name = name;
        NSDictionary *dictype = @{@"name":model.name,
                                  @"time":model.time};
        [dichity setObject:dictype forKey:name];
        [userDefault setObject:dichity forKey:key];
        [userDefault synchronize];
        mutabArrhisty=[self loadBrowsingHistoryandType];
        [tvCityTableView reloadData];
    }
}
#pragma mark 删除历史记录
- (void)deleteBrowsingHistory:(NSString *)string andForKey:(NSString *)key andAll:(BOOL)cler;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   dichity = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (cler) {
        [dichity removeAllObjects];
    }else{
        [dichity removeObjectForKey:string];
    }
    [userDefault setObject:dichity forKey:key];
    [userDefault synchronize];
    mutabArrhisty=[self loadBrowsingHistoryandType];
    
}

#pragma mark textfield代理方法。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
//

#pragma mark  textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    
    vTemp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vTemp.backgroundColor=[UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:0.3];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenTempView)];
    [vTemp addGestureRecognizer:tap];
    [self.view addSubview:vTemp];
    
}

-(void)hidenTempView
{
    if (vTemp) {
        [vTemp removeFromSuperview];
    }
    
    [tfInputCityName resignFirstResponder];
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hidenTempView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //    if (!searchResults) {
    searchResults = [[NSMutableArray alloc]init];
    //    }
    
    if ([Utils isBlankString:searchText]) {
        return ;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<self.marrDatasource.count; i++) {
        for (NSInteger j=0; j<[self.marrDatasource[i] count]; j++) {
            [resultArr addObject:self.marrDatasource[i][j]];
            
        }
    }
    
    if (mySearchBar.text.length>0) {
        //  for (GYCityInfo * model in self.marrDatasource) {
        for (GYCityInfo * model in resultArr) {
            //            if ([ChineseInclude isIncludeChineseInString:model.strAreaName]){
            if ([ChineseInclude isIncludeChineseInString:searchText]){
                //把中文转换为拼音
                //                NSString *searchBarPinYinStr = [PinYinForObjc chineseConvertToPinYinHead:mySearchBar.text];
                //                NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strAreaName];
                NSString *datasourcePinYinStr = model.strAreaName;
                if (datasourcePinYinStr.length>=2) {
                    //                    NSRange titleResult=[[datasourcePinYinStr substringToIndex:2 ] rangeOfString:searchBarPinYinStr options:NSCaseInsensitiveSearch];
                    NSRange titleResult=[[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:model];
                    }
                }
                
                
            } //没有中文来到这里
            else {
                //                NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYinHead:model.strAreaName];
                NSString *datasourcePinYinStr = [PinYinForObjc chineseConvertToPinYin:model.strAreaName];
                //                NSRange titleResult=[[datasourcePinYinStr substringToIndex:1 ] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                //                NSRange titleResult=[[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                NSRange titleResult=[[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:model];
                }
                
            }
            
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length>0) {
        [self.searchDisplayController.searchResultsTableView reloadData];
        
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
    
    
}

@end


//  GYEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEasyBuySearchViewController.h"
#import "GYEasyBuyModel.h"
#import "GYEeayBuyTableViewCell.h"
#import "GYEasyPurchaseMainViewController.h"
#import "DropDownWithChildListView.h"
#import "GYGoodsDetailController.h"
#import "GYGoodCategoryModel.h"
#import "EasyPurchaseHead.h"
#import "GYFindShopTableViewCell.h"
#import "GYSortTypeModel.h"
#import "MJRefresh.h"
#import "GYEasyBuySearchList.h"
#import "PopoverView.h"
#import "MMLocationManager.h"
#import "GYEasyBuySearchShopList.h"
#import "GYShopDetailViewController.h"//商铺详情
#import "GYseachhistoryModel.h"
#import "GYStoreDetailViewController.h"

static NSString * cellIdentifer =@"EasyBuyGoodsCell";
static  NSString * shopCellIdentifer =@"EasyBuyshopCell";

@interface GYEasyBuySearchViewController ()
@property (nonatomic,copy) NSString *hasCoupon;
@end

@implementation GYEasyBuySearchViewController
{
    __weak IBOutlet UITableView *tvEasyBuy;
    NSMutableArray          * chooseArray;
    NSMutableArray      *  marrEasyBuySource;
    
    EasyPurchaseHead * viewHeader ;
    
    UIView * vTemp;
    
    UITextField * tfInputSearchText;
    NSMutableArray * marrSortTtile;
    NSMutableArray * marrSortType;
    
    NSMutableArray * marrSortName;
    NSMutableArray * marrSortNameTitle;
    
    NSMutableArray * marrSpecailService;
    
    int currentPage;
    
    DropDownWithChildListView * dropDownView;
    
    NSString * strCategory;
    NSString * strSortType;
    NSString * strSpecialService;
    
    BOOL isUpFresh; //是否是上拉刷新
    
    int totalPage;//总共多少页
    
    UIView * vTitleView;
    
    CLLocationCoordinate2D currentLocation;
    
    NSInteger seachType; //0 商品  1 商铺
    
    BMKMapPoint mp1;//用于计算距离
    UITableView *historytableview;
    NSMutableArray *caohistoryArry;
    GYseachhistoryModel *seachmodel;
    GYhistoryView *historyView;
    CGFloat keyheight;
    UIView *myfooterView;
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
    keyheight=0;
    marrEasyBuySource=[NSMutableArray array];
    marrSortType = [NSMutableArray array];
    marrSortTtile = [NSMutableArray array];
    marrSortName = [NSMutableArray array];
    marrSortNameTitle = [NSMutableArray array];
    self.marrDataSource = [NSMutableArray array];
    marrSpecailService= [NSMutableArray array];
    self.navigationItem.titleView=[self titleView];
    strCategory=@"0";
    currentPage=1;
    strSpecialService=@"";
    strSortType=@"0";
    seachType=1;
    
//    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnRight setTitle:@"搜索" forState:UIControlStateNormal];
//    btnRight.frame=CGRectMake(0, 0, 40, 40);
//    [btnRight setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(ToSearch) forControlEvents:UIControlEventTouchUpInside];
//    btnRight.titleLabel.font=[UIFont systemFontOfSize:15.0];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
//    self.navigationController.navigationItem.rightBarButtonItem =rightButton;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // [tvEasyBuy addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    // [tvEasyBuy addFooterWithTarget:self action:@selector(footerRereshing)];
    [tvEasyBuy addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    //    [tvEasyBuy headerBeginRefreshing];
    
    // 设置文字(默认的文字在MJRefreshConst中修改)
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYEasyBuySearchList" bundle:nil] forCellReuseIdentifier:cellIdentifer];
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYEasyBuySearchShopList" bundle:nil] forCellReuseIdentifier:shopCellIdentifer];
    tvEasyBuy.tableFooterView=[[UIView alloc]init];
    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {
        [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
    }
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        tvEasyBuy.frame = CGRectMake(tvEasyBuy.frame.origin.x, tvEasyBuy.frame.origin.y, tvEasyBuy.frame.size.width, tvEasyBuy.frame.size.height -CGRectGetMaxY(self.navigationController.navigationBar.frame));
    }
    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        currentLocation=locationCorrrdinate;
        mp1= BMKMapPointForCoordinate(currentLocation);
    } withError:^(NSError *error) {
        currentLocation.latitude=22.549225;
        currentLocation.longitude=114.077427;
        mp1= BMKMapPointForCoordinate(currentLocation);
    }];
    
    //请求代码
    [self getSortTypeData];
    
}
#pragma mark  historyView  myfooterView 底部清空搜索历史记录按钮   addSubview
-(void)historyViewAddfooterView
{
    historyView =[[GYhistoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65-keyheight+2)];
    historyView.backgroundColor=[UIColor whiteColor];
    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
    historyView.Hdelegate=self;
    myfooterView =[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight-100-keyheight, 100,30)];
 
    historyView.hidden=NO;
    [myfooterView  addSubview: [self tableViewfootview]];
    [historyView addSubview: myfooterView];
    [self.view addSubview:historyView];
}


-(void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyheight = keyboardRect.size.height;
    NSLog(@"-----------------------------------%f",keyheight);
    if(!historyView){
        if (historyView.hidden==NO) {
            [self historyViewAddfooterView];
        }
        else
            historyView.hidden=NO;
    }
    else
        historyView.hidden=NO;
//    [historyView removeFromSuperview];
//    [self historyViewisdata];
//    historyView =[[GYhistoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-70-keyheight)];
//    historyView.backgroundColor=[UIColor clearColor];
//    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
//    historyView.Hdelegate=self;
//    
//    NSLog( @"%@",historyView.historyArry);
//    
//    [self.view addSubview:historyView];
//    myfooterView =[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight-110-keyheight+10, 100,30)];
//    myfooterView = [self tableViewfootview];
//    [self.view addSubview: myfooterView];
    
}
- (void) keyboardWasHidden:(NSNotification *) notif 
{
    historyView.hidden=YES;
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (seachType==1) {
        // 2.2秒后刷新表格UI
        currentPage=1;
        isUpFresh=YES; 
        [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
    }else
    {
        isUpFresh=YES;
        currentPage=1;
        [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
    }
}

- (void)footerRereshing
{
    currentPage+=1;
    isUpFresh=NO;
    if (currentPage<=totalPage) {
        if (seachType==1)
        {
            [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
            // 2.2秒后刷新表格UI
        }
        else
        {
            [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
        }
        
    }else{
        [tvEasyBuy.footer endRefreshing];
        [tvEasyBuy.footer noticeNoMoreData];
    }
}

///查询历史数据
- (NSArray *)loadBrowsingHistoryandType:(NSInteger)type
{
    NSString *key;
    if (type==1)
        key = kKeyForsearchHistorygoods;////商品
    else
    key = kKeyForsearchHistoryshop;////商铺
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicBrowsing = [userDefault objectForKey:key];
    NSLog(@"%@",dicBrowsing);
    if (!dicBrowsing)
    {
//        viewTipBkg.hidden = NO;
//        [self.tableView setHidden:YES];
//        return;
    }
    NSMutableArray *arrgg=[[NSMutableArray alloc]init];
    for (NSString *key in [dicBrowsing allKeys])
    {
        NSDictionary *dic = dicBrowsing[key];
        GYseachhistoryModel *model=[[GYseachhistoryModel alloc]init];
        model.name= [dic objectForKey:@"name"];
        model.time = [dic objectForKey:@"time"];
        model.type = [dic objectForKey:@"type"];
        [arrgg addObject:model];
    }
    NSArray *sortedArray = [arrgg sortedArrayUsingComparator:^NSComparisonResult(GYseachhistoryModel *p1, GYseachhistoryModel *p2){//倒序
        return [p2.time compare:p1.time];
    }];
//    caohistoryArry = [NSMutableArray arrayWithArray:sortedArray];
    return sortedArray;
}

#pragma mark 保存搜索记录
- (void)saveBrowsingHistory:(NSString *)name  andType:(NSInteger)type
{
    if([name isEqualToString:@""]||[name isKindOfClass:[NSNull class]]){
        
    }else{
    NSString *key;
    if (type==1) {
        key =kKeyForsearchHistorygoods;////商品
    }else key =  kKeyForsearchHistoryshop;////商铺
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
     NSMutableDictionary *dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    /////先查询当前的值是否已存在
    NSDictionary *dicname = [userDefault objectForKey:key];
    for (NSString *keyname in [dicname allKeys])
    {
        if ([keyname isEqualToString:name]) {
            NSLog(@"%@",key);
            [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
        }
    }

    GYseachhistoryModel *model= [[GYseachhistoryModel alloc]init];
    model.type=[NSString stringWithFormat:@"%ld",type];
    model.time= @([[NSDate date] timeIntervalSince1970]);
    model.name = name;
    NSDictionary *dictype = @{@"name":model.name,
                               @"type":model.type,
                              @"time":model.time};
    [dicBrowsing setObject:dictype forKey:model.name];
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
    [historyView reloadDatatable:historyView.historyArry];

    }
}
//////删除
- (void)deleteBrowsingHistory:(NSString *)model andForKey:(NSString *)key andAll:(BOOL)cler;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (cler) {
        [dicBrowsing removeAllObjects];
    }else{
    [dicBrowsing removeObjectForKey:model];
    }
    
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
    [historyView reloadDatatable:historyView.historyArry];
}
/////  搜索
-(void)ToSearch
{
//    [tfInputSearchText resignFirstResponder];
//    historyView.hidden=YES;
//
//    [self saveBrowsingHistory:tfInputSearchText.text  andType:seachType];
////    myfooterView.hidden=YES;
//       if (seachType==1) {
//        if (marrEasyBuySource.count>0)
//        {
//            [marrEasyBuySource removeAllObjects];
//        }
//        currentPage=1;
//        [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
//    }else
//    {
//        if (marrEasyBuySource.count>0)
//        {
//            [marrEasyBuySource removeAllObjects];
//        }
//        currentPage=1;
//        [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
//    }
//     [self hidenTempView];
}


-(UIView * )titleView
{
    UIView * vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    vHead.backgroundColor = [UIColor whiteColor];
    vTitleView =[[UIView alloc]initWithFrame:CGRectMake(40, 4, 180, 32)];
    vTitleView.backgroundColor=[UIColor colorWithRed:235.0/255.0f green:235.0/255.0f  blue:235.0/255.0f  alpha:1.0f];
    UIButton * btnChooseType =[UIButton buttonWithType:UIButtonTypeCustom];
    btnChooseType.frame=CGRectMake(0, 0, 50, 32);
    btnChooseType.backgroundColor=[UIColor clearColor];
    btnChooseType.titleLabel.textColor=[UIColor colorWithRed:160.0/255.0F green:160.0/255.0F blue:160.0/255.0F alpha:1.0f];
    btnChooseType.titleLabel.font=[UIFont systemFontOfSize:14];
    [btnChooseType setTitle:@"商品" forState:UIControlStateNormal];
    
    [btnChooseType setImage:[UIImage imageNamed:@"sp_prow_trigon.png"] forState:UIControlStateNormal];
    [btnChooseType setImageEdgeInsets:UIEdgeInsetsMake(13, 44, 13, -6)];
    [btnChooseType setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnChooseType.frame.size.width+32, 0, 5)];
    [btnChooseType setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChooseType addTarget:self action:@selector(changeSearchType:) forControlEvents:UIControlEventTouchUpInside];
    
    tfInputSearchText =[[UITextField alloc]initWithFrame:CGRectMake(60, 4, 115, 25)];
    tfInputSearchText.contentMode=UIViewContentModeScaleToFill;
    tfInputSearchText.returnKeyType = UIReturnKeySearch;
    tfInputSearchText.delegate=self;

    tfInputSearchText.textColor=[UIColor colorWithRed:95.0/255.0f green:95.0/255.0f blue:95.0/255.0f alpha:1.0f];
    tfInputSearchText.backgroundColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f  blue:235.0/255.0f  alpha:1.0f];
    [tfInputSearchText becomeFirstResponder];
    [vTitleView addSubview:btnChooseType];
    
    [vTitleView addSubview:tfInputSearchText];
    [vHead addSubview:vTitleView];
    return vHead;
    
}

-(void)changeSearchType:(UIButton *)sender
{   //指定弹出点
    CGPoint point = CGPointMake(85, 65);
    NSArray *titles = @[@"商品", @"商铺"];
    NSArray *images=@[@"sp_prow_shop.png",@"sp_prow_goods.png"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", (long)index);
        switch (index) {
            case 0:{
                seachType=1;
                    if (historyView) {/////换了条件
                   historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
                        [historyView reloadDatatable:historyView.historyArry];
                    }
                }
                break;
            case 1:{
                seachType=0;
                if (historyView) {/////换了条件
                    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
                    [historyView reloadDatatable:historyView.historyArry];
                }
                }
                break;
            default:
                break;
        }
        if (marrEasyBuySource.count>0) {
            [marrEasyBuySource removeAllObjects];
            [tvEasyBuy reloadData];
            tfInputSearchText.text=@"";
            tvEasyBuy.footer.hidden=YES;
        }
        
        NSString * string = titles[index];
        
        [sender setTitle:string forState:UIControlStateNormal];
    };
    [pop show];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (seachType==1) {
        isUpFresh=YES;
        currentPage=1;
        /////保存搜索历史
        [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
    }else
    {
        isUpFresh=YES; 
        currentPage=1;
        [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
    }
    [self  saveBrowsingHistory:textField.text andType:seachType];
    [tfInputSearchText resignFirstResponder];
    return YES;
}

//逛商铺  排序
-(void)getSortTypeData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/sortType"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error]; 
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                { 
                    for (NSDictionary * dict in ResponseDic[@"data"]) {
                        GYSortTypeModel * sortTypeMod =[[GYSortTypeModel alloc]init];
                        sortTypeMod.strSortType=[NSString stringWithFormat:@"%@",dict[@"sortType"]];
                        sortTypeMod.strTitle=[NSString stringWithFormat:@"%@",dict[@"title"]]; 
                        [marrSortTtile addObject:sortTypeMod.strTitle];
                        [marrSortType addObject:sortTypeMod];
                    }
                    [self getSortNameData];
                    
                }
                
            }
            
        }
        
    }];
    
}////////ceshi

-(void)getSortNameData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/sortName"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        //
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"])
                {
                    for (NSDictionary * dict in ResponseDic[@"data"]) {
                        GYSortTypeModel * sortTypeMod =[[GYSortTypeModel alloc]init];
                        sortTypeMod.strSortType=[NSString stringWithFormat:@"%@",dict[@"sortType"]];
                        sortTypeMod.strTitle=[NSString stringWithFormat:@"%@",dict[@"title"]];
                        [marrSortNameTitle addObject:sortTypeMod.strTitle];
                        [marrSortName addObject:sortTypeMod];
                    }
                    [self addTopSelectView];
                }
            }
        }
        
    }];
    
}

#pragma mark 商品
-(void)loadSearchDataWithSortType :(NSString *)sorttype WithspecialService: (NSString *) specialService
{
    
    if ([Utils isBlankString:tfInputSearchText.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入搜索商品！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    // 消费抵扣全 传在hasCoupon
    self.hasCoupon = @"0";
    NSString * strSpecialServiceType = specialService;
    if (specialService && specialService.length>0)
    {
        
        if ([specialService rangeOfString:@"6"].location != NSNotFound)
        {
            self.hasCoupon = @"1";
            
            NSArray * arrService = [specialService componentsSeparatedByString:@","];
            NSMutableArray * marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"6"];
            if (marrService.count>0)
            {
                strSpecialServiceType = [marrService componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
        // add by songjk 去掉默认
        if ([strSpecialServiceType rangeOfString:@"1"].location != NSNotFound)
        {
            NSArray * arrService = [strSpecialServiceType componentsSeparatedByString:@","];
            NSMutableArray * marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"1"];
            if (marrService.count>0)
            {
                strSpecialServiceType = [marrService componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
    }
    
    NSString * strKeyWork = [tfInputSearchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setValue:strKeyWork forKey:@"keyword"];
    [dict setValue:sorttype forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:@"10" forKey:@"count"];
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/search"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){ 
        if (!error) {
            NSDictionary * responseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSString * str =[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"retCode"]];
                if (isUpFresh) {
                    if (marrEasyBuySource.count>0) {
                        [marrEasyBuySource removeAllObjects];
                    }
                }
                if ([str isEqualToString:@"200"]&& [responseDict[@"data"] isKindOfClass:[NSArray class]]) {
                    [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                    totalPage =[responseDict [@"totalPage"] intValue ];
                    
                    NSMutableArray   *   dataSource= [NSMutableArray array];
                    NSArray * arrData = [responseDict objectForKey:@"data"];
                    for (int i = 0; i<arrData.count; i++) {
                        NSDictionary * dic  =arrData[i];
                        GYEasyBuyModel * model =[[GYEasyBuyModel alloc]init];
                        
                        model.strGoodPictureURL= kSaftToNSString([dic objectForKey:@"url"]);
                        model.strGoodName=kSaftToNSString([dic objectForKey:@"title"]);
                        model.strGoodPrice=kSaftToNSString([dic objectForKey:@"price"]);
                        model.strGoodPoints=kSaftToNSString([dic objectForKey:@"pv"]);
                        model.strGoodId=kSaftToNSString([dic objectForKey:@"id"]);
                        model.beCash=[dic[@"beCash"] boolValue];
                        model.beReach=[dic[@"beReach"] boolValue];
                        model.beSell=[dic[@"beSell"] boolValue];
                        model.beTake=[dic[@"beTake"] boolValue];
                        model.beTicket=[dic[@"beTicket"] boolValue];
                        model.city=dic[@"city"];
                        model.monthlySales=dic[@"monthlySales"];
                        model.saleCount = kSaftToNSString([dic objectForKey:@"salesCount"]);
                        model.companyName=dic[@"vShopName"];
                        ShopModel * shopMod =[[ShopModel alloc]init];
                        shopMod.strShopId=kSaftToNSString([dic objectForKey:@"vShopId"]);
                        model.monthlySales=kSaftToNSString(dic[@"monthlySales"]);
                        model.shopInfo=shopMod;
                        if (isUpFresh) {
                            [dataSource addObject:model];
                        }
                        else
                        {
                            [marrEasyBuySource addObject:model];
                        }
                    }
                    
                    if (isUpFresh) {
                        marrEasyBuySource=dataSource;
                    }
                    if ([responseDict[@"data"] isKindOfClass:([NSArray   class])]&&![responseDict[@"data"]  count]>0) {
                        tvEasyBuy.footer.hidden=YES;
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 160);
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.font=[UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 210, 40);
                        lbTips.textAlignment=UITextAlignmentCenter;
                        lbTips.text=@"没有搜到相关商品数据！";
                        UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                        imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView=background;
                        tvEasyBuy.backgroundView.hidden=NO;
                    }
                    else{
                        tvEasyBuy.backgroundView.hidden=YES;
                    }
                    
                }else if ([str isEqualToString:@"768"])
                {
                    [Utils showMessgeWithTitle:nil message:[NSString stringWithFormat:@"根据相关的法律，无法显示与“%@”相关商品",tfInputSearchText.text] isPopVC:nil];
                    [tvEasyBuy.header endRefreshing];
                }else if ([str isEqualToString:@"201"])
                {
                    if (marrEasyBuySource.count>0) {
                        
                        [marrEasyBuySource removeAllObjects];
                    }
                    [tvEasyBuy reloadData];
                    [tvEasyBuy.header endRefreshing];
                    tvEasyBuy.footer.hidden=YES;
                    UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                    lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:15.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 40);
                    lbTips.text=@"没有搜到相关商品数据！";
                    
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    
                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView=background;
                    //
                    
                }
                [tvEasyBuy reloadData];
                
                if (currentPage<=totalPage) {
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [tvEasyBuy.header endRefreshing];
                    [tvEasyBuy.footer endRefreshing];
                    
                }else{
                    [tvEasyBuy.header endRefreshing];
                    [tvEasyBuy.footer endRefreshing];
                    [tvEasyBuy.footer noticeNoMoreData];//必须要放在reload后面
                }
            }
        }
        
    }
     ];
    
    
}



#pragma mark  搜商铺
-(void)loadSearchShopDataWithSortType :(NSString *)sorttype WithspecialService: (NSString *) specialService
{
    
    if ([Utils isBlankString:tfInputSearchText.text]) {
        [tvEasyBuy.header endRefreshing];
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入搜索商铺！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return ; 
    }
    // add bysongjk
    // 消费抵扣全 传在hasCoupon
    self.hasCoupon = @"0";
    NSString * strSpecialServiceType = specialService;
    if (specialService && specialService.length>0)
    {
        
        if ([specialService rangeOfString:@"6"].location != NSNotFound)
        {
            self.hasCoupon = @"1";
            
            NSArray * arrService = [specialService componentsSeparatedByString:@","];
            NSMutableArray * marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"6"];
            if (marrService.count>0)
            {
                strSpecialServiceType = [marrService componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
        // add by songjk 去掉默认
        if ([strSpecialServiceType rangeOfString:@"1"].location != NSNotFound)
        {
            NSArray * arrService = [strSpecialServiceType componentsSeparatedByString:@","];
            NSMutableArray * marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"1"];
            if (marrService.count>0)
            {
                strSpecialServiceType = [marrService componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
    }
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    NSString * strKeyWork = [tfInputSearchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setValue:strKeyWork forKey:@"keyword"];
    [dict setValue:sorttype forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:@"10" forKey:@"count"];
    
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude] forKey:@"location"];
    [dict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/searchShop"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSString * str =[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"]&& [responseDict[@"data"] isKindOfClass:[NSArray class]]) {
                    [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                    totalPage =[responseDict [@"totalPage"] intValue ];
                    
                    NSMutableArray   *   dataSource= [NSMutableArray array];
                    
                    if (isUpFresh) {
                        if (marrEasyBuySource.count>0) {
                            [marrEasyBuySource removeAllObjects];
                        }
                    }
                    
                    NSArray * arrData = [responseDict objectForKey:@"data"];
                    for (int i = 0; i<arrData.count; i++) {
                        NSDictionary * dic  =arrData[i];
                        ShopModel * model =[[ShopModel alloc]init];
                        
                        model.strShopPictureURL= kSaftToNSString([dic objectForKey:@"pic"]);
                        model.strStoreName=kSaftToNSString([dic objectForKey:@"vShopName"]);
                        model.strVshopId=kSaftToNSString([dic objectForKey:@"vShopId"]);
                        
                        model.beCash=kSaftToNSString([dic[@"beCash"] stringValue]);
                        model.beReach=kSaftToNSString([dic[@"beReach"] stringValue]);
                        model.beSell=kSaftToNSString([dic[@"beSell"] stringValue]);
                        model.beTake=kSaftToNSString([dic[@"beTake"] stringValue]);
                        model.beTicket=kSaftToNSString([dic[@"beTicket"] stringValue]);
//                        model.beTicket=@"1";
                        
                        model.strCity=dic[@"city"];
                        model.strLat=dic[@"lat"];
                        model.strLongitude= dic[@"longitude"];
                        model.strRate=dic[@"rate"];
                        model.strShopName=dic[@"shopName"];
                        model.strShopId=dic[@"shopId"];
                        model.strShopAddress=dic[@"addr"];
                        model.strResourceNumber=dic[@"companyResourceNo"];
                        model.strCompanyName=dic[@"vShopName"];
                        model.strShopTel=dic[@"hotline"];
                        
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=model.strLat.doubleValue;
                        shopCoordinate.longitude=model.strLongitude.doubleValue;
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                        model.shopDistance=[NSString stringWithFormat:@"%.2f",dis/1000];
                        
                        if (isUpFresh) {
                            [dataSource addObject:model];
                        }
                        else
                        {
                            [marrEasyBuySource addObject:model];
                        }
                    }
                    
                    if (isUpFresh) {
                        marrEasyBuySource=dataSource;
                    }
                    if ([responseDict[@"data"] isKindOfClass:([NSArray   class])]&&![responseDict[@"data"]  count]>0) {
                        
                        tvEasyBuy.footer.hidden=YES;
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 160);
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.font=[UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 210, 40);
                        lbTips.textAlignment=UITextAlignmentCenter;
                        lbTips.text=@"没有搜到相关商品数据！";
                        UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                        imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView=background;
                        tvEasyBuy.backgroundView.hidden=NO;
                    }
                    else{
                        tvEasyBuy.backgroundView.hidden=YES;
                        
                    }
                    
                }else if ([str isEqualToString:@"768"])
                {
                    [Utils showMessgeWithTitle:nil message:[NSString stringWithFormat:@"根据相关的法律，无法显示与“%@”相关商品",tfInputSearchText.text] isPopVC:nil];
                    [tvEasyBuy.header endRefreshing];
                }else if ([str isEqualToString:@"201"])
                {
                    if (marrEasyBuySource.count>0) {
                        
                        [marrEasyBuySource removeAllObjects];
                    }
                    [tvEasyBuy reloadData];
                    [tvEasyBuy.header endRefreshing];
                    tvEasyBuy.footer.hidden=YES;
                    
                    UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                    lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:15.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 40);
                    lbTips.text=@"没有搜到相关商品数据！";
                    
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    
                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView=background;
                    //
                    
                }
                [tvEasyBuy reloadData];
                
                if (currentPage<=totalPage) {
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [tvEasyBuy.header endRefreshing];
                    [tvEasyBuy.footer endRefreshing];
                    
                }else{
                    [tvEasyBuy.header endRefreshing];
                    [tvEasyBuy.footer endRefreshing];
                    [tvEasyBuy.footer noticeNoMoreData];//必须要放在reload后面
                }
            }
        }
        
    }
     ];
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //UIKeyboardWillShowNotification键盘出现
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];

    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        //[[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
        //add by shiang
         [self.navigationController.navigationBar setBackgroundImage:[self buttonImageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }else
    {
//        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
        self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    
    //隐藏 navigationController
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO   animated:YES];
    
}

//add by shiang
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void)addTopSelectView
{
    
    chooseArray = [NSMutableArray arrayWithArray:@[marrSortNameTitle,
                                                   marrSortTtile,
                                                   ]];
    
    dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:easyBuySearchType WithOther:nil];
    
    dropDownView.mSuperView = self.view;
    dropDownView.deleteTableview=self;
    dropDownView.dropDownDataSource=self;
    dropDownView.has=NO;
    
    [dropDownView.BtnConfirm addTarget:self action:@selector(btnConfirmRequest) forControlEvents:UIControlEventTouchUpInside];
    _delegate=dropDownView;
    
    
    
    [self.view addSubview:dropDownView];
    //解决 弹出的view的循序问题。
    [self.view sendSubviewToBack:dropDownView];
    
}


-(void)btnConfirmRequest
{
    strSpecialService =  [marrSpecailService  componentsJoinedByString:@","];
    currentPage=1;
    isUpFresh=YES;
    
    if (seachType==1) {
        [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
    }else
    {
        [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        
        [_delegate hidenBackgroundView];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        [[UINavigationBar appearance]setTintColor:kNavigationBarColor];
    }else
    {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//        [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
        self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    }
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
     [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [tfInputSearchText resignFirstResponder];
}


#pragma mark 选中一行的回调方法。
-(void)didSelectedOneShow : (NSString *)title WithIndexPath:(NSIndexPath *)indexPath WithCurrentSection:(NSInteger)sectionNumber2
{
    currentPage = 1;
    switch (sectionNumber2) {
        case 0:
        {
            if (seachType==1) {
                //修改 第一个可选项 排序名称
                GYSortTypeModel * sortTypeMod2 =marrSortName[indexPath.row];
                if (marrEasyBuySource.count>0) {
                    [marrEasyBuySource removeAllObjects];
                }
                strSortType=sortTypeMod2.strSortType;
                [self loadSearchDataWithSortType:strSortType WithspecialService:strSpecialService];
            }else{
                //修改 第一个可选项 排序名称
                GYSortTypeModel * sortTypeMod2 =marrSortName[indexPath.row];
                
                if (marrEasyBuySource.count>0) {
                    [marrEasyBuySource removeAllObjects];
                }
                
                strSortType=sortTypeMod2.strSortType;
                [self loadSearchShopDataWithSortType:strSortType WithspecialService:strSpecialService];
                
            }
            
        }
            break;
        case 1:
        {
            GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];
            
            [marrSpecailService addObject:sortTypeMod2.strSortType];
            
            //nsset去重
            
            NSSet * set =[NSSet setWithArray:marrSpecailService];
            
            marrSpecailService= [[set allObjects]  mutableCopy];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}
//多选项中用于删除 选中的项目
-(void)mutableSelectRemoveObj: (NSIndexPath *)indexPath WithCurrentSectin :(NSInteger )sectionNumber
{
    GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];
    
    if ([marrSpecailService containsObject:sortTypeMod2.strSortType]) {
        [marrSpecailService removeObject:sortTypeMod2.strSortType];
    }
    
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}


//返回的多选列表总共有多少项。
-(NSInteger)multipleChoiceCount
{
    int arrCount =[chooseArray count];
    return  [ chooseArray[arrCount-1] count];
}


-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arry =[chooseArray[section] mutableCopy];
    return [arry count];
}


-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}


-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return marrEasyBuySource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    if (seachType==1) {
        height=117.0f;
    }else
    {
        height=95.0f;
    }
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell;
    
    GYEasyBuySearchList * easyBuyCell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    GYEasyBuySearchShopList *easyBuyShopCell =[tableView dequeueReusableCellWithIdentifier:shopCellIdentifer];
    [easyBuyShopCell.btnShopTel addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
    
    if (seachType==1) {
        if (easyBuyCell==nil) {
            easyBuyCell=[[GYEasyBuySearchList alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        easyBuyCell.selectionStyle=UITableViewCellSelectionStyleNone;
        GYEasyBuyModel * model = marrEasyBuySource[indexPath.row];
        [easyBuyCell refreashUIWithModel:model];
        cell=easyBuyCell;
    }else {
        
        if (easyBuyShopCell==nil) {
            easyBuyShopCell=[[GYEasyBuySearchShopList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCellIdentifer];
        }
        id obj = marrEasyBuySource[indexPath.row];
        if ([obj isKindOfClass:[ShopModel class]]) {
            //           [[tableView visibleCells]];
            
            ShopModel * model = marrEasyBuySource[indexPath.row];
            [easyBuyShopCell refreashUIWithModel:model];
        }else
        {
            [tableView setValue:nil forKey:@"visibleCells"];
        }
        cell= easyBuyShopCell;
        
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seachType==1) {
        if (marrEasyBuySource.count>0)
        {
            GYEasyBuyModel * model = marrEasyBuySource[indexPath.row];
            GYGoodsDetailController * vcGoodDetail =[[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
            vcGoodDetail.model=model;
            self.hidesBottomBarWhenPushed=YES;
        
            self.navigationController.navigationBar.backgroundColor=[UIColor redColor ];
            [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"nav_btn_back.png"]];
            [self.navigationController pushViewController:vcGoodDetail animated:YES];
            
        }
    }else{
        
        if (marrEasyBuySource.count>0) {
            ShopModel * model = marrEasyBuySource[indexPath.row];
            
//            GYShopDetailViewController * vcShopDetail =[[GYShopDetailViewController alloc]initWithNibName:@"GYShopDetailViewController" bundle:nil];
//            vcShopDetail.fromEasyBuy=1;
//            vcShopDetail.ShopID=model.strShopId;
//            vcShopDetail.hidesBottomBarWhenPushed=YES;
//            self.navigationController.navigationBar.backgroundColor=[UIColor redColor ];
//            [self.navigationController pushViewController:vcShopDetail animated:YES];
            GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
            vc.shopModel = model;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark 历史记录的表格显示
-(void)historyViewisdata{
//    UIView *new=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    
//    new.backgroundColor= [UIColor clearColor];
//    [self.view addSubview:new];
    
//    
//    historyView =[[GYhistoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-70-keyheight)];
//    historyView.backgroundColor=[UIColor clearColor];
//    historyView.historyArry=[self loadBrowsingHistoryandType:seachType];
//    historyView.Hdelegate=self;
//    
//    NSLog( @"%@",historyView.historyArry);
//
//    [self.view addSubview:historyView];
    
//    [self.view addSubview: [self tableViewfootview]];
}
#pragma mark 清空搜索历史
-(UIView *)tableViewfootview
{
    UIView *footerView = [[UIView alloc]init];
    footerView.frame =CGRectMake(0, 0, 100,30);
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame= CGRectMake(0, 0, 100, 30);
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setCornerRadius:5.0];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    loginButton.layer.borderWidth=0.3;
    loginButton.layer.borderColor = [UIColor redColor].CGColor;
    [loginButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginButton addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:loginButton];
    return footerView;
    
}
#pragma mark 清空搜索历史按钮触发方法
-(void)clearBtnClick
{
    NSString *key;
    if (seachType==1) {
        key =kKeyForsearchHistorygoods;////商品
    }else key =  kKeyForsearchHistoryshop;////商铺
    [self deleteBrowsingHistory:nil andForKey:key andAll:YES];
    NSLog( @"fsdfsdafa");
}
#pragma mark  textfield delegate  添加一个表格
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    historyView.hidden=NO;
//    myfooterView.hidden=NO;
//    vTemp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    vTemp.backgroundColor=[UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:0.3];
//    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenTempView)];
//    [vTemp addGestureRecognizer:tap];
//    
//    [self.view addSubview:vTemp];
    
//    [self historyViewisdata];
}

-(void)hidenTempView
{
//    if (vTemp) {
//        [vTemp removeFromSuperview];
////        [historyView removeFromSuperview];
////        [myfooterView removeFromSuperview];
//    }
//    //    if ([tfInputSearchText becomeFirstResponder]) {
//    [tfInputSearchText resignFirstResponder];
    //    }
//    if (historyView) {
//        [historyView removeFromSuperview];
//        [myfooterView removeFromSuperview];
//    }
    [tfInputSearchText resignFirstResponder];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
     
//    myfooterView.hidden=YES;
    historyView.hidden=YES;
//    [self hidenTempView];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
}

/**
 *  拨打电话
 *
 */
- (void)callShop:(UIButton *)button
{
    [Utils callPhoneWithPhoneNumber:button.currentTitle showInView:self.view];
    
}
//////第二个页面点击cell 返回的值
-(void)didSelectOneRow:(NSString *)title
{
    tfInputSearchText.text=title;

}
@end

//
//  GYEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEasyBuyViewController.h"
#import "GYEasyBuyModel.h"
#import "GYEeayBuyTableViewCell.h"
#import "GYEasyPurchaseMainViewController.h"
#import "DropDownWithChildListView.h"
#import "GYGoodsDetailController.h"
#import "GYGoodCategoryModel.h"
#import "EasyPurchaseData.h"
#import "GYSortTypeModel.h"
#import "GYCartViewController.h"
#import "MJRefresh.h"
#import "GYEPMyHEViewController.h"


#define pageCount 8
@interface GYEasyBuyViewController ()
@property (nonatomic,strong) NSString *hasCoupon;
@end

@implementation GYEasyBuyViewController
{
    __weak IBOutlet UITableView *tvEasyBuy;
    NSMutableArray          * marrEasyBuySource;
    NSMutableArray          * chooseArray;
    NSMutableArray          * marrCategoryLevelTwo;
    NSInteger sectionNumber;
    UITableView * tempTv;
    NSMutableArray * testArr;
    NSMutableArray * marrCategoryLevelOne;
    NSMutableArray * marrLevelTwoTitle;
    
    NSInteger levelTwo;
    NSMutableArray *  marrSortType;
    NSMutableArray *  marrSortTtile;
    
    
    NSMutableArray * marrSortName;
    NSMutableArray * marrSortNameTitle;
    
    NSString * strSortType;
    NSString * strSpecialService;
    NSString * strCategory;
    
    NSMutableArray * marrSpecailService;
    
    NSInteger currentPage;
    NSInteger totalCount;
    
    BOOL isUpFresh;
    
    NSInteger totalPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* image= kLoadPng(@"ep_img_nav_cart");
        CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
        UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = backframe;
        [backButton setBackgroundImage:image forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    testArr=[NSMutableArray array];
    marrEasyBuySource=[NSMutableArray array];
    marrCategoryLevelOne=[NSMutableArray array];
    marrCategoryLevelTwo=[NSMutableArray array];
    marrLevelTwoTitle =[NSMutableArray array];
    
    marrSortType = [NSMutableArray array];
    marrSortTtile = [NSMutableArray array];
    
    marrSortName = [NSMutableArray array];
    marrSortNameTitle = [NSMutableArray array];
    
    
    marrSpecailService = [NSMutableArray array];
    
    // 2为销量最高 1为人气排序
    strSortType=@"1";
    strSpecialService=@"";
    strCategory=self.strGoodsCategoryId;
    currentPage=1;
    
    
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYEeayBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    //    if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {
    //
    //        [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
    //
    //    }
    
    tvEasyBuy.tableFooterView=[[UIView alloc]init];
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0")) {
        tvEasyBuy.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tvEasyBuy addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    //    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [tvEasyBuy addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    //    [tvEasyBuy headerBeginRefreshing];
    
    // 设置文字(默认的文字在MJRefreshConst中修改)
    UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:[self leftView]];
    self.navigationItem.rightBarButtonItem = btnSetting;
    [self loadTopicFromNetwork];
    
}

-(UIView *)leftView
{
    UIView * vBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0,65, 30)];
    UIImage* imageHs= kLoadPng(@"myHs");
    
    UIImage* imageCart= kLoadPng(@"ep_img_nav_cart");
    
    CGRect backframe= CGRectMake(0, 2, imageCart.size.width * 0.5, imageCart.size.height * 0.48);
    
    UIButton* cartButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    cartButton.frame = backframe;
    
    [cartButton setBackgroundImage:imageHs forState:UIControlStateNormal];
    
    [cartButton setTitle:@"" forState:UIControlStateNormal];
    
    [cartButton addTarget:self action:@selector(pushToMyHS:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* myHSButton= [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect Hsframe= CGRectMake(40, 2, imageCart.size.width * 0.5, imageCart.size.height * 0.5);
    myHSButton.frame=Hsframe;
    [myHSButton setBackgroundImage:imageCart forState:UIControlStateNormal];
    
    [myHSButton setTitle:@"" forState:UIControlStateNormal];
    
    [myHSButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    
    [vBackground addSubview:cartButton];
    
    [vBackground addSubview:myHSButton];
    return vBackground;
    
}

-(void)pushToMyHS:(UIButton *)sender
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYEPMyHEViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
    
}
//加载列表数据
-(void)loadDataFromNetworkWithCategoryId :(NSString * )categoryid WithSortType :(NSString *)sorttype WithspecialService: (NSString *) specialService
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    self.hasCoupon = @"0";
    // 消费抵扣全 传在hasCoupon
    
    // modify by songjk 传入的id由数字改为名称
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
                NSMutableArray * marrName = [NSMutableArray array];
                NSString * strName = @"";
                for (int i =0; i<marrService.count; i++)
                {
                    strName = [Utils getServiceNameWithServiceCode:marrService[i]];
                    if (strName && strName.length>0)
                    {
                        [marrName addObject:strName];
                        
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
            else
            {
                strSpecialServiceType = @"";
            }
        }
        else // 不包含6
        {
            NSArray * arrService = [specialService componentsSeparatedByString:@","];
            if (arrService.count>0)
            {
                // modify 传入的id由数字改为名称
                NSMutableArray * marrName = [NSMutableArray array];
                NSString * strName = @"";
                for (int i =0; i<arrService.count; i++)
                {
                    strName = [Utils getServiceNameWithServiceCode:arrService[i]];
                    if (strName && strName.length>0)
                    {
                        [marrName addObject:strName];
                        
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
        }
    }
    
    strSpecialServiceType = [strSpecialServiceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [dict setValue:categoryid forKey:@"categoryId"];
    [dict setValue:sorttype forKey:@"sortType"];
      [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"currentPage"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getTopicList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        //       [Utils hideHudViewWithSuperView:self.view];
        if (!error) {
            NSDictionary * responseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSString * str =[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"])
                {
                    tvEasyBuy.backgroundView.hidden=YES;
                    totalCount=[[responseDict objectForKey:@"rows"] integerValue];
                    totalPage =[responseDict [@"totalPage"] intValue];
                    
                    NSMutableArray * dataSource =[NSMutableArray array];
                    NSArray * arrData = [responseDict objectForKey:@"data"];
                    for (int i = 0; i<arrData.count; i++)
                    {
                        NSDictionary * dic = arrData[i];
                        GYEasyBuyModel * model =[[GYEasyBuyModel alloc]init];
                        model.strGoodPictureURL= kSaftToNSString([dic objectForKey:@"url"]);
                        model.strGoodName=kSaftToNSString([dic objectForKey:@"title"]);
                        model.strGoodPrice=kSaftToNSString([dic objectForKey:@"price"]);
                        model.strGoodPoints=kSaftToNSString([dic objectForKey:@"pv"]);
                        model.strGoodId=kSaftToNSString([dic objectForKey:@"id"]);
                        model.strCurrentPageIndex=kSaftToNSString([dic objectForKey:@"currentPageIndex"]);
                        model.strTotalPage=kSaftToNSString([dic objectForKey:@"totalPage"]);
                        model.strTotalRows=kSaftToNSString([dic objectForKey:@"rows"]);
                        model.city=kSaftToNSString(dic[@"city"]);
                        model.companyName=dic[@"companyName"];
                        model.beCash=[dic[@"beCash"] boolValue];
                        model.beReach=[dic[@"beReach"] boolValue];
                        model.beSell = [dic[@"beSell"] boolValue];
                        model.beTake =[dic[@"beTake"] boolValue];
                        model.beTicket=[dic[@"beTicket"] boolValue];
                        model.monthlySales=kSaftToNSString(dic[@"monthlySales"]);
                        model.saleCount = kSaftToNSString(dic[@"salesCount"]);
                        ShopModel * shopMod =[[ShopModel alloc]init];
                        shopMod.strShopId=kSaftToNSString([dic objectForKey:@"vShopId"]);
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
                    
                    [tvEasyBuy reloadData];
                    
                    [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                    currentPage+=1;

                    if (currentPage<=totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEasyBuy.header endRefreshing];
                        [tvEasyBuy.footer endRefreshing];
                        
                    }else{
                        [tvEasyBuy.header endRefreshing];
                        [tvEasyBuy.footer endRefreshing];
                        [tvEasyBuy.footer noticeNoMoreData];//必须要放在reload后面
                    }
                    if ([responseDict[@"data"] isKindOfClass:([NSArray   class])]&&![responseDict[@"data"]  count]>0) {
                        
                        tvEasyBuy.footer.hidden=YES;
                        
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 160);
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.textAlignment=UITextAlignmentCenter;
                        lbTips.font=[UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 235, 40);
                        lbTips.text=@"Sorry,没有搜到相关商品数据！";
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
                }
                else
                {
                    if ([tvEasyBuy.header isRefreshing])
                    {
                        [tvEasyBuy.header endRefreshing];
                    }
                    
                    if ([tvEasyBuy.footer isRefreshing]) {
                        [tvEasyBuy.footer endRefreshing];
                    }
                    
                    [tvEasyBuy.footer noticeNoMoreData];
                    
                    [tvEasyBuy reloadData];
                    
                    if (marrEasyBuySource.count == 0)
                    {
                        tvEasyBuy.footer.hidden=YES;
                        UIView * background =[[UIView alloc]initWithFrame:tvEasyBuy.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 160);
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.textAlignment=UITextAlignmentCenter;
                        lbTips.font=[UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 235, 40);
                        lbTips.text=@"Sorry,没有搜到相关商品数据！";
                        UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                        imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView=background;
                        tvEasyBuy.backgroundView.hidden=NO;
                    }

                }
            }
        }
        
    }
     ];
    
    
    
}


-(void)loadTopicFromNetwork
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:[GlobalData shareInstance].ecKey forKeyPath:@"key"];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/columnClassify"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        [Utils hideHudViewWithSuperView:self.view];
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            
            if (!error)
            {
                NSString * str =[NSString stringWithFormat:@"%@",[ResponseDic objectForKey:@"retCode"]];
                
                if ([str isEqualToString:@"200"])
                {
                    
                    NSArray * arrtest =[ResponseDic objectForKey:@"data"];
                    for (NSDictionary * Dic1 in arrtest)
                    {
                        
                        GYGoodCategoryModel * model1 =[[GYGoodCategoryModel alloc]init];
                        model1.strCategoryTitle =[Dic1 objectForKey:@"name"];
                        model1.strCategoryId =[Dic1 objectForKey:@"id"];
                        
                        
                        for (NSDictionary * Dic2 in [Dic1 objectForKey:@"categories"])
                        {
                            GYGoodCategoryModel * model2 =[[GYGoodCategoryModel alloc]init];
                            model2.strCategoryTitle=[Dic2 objectForKey:@"name"];
                            model2.strCategoryId=[Dic2 objectForKey:@"id"];
                            [model1.marrSubCategory addObject:model2];
                            
                        }
                        [testArr addObject:model1];
                        [marrCategoryLevelOne addObject: model1.strCategoryTitle];
                        
                        
                    }
                    [self getSortTypeData];
                    
                    
                    
                }
                
            }
            
        }
        
    }
     ];
    
    
}


-(void)getSortNameData
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/sortName"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        
        
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

// 排序
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
                    // 排序
                    if (marrSortType.count>0)
                    {
                        [marrSortType sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            return [((GYSortTypeModel *)obj1).strSortType integerValue] > [((GYSortTypeModel *)obj1).strSortType  integerValue];
                        }];
                        [marrSortTtile removeAllObjects];
                        for (int i = 0; i<marrSortType.count; i++)
                        {
                            GYSortTypeModel * model = marrSortType[i];
                            [marrSortTtile addObject:model.strTitle];
                        }
                    }
                    [self     getSortNameData];
                    
                }
                
            }
            
        }
        
    }];
    
}




//主线程中更新UI
-(void)refreshTableview
{
    [tvEasyBuy reloadData];
    
}

//添加多选横条
-(void)addTopSelectView
{
    NSLog(@"%d-----------levelone-------%d----------sortname-------%d-----sorttitle",marrCategoryLevelOne.count,marrSortNameTitle.count,marrSortTtile.count);
    if (marrCategoryLevelOne.count>0&&marrSortNameTitle.count>0&&marrSortTtile.count>0) {
        chooseArray = [NSMutableArray arrayWithArray:@[
                                                       marrCategoryLevelOne,
                                                       marrSortNameTitle,  marrSortTtile
                                                       ]];
        
        
        DropDownWithChildListView * dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:easyBuyListType WithOther:nil];
        
        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview=self;
        dropDownView.dropDownDataSource=self;
        dropDownView.has=YES;
        [dropDownView.BtnConfirm addTarget:self action:@selector(btnSpecailServiceRequet) forControlEvents:UIControlEventTouchUpInside];
        
        _delegate=dropDownView;
        [self.view addSubview:dropDownView];
    }
    
    
    
  
    
    
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currentPage=1;
    isUpFresh=YES;
    [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
    
}



- (void)footerRereshing
{
    isUpFresh=NO;
    if (currentPage<=totalPage) {
        [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
    }
    
   
    
}


//点击确认按钮出发方法，发起请求
-(void)btnSpecailServiceRequet
{
    NSString * strSpecailServiceTotal =  [marrSpecailService  componentsJoinedByString:@","];
    currentPage=1;
    if (marrEasyBuySource.count>0)
    {
        [marrEasyBuySource removeAllObjects];
        
    }
    strSpecialService=strSpecailServiceTotal;
    [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecailServiceTotal];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        
        [_delegate hidenBackgroundView];
        
        
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//第一次加载的请求
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (marrEasyBuySource.count>0) {
        
    }else
    {
        
        [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
        
    }
    
    
}

#pragma mark 多选时用于 清除 多选项中得数据
-(void)btnTouch:(NSInteger)section
{
    if (section==2)
    {
        
    }
    else{
        
        [marrSpecailService removeAllObjects];
    }
    
    
    
}


#pragma mark -- dropDownListDelegate  选择section下面的row 的回调方法
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
    sectionNumber=section;
    //当点击到不是  多选项的btn 清除特殊服务数组
    
    CGFloat width =self.view.frame.size.width/[chooseArray count];
    
    
    if (marrLevelTwoTitle.count>0) {
        [marrLevelTwoTitle removeAllObjects];
    }
    
    GYGoodCategoryModel * CategoryLevelOne =testArr[index];
    marrCategoryLevelTwo = [NSMutableArray arrayWithArray:CategoryLevelOne.marrSubCategory];
    
    for (GYGoodCategoryModel * model in marrCategoryLevelTwo) {
        
        [marrLevelTwoTitle addObject:model.strCategoryTitle];
        
    }
    
    if (marrCategoryLevelTwo.count>0&&has) {
        if (tempTv==nil) {
            
            tempTv =[[UITableView alloc]init];
            tempTv.tag=100;
            tempTv.delegate=self;
            tempTv.dataSource=self;
            
        }
        //隐藏分割线
        if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        //        if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {
        //
        //            [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
        //
        //        }
        
        float  height;
        height= (kScreenHeight-64-40)*0.8;
        tempTv.frame =CGRectMake(width, 40, self.view.frame.size.width-width, height);
        //        tempTv.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:tempTv];
    }
    [tempTv reloadData];
    
}


-(void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
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
    NSArray *arry =chooseArray[section];
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
    
    if (tableView.tag==100) {
        return marrCategoryLevelTwo.count;
        
    }
    int rows=0;
    if (marrEasyBuySource.count % 2 == 0)
    {
        rows = marrEasyBuySource.count / 2;
    }else
    {
        rows = marrEasyBuySource.count / 2 + 1;
    }
    
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100) {
        return 40;
    }
    return 265;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    static NSString * cellIdentiferForTemp=@"TempCell";
    if (tableView.tag==100) {
        UITableViewCell  * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell==nil) {
            cell  =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text=marrLevelTwoTitle[indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor=kCellItemTitleColor;
        return cell;
        
    }else{
    
        GYEeayBuyTableViewCell * easyBuyCell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
//        [easyBuyCell.contentView removeFromSuperview];
    if (easyBuyCell!=nil) {
//        easyBuyCell=[[GYEeayBuyTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        NSArray *arr=[[NSBundle mainBundle]loadNibNamed:@"GYEeayBuyTableViewCell" owner:self options:nil];
        easyBuyCell=[arr objectAtIndex:0];
    }
    else{
        while ([easyBuyCell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[easyBuyCell.contentView.subviews lastObject]removeFromSuperview];
        }
        
    }
    easyBuyCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    GYEasyBuyModel * modelleft =marrEasyBuySource[indexPath.row*2];
    GYEasyBuyModel * modelright =nil;
    if ((indexPath.row*2+1)>=marrEasyBuySource.count) {
        
    }
    else {
        modelright =marrEasyBuySource[indexPath.row*2+1];
    }
    
    [easyBuyCell refreshUIWithModel:modelleft WithSecondModel:modelright];
    easyBuyCell.btnLeftCover.tag=100+indexPath.row*2;
    [easyBuyCell.btnLeftCover addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    easyBuyCell.btnRightCover.tag=5000+indexPath.row*2+1;
    [easyBuyCell.btnRightCover addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return easyBuyCell;
    
    }
}


#pragma mark tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==tempTv) {
        GYGoodCategoryModel  * mod = marrCategoryLevelTwo[indexPath.row];
        
        if (_delegate&&[_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
            
            if (marrEasyBuySource.count>0)
            {
                
                [marrEasyBuySource removeAllObjects];
            }
            
            [_delegate chooseRowWith:marrLevelTwoTitle[indexPath.row] WithSection:sectionNumber WithTableView :tempTv];
            currentPage=1;
            self.title=mod.strCategoryTitle;
            strCategory=mod.strCategoryId;
            [self loadDataFromNetworkWithCategoryId:mod.strCategoryId WithSortType:strSortType WithspecialService:strSpecialService];
            
        }
        
        [tempTv removeFromSuperview];
    }
    
    
}

//用于隐藏分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        [cell setLayoutMargins:UIEdgeInsetsZero];

    }
    
}

#pragma mark 代理类传过来选中的section和 indexpath DropDownWithChildChooseDataSource回调
-(void)didSelectedOneShow : (NSString *)title WithIndexPath:(NSIndexPath *)indexPath WithCurrentSection:(NSInteger)sectionNumber2
{
    
    switch (sectionNumber2) {
        case 1:
        {
            if (marrEasyBuySource.count>0)
            {
                
                [marrEasyBuySource removeAllObjects];
            }
            
            GYSortTypeModel * sortTypeMod1 =marrSortName[indexPath.row];
            strSortType=sortTypeMod1.strSortType;
            currentPage=1;
            [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
            
        }
            break;
        case 2:
        {
            
            GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];
            
            if ([sortTypeMod2.strTitle isEqualToString:@"全部"]) {
                sortTypeMod2.strSortType=@"";
            }
            
            [marrSpecailService addObject:sortTypeMod2.strSortType];
            
            //nsset去重
            
            NSSet * set =[NSSet setWithArray:marrSpecailService];
            
            marrSpecailService= [[set allObjects]  mutableCopy];
//                  [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
            
        }
            break;
        default:
            break;
    }
    
    
    
}

#pragma mark 用于消除 多选项中选中的项目
-(void)mutableSelectRemoveObj:(NSIndexPath *)indexPath WithCurrentSectin:(NSInteger)sectionNumber
{
    GYSortTypeModel * sortTypeMod2 =marrSortType[indexPath.row];
    
    [marrSpecailService removeObject:sortTypeMod2.strSortType];
    
    
}


-(void)btnClicked:(UIButton *)sender
{
    GYEasyBuyModel * mod = nil;
    
    if (sender.tag<5000) {
        mod = marrEasyBuySource[sender.tag-100];
    }else
        
    {
        mod =marrEasyBuySource[sender.tag-5000];
    }
    
    GYGoodsDetailController * vcGoodDetail =[[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
    vcGoodDetail.model=mod;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

//进入购物车
- (void)pushCartVc:(id)sender
{
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");//ep_img_nav_cart.png
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
}

@end

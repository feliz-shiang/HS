//
//  GYEvaluationGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAlreadyEvaluateGoodsViewController.h"
#import "GYEvaluationTableViewCell.h"
#import "GYEasyBuyModel.h"

#import "GYEvaluateGoodModel.h"

#import "GYMakeEvaluationViewController.h"
#import "MJRefresh.h"
#import "GYEasyPurchaseMainViewController.h"
#define Count 10
@interface GYAlreadyEvaluateGoodsViewController ()

@end

@implementation GYAlreadyEvaluateGoodsViewController

{

    __weak IBOutlet UITableView *tvEvaluationTableview;
    GYEasyBuyModel * model ;
    int currentPage;
    int totalCount;
    int totalPage;
    BOOL isUpFresh;

}
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
    // Do any additional setup after loading the view from its nib.
    _marrDataSource=[NSMutableArray array];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    CGRect rect=tvEvaluationTableview.frame;
    currentPage=1;
    
    UIView * backgroundForTV =[[UIView alloc]initWithFrame:rect];
    backgroundForTV.backgroundColor=kDefaultVCBackgroundColor;
    tvEvaluationTableview.backgroundView=backgroundForTV;
    [tvEvaluationTableview registerNib:[UINib nibWithNibName:@"GYEvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tvEvaluationTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
  
    UIView * header =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 16)];
    header.backgroundColor=kDefaultVCBackgroundColor;
    
    tvEvaluationTableview.tableHeaderView=header;
    tvEvaluationTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 14)];
    footer.backgroundColor=kDefaultVCBackgroundColor;
    tvEvaluationTableview.tableFooterView=footer;
    [self loadDataFromNetwork];
   
    [tvEvaluationTableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
}


-(void)viewWillDisappear:(BOOL)animated
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

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    isUpFresh=YES;
    currentPage=1;
    [self loadDataFromNetwork];
    
}



- (void)footerRereshing
{
    isUpFresh=NO;
    if (currentPage<=totalPage) {
        [self loadDataFromNetwork];
    }
    
}

-(void)loadDataFromNetwork
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:@"1" forKey:@"status"];
    [dict setValue:[NSString stringWithFormat:@"%d",Count] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getEvaluationGoodsList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){

        if (!error) {
             NSDictionary * resonpseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
               
                
                NSString * retCode =[NSString stringWithFormat:@"%@",resonpseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                     totalCount =[resonpseDic[@"rows"] intValue];
                     totalPage=[resonpseDic[@"totalPage"] intValue];
                    NSMutableArray * dataSource = [NSMutableArray array ];
                    for (NSDictionary * tempDic in resonpseDic[@"data"]) {
                        GYEvaluateGoodModel * mod= [[GYEvaluateGoodModel alloc]init];
                        mod.isEvaluated= kSaftToNSString(tempDic[@"beEvaluated"]);
                        mod.categoryId= kSaftToNSString(tempDic[@"categoryId"]);
                        mod.descComment= kSaftToNSString(tempDic[@"desc"]);
                        mod.goodIdString= kSaftToNSString(tempDic[@"id"]);
                        mod.orderDetailId= kSaftToNSString(tempDic[@"orderDetailId"]);
                        mod.orderId= kSaftToNSString(tempDic[@"orderId"]);
                        mod.price= kSaftToNSString(tempDic[@"price"]);
                        mod.serviceResourceNo= kSaftToNSString(tempDic[@"serviceResourceNo"]);
                        mod.shopId= kSaftToNSString(tempDic[@"shopId"]);
                        mod.skuString= kSaftToNSString(tempDic[@"sku"]);
                        mod.titleString= kSaftToNSString(tempDic[@"title"]);
                        mod.urlString= kSaftToNSString(tempDic[@"url"]);
                        mod.vShopIdString= kSaftToNSString(tempDic[@"vShopId"]);
                        mod.vShopName= kSaftToNSString(tempDic[@"vShopName"]);
                        if (isUpFresh) {
                            [dataSource addObject:mod];
                        }
                        else
                        {
                            [_marrDataSource addObject:mod];
                            
                        }
                    }
                    
                    if (isUpFresh) {
                        
                        [_marrDataSource removeAllObjects];
                        _marrDataSource=dataSource;
                    }
                    [tvEvaluationTableview reloadData];
                    
                    [tvEvaluationTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                    currentPage+=1;

                    if (currentPage<=totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEvaluationTableview.header endRefreshing];
                        [tvEvaluationTableview.footer endRefreshing];
                        
                    }else{
                        [tvEvaluationTableview.header endRefreshing];
                        [tvEvaluationTableview.footer endRefreshing];
                        [tvEvaluationTableview.footer noticeNoMoreData];//必须要放在reload后面
                    }

                    
                }
                
                
            }
            
        }
        
    }];



}

#pragma mark DataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    GYEvaluationTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[GYEvaluationTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.btnMakeEvalutaion.tag=indexPath.row;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    [cell.btnMakeEvalutaion setTitle:@"已评价" forState:UIControlStateNormal];
    GYEvaluateGoodModel  * EvaluateGoodModel =_marrDataSource[indexPath.row];

    [cell refreshUIWithModel:EvaluateGoodModel WithType:1];
    
    return cell;
}




@end

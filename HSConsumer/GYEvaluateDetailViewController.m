//
//  GYEvaluateDetailViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-12.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYEvaluateDetailViewController.h"
#import "GYGoodComments.h"
#import "GYMyCommentTableViewCell.h"
#import "MJRefresh.h"
#define Count 8
@interface GYEvaluateDetailViewController ()

@end

@implementation GYEvaluateDetailViewController

{
    __weak IBOutlet UITableView *tvEvaluationTalbe;
 
    UILabel * lbNoResultTip;
    
    int currentPage;
    
    int totalCount;
    
    int totalPage;

   
    BOOL isUpFresh;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _marrDatasource=[NSMutableArray array];
    currentPage=1;
    tvEvaluationTalbe.delegate=self;
    tvEvaluationTalbe.dataSource=self;
    [tvEvaluationTalbe registerNib:[UINib nibWithNibName:@"GYMyCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tvEvaluationTalbe.tableFooterView=[[UIView alloc]init];
    [self loadDataFromNetwork];
    [tvEvaluationTalbe addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [tvEvaluationTalbe addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}


-(void)loadDataFromNetwork
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:self.strGoodId   forKey:@"itemID"];
    [dict setValue:[NSString stringWithFormat:@"%d",Count]  forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    [dict setValue:self.EvaluteStatus   forKey:@"status"];
   
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getEvaluationInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * resonpseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                NSString * retCode =[NSString stringWithFormat:@"%@",resonpseDic[@"retCode"]];
        
                if ([retCode isEqualToString:@"200"]) {
                    NSMutableArray * dataSource= [NSMutableArray array];
                    for (NSDictionary * tempDict in resonpseDic[@"data"]) {
                        totalCount =[resonpseDic[@"rows"] intValue];
                        totalPage= [resonpseDic [@"totalPage"] intValue];
                         GYGoodComments * model =[[GYGoodComments alloc]init];
                         model.strUserName=kSaftToNSString(tempDict[@"name"]);
                         model.strIdstring=kSaftToNSString(tempDict[@"id"]);
                         model.strComments=kSaftToNSString(tempDict[@"content"]);
                         model.strGoodName=kSaftToNSString(tempDict[@"gName"]);
                         model.strGoodType=kSaftToNSString(tempDict[@"gType"]);
                       model.strTime = kSaftToNSString(tempDict[@"time"]);////////by liss
                       
                        if (isUpFresh) {
                            [dataSource addObject:model];
                        }
                        else
                        {
                            [_marrDatasource addObject:model];
                            
                        }
                        
                    }
                    
                    if (isUpFresh) {
                        
                        [_marrDatasource removeAllObjects];
                         _marrDatasource=dataSource;
                        
                    }
//                  _marrDatasource = (NSMutableArray *)[[_marrDatasource reverseObjectEnumerator] allObjects];
                    [tvEvaluationTalbe reloadData];
 
                    currentPage+=1;
               
                    if (currentPage<=totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEvaluationTalbe.header endRefreshing];
                        [tvEvaluationTalbe.footer endRefreshing];
                        
                    }else{
                        [tvEvaluationTalbe.header endRefreshing];
                        [tvEvaluationTalbe.footer endRefreshing];
                        [tvEvaluationTalbe.footer noticeNoMoreData];//必须要放在reload后面
                    }

                }
                
                
            }
            
        }
        
    }];
    

}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    isUpFresh=YES;
    
    currentPage=1;
//    if (_marrDatasource.count>0) {
//    [_marrDatasource removeAllObjects];
//    }
//    
    [self loadDataFromNetwork];
    
}


- (void)footerRereshing
{
    
    isUpFresh=NO;
    if (currentPage<=totalPage) {
        [self loadDataFromNetwork];
    }
  
    
}



#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _marrDatasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodComments * model =_marrDatasource[indexPath.row];
    CGFloat height = 123;
    if (model.contentHeight>44)
    {
        height = 123 - 44 + model.contentHeight;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    GYMyCommentTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[GYMyCommentTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    GYGoodComments * model =_marrDatasource[indexPath.row];
    
    [cell refreshUIWithModel:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end

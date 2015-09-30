//
//  GYSelWayViewController.m
//  HSConsumer
//
//  Created by 00 on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSelWayVC.h"
#import "UIView+CustomBorder.h"
#import "GYExpress.h"

@interface GYSelWayVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tbv;
    
    NSString * fee;
    
}
@end

@implementation GYSelWayVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"配送方式";
    self.marrDataSource = [NSMutableArray array];
    
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.scrollEnabled = NO;
    tbv.tableFooterView=[[UIView alloc]init];
    
    //    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, 44 * self.marrData.count);
    
    
    [tbv addAllBorder];
    
    //    [tbv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    if ([self.dictShopInfo[@"shopId"] isEqualToString:@"0"]) {
        
        
        CGRect  Frect  = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UIView * background =[[UIView alloc]initWithFrame:Frect];
        background.backgroundColor=kDefaultVCBackgroundColor;
        UILabel * lbTips =[[UILabel alloc]init];
        lbTips.center=CGPointMake(160, 160);
        lbTips.textColor=kCellItemTitleColor;
        lbTips.textAlignment=UITextAlignmentCenter;
        lbTips.font=[UIFont systemFontOfSize:15.0];
        lbTips.backgroundColor =[UIColor clearColor];
        lbTips.bounds=CGRectMake(0, 0, 270, 80);
        lbTips.text=@"商品在不同营业点销售，请选择单个商品下单!";
        lbTips.numberOfLines=0;
        
        UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
        imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
        imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
        [background addSubview:imgvNoResult];
        
        [background addSubview:lbTips];
       
        [self.view addSubview:background];
    }else
    {
       [self loadDataFromNetwork];
        
    }
    
    
 
}

-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    int Amount=0;
    NSMutableArray * marrItemList =[NSMutableArray array];
    
    for (NSDictionary * orderDict in self.dictShopInfo[@"orderDetailList"])
    {
        Amount += [orderDict[@"price"] intValue]* [orderDict[@"quantity"] intValue];
        
        [marrItemList addObject:orderDict[@"itemId"]];
        
    }
    
    [dict setValue:self.dictShopInfo[@"shopId"] forKey:@"shopId"];
    [dict setValue:[NSString stringWithFormat:@"%d",Amount] forKey:@"amount"];
    [dict setValue:[marrItemList componentsJoinedByString:@","]  forKey:@"itemIdList"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getExpressType",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            
        }else{
 
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            if (!error) {
                
                NSString * retcode =  [NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]] ;
                if ([retcode  isEqualToString:@"200"]) {
                   
                    fee=  kSaftToNSString(ResponseDic[@"data"][@"fee"]);

                    for (NSDictionary * dic in ResponseDic[@"data"][@"types"]) {
                        GYExpress * model =[[GYExpress alloc]init];
                        model.strExpress=dic[@"desc"];
                        
                        model.strExpressCode=kSaftToNSString(dic[@"type"]);
                        [self.marrDataSource addObject:model];
                    }
 
                    [tbv reloadData];
                    
                }
            }
            
            
        }
        
    }];
    
    
}

#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.textLabel.textColor=kCellItemTitleColor;
        cell.accessoryView.hidden=YES;
        

    }
    GYExpress * model = self.marrDataSource[indexPath.row];
    
    if ([model.strExpressCode isEqualToString:@"1"]) {
        cell.textLabel.textColor=kNavigationBarColor;
        UIView * accessoryView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        UIImageView * imgvCoin =[[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 25, 25)];
        imgvCoin.image=[UIImage imageNamed:@"hs_coin.png"];
        UILabel * lbFee =[[UILabel alloc]initWithFrame:CGRectMake(imgvCoin.frame.origin.x+imgvCoin.frame.size.width+10, 0, 60, 40)];
        lbFee.text=fee;
        [accessoryView addSubview:imgvCoin];
        [accessoryView addSubview:lbFee];
        cell.accessoryView=accessoryView;
        
    }
    
    cell.textLabel.text = model.strExpress;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYExpress * model = self.marrDataSource[indexPath.row];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(returnTitle:WithIndexPath:WithRetIndex:WithFee:)]) {
        
        if ([model.strExpressCode isEqualToString:@"1"]) {
            [self.delegate returnTitle:model WithIndexPath:self.indexPath WithRetIndex:indexPath.row WithFee:fee];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self.delegate returnTitle:model WithIndexPath:self.indexPath WithRetIndex:indexPath.row WithFee:@"0"];
            
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
    
    
    
}


@end

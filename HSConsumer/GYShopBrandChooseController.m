//
//  GYShopBrandChooseController.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/26.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYShopBrandChooseController.h"
#import "GYSearchShopGoodsViewController.h"

#define kShopBrandChooseCell @"ShopBrandChooseCell"
@interface GYShopBrandChooseController ()
@property (nonatomic,strong) NSMutableArray * marrData;
@property (nonatomic,assign) BOOL isSelected;
@end

@implementation GYShopBrandChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌专区";
    self.tableView.tableFooterView = [[UIView alloc] init];
    if (!self.strShopID || self.strShopID.length ==0) {
        [Utils showMessgeWithTitle:@"友情提示" message:@"无效的店铺" isPopVC:self.navigationController];
        return;
    }
//    [self.marrData addObject:@"全部品牌"];
    [self httpRequestForShopInfo];
}
-(NSMutableArray *)marrData
{
    if (_marrData == nil) {
        _marrData = [NSMutableArray array];
    }
    return _marrData;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strBrandyName = self.marrData[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopBrandChooseCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShopBrandChooseCell];
    }
    cell.textLabel.text = strBrandyName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strBrandyName = self.marrData[indexPath.row];
    if ([strBrandyName rangeOfString:@"全部"].location !=NSNotFound) {
        strBrandyName = @"";
    }
    self.isSelected = YES;
    if ([self.delegate respondsToSelector:@selector(ShopBrandChooseControllerDidChooseBrand:)]) {
        [self.delegate ShopBrandChooseControllerDidChooseBrand:strBrandyName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isSelected && [self.delegate respondsToSelector:@selector(ShopBrandChooseControllerDidChooseBrand:)]) {
        [self.delegate ShopBrandChooseControllerDidChooseBrand:@""];
    }
}
#pragma mark 加载店铺品牌
-(void)httpRequestForShopInfo
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    //    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.strShopID forKey:@"vShopId"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getVShopBrandName" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view];
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    NSArray * arrData = ResponseDic[@"data"];
                    for (int i = 0; i<arrData.count; i++)
                    {
                        NSDictionary * dictData = arrData[i];
                        NSString * strBrandyName = [dictData objectForKey:@"brandName"];
                        if (strBrandyName && strBrandyName.length>0) {
                            [self.marrData addObject:strBrandyName];
                        }
                    }
                }
            }
            else
            {
                [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺品牌失败" isPopVC:self.navigationController];
            }
        }
        else
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺品牌失败" isPopVC:self.navigationController];
        }
        if(self.marrData.count>0)
        {
            [self.tableView reloadData];
        }
    }];
    
}
@end

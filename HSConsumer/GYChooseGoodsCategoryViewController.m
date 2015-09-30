//
//  GYShopCategoryChooseController.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/26.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYChooseGoodsCategoryViewController.h"
#import "GYSearchShopGoodsViewController.h"

#define kShopCategoryChooseCell @"ShopCategoryChooseCell"
@interface  GYChooseGoodsCategoryViewController()
@property (nonatomic,strong) NSMutableArray * marrData;
@property (nonatomic,strong) NSMutableDictionary * mdictData;// add by songjk 保存cid
@end

@implementation GYChooseGoodsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    self.tableView.tableFooterView = [[UIView alloc] init];
    if (!self.strShopID || self.strShopID.length ==0) {
        [Utils showMessgeWithTitle:@"友情提示" message:@"无效的店铺" isPopVC:self.navigationController];
        return;
    }
    //    [self.marrData addObject:@"全部商品"];
    [self httpRequestForShopInfo];
}
-(NSMutableDictionary *)mdictData
{
    if (_mdictData == nil) {
        _mdictData = [NSMutableDictionary dictionary];
    }
    return _mdictData;
}
-(NSMutableArray *)marrData
{
    if (_marrData == nil) {
        _marrData = [NSMutableArray array];
    }
    return _marrData;
}
#pragma mark - Table view data source
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.marrData.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSString * name = self.marrData[section];
    //    NSArray * arrList = [self.mdictData objectForKey:name];
    //    return arrList.count;
    return self.marrData.count;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString * name = self.marrData[section];
//    UILabel * lbName = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    lbName.textColor = kCellItemTitleColor;
//    lbName.backgroundColor = kDefaultVCBackgroundColor;
//    lbName.text = name;
//    return lbName;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString * name = self.marrData[indexPath.section];
    //    NSArray * arrList = [self.mdictData objectForKey:name];
    //    NSString * strcategoryName = arrList[indexPath.row];
    NSString * strcategoryName = self.marrData[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCategoryChooseCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShopCategoryChooseCell];
    }
    cell.textLabel.text = strcategoryName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString * name = self.marrData[indexPath.section];
    //    NSArray * arrList = [self.mdictData objectForKey:name];
    //    NSString * strcategoryName = arrList[indexPath.row];
    NSString * strcategoryName = self.marrData[indexPath.row];
    strcategoryName = [strcategoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * strCID = [self.mdictData objectForKey:strcategoryName];// add by songjk 传入cid
    strcategoryName = [strcategoryName stringByAppendingString:@"*"];
    if ([strcategoryName rangeOfString:@"全部"].location != NSNotFound)
    {
        strcategoryName = @"";
    }
    if (!strCID) {
        strCID = @"";
    }
    //add by zhangqy  商品列表页面回调
    self.CompletionBlock(strcategoryName,strCID);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 加载店铺分类
-(void)httpRequestForShopInfo
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    //    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.strShopID forKey:@"vShopId"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getVShopCategory" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
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
                        //                        NSMutableArray * marrListData = [NSMutableArray array];
                        NSDictionary * dictData = arrData[i];
                        NSString * strcategoryName = [dictData objectForKey:@"categoryName"];
                        if (strcategoryName && strcategoryName.length>0)
                        {
                            [self.marrData addObject:strcategoryName];
                            //                            [marrListData addObject:strcategoryName];
                            // add by songjk 传入cid
                            NSString * strCID = [dictData objectForKey:@"cid"];
                            if (strCID && strCID.length>0)
                            {
                                [self.mdictData setObject:strCID forKey:strcategoryName];
                            }
                        }
                        // 子类
                        NSArray * arrSubList = [dictData objectForKey:@"listMap"];
                        for (NSDictionary * dictList in arrSubList)
                        {
                            NSString * strListName = [dictList objectForKey:@"categoryName"];
                            if (strListName && strListName.length>0)
                            {
                                // add by songjk 传入cid
                                NSString * strCID = [dictList objectForKey:@"cid"];
                                if (strCID && strCID.length>0)
                                {
                                    [self.mdictData setObject:strCID forKey:strListName];
                                }
                                
                                strListName = [NSString stringWithFormat:@"        %@",strListName];
                                //                                [marrListData addObject:strListName];
                                [self.marrData addObject:strListName];
                            }
                        }
                        //                        [self.mdictData setObject:marrListData forKey:strcategoryName];
                    }
                }
            }
            else
            {
                [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺分类失败" isPopVC:self.navigationController];
            }
        }
        else
        {
            [Utils showMessgeWithTitle:@"友情提示" message:@"加载店铺分类失败" isPopVC:self.navigationController];
        }
        if(self.marrData.count>0)
        {
            [self.tableView reloadData];
        }
    }];
    
}
@end



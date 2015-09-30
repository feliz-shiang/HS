//
//  GYCityChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCityChooseViewController.h"
#import "GYCityInfo.h"
@interface GYCityChooseViewController ()

@end

@implementation GYCityChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择城市";
    self.marrDatasource=[NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist"ofType:@"txt"];
    NSLog(@"%@---------code",self.parentCode);
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
       for (NSDictionary * tempDic in dict[@"data"]) {
        GYCityInfo * cityModel =[[GYCityInfo alloc]init];
        cityModel.strAreaName=tempDic[@"areaName"];
        cityModel.strAreaCode=tempDic[@"areaCode"];
        cityModel.strAreaType=tempDic[@"areaType"];
        cityModel.strAreaParentCode=kSaftToNSString(tempDic[@"parentCode"]);
           cityModel.strAreaSortOrder= kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaParentCode isEqualToString:self.parentCode]) {
            [self.marrDatasource addObject:cityModel];
        }
        
    }

    
}



#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrDatasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
  
    GYCityInfo * cityModel = self.marrDatasource[indexPath.row];
    cell.textLabel.text=cityModel.strAreaName;
    cell.textLabel.textColor=kCellItemTitleColor;
    
//    [cell refreshUIWith:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     GYCityInfo * cityModel = self.marrDatasource[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectOneCity:)]) {
        [_delegate selectOneCity:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
@end

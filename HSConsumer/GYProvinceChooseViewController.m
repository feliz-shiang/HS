//
//  GYProvinceChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYProvinceChooseViewController.h"
#import "GYCityInfo.h"

@interface GYProvinceChooseViewController ()

@end

@implementation GYProvinceChooseViewController
{

    __weak IBOutlet UITableView *tableProvince;




}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"选择省份";
    self.marrDatasource=[NSMutableArray array];
    tableProvince.delegate=self;
    tableProvince.dataSource=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"statelist"ofType:@"txt"];
    
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
    NSLog(@"%d-----bbbbbb",self.marrDatasource.count);
//    [tableProvince reloadData];
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     GYCityInfo * cityModel = self.marrDatasource[indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(selectOneProvince:)]) {
        [_delegate selectOneProvince:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}
@end

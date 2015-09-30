//
//  GYAreaChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYAreaChooseViewController.h"

@interface GYAreaChooseViewController ()

@end


@implementation GYAreaChooseViewController

{

    __weak IBOutlet UITableView *tableArea;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"选择区/县";
    self.marrDatasource=[NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"districtlist"ofType:@"txt"];
 
    
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
    tableArea.delegate=self;
    tableArea.dataSource=self;
    NSLog(@"%@-------",self.marrDatasource);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (_delegate && [_delegate respondsToSelector:@selector(selectOneArea:)]) {
        [_delegate selectOneArea:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end

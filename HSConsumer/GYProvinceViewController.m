//
//  GYProvinceViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYProvinceViewController.h"
#import "GYCityAddressViewController.h"

@interface GYProvinceViewController ()

@end

@implementation GYProvinceViewController
{

   FMDatabase *dataBase;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"选择省份";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //1、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }
    
    
    self.marrSourceData =[self selectFromDB];
    
  
}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrSourceData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
    
    cell.textLabel.text=MOD.areaName;

//    cell.textLabel.text=self.marrSourceData[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (_fromWhere==1) {
         GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
        if (_delegate &&[_delegate respondsToSelector:@selector(didSelectProvince:)]) {
            [_delegate didSelectProvince:MOD];
        }
        
    }else{
    
    GYCityAddressViewController * vcCity =[[GYCityAddressViewController alloc]initWithNibName:@"GYCityAddressViewController" bundle:nil];
    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:MOD.areaNo forKey:@"province"];
    [defaults synchronize];
    
    vcCity.areaIdString=MOD.areaId;
    vcCity.mstrCountryAndProvince=[[NSString stringWithFormat:@"%@ %@",self.mstrCountry,MOD.areaName]mutableCopy];
    [self.navigationController pushViewController:vcCity animated:YES];
    
    }
    
}

-(NSMutableArray *)selectFromDB
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    FMResultSet * set = [dataBase executeQuery:@"select * from T_PUB_AREA where parent_id = ?",self.areaId ];
    while ([set next]) {
        
        GYChooseAreaModel * m = [[GYChooseAreaModel alloc] init];
        
        m.areaId = [NSString stringWithFormat:@"%d",[set intForColumn:@"area_id"]];
        
        m.parentIdstring = [NSString stringWithFormat:@"%@",[set stringForColumn:@"parent_id"]];
        m.hiberarchy = [NSString stringWithFormat:@"%@",[set stringForColumn:@"hiberarchy"]];
        m.areaName = [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_name"]];
        m.fullName = [NSString stringWithFormat:@"%@",[set stringForColumn:@"full_name"]];
        m.isbnCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"isbn_code"]];
        m.code = [NSString stringWithFormat:@"%@",[set stringForColumn:@"code"]];
        m.areaNo= [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_no"]];
        m.areaCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"area_code"]];
        m.phonePrefix = [NSString stringWithFormat:@"%@",[set stringForColumn:@"phone_prefix"]];
        m.langCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"lang_code"]];
        m.dateFmtCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"date_fmt_code"]];
        m.treeLevel = [NSString stringWithFormat:@"%@",[set stringForColumn:@"tree_level"]];
        m.currencyId = [NSString stringWithFormat:@"%@",[set stringForColumn:@"currency_id"]];
        m.populations = [NSString stringWithFormat:@"%@",[set stringForColumn:@"populations"]];
        m.isParent = [NSString stringWithFormat:@"%@",[set stringForColumn:@"is_parent"]];
        m.internationalCode = [NSString stringWithFormat:@"%@",[set stringForColumn:@"international_code"]];
        m.zoneNo= [NSString stringWithFormat:@"%@",[set stringForColumn:@"zone_no"]];
    
        [arr addObject:m];
        
    }
    
  
    
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects: secondDescriptor, nil];
    
    arr= [[ arr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    
    
    return arr;
    
}

@end

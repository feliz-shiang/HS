//
//  GYCountrySelectionViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCountrySelectionViewController.h"
#import "FMDatabase.h"
#import "GYChooseAreaModel.h"
@interface GYCountrySelectionViewController ()

@end

@implementation GYCountrySelectionViewController

{
    __weak IBOutlet UITableView *tvCountrySelection;
    FMDatabase * dataBase;


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"选择国籍";
    [self moveToDBFile];
    
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }
    
    self.marrSourceData = [self selectFromDB];
    
    
}

-(void)moveToDBFile
{
    //1、获得数据库文件在工程中的路径——源路径。
    NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"T_PUB_AREA"ofType:@"db"];
    NSLog(@"%@--------sourcesPath",sourcesPath);
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    NSLog(@"path   =======%@",desPath);
    //3、通过NSFileManager类，将工程中的数据库文件复制到沙盒中。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath])
    {
        NSError *error ;
        
        if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
            NSLog(@"数据库移动成功");
        }
        else {
            NSLog(@"数据库移动失败");
        }
        
    }
    
}

#pragma mark DataSourceDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

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
            cell.accessoryView=nil;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
    
    if (_Delegate &&[_Delegate respondsToSelector:@selector(selectNationalityModel:)]) {
        [_Delegate selectNationalityModel:MOD];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    

    
    
}


-(NSMutableArray *)selectFromDB
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    FMResultSet * set = [dataBase executeQuery:@"select * from T_PUB_AREA"];
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
        
        if ([m.parentIdstring isEqualToString:@"0"]) {
            
            [arr addObject:m];
        }
        
        
    }
    
    
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects: secondDescriptor, nil];
    
    arr= [[ arr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return arr;
    
}

@end

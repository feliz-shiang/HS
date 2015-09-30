//
//  GYProvinceViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCityAddressViewController.h"
#import "GYPersonalFileViewController.h"
#import "GYPersonDetailFileViewController.h"
#import "GYCardBandingViewController.h"
#import "GYChooseAreaModel.h"
#import "GYCardBandingViewController.h"
#import "GYModifyCardViewController.h"
#import "UIAlertView+Blocks.h"

//@class GYPersonDetailFileViewController;
@interface GYCityAddressViewController ()

@end

@implementation GYCityAddressViewController
{

   FMDatabase *dataBase;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            self.title=@"选择城市";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.marrSourceData =[NSMutableArray  arrayWithObjects:@"深圳市",@"广州",@"韶关",@"河源",@"梅州",@"汕头",@"汕尾",@"江门", nil];
    
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    NSLog(@"%@",documentPath);
    
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }
    
    
    self.marrSourceData =[self selectFromDB];
    
    
    NSLog(@"%@",self.navigationController.childViewControllers);
    
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

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
    
    NSUserDefaults * cityDefault =[NSUserDefaults standardUserDefaults];
    [cityDefault setObject:MOD.areaNo forKey:@"cityNO"];
    [cityDefault synchronize];

    NSUserDefaults * cityNameDefault =[NSUserDefaults standardUserDefaults];
    [cityNameDefault setObject:MOD.areaName forKey:@"cityName"];
    [cityNameDefault synchronize];
    
    NSString * strArea =[NSString stringWithFormat:@"%@ %@",self.mstrCountryAndProvince,MOD.areaName];

    NSLog(@"%@--------controller",self.navigationController.childViewControllers);
    
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for (UIViewController *aViewController in allViewControllers) {
                if ([aViewController isKindOfClass:[GYCardBandingViewController class]]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"getAddress" object:strArea userInfo:nil];
                    [self.navigationController popToViewController:aViewController animated:YES];
                }else if ([aViewController isKindOfClass:[GYPersonDetailFileViewController class]])
                {
                
                 [self saveRequest:strArea];
                }
            }
    
    
}


-(void)saveRequest :(NSString *)address
{
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    [insideDict setValue:address   forKey:@"address"];
    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
    
        if ([retCode isEqualToString:@"200"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAddress" object:address userInfo:nil];
            
            if ([self.navigationController.childViewControllers[1] isKindOfClass:[GYPersonDetailFileViewController class]])
            {
                
                [UIAlertView showWithTitle:nil message:@"修改成功" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
                }];
   
            }
            else if([self.navigationController.childViewControllers[3] isKindOfClass:[GYCardBandingViewController class]])
            {
                
                [UIAlertView showWithTitle:nil message:@"修改成功" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popToViewController:self.navigationController.childViewControllers[3] animated:YES];
                }];
 
            }
            else if ([self.navigationController.childViewControllers[2] isKindOfClass:[GYPersonDetailFileViewController class]])
            {
                
                [UIAlertView showWithTitle:nil message:@"修改成功" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                   [self.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
                }];

            }
           
        }
        else
        {
            [UIAlertView showWithTitle:nil message:@"修改失败" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
              [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
            }];
        
        }
    }];
    
    
}


-(NSMutableArray *)selectFromDB
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    FMResultSet * set = [dataBase executeQuery:@"select * from T_PUB_AREA where parent_id = ?",self.areaIdString ];
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

//
//  GYAddressCountryViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYAddressCountryViewController.h"
#import "GYProvinceViewController.h"
#import "FMDatabase.h"
#import "GYChooseAreaModel.h"
#import "MMLocationManager.h"
#import "PinYinForObjc.h"
#import "GYPersonDetailFileViewController.h"

@interface GYAddressCountryViewController ()

@end

@implementation GYAddressCountryViewController
{

    __weak IBOutlet UITableView *tvCountry;
    
    FMDatabase *dataBase;
    NSString * locatinString;


}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"选择国家";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
   
    switch (self.addressType) {
        case noLocationfunction:
        {
        
        
        }
            break;
        case locationFunction:
        {
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"正在定位..."];
            
            
            [[MMLocationManager shareLocation]getCity:^(NSString *countryString) {
                [Utils hideHudViewWithSuperView:self.view];
                locatinString =countryString  ;
                NSLog(@"%@-----locationstring",locatinString);
                [tvCountry reloadData];
            } error:^(NSError *error) {
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }];

            
        }
            break;
            
        default:
            break;
    }
       [self moveToDBFile];
    
    
      //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        NSLog(@"open db error!");
    }else{
    
        NSLog(@"open db succeed");
    }
    
    self.marrSourceData = [self selectFromDB];
    tvCountry.tableFooterView=[[UIView alloc]init];
  

}

-(void)moveToDBFile
{       //1、获得数据库文件在工程中的路径——源路径。
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
    
    switch (self.addressType) {
        case noLocationfunction:
        {
            return 2;
        
        }
            break;
        case locationFunction:
        {
            return 3;
            
        }
            break;
        default:
            break;
    }
    

}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headerView;
    switch (self.addressType) {
        case noLocationfunction:
        {
        
        
        }
            break;
          
            
        case locationFunction:
        {
            headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            headerView.backgroundColor=kDefaultVCBackgroundColor;
            
            UILabel * lbTitle =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 30)];
            NSString * titleString;
            switch (section) {
                case 0:
                 titleString=@"当前位置";
                 break;
                case 1:
                    titleString=@"全部地区";
                    break;
                default:
                    break;
            }
            lbTitle.text=titleString;
            [headerView addSubview:lbTitle];
            
            
//            return headerView;
            
        }
            break;
        default:
            break;
    }
    
    return headerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    switch (self.addressType) {
        case noLocationfunction:
        {
            CGFloat sectionHeight;
            sectionHeight=20;
            switch (section) {
                case 2:
                    sectionHeight=0;
                    break;
                    
                default:
                    break;
            }
            
            return sectionHeight;
            
        }
            break;
            
            
        case locationFunction:
        {
            CGFloat sectionHeight;
            sectionHeight=30;
            switch (section) {
                case 2:
                    sectionHeight=0;
                    break;
                    
                default:
                    break;
            }
            
            return sectionHeight;
            
        }
            break;
        default:
            break;
    }
    
    return 0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
     NSInteger rows;
    
    switch (self.addressType) {
        case noLocationfunction:
        {
            switch (section) {
                case 0:
                    rows=1;
                    break;
                case 1:
                {
                    rows=self.marrSourceData.count;

                
                }
                default:
                    break;
            }
            
            
        }
            break;
        case locationFunction:
        {
           
            switch (section) {
                case 0:
                    rows=1;
                    break;
                case 1:
                    rows=1;
                    break;
                case 2:
                    rows=self.marrSourceData.count;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    
    return rows;
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
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    switch (self.addressType) {
        case noLocationfunction:
        {
            switch (indexPath.section) {
                case 0:
                {
                    cell.textLabel.text=self.strSelectedArea;
                    UILabel * lbSelect =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
                    lbSelect.font=[UIFont systemFontOfSize:15.0];
                    lbSelect.text=@"已选地区";
                    cell.accessoryView=lbSelect;
                
                }
                    break;
                case 1:
                {
                    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
                    
                    cell.textLabel.text=MOD.areaName;
                    cell.accessoryView=nil;
                    
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
        case locationFunction:
        {
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text=locatinString;
                    break;
                case 1:
                {
                    cell.textLabel.text=self.strSelectedArea;
                    UILabel * lbSelect =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
                    lbSelect.font=[UIFont systemFontOfSize:15.0];
                    lbSelect.text=@"已选地区";
                    cell.accessoryView=lbSelect;
                    
                }
                    
                    break;
                case 2:
                {
                    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
                    
                    cell.textLabel.text=MOD.areaName;
                    cell.accessoryView=nil;
                }
                    break;
                default:
                    break;
            }

        
        
        }
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.addressType) {
        case noLocationfunction:
        {
        
            switch (indexPath.section) {
                case 1:
                {
                    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
                    GYProvinceViewController * vcProvince =[[GYProvinceViewController alloc]initWithNibName:@"GYProvinceViewController" bundle:nil];
                    vcProvince.mstrCountry=[MOD.areaName mutableCopy];
                    
                    vcProvince.areaId=MOD.areaId;
                    vcProvince.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:vcProvince animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }

            
            
        }
            break;
        case locationFunction:
        {
            switch (indexPath.section) {
                    
                case 0:
                {
                  
                    [self saveRequest:locatinString];
                   

                }
                       break; 
                case 2:
                {
                    GYChooseAreaModel * MOD = self.marrSourceData[indexPath.row];
                    GYProvinceViewController * vcProvince =[[GYProvinceViewController alloc]initWithNibName:@"GYProvinceViewController" bundle:nil];
                    vcProvince.mstrCountry=[MOD.areaName mutableCopy];
        
                    vcProvince.areaId=MOD.areaId;
                    vcProvince.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:vcProvince animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }

        
        }
        default:
            break;
    }
    
   
}

//发起网络请求保存地址
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
                [self.navigationController popViewControllerAnimated:YES];
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            }
        else {
        
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];

        
        }
        
    }];
    
    
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

    
        if (_fromBandingCard==1) {
            if (kSystemVersionLessThan(@"8.0")) {
                if ([m.areaName hasPrefix:@"中国"]) {
                    [arr addObject:m];
                    
                }
                
                
            }else
            {
                if ([m.areaName containsString:@"中国"]) {
                    [arr addObject:m];
                }
            
            }
            
           
        }else
        {
        
            if ([m.parentIdstring isEqualToString:@"0"]) {
                
                [arr addObject:m];
            }
        
        }
        
      
    }

 
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects: secondDescriptor, nil];
    
    arr= [[ arr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return arr;
    
}




@end

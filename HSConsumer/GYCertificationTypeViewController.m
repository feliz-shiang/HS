//
//  GYCertificationTypeViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-9.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCertificationTypeViewController.h"
#import "GlobalData.h"
#import "GYCertificationType.h"

@interface GYCertificationTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tvCertificationTable;

@end

@implementation GYCertificationTypeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"选择证件";
    _marrDataSoure =[NSMutableArray array];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
   [insideDict setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
     [dict setValue:insideDict forKey:@"params"];
    
    [dict setValue:@"get_certificate_type" forKeyPath:@"cmd"];
    

    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain  stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        NSDictionary * resopnseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSString * retCode =[NSString stringWithFormat:@"%@",resopnseDict[@"code"]];
        
        if (!error) {
            if ([retCode isEqualToString:@"SVC0000"]) {
                
              
                for (NSDictionary * tempDict in resopnseDict[@"data"][@"cretificateTypeList"])
                {
                    
                   
                    GYCertificationType * model =[[GYCertificationType alloc]init];
                    model.strCretIdstring= kSaftToNSString(tempDict[@"cretypeId"]);
                    model.strCretype=tempDict[@"cretype"];
                    
                    [_marrDataSoure addObject:model];
                }
                [self.tvCertificationTable reloadData];
        }
        }
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _marrDataSoure.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    GYCertificationType * mod =_marrDataSoure[indexPath.row];
    cell.textLabel.text=mod.strCretype;
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    GYCertificationType * mod = _marrDataSoure[indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(sendSelectDataWithMod:)]) {
        [_delegate sendSelectDataWithMod:mod];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


@end

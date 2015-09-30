//
//  GYChooseInfoViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYChooseInfoViewController.h"

@interface GYChooseInfoViewController ()

@end

@implementation GYChooseInfoViewController

{

    __weak IBOutlet UITableView *tvChooseInfoTable;
    BOOL isSelect;
    
    UITableViewCell * oldCell;
    NSString * sexString;


}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title=@"性别";
    
    
    
    _marrDatasource = [@[@"男",@"女"] mutableCopy] ;
    
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultMarginToBounds)];
    
    headerView.backgroundColor=kDefaultVCBackgroundColor;

    
    tvChooseInfoTable.tableHeaderView=headerView;
    
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    
    footerView.backgroundColor=kDefaultVCBackgroundColor;

    tvChooseInfoTable.tableFooterView=footerView;
    
    NSLog(@"%@----sex",self.strSex);
    
    UIView * Background =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    Background.backgroundColor=kDefaultVCBackgroundColor;
    tvChooseInfoTable.backgroundView=Background;
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveRequest) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
  
}

-(void)saveRequest
{
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];

    [insideDict setValue:sexString   forKey:@"sex"];
    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
        NSLog(@"%@--------response",responseDic);
        if ([retCode isEqualToString:@"200"]) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }     
        
    }];


}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDatasource.count;
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
        cell.textLabel.text=_marrDatasource[indexPath.row];
        UIImageView * imgvAccessory =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgvAccessory.image=[UIImage imageNamed:@"cell_btn_tick_green_yes"];
        cell.accessoryView=imgvAccessory;
        cell.accessoryView.hidden=YES;
    }
 
    
        
        switch (indexPath.row) {
            case 0:
            {
                if ([_strSex isEqualToString:@"1"])
                {
                    cell.accessoryView.hidden=NO;
                      oldCell=cell;
                }
                
            }
                break;
            case 1:
            {
                if ([_strSex isEqualToString:@"2"]) {
                cell.accessoryView.hidden=NO;
                      oldCell=cell;
                }
                
           
            }
                break;
            default:
            {
                if ([_strSex isEqualToString:@"3"]) {
                    cell.accessoryView.hidden=YES;
                }
            
            }
                break;
        }
    

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    isSelect=YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isSelect)
    {
        oldCell.accessoryView.hidden=YES;
        cell.accessoryView.hidden=NO;
//        sexString=_marrDatasource[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                sexString=@"1";
                break;
            case 1:
                sexString=@"2";
                break;
            default:
                break;
        }
//        sexString=@"1";
    }
    oldCell=cell;
    
    NSLog(@"%@---------",sexString);
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectSex:)]) {
//        [self.navigationController popViewControllerAnimated:YES];
        [_delegate sendSelectSex:_marrDatasource[indexPath.row]];
    }


}



#pragma mark alertview 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
    
}
@end

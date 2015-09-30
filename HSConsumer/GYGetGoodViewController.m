//
//  GYGetGoodViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGetGoodViewController.h"
#import "GYGetGoodTableViewCell.h"
#import "GYAddressModel.h"
#import "GYAddAddressSroViewController.h"
#import "GlobalData.h"
@interface GYGetGoodViewController ()
{
    NSIndexPath *oldIndex;
    
    UIButton * btnTemp;
    
    GYAddressModel * globalAddressMod;
     GYAddressModel * pushAddressMod;
    
    NSString * goodIdString;
}
@end

@implementation GYGetGoodViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"select_getgood_address");
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //自定义返回按钮
    _marrDataSoure=[NSMutableArray array];
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 44, 44);
    btnRight.backgroundColor=[UIColor clearColor];
    btnRight.titleLabel.font=[UIFont boldSystemFontOfSize:17.0];
    [btnRight addTarget:self action:@selector(ToAddAddress) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitle:@"+" forState:UIControlStateNormal];
    
    //设置右边btn
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _tbvGetGood.backgroundColor=kDefaultVCBackgroundColor;
    _tbvGetGood.separatorStyle=  UITableViewCellSeparatorStyleNone;
    //注册cell
    [_tbvGetGood registerNib:[UINib nibWithNibName:@"GYGetGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //设置header
    UIView * header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,10)];
    header.backgroundColor=kDefaultVCBackgroundColor;
    _tbvGetGood.tableHeaderView=header;
    
    
    //添加footer到tableview
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIButton * btnConfirm =[UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame=CGRectMake(15, 10, 290, 36);
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnConfirm setTitle:kLocalized(@"Set_default_shipping_address")   forState:UIControlStateNormal];
    [btnConfirm addTarget:self action:@selector(setDefaultAddress) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btnConfirm];
    footer.backgroundColor=kDefaultVCBackgroundColor;
    _tbvGetGood.tableFooterView=footer;
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if (_marrDataSoure.count>0) {
        [_marrDataSoure removeAllObjects];
    }
    [self loadDataFromNetwork];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tbvGetGood setEditing:NO];
    
}
#pragma mark  获取收货地址
-(void)loadDataFromNetwork
{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                
                NSString * retcode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
                if ([retcode isEqualToString:@"200"])
                {
                    
                    
                    NSLog(@"%@---------dict",responseDic);
                    for (NSDictionary * temDic in responseDic[@"data"]) {
                        GYAddressModel * model =[[GYAddressModel alloc]init];
                        model.CustomerName=[NSString stringWithFormat:@"%@",temDic[@"consignee"]];
                        model.DetailAddress=[NSString stringWithFormat:@"%@",temDic[@"detail"]];
                        model.Province=[NSString stringWithFormat:@"%@",temDic[@"province"]];
                        model.CustomerPhone=[NSString stringWithFormat:@"%@",temDic[@"mobile"]];
                        model.City=[NSString stringWithFormat:@"%@",temDic[@"city"]];
                        model.Area=[NSString stringWithFormat:@"%@",temDic[@"area"]];
                        model.AddressId=[NSString stringWithFormat:@"%@",temDic[@"id"]];
                        model.BeDefault=[NSString stringWithFormat:@"%@",temDic[@"beDefault"]];
                        model.idString=[NSString stringWithFormat:@"%@",temDic[@"id"]];
                        model.PostCode=kSaftToNSString(temDic[@"postcode"]);
                        model.TelphoneNumber=kSaftToNSString(temDic[@"fixedTelephone"]);
                        [_marrDataSoure addObject:model];
                    }
                    
                    if ([responseDic[@"data"] isKindOfClass:([NSArray   class])]&&![responseDic[@"data"]  count]>0) {
                        
                        _tbvGetGood.tableFooterView.hidden=YES;
                        
                        UIView * background =[[UIView alloc]initWithFrame:_tbvGetGood.frame];
                        UILabel * lbTips =[[UILabel alloc]init];
                        lbTips.center=CGPointMake(160, 60);
                        lbTips.textColor=kCellItemTitleColor;
                        lbTips.backgroundColor =[UIColor clearColor];
                        lbTips.bounds=CGRectMake(0, 0, 290, 40);
                        lbTips.text=@"您还没有收货地址信息，马上完善吧！";
                        [background addSubview:lbTips];
                        _tbvGetGood.backgroundView=background;
               
                        _tbvGetGood.backgroundView.hidden=NO;

                        
                    }
                    else
                    {
                       _tbvGetGood.backgroundView.hidden=YES;
                    
                    }
                    
                    
                }
                
                [_tbvGetGood reloadData];
                
            }
        }
        
    }];
}


-(void)setDefaultAddress
{
    DDLogInfo(@"设置默认地址");
    [self setDefaultAddressRequest];
}


-(void)setDefaultAddressRequest
{
    
    if (!globalAddressMod.AddressId.length>0) {
        
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"请选择默认地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue:globalAddressMod.AddressId forKey:@"id" ];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy//setDefaultDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                
                NSString * retcode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
                if ([retcode isEqualToString:@"200"])
                {
                    if (_marrDataSoure.count>0) {
                        
                        [_marrDataSoure removeAllObjects];
                    }
                    [Utils showMessgeWithTitle:nil message:@"默认地址设置成功！" isPopVC:nil];
                    [self loadDataFromNetwork];
                    
                }else
                {
                 [Utils showMessgeWithTitle:nil message:@"默认地址设置失败！" isPopVC:nil];
                
                }
                
                
                
//                [_tbvGetGood reloadData];
                
                
            }
        }
        
    }];
    
    
    
    
}


-(void)ToAddAddress
{
    GYAddAddressSroViewController * vcAddAddress =[[GYAddAddressSroViewController alloc]initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
    vcAddAddress.boolstr=NO;//添加收货地址传 “0”
    [self.navigationController pushViewController:vcAddAddress animated:YES];
    
}


#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDataSoure.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.f;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    GYGetGoodTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:
                                    cellIdentifer];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (cell==nil) {
        cell=[[GYGetGoodTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        
    }
    cell.senderBtnDelegate=self;
    
    GYAddressModel * model =_marrDataSoure[indexPath.row];
    
    [cell refreshUIWith:model];
    
   
    return cell;
}


#pragma mark tableview didSelect 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYAddressModel * model =_marrDataSoure[indexPath.row];
    
    
    globalAddressMod = model;
    
    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
        [_deletage getAddressModle:model];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        GYAddAddressSroViewController * vcAddAddressModify =[[GYAddAddressSroViewController alloc]initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
        vcAddAddressModify.boolstr=YES;//修改收货地址传 “1”
        vcAddAddressModify.AddModel=model;
        [self.navigationController pushViewController:vcAddAddressModify animated:YES];
        
    }
    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
////删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAddress:_marrDataSoure[indexPath.row]];
        [_marrDataSoure removeObjectAtIndex:indexPath.row];
        [self.tbvGetGood deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
    
}


-(void)setOldCellBtnStatus:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath

{
    GYGetGoodTableViewCell *oldCell = (GYGetGoodTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                 oldIndex];
    oldCell.btnChooseDefaultAddress.selected=NO;
    oldIndex= indexPath;
    
}


//代理方法，用于接受 从cell传过来的button
-(void)senderBtn:(id)sender WithCellModel:(id)mod
{
    globalAddressMod = mod;
//       [_tbvGetGood reloadData];
 //   btnTemp.selected=NO;
    btnTemp=sender;
 //   btnTemp.selected=YES;
    globalAddressMod =(GYAddressModel *)mod;
    
    //add by zhangqy
    for (int i=0; i<self.marrDataSoure.count; i++) {
        GYAddressModel * model =_marrDataSoure[i];
        model.BeDefault = @"0";
        if (model == globalAddressMod) {
            model.BeDefault = @"1";
        }
    }
    
    if (_deletage && [_deletage respondsToSelector:@selector(getAddressModle:)]) {
        [_deletage getAddressModle:mod];
     //   [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        GYAddAddressSroViewController * vcAddAddressModify =[[GYAddAddressSroViewController alloc]initWithNibName:@"GYAddAddressSroViewController" bundle:nil];
        vcAddAddressModify.boolstr=YES;//修改收货地址传 “1”
        vcAddAddressModify.AddModel=mod;
        [self.navigationController pushViewController:vcAddAddressModify animated:YES];
        
    }
    
    [_tbvGetGood reloadData];
    
 
}

-(void)deleteAddress:(GYAddressModel*)model
{
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [ dict setValue:[GlobalData shareInstance].ecKey forKey:@"key" ];
    [ dict setValue: model.AddressId forKey:@"id" ];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/deleteDeliveryAddress"] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSLog(@"%@--------dict",responseDic);
                
                [UIAlertView showWithTitle:nil message:@"删除地址成功！" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
                
                
            }
        }
        
    }];
    
    
}


@end

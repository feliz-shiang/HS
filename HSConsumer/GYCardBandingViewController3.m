//
//  GYCardBandingViewController3.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCardBandingViewController3.h"
#import "GYCardBandTableViewCell.h"


#import "GYCardBandingViewController.h"
#import "GYDefaultCardViewController.h"
#import "GYDeleteCardViewController.h"
#import "GlobalData.h"
#import "GYChooseAreaModel.h"
#import "UIButton+enLargedRect.h"
#import "GYRealNameAuthViewController.h"
#import "GYNameBandingViewController.h"
#import "GYRealNameRegisterViewController.h"
@interface GYCardBandingViewController3 ()

@end

@implementation GYCardBandingViewController3
{
    NSString * provinceString;
    FMDatabase * dataBase;
    GlobalData * data;
    NSDictionary * bankDict ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"bank_card_binding");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _marrDatasoure=[NSMutableArray array];
   
    data =[GlobalData shareInstance];
    
    bankDict = [data getDictionaryOfBank];
    //设置VC的背景色
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    //设置tableview的背景色
    UIView * tableviewBackground =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    tableviewBackground.backgroundColor=kDefaultVCBackgroundColor;
    _tbvCardBanding.backgroundView=tableviewBackground;
    
    //修改导航栏右边按钮
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 40, 40);
    btnRight.titleLabel.font=[UIFont systemFontOfSize:17.0];
    [btnRight setTitle:kLocalized(@"add") forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(addCardBanding) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self moveToDBFile];
    
    //注册cell
    [_tbvCardBanding registerNib:[UINib nibWithNibName:@"GYCardBandTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //tableview 的headerview  用于设置顶部的16像素。
    UIView * header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,10)];
    header.backgroundColor=kDefaultVCBackgroundColor;
    _tbvCardBanding.tableHeaderView=header;
    //不要分割线
    _tbvCardBanding.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    //设置FOOTER，没有内容的Cell 不显示。
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    footer.backgroundColor=kDefaultVCBackgroundColor;
    _tbvCardBanding.tableFooterView=footer;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.marrDatasoure.count>0) {
        [self.marrDatasoure removeAllObjects];
        
    }
    if (bankDict)
    {
        [self loadDataFromNetwork];
    }
}

-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:@"get_bind_banks" forKey:@"cmd"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    
    
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
           [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            NSLog(@"%@----",error);
         
        }else{
            
           
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@-----responsedic",ResponseDic);
            
            if (!error) {
                
                NSString * retCode = kSaftToNSString(ResponseDic[@"data"][@"resultCode"]);
                
                if ([retCode isEqualToString:@"0"]) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray * arrData =[[ResponseDic objectForKey:@"data"] objectForKey:@"bankList"];
                        
                        
                        
                        
                        for (NSDictionary * dict in arrData) {
                            GYCardBandModel * model1 =[[GYCardBandModel alloc]init];
                            model1.strCustId=[dict objectForKey:@"custId"];
                            model1.strBankCode=[dict objectForKey:@"bankCode"];
                            
                            //遍历通过 银行code  获取到 银行名称
                            for (NSDictionary * tempDic in bankDict[@"data"][@"bankList"])
                            {
                                
                                GYBankListModel * model =[[GYBankListModel alloc]init];
                                model.strBankCode=tempDic[@"bankCode"];
                                
                                if ([model1.strBankCode isEqualToString:tempDic[@"bankCode"]]) {
                                    model1.strBankName=tempDic[@"bankName"];
                                    break ;
                                }
                                
                            }
                            
                            
                            model1.strAcctType=[dict objectForKey:@"acctType"];
                            model1.strCityName=[dict objectForKey:@"cityName"];
                            model1.strCustResNo=[dict objectForKey:@"custResNo"];
                            //是否是默认银行卡
                            if ([[dict objectForKey:@"defaultFlag"] isEqualToString:@"Y"]) {
                                model1.strDefaultFlag=YES;
                            }else{
                                model1.strDefaultFlag=NO;
                                
                            }
                            
                            model1.strCustResType=[dict objectForKey:@"custResType"];
                            model1.strBankAcctId=[dict objectForKey:@"bankAcctId"];
                            model1.strBankAreaNo=[dict objectForKey:@"bankAreaNo"];
                            model1.strBankAcctName=[dict objectForKey:@"bankAcctName"];
                            model1.strBankAccount=[dict objectForKey:@"bankAccount"];
                            
                            //加***号
                            NSString * account;
                            
                            if ( model1.strBankAccount.length>=16) {
                                account = [NSString stringWithFormat:@"%@ **** **** %@",[model1.strBankAccount substringToIndex:4],[model1.strBankAccount substringFromIndex:(model1.strBankAccount.length-4)]];
                            }
                            model1.strTempAccount=account;
                            model1.strBankBranch=[dict objectForKey:@"bankBranch"];
                            provinceString =[dict objectForKey:@"provinceCode"];
                            model1.strProvinceCode=[self selectFromDB].areaName;
                            
                            if ([[dict objectForKey:@"usedFlag"] isEqualToString:@"N"]) {
                                model1.strUsedFlag=NO;
                            }else{
                                model1.strUsedFlag=YES;
                            }
                            
                            [_marrDatasoure addObject:model1];
                            
                        }
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (arrData.count) {
//                                self.tbvCardBanding.backgroundView.hidden=YES;
                                self.tbvCardBanding.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                            }else
                            {
                                // modify by songjk
//                                self.tbvCardBanding.backgroundView.hidden=NO;
                                UIView * background =[[UIView alloc]initWithFrame:self.tbvCardBanding.frame];
                                
                                CGFloat maxW = background.frame.size.width;
                                CGFloat imgW = 52;
                                CGFloat imgH = 59;
                                CGFloat imgX = (maxW - imgW)*0.5;
                                CGFloat imgY = 40;
                                UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                                imgvNoResult.frame=CGRectMake(imgX, imgY, imgW, imgH);
                                [background addSubview:imgvNoResult];
                                
                                CGFloat lbTipW = 270;
                                CGFloat lbTipH = 40;
                                CGFloat lbTipX = (maxW - lbTipW)*0.5;
                                CGFloat lbTipY = CGRectGetMaxY(imgvNoResult.frame) +20;
                                UILabel * lbTips =[[UILabel alloc]init];
                                lbTips.textColor=kCellItemTitleColor;
                                lbTips.textAlignment=UITextAlignmentCenter;
                                lbTips.font=[UIFont systemFontOfSize:15.0];
                                lbTips.backgroundColor =[UIColor clearColor];
                                lbTips.frame=CGRectMake(lbTipX, lbTipY, lbTipW, lbTipH);
                                lbTips.text=@"您没有实名注册，请先进行实名注册!";
                                [background addSubview:lbTips];
                                
                                CGFloat btnToNameBandingW = 80;
                                CGFloat btnToNameBandingH = 30;
                                CGFloat btnToNameBandingX = (maxW - btnToNameBandingW)*0.5;
                                CGFloat btnToNameBandingY = CGRectGetMaxY(lbTips.frame) +20;
                                UIButton * btnToNameBanding =[UIButton buttonWithType:UIButtonTypeCustom];
                                [btnToNameBanding setTitle:@"实名注册" forState:UIControlStateNormal];
                                btnToNameBanding.titleLabel.font=[UIFont systemFontOfSize:15];
                                [btnToNameBanding setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
                                btnToNameBanding.frame=CGRectMake(btnToNameBandingX, btnToNameBandingY, btnToNameBandingW, btnToNameBandingH);
                                [btnToNameBanding setBorderWithWidth:1 andRadius:2 andColor:kDefaultViewBorderColor];
                                [btnToNameBanding addTarget:self action:@selector(gotoNameReg) forControlEvents:UIControlEventTouchUpInside];
                                [background addSubview:btnToNameBanding];
                                
//                                UILabel * lbTips =[[UILabel alloc]init];
//                                lbTips.center=CGPointMake(160, 160);
//                                lbTips.textColor=kCellItemTitleColor;
//                                lbTips.textAlignment=UITextAlignmentCenter;
//                                lbTips.font=[UIFont systemFontOfSize:15.0];
//                                lbTips.backgroundColor =[UIColor clearColor];
//                                lbTips.bounds=CGRectMake(0, 0, 270, 40);
//                                lbTips.text=@"您没有实名注册，请先进行实名注册!";
//                                
//                                
//                               
//                                UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
//                                imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
//                                imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
//                                [background addSubview:imgvNoResult];
//                                UIButton * btnToNameBanding =[UIButton buttonWithType:UIButtonTypeCustom];
//                                [btnToNameBanding setTitle:@"实名注册" forState:UIControlStateNormal];
//                                btnToNameBanding.titleLabel.font=[UIFont systemFontOfSize:15];
//                                [btnToNameBanding setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
////                                btnToNameBanding.backgroundColor=[UIColor redColor];
//                                 btnToNameBanding.center=CGPointMake(160, 200);
//                                btnToNameBanding.bounds=CGRectMake(0, 0, 80, 30);
//                                [btnToNameBanding setBorderWithWidth:1 andRadius:2 andColor:kDefaultViewBorderColor];
//                                [btnToNameBanding addTarget:self action:@selector(gotoNameReg) forControlEvents:UIControlEventTouchUpInside];
//                                [background addSubview:lbTips];
//                                [background addSubview:btnToNameBanding];
                                
                                NSLog(@"%d----",data.user.isRealName);
                                if ([GlobalData shareInstance].user.userName && [GlobalData shareInstance].user.userName.length>0) {
                                    btnToNameBanding.hidden=YES;
                                    lbTips.text=@"暂无银行卡信息，请绑定银行卡！";
                               
                                }else
                                {
                                    UIView * v =[[UIView alloc]init];
                                    v.frame=CGRectZero;
                                    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:v];
                                }
                                
                                self.tbvCardBanding.scrollEnabled=NO;
//                                self.tbvCardBanding.backgroundView=background;
                                self.tbvCardBanding.tableFooterView = background;
                                
                            }
                            [self.tbvCardBanding reloadData];
                        
                        });

                    
                    });
                    

                }
                
                
            }
            
        
         
            
        }
        
    }];
    
}

//-(void)gotoNameBanding
//{
//    GYNameBandingViewController *vcNameAuth = [[GYNameBandingViewController alloc]initWithNibName:@"GYNameBandingViewController" bundle:nil];
//    vcNameAuth.title=@"实名绑定";
//    [self.navigationController pushViewController:vcNameAuth animated:YES];
//
//}
// add by songjk 实名注册
-(void)gotoNameReg
{
    GYRealNameRegisterViewController *vcNameAuth = [[GYRealNameRegisterViewController alloc]initWithNibName:@"GYRealNameRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vcNameAuth animated:YES];
}
-(void)moveToDBFile
{
    //1、获得数据库文件在工程中的路径——源路径。
    NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"T_PUB_AREA"ofType:@"db"];
    
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];
    
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


-(GYChooseAreaModel *)selectFromDB
{
    GYChooseAreaModel * model;
    
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
        
        if ([m.areaNo isEqualToString:provinceString]) {
            
            model=m;
        }
        
        
    }
    return model;
    
}

-(void)addCardBanding
{
    GYCardBandingViewController * vcCardBanding =[[GYCardBandingViewController alloc]initWithNibName:@"GYCardBandingViewController" bundle:nil];
    [self.navigationController pushViewController:vcCardBanding animated:YES];
    
    
}


#pragma mark DataSourceDelegate

//有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDatasoure.count;
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}


//cell的具体内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    GYCardBandTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[GYCardBandTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.contentView.backgroundColor=kDefaultVCBackgroundColor;
    }
    //去除model里面的数据，通过Cell显示。
    cell.btnQuitBanding.tag=indexPath.row;
    [cell.btnQuitBanding addTarget:self action:@selector(gotoQuitBanding:) forControlEvents:UIControlEventTouchUpInside];
    GYCardBandModel * model = self.marrDatasoure[indexPath.row];
    [cell refreshUIWith:model];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYCardBandModel * model =_marrDatasoure[indexPath.row];
    
    if (_isSelectBankList) {
        if (_delegate &&[_delegate respondsToSelector:@selector(sendSelectBankModel:)]) {
            [_delegate sendSelectBankModel:model ];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        GYDefaultCardViewController * vcDefaultCard =[[GYDefaultCardViewController alloc]initWithNibName:@"GYDefaultCardViewController" bundle:nil];
        vcDefaultCard.model=model;
        
        [self.navigationController pushViewController:vcDefaultCard animated:YES];
        
    }
    
}


//push到另外一个页面
-(void)gotoQuitBanding:(UIButton *)sender
{

    GYDeleteCardViewController * vcQuitBanding =[[GYDeleteCardViewController  alloc]initWithNibName:@"GYDeleteCardViewController" bundle:nil];
    vcQuitBanding.model=self.marrDatasoure[sender.tag];
    [self.navigationController pushViewController:vcQuitBanding animated:YES];
    
}


@end

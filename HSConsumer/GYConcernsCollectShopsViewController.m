//
//  GYConcernsCollectShopsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYConcernsCollectShopsViewController.h"
#import "MJRefresh.h"
#import "CellShopCell.h"
#import "GYEasyBuyModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+CustomBorder.h"
#import "GYShopDetailViewController.h"
#import "ViewTipBkgView.h"

#import "GYStoreDetailViewController.h"

@interface GYConcernsCollectShopsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ViewTipBkgView *viewTipBkg;
}
@end

@implementation GYConcernsCollectShopsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    [viewTipBkg.lbTip setText:kLocalized(@"您还没有关注的记录哦~")];
    [self.view addSubview:viewTipBkg];
    viewTipBkg.hidden = YES;

    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellShopCell class]) bundle:kDefaultBundle]
          forCellReuseIdentifier:kCellShopCellIdentifier];

    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    CGRect hfFrame = self.tableView.bounds;
    hfFrame.size.height = kDefaultMarginToBounds;
    UIView *vHeader = [[UIView alloc] initWithFrame:hfFrame];
    [vHeader setBackgroundColor:self.view.backgroundColor];
    [vHeader addBottomBorder];
    self.tableView.tableHeaderView = vHeader;
    
    hfFrame.size.height = 30;
    UIView *vFooter = [[UIView alloc] initWithFrame:hfFrame];
    [vFooter setBackgroundColor:self.view.backgroundColor];
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        [vFooter addTopBorder];
    self.tableView.tableFooterView = vFooter;
    
    [self getConcernsCollectShopListIsAppendResult:NO andShowHUD:YES];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CellShopCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellShopCellIdentifier];
    if (!cell)
    {
        cell = [[CellShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellShopCellIdentifier];
    }
    ShopModel *shop = self.arrResult[row];
    cell.lbShopName.text = shop.strTitle;
    cell.lbShopScope.text = [NSString stringWithFormat:@"经营范围：%@", shop.strScope];
    cell.lbShopConcernTime.text = [NSString stringWithFormat:@"关注时间：%@", shop.strConcernTime];
    NSString *imgUrl = shop.strShopPictureURL;
    [cell.ivShopImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopModel *shop = self.arrResult[indexPath.row];
//    GYShopDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYShopDetailViewController class]));
//    ;
//    vc.ShopID = shop.strShopId;
//    vc.fromEasyBuy = 1;
//    [self pushVC:vc animated:YES];
    GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
    ShopModel  * model = [[ShopModel alloc] init];
    model.strVshopId = shop.strShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVC:vc animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)//删除
//    {
//        [self.arrResult removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kLocalized(@"ep_delete");
//}

//可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self concernShopRequest:indexPath];
        //数据请求成功后，再删除tableView的数据
    }
}

#pragma mark- 删除服务器上的收藏数据
-(void)concernShopRequest:(NSIndexPath *)indexPath
{
    
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
        
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    ShopModel *model=self.arrResult[indexPath.row];

    [dict setValue:[NSString stringWithFormat:@"%@",model.strShopId] forKey:@"vShopId"];
    [dict setValue:model.strShopId forKey:@"shopId"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
     
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/cancelConcernShop" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.navigationController.view];
        if (!error)
        {
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                
            if (!error)
            {
                    
                NSString * retCode =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"])
                {
                    //请求成功再删除tableView的数据
                    [self.arrResult removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //设置菜单角标
                    NSString *shop;
                    if (self.arrResult.count!=0) {
                        shop=[NSString stringWithFormat:@"商铺(%lu)",self.arrResult.count];
                    }
                    else
                    {
                        shop=@"商铺";
                        viewTipBkg.hidden=NO;
                    }
                    
                    
                    if(self.block)
                    {
                        self.block(1,shop);
                    }
                    else
                    {
                        
                    }

                    
                    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"取消关注商铺成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
                        
                }
                else
                {
                    
                    [Utils showMessgeWithTitle:nil message:@"取消关注失败！" isPopVC:nil];
                }
                    
            }
                
        }
            
        }];
    
    
    


}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLocalized(@"cancel_collection");
}


#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav)
    {
        [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
        [self.nav pushViewController:vc animated:ani];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getConcernsCollectShopListIsAppendResult:NO andShowHUD:NO];
}

- (void)getConcernsCollectShopListIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey};
    
    MBProgressHUD *hud = nil;
    if (isShow)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.nav.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        [self.nav.view addSubview:hud];
        //    hud.labelText = @"初始化数据...";
        [hud show:YES];
    }
    
    [Network  HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getMyConcernShop"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error){
        
        if (!append)
        {
            self.arrResult = [NSMutableArray array];
        }
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            //            DDLogInfo(@"get_integral_act_trade_list dic:%@", dic);
            
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSArray *arrItems = dic[@"data"];
                    ShopModel *model = nil;
                    for (NSDictionary *dicItem in arrItems)
                    {
                        model = [[ShopModel alloc] init];
                        model.strShopName = kSaftToNSString(dicItem[@"shopName"]);
                        model.strShopId = kSaftToNSString(dicItem[@"id"]);
                        model.strShopPictureURL = kSaftToNSString(dicItem[@"url"]);
                        model.strScope = kSaftToNSString(dicItem[@"scope"]);
                        model.strConcernTime = kSaftToNSString(dicItem[@"createTime"]);
                        model.strTitle = kSaftToNSString(dicItem[@"title"]);
                       
                        
                        [self.arrResult addObject:model];
                    }
                    
                }else//返回失败数据
                {
//                    [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
                }
            }else
            {
//                [Utils alertViewOKbuttonWithTitle:nil message:@"查询失败"];
            }
            
        }else
        {
//            [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.arrResult isKindOfClass:[NSNull class]])
            {
                self.arrResult = nil;
            }
            self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            viewTipBkg.hidden = !self.tableView.hidden;
            NSString *title = kLocalized(@"ep_delete_collect_shop");
            if (!self.tableView.hidden)
            {
                title = [NSString stringWithFormat:@"%@(%zd)", kLocalized(@"ep_delete_collect_shop"), self.arrResult.count];
            }
            if (self.btnMenu)
            {
                [self.btnMenu setTitle:title forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
            if (hud.superview)
            {
                [hud removeFromSuperview];
            }
        });
    }];
}

@end

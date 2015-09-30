//
//  GYWealCheckViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询类

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

#import "GYWealCheckViewController.h"
#import "DropDownListView.h"
#import "WealCheckCell.h"
#import "UIView+CustomBorder.h"
#import "CheckModel.h"
#import "GYWealCheckDetailVC.h"


@interface GYWealCheckViewController ()<UITableViewDataSource,
UITableViewDelegate, DropDownListViewDelegate>
{
    IBOutlet UILabel *lbLabelSelectLeft;    //显示左边选中的菜单
    IBOutlet UILabel *lbLabelSelectRight;   //显示右边选中的菜单
    
    IBOutlet UIView *ivSelectorBackgroundView;//菜单背景
    IBOutlet UIView *ivMenuSeparator;   //菜单分隔列
    
    IBOutlet UIButton *btnMenuLeft; //左边菜单箭头
    IBOutlet UIButton *btnMenuRight;//右边菜单箭头
    
    DropDownListView *selectorLeft; //左边弹出菜单
    DropDownListView *selectorRight;//右边弹出菜单
    
    IBOutlet UILabel *lbLabelNoResult;//无查询结果
    
    

}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GYWealCheckViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrQueryResult = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kLocalized(@"weal_check");
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    [ivSelectorBackgroundView addTopBorder];
    [ivSelectorBackgroundView addBottomBorder];

    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(160, 160, 160, 1)];
    
    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];
    
    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WealCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
    
    
    //设置下拉菜单单击事件
    UITapGestureRecognizer *singleTapRecognizerLeft = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerLeft.numberOfTapsRequired = 1;
    [singleTapRecognizerLeft addTarget:self action:@selector(selectorLeftClick:)];
    lbLabelSelectLeft.userInteractionEnabled = YES;
    [lbLabelSelectLeft addGestureRecognizer:singleTapRecognizerLeft];
    
    UITapGestureRecognizer *singleTapRecognizerRight = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerRight.numberOfTapsRequired = 1;
    [singleTapRecognizerRight addTarget:self action:@selector(selectorRightClick:)];
    lbLabelSelectRight.userInteractionEnabled = YES;
    [lbLabelSelectRight addGestureRecognizer:singleTapRecognizerRight];
    
    //设置下拉菜单项
    if (!arrLeftDropMenu)//用于测试
    {
        arrLeftDropMenu = @[
//                            @"全部",
                            @"互生医疗补贴计划",
                            @"互生意外伤害保障",
                            @"代他人申请身故保障金"
                            ];
    }
    if (!arrRightDropMenu)//用于测试
    {
        arrRightDropMenu = @[
//                             @"全部",
                             @"受理成功",
                             @"受理中",
                             @"驳回"
                             ];
    }
    
    CGRect rFrameLeft = lbLabelSelectLeft.frame;
    rFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft = [[DropDownListView alloc] initWithArray:arrLeftDropMenu parentView:self.view widthSenderFrame:rFrameLeft];
    //设置初始值
    selectorLeft.selectedIndex = 0;
    lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
    selectorLeft.isHideBackground = NO;
    selectorLeft.delegate = self;
    
    CGRect rFrameRight = lbLabelSelectRight.frame;
    rFrameRight.origin.x = CGRectGetMaxX(ivMenuSeparator.frame);
    rFrameRight.size.width = rFrameLeft.size.width;
    selectorRight = [[DropDownListView alloc] initWithArray:arrRightDropMenu parentView:self.view widthSenderFrame:rFrameRight];
    //设置初始值
    selectorRight.selectedIndex = 0;
    lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
    selectorRight.isHideBackground = NO;
    selectorRight.delegate = self;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.arrQueryResult.count > 0) {
        
    }else{
        [self queryWithLeftMenuIndex:0 rightMenuIndex:0];
    }
    
    
    
}


#pragma mark - 查询动作

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    
    [self.arrQueryResult removeAllObjects];
    DDLogDebug(@"【明细查询】 条件【%@】【%@】 正在查询，请稍后...", self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex]);
    
    NSString *status;
    
    NSString *appType;
    
//    if (rIndex == 0) {
//        status = @"0000";
//    }
    // modify by songjk
    if (rIndex == 0) {
        status = @"Y";
//        status = @"W";
    }
    if (rIndex == 1) {
        status = @"W";
//        status = @"Y";
    }
    if (rIndex == 2) {
        status = @"N";
    }
    
//    if (lIndex == 0) {
//        
//        [self getNetDataCheckMedical:status];
//        appType = @"0000";
//        [self getNetDataCheckAccident:status :appType];
//    }
    if (lIndex == 0) {
        [self getNetDataCheckMedical:status];
        appType = @"0000";
    }
    if (lIndex == 1) {
        appType = @"2";
        [self getNetDataCheckAccident:status :appType];
    }
    if (lIndex == 2) {
        
        appType = @"1";
        [self getNetDataCheckAccident:status :appType];
    }
    
}

#pragma mark - 单击下拉菜单

- (void)selectorLeftClick:(UITapGestureRecognizer *)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if(selectorRight.isShow)
    {
        [selectorRight hideExtendedChooseView];
        btnMenuRight.transform = transform;
    }
    
    if(selectorLeft.isShow)
    {
        [selectorLeft hideExtendedChooseView];
    }else
    {
        [selectorLeft showChooseListView];
        transform = CGAffineTransformRotate(btnMenuLeft.transform, DEGREES_TO_RADIANS(180));
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        btnMenuLeft.transform = transform;
    }];
}

- (void)selectorRightClick:(UITapGestureRecognizer *)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if(selectorLeft.isShow)
    {
        [selectorLeft hideExtendedChooseView];
        btnMenuLeft.transform = transform;
    }
    
    if(selectorRight.isShow)
    {
        [selectorRight hideExtendedChooseView];
    }else{
        [selectorRight showChooseListView];
        transform = CGAffineTransformRotate(btnMenuRight.transform, DEGREES_TO_RADIANS(180));
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        btnMenuRight.transform = transform;
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQueryResult.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   WealCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    CheckModel *model = arrQueryResult[indexPath.row];
    
    cell.row1R.text = model.applyNo;
    cell.row2R.text = model.applyDate;
    cell.row3R.text = model.applyType;
    
    if ([model.status isEqualToString:@"W"]) {
        cell.row4R.text = @"受理中";
    }
    if ([model.status isEqualToString:@"Y"]) {
        cell.row4R.text = @"受理成功";

    }
    if ([model.status isEqualToString:@"N"]) {
        cell.row4R.text = @"驳回";
    }
    cell.row5R.text = model.amount;
   
    /*
     model.applyDate = dic[@"applyDate"];
     model.applyNo = dic[@"applyNo"];
     model.applyType = @"互生医疗补贴计划";
     model.amount = dic[@"amount"];
     model.status = dic[@"status"];
     */
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckModel *model = self.arrQueryResult[indexPath.row];
    GYWealCheckDetailVC *vc = [[GYWealCheckDetailVC alloc] init];
    vc.detailType = model.detailType;
    if (model.detailType == 0) {
        vc.medicalId = model.medicalId;
    }
    if (model.detailType == 1) {
        vc.applyId = model.applyId;
    }
    if (model.detailType == 2) {
        vc.applyId = model.applyId;
        
    }
    vc.navigationItem.title = model.applyType;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - DropDownListViewDelegate

- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender
{
    
    if (sender == selectorLeft)
    {
        if (isChange)//只有选择不同的条件才执行操作
        {
            lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
        }
        [self selectorLeftClick:nil];
    }else if (sender == selectorRight)
    {
        if (isChange)//只有选择不同的条件才执行操作
        {
            lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
        }
        [self selectorRightClick:nil];
    }
    if (isChange)
    {
        [self queryWithLeftMenuIndex:selectorLeft.selectedIndex rightMenuIndex:selectorRight.selectedIndex];
    }
}

-(void)getNetDataCheckMedical:(NSString *)status
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    if (![status isEqualToString:@"0000"]) {
        [dictInside setValue:status forKey:@"status"];
    }
    
    [dictInside setValue:@"1" forKey:@"pageNo"];
    [dictInside setValue:@"100" forKey:@"pageSize"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    //请求对应url的运行cmd
    [dict setValue:@"get_integral_welfare_for_free_medical_list" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"ResponseDic === %@",ResponseDic);
            
            
            if ([ResponseDic[@"code"] isEqualToString:@"SVC0000"]) {
                for (NSDictionary *dic in ResponseDic[@"data"][@"integralWelfareForFreeMedicalList"]) {
                    
                    NSLog(@"dic = %@",dic);
                    CheckModel *model = [[CheckModel alloc] init];
                    
                    NSTimeInterval ti = [kSaftToNSString(dic[@"applyDate"]) doubleValue] / 1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
                    NSString *strValue = [Utils dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    model.applyDate = strValue;
                    
                    model.applyNo = [NSString stringWithFormat:@"%@",dic[@"applyNo"]];
                    model.applyType = [NSString stringWithFormat:@"%@",@"互生医疗补贴计划"];
                    model.detailType = 0;
                    model.amount = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                    model.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    model.medicalId = [NSString stringWithFormat:@"%@",dic[@"medicalId"]];
                    [self.arrQueryResult addObject:model];
                }
                
                
                [self.tableView reloadData];
                
                
            }else{
                
                
            }
            //网络请求回调后弹窗
            
            [Utils hideHudViewWithSuperView:self.view.window];
        }
    }];
}


-(void)getNetDataCheckAccident:(NSString *)status :(NSString *)appType
{
//    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    if (![status isEqualToString:@"0000"]) {
        [dictInside setValue:status forKey:@"status"];
    }
    if (![appType isEqualToString:@"0000"]) {
        [dictInside setValue:appType forKey:@"appType"];
    }
    
    
    [dictInside setValue:@"1" forKey:@"pageNo"];
    [dictInside setValue:@"100" forKey:@"pageSize"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    //请求对应url的运行cmd
    [dict setValue:@"get_integral_welfare_for_free_accident_insurance_and_dead_insurance_list" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"ResponseDic === %@",ResponseDic);
            
            
            if ([ResponseDic[@"code"] isEqualToString:@"SVC0000"]) {
                for (NSDictionary *dic in ResponseDic[@"data"][@"IntegralWelfareForFreeAccidentInsuranceAndDeadInsuranceList"]) {
                    
                    NSLog(@"dic = %@",dic);
                    CheckModel *model = [[CheckModel alloc] init];
                    // add by songjk
                    NSTimeInterval ti = [kSaftToNSString(dic[@"applyDate"]) doubleValue] / 1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
                    NSString *strValue = [Utils dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    model.applyDate = strValue;
                    model.applyNo = [NSString stringWithFormat:@"%@",dic[@"applyNo"]];
                    model.applyId = [NSString stringWithFormat:@"%@",dic[@"applyId"]];
                    
                    
                    NSString *temp = [NSString stringWithFormat:@"%@",dic[@"applyType"]];
                    if ([temp isEqualToString:@"2"]) {
                        model.applyType = @"互生意外伤害保障";
                        model.detailType = 1;
                    }
                    if ([temp isEqualToString:@"1"]) {
                        model.applyType = @"代申请身故保障金";
                        model.detailType = 2;
                    }
                    
                    
                    model.amount = [NSString stringWithFormat:@"%@",dic[@"appAmount"]];
                    model.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    model.medicalId = [NSString stringWithFormat:@"%@",dic[@"medicalId"]];
                    
                    if (![appType isEqualToString:@"0000"]) {
                        if ([appType isEqualToString:temp]) {
                            [self.arrQueryResult addObject:model];
                        }
                    }else{
                        [self.arrQueryResult addObject:model];
                    }
                    
                    
                    
                }
                
                
                    [self.tableView reloadData];
                
                
            }else{
                
                
            }
            //网络请求回调后弹窗
            
//            [Utils hideHudViewWithSuperView:self.view.window];
        }
    }];
}

@end

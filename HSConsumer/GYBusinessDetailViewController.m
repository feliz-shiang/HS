//
//  GYBusinessDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询类

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

#import "GYBusinessDetailViewController.h"
#import "DropDownListView.h"
#import "GYCheckCell.h"
#import "CheckModel.h"
#import "GYAgainConfirmViewController.h"


@interface GYBusinessDetailViewController ()<UITableViewDataSource,
UITableViewDelegate, DropDownListViewDelegate,GYCheckCellDelegate>
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
    
    NSMutableArray *mArrData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GYBusinessDetailViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;



- (void)viewDidLoad
{
    [super viewDidLoad];
    mArrData = [[NSMutableArray alloc] init];
    self.title = @"业务办理查询";
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [Utils setBorderWithView:ivSelectorBackgroundView WithWidth:1.0f WithRadius:0 WithColor:kDefaultViewBorderColor];
    
    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(160, 160, 160, 1)];
    
    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];
    
    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GYCheckCell" bundle:kDefaultBundle] forCellReuseIdentifier:@"CELL"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //    [self.tableView setBackgroundView:nil];
    //    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //    self.tableView.hidden = YES;
    
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
        arrLeftDropMenu = @[@"互生卡挂失"
                            ,@"互生卡解挂"
                            ,@"互生卡补办"
//                            ,@"消息通知服务办理"
                            ];
    }
    if (!arrRightDropMenu)//用于测试
    {
        arrRightDropMenu = @[@"最近一月"
                             ,@"最近三月"
                             ,@"最近半年"
                             ,@"最近一年"
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
    
    //设置显示测试结果
    self.arrQueryResult = [NSMutableArray array];
    
}



#pragma mark - 查询动作

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self queryWithLeftMenuIndex:0 rightMenuIndex:0];
}

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    DDLogDebug(@"【明细查询】 条件【%@】【%@】 正在查询，请稍后...", self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex]);
    
    NSLog(@"%d ***  %d",lIndex,rIndex);
    NSString *time;
    //获取时间
    time = [self getTime:rIndex];
    
    if (lIndex  == 0 || lIndex == 1) {
        NSString *type;
        if (lIndex == 0) {
            type = @"3";
        }
        
        if (lIndex == 1) {
            type = @"4";
        }
        
        
        [self getNetDataCheckLose:type :time];
        
    }
    
    
    if (lIndex == 2) {
        
        [self getNetDataCheckRepair:time];
    }
    
    
    if (lIndex == 3) {
        
        [self getNetDataCheckMSN];
        
    }
    
    
    [self.tableView reloadData];
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
    CheckModel *modelCell =self.arrQueryResult[indexPath.row];
    
//    if ([model.strRow3R isEqualToString:@"处理成功"]) {
//        return 78;
//    }else{
//        return 128;
//    }

    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    GYCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    CheckModel *cellModel = self.arrQueryResult[indexPath.row];
    
    if ([cellModel.type integerValue] == 3) {
        cell.lbRow1L.text = @"互生卡挂失";
        
    }
    if ([cellModel.type integerValue] == 4) {
        cell.lbRow1L.text = @"互生卡解挂";
        
    }
    
    cell.lbRow1R.text = cellModel.created;
    cell.lbRow2L.text = @"业务流水号";
    cell.lbRow2R.text = cellModel.serialNo;
    cell.lbRow3L.text = @"业务受理结果";
    
    if ([cellModel.status integerValue] == 1) {
        
        cell.lbRow3R.text = @"处理成功";
        cell.lbRow3R.textColor = [UIColor greenColor];

    }else{
        cell.lbRow3R.text = @"处理失败";
        cell.lbRow3R.textColor = cell.lbRow3L.textColor;
    }
    cell.lbRow4L.hidden = YES;
    cell.lbRow4R.hidden = YES;
    cell.lbRow5L.hidden = YES;
    cell.lbRow5R.hidden = YES;
    cell.btnRow4R.hidden = YES;
    
    /*
     @property (nonatomic , copy) NSString *created;//创建日期
     @property (nonatomi;c , copy) NSString *serialNo;//业务流水号
     @property (nonatomic , copy) NSString *status;//业务受理结果 1 成功 2失败
     @property (nonatomic , copy) NSString *type; //业务类型 1-实名绑定、2实名注册、3-挂失、4-解挂
     
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark -GYCheckCellDelegate

-(void)pushPayViewWithURL:(NSString *)url
{
    GYAgainConfirmViewController * vc = [[GYAgainConfirmViewController alloc] init];
    NSLog(@"123");
    [self.navigationController pushViewController:vc animated:YES];
}

//挂失/解挂－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)getNetDataCheckLose :(NSString *)type :(NSString *)time
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
   
    [dictInside setValue:type forKey:@"type"];//3 4
    
    [dictInside setValue:time forKey:@"period"]; //@"2015-1-1~2015-1-6"
  
    
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
    [dict setValue:@"get_card_business_list" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"ResponseDic === %@",ResponseDic);
            
            
            if ([ResponseDic[@"code"] isEqualToString:@"SVC0000"]) {
                [self.arrQueryResult removeAllObjects];
                for (NSDictionary *dic in ResponseDic[@"data"][@"cardBusinessList"]) {
                    
//                    NSLog(@"dic = %@",dic);
                    CheckModel *model = [[CheckModel alloc] init];
                    model.created = dic[@"created"];
                    model.serialNo = dic[@"serialNo"];
                    model.status = dic[@"status"];
                    
                    
                    model.type = dic[@"type"];
                    
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

//补办－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

-(void)getNetDataCheckRepair :(NSString *)time
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:time forKey:@"period"]; //@"2015-1-1~2015-1-6"
    
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
    [dict setValue:@"get_remake_card_business_list" forKeyPath:@"cmd"];
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"ResponseDic ==*%@",ResponseDic);
            
    
            //网络请求回调后弹窗
            
            [Utils hideHudViewWithSuperView:self.view.window];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }
    }];
    
    
}

//短信通知－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

-(void)getNetDataCheckMSN
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:@"06186010001" forKey:@"resource_no"];
    
    [dictInside setValue:@"06186010001" forKey:@"deathCer"];
    [dictInside setValue:@"06186010001" forKey:@"trusteeIdCardPic"];
    [dictInside setValue:@"06186010001" forKey:@"pointCardPic"];
    [dictInside setValue:@"06186010001" forKey:@"idLogoutCer"];
    [dictInside setValue:@"06186010001" forKey:@"elseCer"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
//    [dict setValue:dictInside forKey:@"params"];
//    [dict setValue:kTempKey forKey:@"key"];
    //请求对应url的运行cmd
    [dict setValue:@"apply_dead_insurance" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
                
            }else{
                
                
            }
            //网络请求回调后弹窗
            
            [Utils hideHudViewWithSuperView:self.view.window];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }
    }];
    
    
}


//获取时间参数
-(NSString *)getTime:(NSInteger)timeType
{
    
    NSTimeInterval time = 0.0;
    //最近一个月
    if (timeType == 0) {
        time = - 60.0 *60 * 24 * 30;
    }
    //最近三个月
    if (timeType == 1) {
        time = - 60.0 *60 * 24 * 30 *3;
    }
    //最近六个月
    if (timeType == 2) {
        time = - 60.0 *60 * 24 * 183;
    }
    //最近一年
    if (timeType == 3) {
        time = - 60.0 *60 * 24 * 365;
    }
    
    NSDate *date1 = [[NSDate alloc] initWithTimeInterval:time sinceDate:[NSDate date]];;

    NSDateFormatter *formatter1=[[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-M-d"];
    NSString *dataString1=[formatter1 stringFromDate:date1];
   
    NSDate *date2=[NSDate date];
    NSDateFormatter *formatter2=[[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"YYYY-M-d"];
    NSString *dataString2=[formatter2 stringFromDate:date2];
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%@~%@",dataString1,dataString2]);
    
    return [NSString stringWithFormat:@"%@~%@",dataString1,dataString2];
    
//@"2015-1-1~2015-1-6
}



@end

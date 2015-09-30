//
//  GYCashDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询类

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

#import "GYCashDetailViewController.h"
#import "DropDownListView.h"
#import "CellDetailCell.h"
#import "UIView+CustomBorder.h"

@interface GYCashDetailViewController ()<UITableViewDataSource,
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

@implementation GYCashDetailViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    //设置边框
    [ivSelectorBackgroundView addTopBorder];
    [ivSelectorBackgroundView addBottomBorder];
    
    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(160, 160, 160, 1)];
    
    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];
    
    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailCell" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailCellIdentifier];
    
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
        arrLeftDropMenu = @[@"全部"];
    }
    if (!arrRightDropMenu)//用于测试
    {
        arrRightDropMenu = @[@"全部"];
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
    if (!self.arrQueryResult)//用于测试
    {
        self.arrQueryResult = [[NSMutableArray alloc] init];
        int i = 0;
        for (i = 0; i < 30; i++)
        {
            [self.arrQueryResult addObject:[NSString stringWithFormat:@"QueryResult Row %d", i]];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 查询动作

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    DDLogDebug(@"【明细查询】 条件【%@】【%@】 正在查询，请稍后...", self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex]);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString * cellIdentifier = @"cellIdentifier";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CellDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellDetailCellIdentifier];
    
    if (!cell)
    {
        cell = [[CellDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    cell.lbRow1Left.text = @"科目";
    cell.lbRow1Right.text = @"2015-01-01";
    cell.lbRow2Left.text = @"交易金额";
    cell.lbRow2Right.text = @"12,000.50";
    cell.lbRow3Left.text = @"状态";
    cell.lbRow3Right.text = @"失败";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
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

@end

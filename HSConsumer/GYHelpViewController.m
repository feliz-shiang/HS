//
//  GYHelpViewController.m
//  HSConsumer
//
//  Created by 00 on 14-12-5.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYHelpViewController.h"
#import "GYGeneralTableViewCell.h"
#import "UIView+CustomBorder.h"


@interface GYHelpViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tbvHelp;

    NSArray * arrDataL ;//标题数组
    NSArray * arrDataR ;//内容数组
}



@end

@implementation GYHelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    arrDataL = [NSArray arrayWithObjects:
               @"平台热线",
               @"平台邮箱",
               @"平台地址",
               @"户名",
               @"开户行",
               @"账户",
               nil];
    
    arrDataR = [NSArray arrayWithObjects:
               @"0755-83344111",
               @"cs@hsxt.com",// 之前是es
               @"深圳市福田区福中路深圳市勘察研究院7栋",
               @"深圳市互生科技有限公司",
               @"中国银行深圳中兴支行",
               @"7640 6170 4406",
               nil];
    
    
    
    tbvHelp.delegate = self;
    tbvHelp.dataSource = self;
    tbvHelp.scrollEnabled = NO;
    
    //注册自定义cell
    [tbvHelp registerNib:[UINib nibWithNibName:@"GYGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];



}

#pragma mark - UITableViewDataSource

//设置Section 个数 组头高度 组尾高度 组头背景图 组尾背景图
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置下边框
    [view addBottomBorder];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置上边框
    [view addTopBorder];
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    //重设置自定义cell 控件位置、字体大小、字体颜色
    cell.imgRightArrow.hidden = YES;
    cell.lbVersions.frame = CGRectMake(116, 1, 179, 42);
    cell.lbVersions.numberOfLines = 0;
    cell.lbVersions.textAlignment = NSTextAlignmentLeft;
    cell.lbVersions.font = [UIFont systemFontOfSize:17];
    cell.lbTitle.textColor = kCellItemTitleColor;
    cell.lbVersions.textColor = kCellItemTextColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        cell.lbTitle.text = arrDataL[indexPath.row];
        cell.lbVersions.text = arrDataR[indexPath.row];
    }else
    {
        cell.lbVersions.frame = CGRectMake(96, 1, 189, 42);
        cell.lbTitle.text = arrDataL[indexPath.row+3];
        cell.lbVersions.text = arrDataR[indexPath.row+3];
    }
    
    
    return cell;
}



@end

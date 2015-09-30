//
//  GYBottomActionView.m
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/4.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import "GYBottomActionView.h"
#import "GYActionViewCell.h"
#define kBorder 5
#define KcellHeight 44
@interface GYBottomActionView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView * superViewShow;
@end

@implementation GYBottomActionView

-(instancetype)initWithView:(UIView *)view arrayData:(NSArray *)arrayData
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.backView = [[UIView alloc] initWithFrame:frame];
        self.backView.backgroundColor = [UIColor grayColor];
        self.backView.alpha = 0;
        [self addSubview:self.backView];
        self.superViewShow = view;
        self.arrList = arrayData;
        [self.superViewShow addSubview:self];
    }
    return self;
}
-(void)show
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.backView  addGestureRecognizer:tap];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor grayColor];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, KcellHeight*(self.arrList.count+1)+kBorder);
    [self.superViewShow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.3;
        self.tableView.frame = CGRectMake(0, self.frame.size.height - KcellHeight*(self.arrList.count+1)-kBorder, [UIScreen mainScreen].bounds.size.width, KcellHeight*(self.arrList.count+1)+kBorder);
    }];
}
-(void)close
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,0);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.frame = CGRectZero;
            [self removeFromSuperview];
        }
    }];
}
#pragma mark UITableViewDeletate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    return self.arrList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return kBorder;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYActionViewCell * cell = [GYActionViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1)
    {
        GYBottomActionViewItemModel * model = [[GYBottomActionViewItemModel alloc] init];
        model.type = 1;
        model.strTitle = @"取消";
        cell.model = model;
    }
    else
    {
        
        GYBottomActionViewItemModel * model = self.arrList[indexPath.row];
        cell.model = model;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1)
    {
        [self close];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(BottomActionView:model:)])
        {
            [self.delegate BottomActionView:self model:self.arrList[indexPath.row]];
        }
        
        [self close];
    }
}
@end


@implementation GYBottomActionViewItemModel



@end
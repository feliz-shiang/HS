//
//  GYPOSDealDetailViewController.m
//  company
//
//  Created by 00 on 14-11-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPOSDealDetailViewController.h"
#import "InputCellStypeView.h"
#import "GYPOSDealDetailCell.h"
#import "BtnConfirm.h"
#import "CustomIOS7AlertView.h"
#import "GYResultCell.h"

@interface GYPOSDealDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CustomIOS7AlertViewDelegate>
{
    
    __weak IBOutlet UIScrollView *scvDealDetail;
    __weak IBOutlet UITableView *tbvDealDetail;
    __weak IBOutlet BtnConfirm *btnConfirm;
    
    NSArray * arrTitle;//数据
    NSArray * arrData;
    
    UITableView *tbvAV;
    NSArray * netTitle;
    NSArray * netData;
    
    
    __weak IBOutlet UIView *vTitle;//状态行
    
    __weak IBOutlet UIImageView *imgTitle;//状态图
    
    __weak IBOutlet UILabel *lbTitle;//状态标题
    
    UIView *tempview;
    
}
@end

@implementation GYPOSDealDetailViewController
//确定按钮点击事件
- (IBAction)btnConfirmClick:(id)sender {
    
    /*
     以下代码应该在网络请求完成回调函数中完成，分为成功状态和失败状态。根据服务器返回完成状态自动匹配对应提示框内容。
     
     */
    
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定",nil]];
    [alertView setBackgroundColor:[UIColor redColor]];
    //设置代理
    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        
        
    }];

    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
    
}


#pragma mark - CustomIOS7AlertViewDelegate
//按钮代理回调事件设置
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"呵呵好: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

//弹窗控件插入视图
- (UITableView *)createUI
{
    tbvAV = [[UITableView alloc] initWithFrame:CGRectMake(0, 3, 290, netTitle.count * 25+44 +10)];
    tbvAV.backgroundColor = [UIColor clearColor];
    tbvAV.scrollEnabled = NO;
    tbvAV.delegate = self;
    tbvAV.dataSource = self;
    tbvAV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tbvAV registerNib:[UINib nibWithNibName:@"GYResultCell" bundle:nil] forCellReuseIdentifier:@"RESULTCell"];
    [tbvAV reloadData];
    return tbvAV;
}
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


- (void)viewDidLoad
{
    [super viewDidLoad];
//必要数据初始化
    arrTitle = self.model.arrTitle;
    arrData = self.model.arrData;
    vTitle.frame = CGRectMake(0, -100, 0, 0);
    tempview = vTitle;
    
//设置tableView
    tbvDealDetail.scrollEnabled = NO;
    tbvDealDetail.delegate = self;
    tbvDealDetail.dataSource = self;
    tbvDealDetail.frame = CGRectMake(tbvDealDetail.frame.origin.x, tbvDealDetail.frame.origin.y, tbvDealDetail.frame.size.width,arrTitle.count * 44);
    [Utils setBorderWithView:tbvDealDetail WithWidth:1.0 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
//设置输入行
    self.vInputPWD.frame = CGRectMake(self.vInputPWD.frame.origin.x, tbvDealDetail.frame.origin.y+tbvDealDetail.frame.size.height+16, self.vInputPWD.frame.size.width,self.vInputPWD.frame.size.height);
    self.vInputPWD.lbLeftlabel.text = self.model.strPWTitlt;
    self.vInputPWD.tfRightTextField.placeholder = self.model.strPWPlaceHolder;
    self.vInputPWD.tfRightTextField.secureTextEntry = YES;
    
    self.vInputPWD.hidden = self.hid;
//设置确定按钮
    
    [btnConfirm setTitle:@"确定提交" forState:UIControlStateNormal];
    
    if (self.vInputPWD.hidden) {
        btnConfirm.frame = CGRectMake(btnConfirm.frame.origin.x, tbvDealDetail.frame.origin.y+tbvDealDetail.frame.size.height+20, btnConfirm.frame.size.width,btnConfirm.frame.size.height);
    }else{
        btnConfirm.frame = CGRectMake(btnConfirm.frame.origin.x, self.vInputPWD.frame.origin.y+self.vInputPWD.frame.size.height+20, btnConfirm.frame.size.width,btnConfirm.frame.size.height);
    }
    
//tableView注册自定义Cell
    [tbvDealDetail registerNib:[UINib nibWithNibName:@"GYPOSDealDetailCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

    [tbvDealDetail reloadData];

    
    
    
//假数据
    netTitle = self.model.netTitle;
    
    netData = self.model.netData;
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    
    
    
    
}

//tableview代理函数
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tbvAV) {
        
        return 44;

    }else{
        return 0;
    }

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return tempview;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbvAV) {
        //弹窗
        return netTitle.count;
    }else{
        //页面
        return arrTitle.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbvAV) {
        return 25;
    }else{
        return 44;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tbvAV) {
        
        //弹窗tableview设置
        GYResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESULTCell"];
        
        cell.lbCellTitle.text = netTitle[indexPath.row];
        cell.lbResult.text = netData[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       // cell.lbResult.textColor = kCashTextColor;
        
        return cell;
    }else{
        
        //页面tableview设置
        GYPOSDealDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        cell.lbTitle.text = arrTitle[indexPath.row];
        cell.lbData.text = arrData[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}



@end

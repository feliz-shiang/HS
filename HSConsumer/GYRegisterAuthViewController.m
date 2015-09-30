//
//  GYCompanyManageViewController.m
//  company
//
//  Created by apple on 14-11-13.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//  实名注册 认证
#define kKeyCellName @"keyName"
#define kKeyCellIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYRegisterAuthViewController.h"
#import "CellTypeImagelabel.h"
#import "TestViewController.h"


#import "GYMyInfoTableViewCell.h"
#import "GlobalData.h"
//实名注册
#import "GYRealNameRegisterViewController.h"
//待审批状态
#import "GYApproveViewController.h"


#import "GYRealNameAuthViewController.h"
//审批驳回
#import "GYRefuseAuthViewController.h"
//通过验证
#import "GYFinishAuthViewController.h"
//没有注册的进入实名认证
#import "GYNoRegisterViewController.h"
//待审批 三张图片
#import "GYApproveThreePicViewController.h"
//审批驳回  三张图片
#import "GYRefuseThreePicAuthViewController.h"
//去实名绑定
#import "GYNoRegisterForSkipViewController.h"
@interface GYRegisterAuthViewController ()

@end

@implementation GYRegisterAuthViewController
{
    NSArray *arrPowers;    //账户的属性
    GlobalData * data;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=@"实名注册认证";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    data=[GlobalData shareInstance];
    //注册cell
    [self.tvRegisterAuth registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"GYMyInfoTableViewCell_35" : @"GYMyInfoTableViewCell" bundle:kDefaultBundle]
              forCellReuseIdentifier:@"cell"];
    
    
    NSString * vcNameUp;
    NSString * vcName;
    
    //根据认证状态 判断进入 待审核  审核驳回  已通过页面。
    //判断实名绑定  再进入 实名注册

    
        vcNameUp=NSStringFromClass([GYRealNameRegisterViewController class]);

    
  
    
    if ([[GlobalData shareInstance].personInfo.regStatus isEqualToString:@"Y"]) {
        
        vcName=NSStringFromClass([GYRealNameAuthViewController class]);
        
        //对实名注册  和  实名认证的状态进行判断
        if ([[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"U"]) {
            vcName=NSStringFromClass([GYRealNameAuthViewController class]);
            
        }
        //待审核状体
        else if ([[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"W"])
        {
            //证件类型为身份证
        
            if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"]) {
                
                vcName=NSStringFromClass([GYApproveThreePicViewController class]);
                
                //证件类型为护照
            }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
            {
                vcName=NSStringFromClass([GYApproveViewController class]);
                //证件类型为营业执照
            }else
            {
                vcName=NSStringFromClass([GYApproveViewController class]);
                
            }
        }
        //审核拒绝
        else if ([[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"N"])
        {
            //证件类型为身份证
            if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"1"]) {
                
                vcName=NSStringFromClass([GYRefuseThreePicAuthViewController class]);
                //证件类型为护照
            }else if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"2"])
            {
                vcName=NSStringFromClass([GYRefuseAuthViewController class]);
                //证件类型为营业执照
            }else
            {
                vcName=NSStringFromClass([GYRefuseAuthViewController class]);
                
            }
            
        }
        //审核通过
        else if ([[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"Y"])
        {
            vcName=NSStringFromClass([GYFinishAuthViewController class]);
        }
        else{
            
            
            
            
            
        }

        
        
        
    }else
    {
        
        vcName=NSStringFromClass([GYNoRegisterViewController class]);
    }
    
    
    
    
    
    NSLog(@"%@----nameUP",vcNameUp);
    arrPowers=@[@{kKeyCellIcon:@"cell_realname_register.png",
                  kKeyCellName: kLocalized(@"real_name_register"),
                  kKeyNextVcName: vcNameUp                   },
                @{kKeyCellIcon: @"cell_realname_authentication.png",
                  kKeyCellName: kLocalized(@"real_name_authentication"),
                  kKeyNextVcName:vcName
                  },
                ];
    
    
    //兼容IOS6设置背景色
    self.tvRegisterAuth.backgroundView = [[UIView alloc]init];
    self.tvRegisterAuth.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    
    [self.tvRegisterAuth reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return arrPowers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString * identifier =@"cell";
    GYMyInfoTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell=[[GYMyInfoTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identifier];
      
    }
    [cell refreshWithImg:[arrPowers[indexPath.row] objectForKey:kKeyCellIcon] WithTitle:[arrPowers[indexPath.row] objectForKey:kKeyCellName]];
    
    switch (indexPath.row) {
        case 0:
        {
            
            if (data.user.isRealNameRegistration) {
                cell.vAccessoryView.text=@"已注册";
            }else
            {
                cell.vAccessoryView.text=@"未注册";
                
            }
        }
            break;
            
        case 1:
        {
            if (data.user.isRealName) {
                cell.vAccessoryView.text=@"已认证";
            }else
            {
                cell.vAccessoryView.text=@"未认证";
                
            }
        }
            break;
        default:
            break;
    }
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (data.currentDeviceScreenInch)
    {
        case kDeviceScreenInch_3_5:
            return kDefaultCellHeight3_5inch;
            break;
            
        case kDeviceScreenInch_4_0:
        default:
            return kDefaultCellHeight;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16;
    }else
    {
        return 6;//加上页脚＝16
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = nil;
    vc = kLoadVcFromClassStringName([arrPowers[indexPath.row] valueForKey:kKeyNextVcName]);
    vc.navigationItem.title = [arrPowers[indexPath.row] valueForKey:kKeyCellName];
    
    if (indexPath.row==0) {
        GYRealNameRegisterViewController * noRegister =  (GYRealNameRegisterViewController *)vc;
        vc=noRegister;
        
    }else if ([vc isKindOfClass:[GYNoRegisterViewController class]]&&indexPath.row==1)
    {
//        GYNoRegisterForSkipViewController * noRegister = (GYNoRegisterForSkipViewController *)vc;
        GYNoRegisterForSkipViewController * noRegister = [[GYNoRegisterForSkipViewController alloc]init];
        noRegister.strContent=@"您还没有进行实名注册，请先进行实名注册！";
        vc=noRegister;
    
    }
    
    [self pushVC:vc animated:YES];
    
}


- (id)getVC:(NSString *)classString
{
    return [[NSClassFromString(classString) alloc] init];
}



//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sender animated:ani];
  
}

@end

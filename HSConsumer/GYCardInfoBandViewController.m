//
//  GYCompanyManageViewController.m
//  company
//
//  Created by apple on 14-11-13.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#define kKeyCellName @"keyName"
#define kKeyCellIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYCardInfoBandViewController.h"
#import "CellTypeImagelabel.h"
#import "TestViewController.h"


#import "GYMyInfoTableViewCell.h"
#import "GlobalData.h"
//手机号码绑定
#import "GYPhoneBandingViewController.h"
#import "GYNameBandingViewController.h"
//银行卡绑定
#import "GYCardBandingViewController3.h"
//邮箱绑定
#import "GYEmailBandingViewController.h"


#import "GYCitySelectViewController.h"
//绑定邮箱列表  手机列表
#import "GYQuitPhoneBandingViewController.h"




@interface GYCardInfoBandViewController ()

@end

@implementation GYCardInfoBandViewController
{
    NSArray *arrPowers;    //账户的属性
    GlobalData * data;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=kLocalized(@"card_info_banding");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data=[GlobalData shareInstance];
    
    //注册cell
    [self.tvCardBand registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"GYMyInfoTableViewCell_35" : @"GYMyInfoTableViewCell" bundle:kDefaultBundle] forCellReuseIdentifier:@"cell"];
    
    //zhangqy 去掉实名绑定
    arrPowers = @[
//  @{kKeyCellIcon: @"cell_name_banding.png",
//                    kKeyCellName: kLocalized(@"name_banding"),
//                    kKeyNextVcName: NSStringFromClass([GYNameBandingViewController class])
//                    },
                  @{kKeyCellIcon: @"cell_cardbanding.png",
                    kKeyCellName: kLocalized(@"bank_card_binding"),
                    kKeyNextVcName: NSStringFromClass([GYCardBandingViewController3 class])
                    },
                  @{kKeyCellIcon: @"cell_phone_banding.png",
                    kKeyCellName: kLocalized(@"cell_phone_number_binding"),
                    kKeyNextVcName: NSStringFromClass([GYQuitPhoneBandingViewController class])
                    },
                  @{kKeyCellIcon: @"cell_email_banding.png",
                    kKeyCellName: kLocalized(@"email_binding"),
                    kKeyNextVcName: NSStringFromClass([GYQuitPhoneBandingViewController class])
                    }
                  
                  ];
    
    //兼容IOS6设置背景色
    self.tvCardBand.backgroundView = [[UIView alloc]init];
    self.tvCardBand.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
 
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tvCardBand reloadData];

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
    //zhangqy 去掉实名绑定
    switch (indexPath.row) {
//        case 0:
//        {
//            
//          
//            
//            if ([GlobalData shareInstance].user.userName) {
//
//                cell.vAccessoryView.text=@"已绑定";
//                
//            }else{
//                
//                cell.vAccessoryView.text=@"未绑定";
//                
//            }
//            
//        }
//                  break;
        case 0:
        {
            if (self.model.isBankBinding) {
                
               cell.vAccessoryView.text=@"已绑定";
                
            }else{
                
               cell.vAccessoryView.text=@"未绑定";
                
            }
        
        }
            break;
        case 1:
        {
            if (self.model.isPhoneBinding) {
                cell.vAccessoryView.text=@"已绑定";
            }else{
                cell.vAccessoryView.text=@"未绑定";
            }
            
        }
            break;
        case 2:
        {
            if (self.model.isEmailBinding) {
                cell.vAccessoryView.text=@"已绑定";
            }else{
                cell.vAccessoryView.text=@"未绑定";
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
    //当已经有绑定的号码时，弹出号码列表
    if ([vc isKindOfClass:[GYQuitPhoneBandingViewController class]])
    {
        //zhangqy 去掉实名绑定 row 前移1
        if (indexPath.row==1) {
            //已经有邮箱绑定。

            if (self.model.isPhoneBinding) {
                 ((GYQuitPhoneBandingViewController *)vc).FromWhere=YES;
            }
            else
            {
                GYPhoneBandingViewController * vcPhone =[[GYPhoneBandingViewController alloc]initWithNibName:@"GYPhoneBandingViewController" bundle:nil];
                vc=vcPhone;

            }     
            
        }else{
            
            if (self.model.isEmailBinding) {
                 ((GYQuitPhoneBandingViewController *)vc).FromWhere=NO;
            }
            else
            {
                GYEmailBandingViewController * vcEmail =[[GYEmailBandingViewController alloc]initWithNibName:@"GYEmailBandingViewController" bundle:nil];
                vc=vcEmail;
            
            }
        
        }
        
      
    }
    
    vc.navigationItem.title = [arrPowers[indexPath.row] valueForKey:kKeyCellName];
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

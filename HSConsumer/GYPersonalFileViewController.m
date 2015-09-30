//
//  GYPersonalFileViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPersonalFileViewController.h"
#import "GYPersonalWithpictureTableViewCell.h"
#import "GYPersonalInfoTableViewCell.h"

@interface GYPersonalFileViewController ()<GYPersonalInfoTableViewCellDelegate>

@end

@implementation GYPersonalFileViewController
{

    __weak IBOutlet UITableView *tvPersonalFile;

    NSMutableArray * arrPlaceHolder;
    NSMutableArray * arrTest;
    
//    NSInteger sectionIndex;
//    
//    NSInteger index;
}
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
    arrPlaceHolder=[NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    tvPersonalFile.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.arrDataSource=@[@[kLocalized(@"avatar"),kLocalized(@"nickname"),kLocalized(@"name")],@[kLocalized(@"sex"),kLocalized(@"ep_ages"),kLocalized(@"ep_blood"),kLocalized(@"ep_zodiac"),kLocalized(@"professional"),kLocalized(@"ep_hobby")],@[kLocalized(@"ep_graduation_from"), kLocalized(@"ep_qq_for_job"), kLocalized(@"ep_weixin_number"),kLocalized(@"ep_contact_phone"),kLocalized(@"city"),kLocalized(@"ep_resident_address"),kLocalized(@"zip_code")]];
    
    arrPlaceHolder=[@[[@[@"",
                         kLocalized(@"input_nickname"),
                        kLocalized(@"input_receive_name")] mutableCopy],
                      [@[kLocalized(@"input_sex"),
                        kLocalized(@"ep_input_ages"),
                        kLocalized(@"ep_input_blood"),
                        kLocalized(@"ep_input_zodiac"),
                        kLocalized(@"input_job"),
                        kLocalized(@"ep_enter_hobby")] mutableCopy],
                      [@[kLocalized(@"ep_input_graduation_from"),
                        kLocalized(@"ep_input_qq"),
                        kLocalized(@"ep_input_weixin_number"),
                        kLocalized(@"ep_input_contact_phone"),
                        kLocalized(@"input_city"),
                        kLocalized(@"ep_input_resident_address"),
                        kLocalized(@"input_postCode")] mutableCopy]
                      ] mutableCopy];
    
    arrTest= [[NSMutableArray alloc] init];
    NSMutableArray *arrTmp=nil;
    for (int i = 0; i < arrPlaceHolder.count; i++)
    {
        arrTmp = [NSMutableArray array];
        for (int cellCount = 0; cellCount < [arrPlaceHolder[i] count]; cellCount++)
        {
            [arrTmp addObject:@""];
        }
        [arrTest addObject:arrTmp];
    }
 
    tvPersonalFile.delegate = self;
    tvPersonalFile.dataSource = self;
    
    [tvPersonalFile registerNib:[UINib nibWithNibName:@"GYPersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"mostcell"];
    [tvPersonalFile registerNib:[UINib nibWithNibName:@"GYPersonalWithpictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    footer.backgroundColor=kDefaultVCBackgroundColor;
    tvPersonalFile.tableFooterView=footer;
}
#pragma mark DataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.arrDataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.arrDataSource[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 72.f;
        }
    }
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kDefaultMarginToBounds;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeader =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    static NSString * mostCellIdentifier=@"mostcell";
    GYPersonalWithpictureTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    GYPersonalInfoTableViewCell * maincell =[tableView dequeueReusableCellWithIdentifier:mostCellIdentifier];
    
    //cell的初始化
    if (indexPath.section==0&&indexPath.row==0) {
        
        if (cell==nil) {
            
            cell=[[GYPersonalWithpictureTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
             UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAvater)];
                [cell.imgAvater addGestureRecognizer:tap];
        
        
    }else{
        
        
        if (maincell==nil) {
            
            maincell=[[GYPersonalInfoTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:mostCellIdentifier];
            
        }
        
    }
    //cell内容的赋值
    switch (indexPath.section) {
        case 0:
        {
            cell.inputPictureInfoRow.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
            if (indexPath.row>0) {
                maincell.InputCellInfo.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
                maincell.InputCellInfo.tfRightTextField.placeholder=arrPlaceHolder[indexPath.section][indexPath.row];
           maincell.InputCellInfo.tfRightTextField.text = arrTest[indexPath.section][indexPath.row];
            }
            
        }
            break;
        case 1:
            
        case 2:
        {
            
           maincell.InputCellInfo.lbLeftlabel.text=self.arrDataSource[indexPath.section][indexPath.row];
           maincell.InputCellInfo.tfRightTextField.placeholder=arrPlaceHolder[indexPath.section][indexPath. row];
         maincell.InputCellInfo.tfRightTextField.text = arrTest[indexPath.section][indexPath.row];
//            maincell.section = indexPath.section;
//            maincell.row = indexPath.row;
//            maincell.delegate = self;
        }
            break;
        default:
            break;
    }
    
    if (indexPath.section==0&&indexPath.row==0) {
        return cell;
    }
    maincell.section = indexPath.section;
    maincell.row = indexPath.row;
    maincell.delegate = self;

    
    return maincell;
}


#pragma mark textfiled delegate
- (void)didEndEditing:(NSInteger)section inRow:(NSInteger)row object:(id)sender
{


    GYPersonalInfoTableViewCell *cell = sender;
    
 
    [arrTest[section] replaceObjectAtIndex:row withObject:cell.InputCellInfo.tfRightTextField.text];


    [tvPersonalFile reloadData];

}


-(void)chooseAvater
{
    NSLog(@"123456");
    
}
@end

//
//  GYFalseAddViewController.m
//  HSConsumer
//
//  Created by 00 on 14-11-6.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYFalseAddViewController.h"
#import "GYGetGoodTableViewCell.h"
#import "GYAddressModel.h"

//假数据页面

@interface GYFalseAddViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tbvAdd;
    NSMutableArray *mArrData;
    
}
@end

@implementation GYFalseAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mArrData = [[NSMutableArray alloc] init];
        tbvAdd.delegate = self;
        tbvAdd.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addAdd];

    tbvAdd.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tbvAdd registerNib:[UINib nibWithNibName:@"GYGetGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"ADDCELL"];
    

}

-(void)addAdd
{
    for (int i = 0; i < 3; i++) {
        GYAddressModel *model = [[GYAddressModel alloc] init];
        model.CustomerName = [NSString stringWithFormat:@"大锤%d号",i];
        model.DetailAddress = [NSString stringWithFormat:@"收货地址:深圳南山区高新南一道%d号",i];
        model.CustomerPhone = [NSString stringWithFormat:@"1346666777%d",i];
        [mArrData addObject:model];
    }


}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"ADDCELL";
    GYGetGoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    cell.btnChooseDefaultAddress.hidden = YES;
    GYAddressModel *model = mArrData[indexPath.row];
    cell.lbCustomerName.text = model.CustomerName;
    cell.lbCustomerAddress.text = model.DetailAddress;
    cell.lbCustomerPhone.text = model.CustomerPhone;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYAddressModel *model = mArrData[indexPath.row];
    [self.delegate returnAdd:model];
    [self.navigationController popViewControllerAnimated:YES];


}


@end

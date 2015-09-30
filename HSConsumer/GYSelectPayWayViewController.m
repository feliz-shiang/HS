//
//  GYSelectPayWayViewController.m
//  HSConsumer
//
//  Created by 00 on 14-11-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSelectPayWayViewController.h"

@interface GYSelectPayWayViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    __weak IBOutlet UITableView *tbvSelPayWay;//支付方式tableview

}
@end

@implementation GYSelectPayWayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //tableView代理
        tbvSelPayWay.delegate = self;
        tbvSelPayWay.dataSource = self;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"PAYWAYCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }

    cell.textLabel.text = self.arrData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:90/255.0f green:90/255.0f blue:90/255.0f alpha:1.0f];
    if (indexPath.row == self.selectIndex)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(getBackPayWay:)])
    {
        [_delegate getBackPayWay:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

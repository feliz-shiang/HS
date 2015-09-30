//
//  GYSelAccountViewController.m
//  HSConsumer
//
//  Created by 00 on 14-11-5.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSelAccountViewController.h"

@interface GYSelAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tbvSelAcc;
    
    NSArray *arrData;
}
@end

@implementation GYSelAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arrData = @[@"622588***8888",
                    @"622588***8888",
                    @"624588***8888",
                    @"624588***8888",
                    @"622548***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888",
                    @"622588***8888"
                    ];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tbvSelAcc.delegate = self;
    tbvSelAcc.dataSource = self;
    
    
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SELACCCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.textLabel.text = arrData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.textColor = kCorlorFromRGBA(90, 90, 90, 1.0);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.delegate returnAccNum:arrData[indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
    

}



@end

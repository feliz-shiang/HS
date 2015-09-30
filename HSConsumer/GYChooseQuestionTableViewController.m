//
//  GYTestTableViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-6.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYChooseQuestionTableViewController.h"


@interface GYChooseQuestionTableViewController ()

@end






@implementation GYChooseQuestionTableViewController
@synthesize marrDataSource;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=@"选择问题";
        self.tag = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    marrDataSource=[NSMutableArray array];
    self.tvQuestionTable.delegate=self;
    self.tvQuestionTable.dataSource=self;
    [self loadDataFromNetwork];
        
}

-(void)loadDataFromNetwork
{

    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:@" " forKey:@"resource_no"];

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"get_password_hint" forKeyPath:@"cmd"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"%@----",error);
        }
        else
        {
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view];
            NSString * code =[NSString stringWithFormat:@"%@",ResponseDic[@"code"]];
            if ([code isEqualToString:@"SVC0000"]) {
                for (NSDictionary * tempDict in ResponseDic[@"data"][@"questions"]) {
                    GYQuestionModel * model = [[GYQuestionModel alloc]init];
                    model.strQuestion=tempDict[@"question"];
                    model.strQuestionId=tempDict[@"questionId"];
                    
                    [marrDataSource addObject:model];
                }
                [self.tvQuestionTable reloadData];
          
            }
            
        }
        
    }];
    
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return marrDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    GYQuestionModel * model =self.marrDataSource[indexPath.row];
    cell.textLabel.text=model.strQuestion;
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYQuestionModel * model =marrDataSource[indexPath.row];
    //[UITableViewCell * cell
    if (_Delegate&&[_Delegate respondsToSelector:@selector(selectedOneQuestion:)]) {
        [_Delegate selectedOneQuestion:model];
        [self.navigationController popViewControllerAnimated:YES];
        
    }


    
    
}


@end

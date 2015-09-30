//
//  GYGetPasswordHitViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGetPasswordHitViewController.h"
#import "GYQuestionModel.h"

@interface GYGetPasswordHitViewController ()

@end

@implementation GYGetPasswordHitViewController

{

    __weak IBOutlet UITableView *tvQuestionList;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"选择问题";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return self.marrQuestion.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    GYQuestionModel * model =self.marrQuestion[indexPath.row];
    
    NSLog(@"%@------id",model.strQuestionId);
    cell.textLabel.text=model.strQuestion;
    
    return cell;


}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYQuestionModel * model =self.marrQuestion[indexPath.row];
    //[UITableViewCell * cell
    if (_delegate&&[_delegate respondsToSelector:@selector(selectedOneQuestion:)]) {
        [_delegate selectedOneQuestion:model];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
    
}
@end

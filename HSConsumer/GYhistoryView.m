//
//  GYhistoryView.m
//  HSConsumer
//
//  Created by appleliss on 15/8/20.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYhistoryView.h"

@implementation GYhistoryView

{
    UITableView *table;
    NSArray * arr1;

}

- (void)drawRect:(CGRect)rect {
   table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-40) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
//    table.tableFooterView=[self tableViewfootview];
    
    [self addSubview:table];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArry.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *diferCell=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:diferCell];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:diferCell];
        
    }
    GYseachhistoryModel *model= self.historyArry[indexPath.row];
    cell.textLabel.text =model.name;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        GYseachhistoryModel *model= self.historyArry[indexPath.row];
    
    if (_Hdelegate && [_Hdelegate respondsToSelector:@selector(didSelectOneRow:)]) {
        [_Hdelegate didSelectOneRow:model.name];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)reloadDatatable:(NSArray *)hiArry
{
    self.historyArry=hiArry;
    [table reloadData];

}

@end

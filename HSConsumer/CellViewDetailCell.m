//
//  CellViewDetailCell.m
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellViewDetailCell.h"
#import "CellDetailRow.h"

@implementation CellViewDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect btnFrame = CGRectMake(170, 175, 90, 30);
        self.labelShowDetails = [[UILabel alloc] initWithFrame:btnFrame];
        [self.labelShowDetails setText:kLocalized(@"show_detail")];
        [self.labelShowDetails setTextColor:kCorlorFromRGBA(200, 200, 200, 1)];
        [self.labelShowDetails setTextAlignment:NSTextAlignmentCenter];
        [self.labelShowDetails setBackgroundColor:kClearColor];
//        [self.btnButton.titleLabel setTextColor:[UIColor redColor]];
        
        CGRect tbvFrame = CGRectMake(0, 0, 320, 225);
        self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
        [self addSubview:self.labelShowDetails];
        
        self.arrDataSource = [NSMutableArray array];
        [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailRowIdentifier];        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
//    NSLog(@"CellViewDetailCell frame:%@", NSStringFromCGRect(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table view data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CellDetailRow *cell = [tableView dequeueReusableCellWithIdentifier:kCellDetailRowIdentifier];
    
    if (!cell)
    {
        cell = [[CellDetailRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailRowIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lbTitle.text = self.arrDataSource[row][@"title"];
    cell.lbValue.text = self.arrDataSource[row][@"value"];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell.lbTitle setFont:[UIFont systemFontOfSize:15.0f]];
    [cell.lbValue setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.lbTitle setTextColor:kCellItemTitleColor];
    [cell.lbValue setTextColor:kCellItemTextColor];
    
    //设置title高亮的颜色
    if (self.rowTitleHighlightedProperty)
    {
        [self.rowTitleHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([(NSArray *)obj count] > 1)
            {
                if ([cell.lbTitle.text isEqualToString:obj[0]])//Title的颜色
                {
                    [cell.lbTitle setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];
                }
            }
        }];
    }else
        [cell.lbTitle setTextColor:kCellItemTitleColor];

    //设置value高亮的颜色
    if (self.rowValueHighlightedProperty)
    {
        [self.rowValueHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([(NSArray *)obj count] > 1)
            {
                if ([cell.lbTitle.text isEqualToString:obj[0]])//value的颜色
                {
                    [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
                    [cell.lbValue setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];

                    if ([(NSArray *)obj count] > 2 && [obj[2] boolValue])//为真是格式化货币值
                    {
                        cell.lbValue.text = [Utils formatCurrencyStyle:[cell.lbValue.text doubleValue]];
                    }
                }
            }
        }];
    }else
        [cell.lbValue setTextColor:kCellItemTextColor];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat minHeight = 16;
    return self.cellSubCellRowHeight > minHeight ? self.cellSubCellRowHeight : minHeight;
}

@end

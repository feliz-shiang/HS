//
//  GYGoodsParameterViewController.m
//  HSConsumer
//
//  Created by 00 on 15-2-5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGoodsParameterViewController.h"
#import "GYParameterCell.h"
#import "UIView+CustomBorder.h"

@interface GYGoodsParameterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbv;
    NSArray *arrData;
    
}
@end

@implementation GYGoodsParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = self.model.arrBasicParameter;
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    tbv.delegate = self;
    tbv.dataSource = self;
    UIView *vFooter = [[UIView alloc] init];
    vFooter.backgroundColor = kClearColor;
    tbv.tableFooterView = vFooter;
//    [tbv addTopBorder];
//    tbv.scrollEnabled = NO;
//    
//    CGFloat tbvHeight = arrData.count * 44 + 0.5;
//    if (tbvHeight + 16 > [UIScreen mainScreen].bounds.size.height) {
//        tbvHeight = [UIScreen mainScreen].bounds.size.height - 16.0f;
//        tbv.scrollEnabled = YES;
//    }
//    
//    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, [UIScreen mainScreen].bounds.size.width, tbvHeight);
    
    [tbv registerNib:[UINib nibWithNibName:@"GYParameterCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
}

#pragma mark - UITableViewDataSource;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GYParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
//    ArrModel *model = arrData[indexPath.row];
////    cell.model=arrData[indexPath.row];
//    cell.lbTitle.text = model.key;
//    cell.lbContent.text = model.value;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    static NSString *ID=@"Id";
//    GYParameterCellss *cell=[tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell==nil) {
//        cell = [[GYParameterCellss alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    ArrModel *model=arrData[indexPath.row];
//    cell.model=model;
//    [cell setIntroductionText:model];
//    [cell setNeedsLayout];
    static NSString *identifercell=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifercell];
    
    UILabel *leftlabel = [[UILabel alloc]init];
    
    UILabel *rightlabel = [[UILabel alloc]init];
    leftlabel.text=@"";
    rightlabel.text=@"";
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifercell  ];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.userInteractionEnabled = NO;
    ArrModel *model=arrData[indexPath.row];
    leftlabel.text = model.key;
    leftlabel.numberOfLines= 0;
    leftlabel.textAlignment = UITextAlignmentLeft;
    leftlabel.font=[UIFont systemFontOfSize:18];
    CGFloat labSize=[Utils heightForString:leftlabel.text fontSize:18 andWidth:95];///算出的是字体换行的高度
    CGFloat ly=(cell.bounds.size.height-labSize)/2;
    leftlabel.frame = CGRectMake(5, ly, 95,labSize);
    [cell.contentView addSubview:leftlabel];
//    model.value=model.value;
    rightlabel.text = model.value;
    rightlabel.numberOfLines= 0;
    rightlabel.font = [UIFont systemFontOfSize:18];
    rightlabel.textAlignment = UITextAlignmentLeft;
    CGFloat h=  [Utils heightForString:rightlabel.text fontSize:18 andWidth:self.view.bounds.size.width - 110];
  
    
    rightlabel.frame = CGRectMake(110, 2,self.view.bounds.size.width - 110 ,h+10);
    [cell.contentView addSubview:rightlabel];
  
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight=44;///cell默认高度
    ArrModel *model=arrData[indexPath.row];
//        model.value=@"逛逛嘎嘎嘎灌灌灌灌灌灌灌灌灌灌灌反反复复反反复复灌灌灌灌灌灌灌灌灌嘎嘎嘎嘎嘎嘎嘎hhh9";
    ///左边的label高度
    CGFloat labSize=[Utils heightForString:model.key fontSize:18 andWidth:95];
    ///右边的label  高度
    CGFloat labSizeright=[Utils heightForString:model.value fontSize:18 andWidth:self.view.bounds.size.width - 110];
    if (labSize>=labSizeright ) {
        if(labSize<=44)
            return cellheight;
        else
            return labSize+2;

    }
    else{
//        if (labSizeright<=cellheight) {
//            return labSizeright+10;
//        }
//        else
//        {
                return labSizeright+10;
//        }
    }
    return cellheight;
 
}
@end

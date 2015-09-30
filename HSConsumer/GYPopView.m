//
//  GYPopView.m
//  GYPopView
//
//  Created by 00 on 14-12-27.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYPopView.h"
#import "GYPopViewCell1.h"
#import "GYPopViewCell2.h"
#import "UIView+CustomBorder.h"



@implementation GYPopView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCellType:(NSInteger)cellType WithArray:(NSArray *)array WithImgArray:(NSArray *)imgArray WithBigFrame:(CGRect)bigFrame WithSmallFrame:(CGRect)smallFrame WithBgColor:(UIColor *)bgColor
{
    self = [self init];
    if (self) {
        self.cellType = cellType;
        self.bigFrame = bigFrame;
        self.smallFrame = smallFrame;
        self.bgColor = bgColor;
        
        
        self.arrData = array;
        self.arrImg = imgArray;
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        self.popView = [[UITableView alloc] initWithFrame:self.smallFrame];
        
//        self.popView.backgroundColor = [UIColor ];
//        self.popView.backgroundColor = [UIColor redColor];
//        [self.popView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.popView.scrollEnabled = NO;
        self.popView.delegate = self;
        self.popView.dataSource = self;
        //[self.popView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = self.bgColor;
        [self addSubview:bgView];
        
        [self addSubview:self.popView];
            [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
        
                                 self.popView.frame = self.bigFrame;
        
                             }
                             completion:NULL
             ];
        
        if (self.cellType == 1) {
            [self.popView registerNib:[UINib nibWithNibName:@"GYPopViewCell1" bundle:nil] forCellReuseIdentifier:@"CELL1"];
        }else if (self.cellType==5)
        {
        [self.popView registerNib:[UINib nibWithNibName:@"GYPopViewCell1" bundle:nil] forCellReuseIdentifier:@"CELL1"];
        
        }
        else{
            [self.popView registerNib:[UINib nibWithNibName:@"GYPopViewCell2" bundle:nil] forCellReuseIdentifier:@"CELL2"];
        
        }
        
        
    }
    return self;
}


//选中cell之后，缩放动画
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.popView.frame = self.smallFrame;
                    }
                     completion:NULL
     ];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeView];
}

-(void)removeView
{
    [self.popView removeFromSuperview];
    [self removeFromSuperview];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.cellType == 1) {
        GYPopViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL1"];
        cell.lbTitle.text = self.arrData[indexPath.row];
        cell.img.image = [UIImage imageNamed:self.arrImg[indexPath.row]];
        
        return cell;
    }
    else if (self.cellType == 5)
    {
        GYPopViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL1"];
        cell.lbTitle.text = self.arrData[indexPath.row];
        cell.img.image = [UIImage imageNamed:self.arrImg[indexPath.row]];
        
        return cell;
    
    
    }
    else{
        GYPopViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL2"];
        
        cell.lbTitle.text = self.arrData[indexPath.row];
        if (indexPath.row == 0) {
            cell.lbTitle.textColor = [UIColor redColor];
            cell.lbTitle.font = [UIFont systemFontOfSize:20];
            [cell addBottomBorderWithBorderWidth:1.0f andBorderColor:[UIColor redColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.cellType == 1) {
        
      [self.delegate pushVCWithIndex:indexPath];
        
    }else if (self.cellType==3)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDataWithIndex:WithSelectRow:)])
        {
            [self.delegate deleteDataWithIndex:self.indexPath WithSelectRow:indexPath.row];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDataWithIndex:)])
        {
            [self.delegate deleteDataWithIndex:self.indexPath];
        }
    
    }else if (self.cellType==5)
    {
        NSLog(@"%d---------%d-----row",indexPath.row,indexPath.section);
      [self.delegate didSelWithIndexPath:indexPath];
        
    }
    else{
        
        switch (indexPath.row) {
                
            case 1:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDataWithIndex:WithSelectRow:)])
                {
                    [self.delegate deleteDataWithIndex:self.indexPath WithSelectRow:indexPath.row];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDataWithIndex:)])
                {
                    [self.delegate deleteDataWithIndex:self.indexPath];
                }
            }
                break;
            case 2:
            {
                [self.delegate didSelWithIndexPath:self.indexPath ];
            }
                break;
                
            default:
                break;
        }
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.popView.frame = self.smallFrame;
                         
                     }
                     completion:NULL
     ];
    
    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.2f];
  
}


@end

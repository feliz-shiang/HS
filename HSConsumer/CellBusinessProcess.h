//
//  CellBusinessProcess.h
//  HSConsumer
//
//  Created by 00 on 14-10-14.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellBusinessProcess : UITableViewCell


/*
大标题与小标题和内容为互斥控件，试用大标题控件时，需要吧小标题控件和内容控件的隐藏属性设置为YES
 如 
 cell.labContent.hidden = YES;
 cell.labTitle.hidden = YES;
*/
//设置图片
@property (weak, nonatomic) IBOutlet UIImageView *imgBPCell;
//设置大标题
@property (weak, nonatomic) IBOutlet UILabel *labBigTitle;
//设置小标题
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
//设置内容
@property (weak, nonatomic) IBOutlet UILabel *labContent;
//箭头属性
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;

@end

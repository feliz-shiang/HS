//
//  ThirdTableViewCell.h
//  DropDownDemo
//
//  Created by apple on 14-11-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//
@protocol ThirdCellSendData <NSObject>

-(void)sendDataWithTitle:(UILabel *)title WithSelectedBtn :(UIButton *)sender;

@end



#import <UIKit/UIKit.h>



@interface ThirdTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (assign,nonatomic) id <ThirdCellSendData> delegate;
-(void)refreshUIWith :(NSString *) title ;
-(void)selectOneRow;
@end

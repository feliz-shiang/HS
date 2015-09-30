//
//  GYCheckCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-5.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYCheckCellDelegate <NSObject>

-(void)pushPayViewWithURL:(NSString *)url;

@end


@interface GYCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbRow1L;
@property (weak, nonatomic) IBOutlet UILabel *lbRow1R;

@property (weak, nonatomic) IBOutlet UILabel *lbRow2L;
@property (weak, nonatomic) IBOutlet UILabel *lbRow2R;

@property (weak, nonatomic) IBOutlet UILabel *lbRow3L;
@property (weak, nonatomic) IBOutlet UILabel *lbRow3R;

@property (weak, nonatomic) IBOutlet UILabel *lbRow4L;
@property (weak, nonatomic) IBOutlet UILabel *lbRow4R;
@property (weak, nonatomic) IBOutlet UIButton *btnRow4R;

@property (weak, nonatomic) IBOutlet UILabel *lbRow5L;
@property (weak, nonatomic) IBOutlet UILabel *lbRow5R;


@property (nonatomic , assign) id<GYCheckCellDelegate> delegate;







@end

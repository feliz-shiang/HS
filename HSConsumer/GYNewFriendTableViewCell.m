//
//  GYNewFriendTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYNewFriendTableViewCell.h"
//我的新朋友 的cell
#import  "UIView+CustomBorder.h"
#import "UIImageView+WebCache.h"
#define KInfoFont [UIFont systemFontOfSize:12]


@interface GYNewFriendTableViewCell ()
- (IBAction)addFriend:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;

@end

@implementation GYNewFriendTableViewCell
{

    __weak IBOutlet UIImageView *imgvAvatarIcon;

    __weak IBOutlet UILabel *lbUserName;

}

- (void)awakeFromNib
{
    
    // Initialization code
  
    
   
    
    
}

//设置分割线方法。
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    view.layer.borderWidth=width;
    view.layer.masksToBounds=YES;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUIWith:(GYNewFiendModel *)model
{
    self.btnAdd.titleLabel.font = KInfoFont;// add by songjk
    self.btnAdd.titleLabel.textAlignment = UITextAlignmentRight;
    lbUserName.text=model.strFriendName;
    [imgvAvatarIcon sd_setImageWithURL:[NSURL URLWithString:model.strFriendIconURL] placeholderImage: [UIImage imageNamed:@"im_img_man.png" ]];
  
    NSLog(@"%@--------friendName",model.strFriendName);
    if (model.strFriendName.length>0) {
        lbUserName.text=model.strFriendName;
    }else
    {
        lbUserName.text=model.strAccountNo;
    }
    
    switch (model.friendStatus) {
        case kAskForAdd:
        {
         [self.btnAdd setTitle:@"添加" forState:UIControlStateNormal];
             self.btnAdd.enabled=YES;
        [self.btnAdd setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
         [self setBorderWithView:self.btnAdd WithWidth:1 WithRadius:3.0 WithColor:kNavigationBarColor];
        }
            break;
        case kAgreeForAdd:
        {
            if (self.fromAddFriendVc) {
                   [self.btnAdd setTitle:@"好友已添加" forState:UIControlStateNormal];
            }else
            {
             [self.btnAdd setTitle:@"通过验证" forState:UIControlStateNormal];
            }
            self.btnAdd.enabled=NO;
            [self.btnAdd setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
            self.btnAdd.layer.borderWidth=0;
        }
            break;
        case kRefuseForAdd:
        {
            
        }
            break;
        case kDeleteFriend:
        {
    
        }
            break;
        case kAskForAuth:
        {
            [self.btnAdd setTitle:@"等待验证" forState:UIControlStateNormal];
            self.btnAdd.enabled=NO;
            [self.btnAdd setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
            self.btnAdd.layer.borderWidth=0;
        }
            break;
      
            
        default:
            break;
    }
   


}


-(void)test:(NSString *)str
{


    lbUserName.text=str;


}


- (IBAction)addFriend:(UIButton *)sender {
}
@end

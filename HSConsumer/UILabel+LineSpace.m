//
//  UILabel+LineSpace.m
//  HSConsumer
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "UILabel+LineSpace.h"

@implementation UILabel (LineSpace)
-(void)setLineSpace :  (CGFloat)spaceCout WithLabel :(UILabel *)label   WithText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:spaceCout];//调整行间距
    
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0")) {
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        label.attributedText = attributedString;
    }
   
 
    [label sizeToFit];

}
@end

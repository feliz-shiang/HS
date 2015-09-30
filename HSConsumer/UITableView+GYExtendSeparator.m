//
//  UITableView+GYExtendSeparator.m
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "UITableView+GYExtendSeparator.h"

@implementation UITableView (GYExtendSeparator)


-(void)tableviewExtendSeparator
{
    

        
    
            if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                
                [self setSeparatorInset:UIEdgeInsetsZero];
                
            }
            
//            if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
//                
//                [self setLayoutMargins:UIEdgeInsetsZero];
//                
//            }
    
        
        
 
    
    


}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
    
}

@end

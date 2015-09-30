//
//  GYBigPic.m
//  HSConsumer
//
//  Created by 00 on 15-3-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYBigPic.h"

@implementation GYBigPic
{
    CGRect screen ;
    UIImageView *imgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        screen = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(screen.size.width/2, screen.size.height/2 - 32, 0, 0)];
        
        self.frame = screen;
        self.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCilck)];
        
        
        [self addGestureRecognizer:tap];
        
        [self addSubview:imgView];
        
        self.hidden = YES;
        NSLog(@"初始化了");
    }
    return self;
}


//图片点击手势
-(void)tapCilck
{
    
    self.hidden = YES;
    

}

-(void)showView:(UIImage *)image
{
    [self.vc.view addSubview:self];
    NSLog(@"%f",image.size.height);
    imgView.image = image;
    imgView.frame = [self imgFrame:image];
    
    self.hidden = NO;
}

-(CGRect)imgFrame:(UIImage *)image
{
    CGRect imgFrame;
    imgFrame = CGRectMake(0, (kScreenHeight - image.size.height*kScreenWidth/image.size.width)/2 - 32,  kScreenWidth, image.size.height*kScreenWidth/image.size.width);
    
    return imgFrame;
}

@end

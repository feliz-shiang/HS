//
//  GYImgVC.m
//  HSConsumer
//
//  Created by 00 on 15-3-17.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYImgVC.h"
#import "UIImageView+WebCache.h"


@interface GYImgVC ()
{

    __weak IBOutlet UIImageView *img;
 
    __weak IBOutlet UIScrollView *mainScrollview;
    
}
@end

@implementation GYImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    img.userInteractionEnabled=YES;
    
   
    
    // 设置初始的缩放比例
    
    DDLogInfo(@"image url:%@", self.imgUrl);
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    [img sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [Utils hideHudViewWithSuperView:self.view];

        if (error) {
            
            NSLog(@"%@",error);

//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"网络故障" message:@"请稍后再尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [av show];
            
        }else{
            img.frame = [self imgFrame:image];

        }
        

    }];
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    mainScrollview.contentSize=img.frame.size;
    //设置实现缩放
    //设置代理scrollview的代理对象
    mainScrollview.delegate=self;
    mainScrollview.showsHorizontalScrollIndicator=NO;
    mainScrollview.showsVerticalScrollIndicator=NO;
    //设置最大伸缩比例
    mainScrollview.maximumZoomScale=2.0;
    //设置最小伸缩比例
    mainScrollview.minimumZoomScale=0.5;

    
    

}


//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
       return img;
}


-(CGRect)imgFrame:(UIImage *)image
{
    CGRect imgFrame;
    imgFrame = CGRectMake(0, 0,  kScreenWidth, image.size.height*kScreenWidth/image.size.width);
 
    return imgFrame;
}
@end

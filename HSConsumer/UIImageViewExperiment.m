//
//  UIImageViewExperiment.m
//  Experiment
//
//  Created by liangzm on 15-3-6.
//
//

#define SAWTOOTH_COUNT 10
#define SAWTOOTH_WIDTH_FACTOR 20

#import "UIImageViewExperiment.h"

@interface UIImageViewExperiment()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIImageView *left;
@property (nonatomic, strong) UIImageView *right;

@end

@implementation UIImageViewExperiment
@synthesize image = _image;
@synthesize left = _left;
@synthesize right = _right;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.redView = [[UIView alloc] initWithFrame:frame];
        [self.redView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:self.redView];
        self.redView.hidden = YES;
    }
    return self;
}

- (void)setBreckImage
{
    NSArray *array = [self splitImageIntoTwoParts:self.image];
    self.left = [[UIImageView alloc] initWithFrame:self.bounds];
    self.left.image = [array objectAtIndex:0];
    self.right = [[UIImageView alloc] initWithFrame:self.bounds];
    self.right.image = [array objectAtIndex:1];
    [self addSubview:self.left];
    [self addSubview:self.right];
    self.redView.hidden = NO;
    CGFloat scale =   0.015/100 * self.frame.size.width;
    self.left.transform = CGAffineTransformMakeTranslation(-160*(scale), 0);
    self.right.transform = CGAffineTransformMakeTranslation(160*(scale), 0);
}

-(NSArray *)splitImageIntoTwoParts:(UIImage *)image
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    CGFloat width,height,widthgap,heightgap;
    int piceCount = SAWTOOTH_COUNT;
    width = image.size.width;
    height = image.size.height;
    
    widthgap = width/SAWTOOTH_WIDTH_FACTOR;
    heightgap = height/piceCount;

    CGContextRef context;
    CGImageRef imageMasked;
    UIImage *leftImage,*rightImage;
    
    //part one
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, 0, 0);
    int a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, 0, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [image drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    leftImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:leftImage];
    UIGraphicsEndImageContext();
    
    //part two
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, width, 0);
    a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, width, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [image drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    rightImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:rightImage];
    UIGraphicsEndImageContext();
    
    return array;
}

@end

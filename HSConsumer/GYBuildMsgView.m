//
//  GYBuildMsgView.m
//  HSConsumer
//
//  Created by 00 on 15-1-30.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//


#define FaceBoardHeight 165
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 162


#import "GYBuildMsgView.h"
#import "GYChatItem.h"


@implementation GYBuildMsgView



//图文混排

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

-(UIView *)assembleMessageAtIndex : (NSString *) message{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    __block CGFloat upX = 0;
    __block CGFloat upY = 0;
    __block CGFloat X = 0;
    __block CGFloat Y = 0;
    if (data)
    {
        for (int i=0;i < [data count];i++)
        {
            UIImage *chatImg=nil;
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 162;
                    Y = upY;
                }
                NSString *imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                chatImg = img.image;
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<162) X = upX;
            }
            if (chatImg == nil)
            {
                NSRange rangeStr = NSMakeRange(0, str.length);
                [str enumerateSubstringsInRange:rangeStr options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    NSString *temp = substring;
                    if (upX >= MAX_WIDTH || [temp isEqualToString:@"\n"])
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 162;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(160, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<162) {
                        X = upX;
                    }
                }];
                
//                for (int j = 0; j < [str length]; j++)
//                {
//                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
//                    if (upX >= MAX_WIDTH || [temp isEqualToString:@"\n"])// modify by songjk
//                    {
//                        upY = upY + KFacialSizeHeight;
//                        upX = 0;
//                        X = 162;
//                        Y =upY;
//                    }
//                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(160, 40)];
//                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
//                    la.font = fon;
//                    la.text = temp;
//                    la.backgroundColor = [UIColor clearColor];
//                    [returnView addSubview:la];
//                    upX=upX+size.width;
//                    if (X<162) {
//                        X = upX;
//                    }
//                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y + 39); //@ 需要将该view的尺寸记下，方便以后使用
    
    return returnView;
}

@end

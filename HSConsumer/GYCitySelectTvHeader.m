//
//  GYCitySelectTvHeader.m
//  HSConsumer
//
//  Created by apple on 15-5-5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYCitySelectTvHeader.h"
#import "GYseachhistoryModel.h"
@implementation GYCitySelectTvHeader
{
    NSString * cityTitleString;

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
    }
    return self;

}

+(id)headerView
{
   
    return [[NSBundle mainBundle]loadNibNamed:@"GYCitySelectTvHeader" owner:nil options:nil][0];
}

-(void)drawRect:(CGRect)rect
{
    NSArray * arrTitle =[NSArray arrayWithObjects:@"北京",@"上海",@"广州",@"西安",@"厦门",@"深圳",@"天津",@"武汉",@"长沙", nil];
    NSArray * arrBtn =[NSArray arrayWithObjects:self.btn1,self.Btn2,self.Btn3,self.Btn4,self.Btn5,self.Btn6,self.Btn7,self.Btn8,self.Btn9,self.Btn10,self.Btn11,self.Btn12,self.Btn13,self.Btn14, nil];

    
    self.lbAllCity.text=@"全部城市";
    self.lbHotCity.text=@"热门城市";
    self.lbLocationCity.text=@"定位城市";
    
    //添加横线
    CALayer *localLayer=[[CALayer alloc]init];
    localLayer.frame=CGRectMake(80, 10, 320, 1);
    localLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
    CALayer *seachLayer=[[CALayer alloc]init];
    seachLayer.frame=CGRectMake(80, 10, 320, 1);
    seachLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
    CALayer *hotLayer=[[CALayer alloc]init];
    hotLayer.frame=CGRectMake(80, 10, 320, 1);
    hotLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
    CALayer *allCityLayer=[[CALayer alloc]init];
    allCityLayer.frame=CGRectMake(80, 10, 320, 1);
    allCityLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
    [self.lbLocationCity.layer addSublayer:localLayer];
    [self.lbHotCity.layer addSublayer:hotLayer];
    [self.lbAllCity.layer addSublayer:allCityLayer];
    [self.lbseachCity.layer addSublayer:seachLayer];
    
    for (int i=1; i<=9; i++) {
        [self setBtnWithTitle:arrTitle[i-1] WithBackgroundColor:[UIColor whiteColor] WithBoderWidth:0.5 WithButton:arrBtn[i-1]];
    }
    for (int j=0; j<self.histyArry.count; j++) {
        GYseachhistoryModel *model=self.histyArry[j];
        
        [self setBtnWithTitle:model.name WithBackgroundColor:[UIColor whiteColor] WithBoderWidth:0.5f WithButton:arrBtn[9+j]];
        
    }

}

-(void)setBtnWithTitle:(NSString *)titile WithBackgroundColor :(UIColor *)color WithBoderWidth:(CGFloat) width WithButton:(UIButton *)sender
{
    sender.hidden=NO;
    [sender setTitle:titile forState:UIControlStateNormal];
    [sender setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.layer.masksToBounds=YES;
    sender.layer.borderWidth=width;
    sender.layer.cornerRadius=1.0;
    sender.layer.borderColor=kCellItemTextColor.CGColor;
    
}

-(void)setLocationBtn:(NSString * )cityTitle
{

//    [self setBtnWithTitle:cityTitle WithBackgroundColor:nil WithBoderWidth:1.0 WithButton:self.BtnLocationCity];
    [self setHidden:NO];
    [self setBtnWithTitle:[NSString stringWithFormat:@"%@市",cityTitle] WithBackgroundColor:nil WithBoderWidth:1.0 WithButton:self.BtnLocationCity];
    
}
@end

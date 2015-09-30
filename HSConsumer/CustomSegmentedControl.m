//
//  CustomSegmentedControl.m
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CustomSegmentedControl.h"
#define segment_corner 3.0

@interface CustomSegmentedControl()
{
    NSUInteger currentSelected;

}
@property (nonatomic,strong) NSMutableArray *segments;
@property (nonatomic,strong) NSMutableArray *separators;
@property (nonatomic,copy) selectionBlock selBlock;
@end

@implementation CustomSegmentedControl

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items andSelectionBlock:(selectionBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selBlock=block;
        
        self.backgroundColor=[UIColor clearColor];
        
        float buttonWith=frame.size.width / items.count;
        int i = 0;
        for(NSString *item in items)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWith * i, 0, buttonWith, frame.size.height)];
        
            [button setTitle:item forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.segments addObject:button];
            [self addSubview:button];
            
            if(i != 0)
            {
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWith, 0, self.borderWidth, frame.size.height)];
                [self addSubview:separatorView];
                [self.separators addObject:separatorView];
            }
            i++;
        }
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = segment_corner;
        currentSelected=0;
    }
    return self;
}

- (NSMutableArray*)segments
{
    if(!_segments) _segments = [[NSMutableArray alloc] init];
    return _segments;
}

- (NSMutableArray*)separators
{
    if(!_separators) _separators = [[NSMutableArray alloc] init];
    return _separators;
}

- (void)segmentSelected:(id)sender
{
    if(sender)
    {
        NSUInteger selectedIndex = [self.segments indexOfObject:sender];
        if (selectedIndex != currentSelected)
        {
            [self setEnabled:YES forSegmentAtIndex:selectedIndex];
            if(self.selBlock)
            {
                self.selBlock(selectedIndex);
            }
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)index
{
    if (index == currentSelected) return;
    if(index < self.segments.count)
    {
        currentSelected = index;
        [self updateSegmentsFormat];
        [self segmentSelected:self.segments[index]];
    }
}

- (NSUInteger)selectedIndex
{
    return currentSelected;
}

- (void)updateSegmentsFormat
{
    if(self.borderColor)
    {
        self.layer.borderWidth = self.borderWidth;
        self.layer.borderColor = self.borderColor.CGColor;
    }else
    {
        self.layer.borderWidth = 0;
    }
    
    for(UIView *separator in self.separators)
    {
        separator.backgroundColor = self.borderColor;
        separator.frame = CGRectMake(separator.frame.origin.x, separator.frame.origin.y,self.borderWidth , separator.frame.size.height);
    }
    
    for (UIButton *segment in self.segments)
    {
        
        if([self.segments indexOfObject:segment] == currentSelected)
        {
            if(self.selectedColor)
            {
                [segment setBackgroundColor:self.selectedColor];
                [segment setTitleColor:self.selectedTextColor ? self.selectedTextColor : self.color forState:UIControlStateNormal];
            }
        }else
        {
            if(self.color)
            {
                [segment setBackgroundColor:self.color];
                [segment setTitleColor:self.textColor ? self.textColor : self.selectedColor forState:UIControlStateNormal];
            }
        }
        segment.titleLabel.textAlignment = UITextAlignmentCenter;
        [segment.titleLabel setFont:self.textFont];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self updateSegmentsFormat];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self updateSegmentsFormat];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateSegmentsFormat];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index
{
    if(index < self.segments.count)
    {
        UIButton *segment = self.segments[index];
        [segment setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor=borderColor;
    [self updateSegmentsFormat];
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{    
    if(enabled)
    {
        currentSelected = segment;
        [self updateSegmentsFormat];
    }
}

@end


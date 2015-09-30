//
//  CustomSegmentedControl.h
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^selectionBlock)(NSUInteger segmentIndex);//块回调

@interface CustomSegmentedControl : UIView

@property (nonatomic) NSUInteger selectedIndex;     //当前选中的项
@property (nonatomic,strong) UIColor *color;        //SegmentedControl 未选中时的背景颜色
@property (nonatomic,strong) UIColor *selectedColor;//SegmentedControl 选中时的背景颜色

@property (nonatomic,strong) UIColor *textColor;        //title 未选中时的字体颜色 可选；  如果没有设置，则为 selectedColor---SegmentedControl 选中时的背景颜色
@property (nonatomic,strong) UIColor *selectedTextColor;//title 选中时的字体颜色 可选； 如果没有设置，则为 color---SegmentedControl 未选中时的背景颜色

@property (nonatomic,strong) UIFont *textFont;      //title 字体
@property (nonatomic,strong) UIColor *borderColor;  //SegmentedControl外框颜色
@property (nonatomic) CGFloat borderWidth;          //SegmentedControl外框宽度

/**
 * 自定义SegmentedControl 唯一生效的实例化方法
 *
 *	@param 	frame 	自定义SegmentedControl 的frame
 *	@param 	items 	标题数组
 *	@param 	block 	块回调
 *
 *	@return	实例化
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items andSelectionBlock:(selectionBlock)block;

/**
 *	修改指定位置的title
 *
 *	@param 	title 	new title
 *	@param 	index 	要设置的位置
 */
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;

@end

//
//  AboutHS.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "AboutHS.h"
#import "RTLabel.h"

@interface AboutHS ()
{
    IBOutlet UIScrollView *scrContainer;
}
@end

@implementation AboutHS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    [scrContainer setBackgroundColor:[UIColor whiteColor]];
    CGRect tFrame = CGRectMake(16, 0, scrContainer.frame.size.width - 16*2, scrContainer.frame.size.height);
    RTLabel *tlabel = [[RTLabel alloc] initWithFrame:tFrame];
    tlabel.lineSpacing = 12.0f;
    [tlabel setTextAlignment:RTTextAlignmentJustify];

    NSString *content = @"解决原理是以“资源整合、互利共赢”为主要内涵，以科技、金融、企业和消费者为一体的互生网络系统和新型的消费权益再分配模式，全面整合社会资源，集资源共享、利益共享、金融流通、商务流通、信息交流、广告宣传、消费增值为一身，满足多方需求，用一卡通用积分帮助企业锁定消费者建立商务流通利益共同体，用互生网络系统将消费积分进行复合应用，给企业带来新的盈利点给消费者带来消费增值，最终实现企业和消费者的永续保障。";
    tlabel.text = [NSString stringWithFormat:@"<font size=16 color='#474443'><p indent=32>%@</p></font>", content];
    [scrContainer addSubview:tlabel];

    CGSize optimumSize = [tlabel optimumSize];
    tlabel.frame = CGRectMake(tlabel.frame.origin.x,
                              tlabel.frame.origin.y - tlabel.lineSpacing,
                              tlabel.frame.size.width,
                              optimumSize.height);
    
    scrContainer.contentSize = CGSizeMake(scrContainer.frame.size.width,
                                          tlabel.optimumSize.height + tlabel.lineSpacing);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  GYAccidentInfoController.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/28.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYAccidentInfoController.h"

#define kTitleFont [UIFont systemFontOfSize:15]
#define kDetialFont [UIFont systemFontOfSize:13]

@interface GYAccidentInfoController ()

@end

@implementation GYAccidentInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settings];
}
-(void)settings
{
    self.title = @"意外伤害保障条款";
    CGFloat svBackH = kScreenHeight - self.navigationController.navigationBar.frame.size.height;
    if (kSystemVersionLessThan(@"6.9")) {
        svBackH -= 20;
    }
    CGRect frame = self.view.bounds;
    frame.size.height = svBackH;
    UIScrollView * svBack = [[UIScrollView alloc] initWithFrame:frame];
    svBack.backgroundColor = kDefaultVCBackgroundColor;
    svBack.scrollEnabled = YES;
    [self.view addSubview:svBack];
    
    CGFloat margin = 20;
    CGFloat border = 16;
    NSArray * arrTitle = @[@"第一条 保障范围",@"第二条 保障期间和续保",@"第三条 保障责任",@"第四条 责任免除",@"第五条 保障金额",@"第六条 保障金申请所需证明和资料",@"第七条 保障金申请",@"第八条 释义"];
    NSArray * arrDetial = @[@"自互生卡实名注册成功次日零点起每年内累计积分总数达到300分以上的互生卡合法持卡人（以下称互生人），均是互生意外伤害保障的被保障人。本保障计划由互生系统平台（以下称平台）从总消费积分收益中提取2%作为此计划的保障基金，免费赠送给符合条件的互生积分卡合法持有人。",
                            @"本保障计划的保障有效期间为一年，自互生人实名注册成功次日零点起开始累计，首次累计积分总数达到300分以上次日零时起至规定终止日二十四时止。 互生人在本保障一年的有效期间内，积分累计总数达到300分以上，新的保障计划于保障期间届满的次日零时起自动延续有效一年，以此类推！ 互生人在超出本保障一年的有效期间，积分累计总数达到300分以上的，新的保障于积分累计总数达到300分以上次日零时起至规定终止日二十四时止。 本保障可按上述方式续保至被保障人获得由平台推出的免费医疗补贴计划后就不再享受此项积分福利。 本保障生效后，若统计周期内的积分累计总数连续七天低于300分时，导致本保障终止的，新的保障起始日以累计积分总数再次达到300分次日零时起开始计算。",
                            @"在本保障有效期间内，互生系统平台依下列约定承担保障责任：\r\n1、被保障人遭受意外伤害，并自该意外伤害发生之日起一百八十日内因该意外伤害身故，本平台按承诺的保障金额给付身故保障金，本保障终止。\r\n2、被保障人遭受意外伤害，对被保障人每次意外伤害事故所发生并实际支出的符合当地社会基本医疗保险支付范围的医疗费用，本平台在扣除当地社会基本医疗保险、对其余额按本保障约定累计给付不得超过3000元人民币的医疗保障金。当一次或累计给付的保障金达到最高3000元人民币医疗保障金额时，本意外伤害医疗保障终止。\r\n3、被保障人在保障有效期间内，积分账户因积分撤单导致统计周期内的积分累计总数连续七天低于300分时，本保障终止。",
                            @"（一）因被保障人积分账户由于积分撤单导致统计周期内的积分累计总数低于300分之日，出现意外伤害导致被保障人身故或产生医疗费用支出的，本平台不承担给付保障金的责任。\r\n（二）因下列情形之一，导致被保障人身故的，本平台不承担给付保障金的责任：\r\n一、被保障人故意犯罪或抗拒依法采取的刑事强制措施；\r\n二、被保障人自杀或故意自伤；\r\n三、被保障人醉酒，服用、吸食或注射毒品；\r\n四、被保障人酒后驾驶、无合法有效驾驶证驾驶或驾驶无有效行驶证的机动车；\r\n五、被保障人未遵医嘱私自使用或服用药物，但按使用说明的规定使用非处方药不在此限；\r\n六、被保障人参加潜水、跳伞、攀岩、驾乘滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高风险运动；\r\n七、被保障人的产前产后检查、妊娠（含宫外孕）、流产（含人工流产）、分娩（含剖腹产）、避孕、绝育手术、治疗不孕不育症以及上述原因引起的并发症；\r\n八、被保障人的精神和行为障碍；\r\n九、战争、军事冲突、暴乱或武装叛乱；\r\n十、核爆炸、核辐射或核污染。\r\n（三）因下列情形之一，导致被保障人支出医疗费用的，本平台不承担给付保障金的责任：\r\n一、被保障人的洗牙、牙齿美白、正畸、烤瓷牙、种植牙或镶牙等牙齿保健和修复；\r\n二、被保障人在台湾、香港、澳门地区或中国境外治疗。",
                            @"本保障的意外伤害身故保障金额为人民币60000元，意外伤害医疗保障金额为人民币3000元。",
                            @"一、申请意外伤害身故保障金时，所需的证明和资料为：\r\n1．注册并经实名认证过的互生积分卡；\r\n2．申请人的法定身份证明；\r\n3．公安部门或二级以上(含二级)医院出具的被保障人死亡证明书；\r\n4．如被保障人为宣告死亡，申请人须提供公安局出具的宣告死亡证明文件；\r\n5．被保障人的户籍注销证明；\r\n6．平台要求的申请人所能提供的与确认保障事故的性质、原因、伤害程度等有关的其他证明和资料；\r\n7．保障金作为被保障人遗产时，必须提供可证明合法继承权的相关权利文件。\r\n二、申请意外伤害医疗保障金时，所需的证明和资料为：\r\n1．注册并经实名认证过的互生积分卡；\r\n2．申请人的法定身份证明；\r\n3．要求申请人所能提供的与确认保障事故的性质、原因、伤害程度等相关的其他证明和资料；\r\n4．本人的医保卡号；\r\n5．没有医保卡号的被保障人需要提交以下资料：\r\n1）二级以上（含二级）医院或本平台认可的其他医疗机构出具的医疗费用原始结算凭证、诊断证明及病历等相关资料；\r\n2）对于已经从当地社会基本医疗保险、公费医疗或其他途径获得补偿或给付的，需提供相应机构或单位出具的医疗费用结算证明；\r\n3）若由代理人代为申请保障金，则还应提供授权委托书、代理人法定身份证明等文件.",
                            @"1、按上述要求登录消费者账户管理系统里进行在线申请；\r\n2、按申请需求填写内容，上传相关资料的扫描件；\r\n3、在接到平台的电话后按要求及流程办理保障费的申领工作。",
                            @"生效对应日：生效日每年（半年、季或月）的对应日为本合同每年（半年、季或月）生效对应日。意外伤害：指遭受外来的、突发的、非本意的、非疾病的客观事件直接致使身体受到的伤害。毒品：指中华人民共和国刑法规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及国家规定管制的其他能够使人形成瘾癖的麻醉药品和精神药品，但不包括由医生开具并遵医嘱使用的用于治疗疾病但含有毒品成分的处方药品。酒后驾驶：指经检测或鉴定，发生事故时车辆驾驶人员每百毫升血液中的酒精含量达到或超过一定的标准，公安机关交通管理部门依据《道路交通安全法》的规定认定为饮酒后驾驶或醉酒后驾驶。无合法有效驾驶证驾驶：指下列情形之一：\r\n（1）没有取得驾驶资格；\r\n（2）驾驶与驾驶证准驾车型不相符合的车辆；\r\n（3）持审验不合格的驾驶证驾驶；\r\n（4）持学习驾驶证学习驾车时，无教练员随车指导，或不按指定时间、路线学习驾车。无有效行驶证：指下列情形之一：\r\n（1）机动车被依法注销登记的；\r\n（2）未依法按时进行或通过机动车安全技术检验。\r\n 机动车：指以动力装置驱动或者牵引，供人员乘用或者用于运送物品以及进行工程专项作业的轮式车辆。\r\n 潜水：指使用辅助呼吸器材在江、河、湖、海、水库、运河等水域进行的水下运动。\r\n 攀岩：指攀登悬崖、楼宇外墙、人造悬崖、冰崖、冰山等运动。\r\n 探险：指明知在某种特定的自然条件下有失去生命或使身体受到伤害的危险，而故意使自己置身于其中的行为，如：江河漂流、登山、徒步穿越沙漠或人迹罕至的原始森林等活动。\r\n 武术比赛：指两人或两人以上对抗性柔道、空手道、跆拳道、散打、拳击等各种拳术及使用器械的对抗性比赛。\r\n 特技表演：指进行马术、杂技、驯兽等表演。\r\n 精神和行为障碍：以世界卫生组织颁布的《疾病和有关健康问题的国际统计分类（ICD-10）》为准。\r\n 战争：指国家与国家、民族与民族、政治集团与政治集团之间为了一定的政治、经济目的而进行的武装斗争，以政府宣布为准。\r\n 军事冲突：指国家或民族之间在一定范围内的武装对抗，以政府宣布为准。\r\n 暴乱：指破坏社会秩序的武装骚动，以政府宣布为准。"];
    
    CGFloat lbTitleW= 200;
    CGFloat lbTitleH = 20;
    CGFloat lbTitleY = 20;
    CGFloat lbTitleX = (kScreenWidth - lbTitleW)*0.5;
    UILabel * lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(lbTitleX, lbTitleY, lbTitleW, lbTitleH)];
    lbTitle.textColor = [UIColor redColor];
    lbTitle.font = [UIFont systemFontOfSize:16];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textAlignment = UITextAlignmentCenter;
    lbTitle.text = @"互生意外伤害保障条款";
    [svBack addSubview:lbTitle];
    
    CGFloat titleY = CGRectGetMaxY(lbTitle.frame) + margin;
    CGFloat titleW = kScreenWidth - border*2;
    CGFloat titleH = 20;
    
    CGFloat lbDetailX = border;
    CGFloat lbDetailW = kScreenWidth - lbDetailX*2;
    
    for (int i = 0; i<arrTitle.count; i++)
    {
        NSString *strTitle = arrTitle[i];
        NSString *strDetail = arrDetial[i];
        UILabel * lbDetailTitle = [[UILabel alloc] initWithFrame:CGRectMake(border, titleY, titleW, titleH)];
        lbDetailTitle.textColor = kCellItemTitleColor;
        lbDetailTitle.font = kTitleFont;
        lbDetailTitle.backgroundColor = [UIColor clearColor];
        lbDetailTitle.textAlignment = UITextAlignmentLeft;
        lbDetailTitle.text = strTitle;
        
        CGFloat lbDetailY = CGRectGetMaxY(lbDetailTitle.frame) + margin;
        CGSize detailSize = [Utils sizeForString:strDetail font:kDetialFont width:lbDetailW];
        CGFloat lbDetalH = detailSize.height;
        UILabel * lbDetailInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbDetailX, lbDetailY, lbDetailW, lbDetalH)];
        lbDetailInfo.numberOfLines = 0;
        lbDetailInfo.textColor = kCellItemTextColor;
        lbDetailInfo.font = kDetialFont;
        lbDetailInfo.backgroundColor = [UIColor clearColor];
        lbDetailInfo.textAlignment = UITextAlignmentLeft;
        lbDetailInfo.text = strDetail;
        
        CGFloat updateH = CGRectGetMaxY(lbDetailInfo.frame);
        titleY = (updateH+margin);
        [svBack addSubview:lbDetailTitle];
        [svBack addSubview:lbDetailInfo];
        if (i == arrTitle.count-1)
        {
            [svBack setContentSize:CGSizeMake(0, titleY)];
        }
    }
//    CGFloat tvDetailX = 16;
//    CGFloat tvDetailY = CGRectGetMaxY(lbTitle.frame) + 20;
//    CGFloat tvDetailW= kScreenWidth - tvDetailX*2;
//    CGFloat tvDetailH = kScreenHeight - tvDetailY;
//    if (kSystemVersionLessThan(@"6.9"))
//    {
//        tvDetailH -= 20;
//    }
//    UITextView * tvDetail = [[UITextView alloc] initWithFrame:CGRectMake(tvDetailX, tvDetailY, tvDetailW, tvDetailH)];
//    tvDetail.editable = NO;
//    tvDetail.userInteractionEnabled = YES;
//    NSString * strPath = [[NSBundle mainBundle] pathForResource:@"accidentInfo" ofType:@"txt"];
//    NSData * data = [NSData dataWithContentsOfFile:strPath];
//    NSString * strInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
//    tvDetail.text = strInfo;
//    [svBack addSubview:tvDetail];
}
@end

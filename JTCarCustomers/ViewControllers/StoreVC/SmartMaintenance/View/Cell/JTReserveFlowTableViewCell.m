//
//  JTReserveFlowTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTReserveFlowTableViewCell.h"

@interface JTReserveFlowTableViewCell ()

@end

@implementation JTReserveFlowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setupViews {
    NSArray *contents = @[@"选择项目", @"选择门店", @"选择师傅", @"提交预约"];
    NSArray *icons = @[@"icon_project_seleted", @"icon_mendian_seleted", @"icon_master_seleted", @"icon_time_seleted"];
    CGFloat xspace = (kIsIphone4s || kIsIphone5)?40:47;
    CGFloat originX = (App_Frame_Width-160-xspace*3)/2.0;
    for (int i = 0; i < contents.count; i++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(originX+(xspace+40)*i, 20, 40, 40)];
        iconView.image = [UIImage imageNamed:icons[i]];
        [self.contentView addSubview:iconView];
        
        UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame)+8, 60, 20)];
        contentLB.font = Font(14);
        contentLB.textColor = BlackLeverColor6;
        contentLB.text = contents[i];
        contentLB.textAlignment = NSTextAlignmentCenter;
        contentLB.centerX = iconView.centerX;
        [self.contentView addSubview:contentLB];
        
        if (i != contents.count-1) {
            UIImageView *flowView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame), CGRectGetMidY(iconView.frame)-0.5, xspace, 1)];
            [self.contentView addSubview:flowView];
            [self drawDashLine:flowView lineLength:3 lineSpacing:2 lineColor:BlueLeverColor1];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame)/2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


@end

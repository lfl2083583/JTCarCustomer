//
//  JTReserveFlowDetailTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTReserveFlowDetailTableViewCell.h"


@implementation JTDashLineView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)/2.0)];
    [shapeLayer setFillColor:WhiteColor.CGColor];
    [shapeLayer setStrokeColor:BlueLeverColor1.CGColor];
    [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:2], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(rect));
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

@end

@implementation JTReserveFlowDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.flowView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.subtitleLB];
        
        __weak typeof(self)weakSelf = self;
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconView.mas_right).offset(15);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(20);
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconView.mas_right).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.titleLB.mas_bottom);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-35);
        }];
        
        [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.equalTo(weakSelf.iconView.mas_bottom);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.centerX.equalTo(weakSelf.iconView.mas_centerX);
        }];
        
        self.userInteractionEnabled = NO;
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (JTDashLineView *)flowView {
    if (!_flowView) {
        _flowView = [[JTDashLineView alloc] init];
    }
    return _flowView;
}


- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.font = Font(14);
        _subtitleLB.textColor = BlackLeverColor3;
        _subtitleLB.numberOfLines = 0;
    }
    return _subtitleLB;
}

@end

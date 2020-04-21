//
//  JTActivityJoinTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityJoinTableViewCell.h"

@implementation JTCircleButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(rect.size.height/2.0, rect.size.height/2.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end


@interface JTActivityJoinTableViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGuester;
@property (nonatomic, copy) id source;

@end

@implementation JTActivityJoinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addsubView];
        [self layoutSubViews];
        self.contentView.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapGuester];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addsubView {
    self.groupCountLB = [self creatLabelWithFont:Font(14) textColor:BlackLeverColor3];
    self.themeLB = [self creatLabelWithFont:Font(14) textColor:BlackLeverColor4];
    self.timeLB = [self creatLabelWithFont:Font(14) textColor:BlackLeverColor4];
    self.siteLB = [self creatLabelWithFont:Font(14) textColor:BlackLeverColor4];
    self.leftImgeView = [[UIImageView alloc] init];
    self.leftImgeView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImgeView.clipsToBounds = YES;
    self.rightBtn = [[JTCircleButton alloc] init];
    self.rightBtn.titleLabel.font = Font(12);
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomView = [[UIView alloc] init];
    self.rightBtn.backgroundColor = BlueLeverColor2;
    self.bottomView.backgroundColor = WhiteColor;
    self.contentView.backgroundColor = BlackLeverColor1;
    self.bottomView.clipsToBounds = YES;
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.leftImgeView];
    [self.contentView addSubview:self.themeLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.siteLB];
    [self.contentView addSubview:self.groupCountLB];
    [self.bottomView addSubview:self.rightBtn];
}

- (void)layoutSubViews {
    __weak typeof(self)weakSelf = self;
    [self.leftImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 105));
        make.left.equalTo(weakSelf.contentView.mas_left).offset(25);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
    }];
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImgeView.mas_right).offset(25);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(25);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeLB.mas_left);
        make.right.equalTo(weakSelf.themeLB.mas_right);
        make.top.equalTo(weakSelf.themeLB.mas_bottom).offset(5);
    }];
    [self.siteLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeLB.mas_left);
        make.right.equalTo(weakSelf.themeLB.mas_right);
        make.top.equalTo(weakSelf.timeLB.mas_bottom).offset(5);
    }];
    [self.groupCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeLB.mas_left);
        make.right.equalTo(weakSelf.themeLB.mas_right);
        make.top.equalTo(weakSelf.siteLB.mas_bottom).offset(10);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 30));
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-18);
        make.right.equalTo(weakSelf.bottomView.mas_right).offset(0);
    }];
}

- (void)rightBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(joinActivityTeamSource:)]) {
        [_delegate joinActivityTeamSource:self.source];
    }
}

- (void)tapGuesterAction:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(activityJoinTableViewCellTapped:)]) {
        [_delegate activityJoinTableViewCellTapped:self.indexPath];
    }
}

- (void)configActivityJoinTableViewCellWithSource:(id)source indexPath:(NSIndexPath *)indexPath {
    if (source && [source isKindOfClass:[NSDictionary class]]) {
        self.source = source;
        self.indexPath = indexPath;
        [self.leftImgeView sd_setImageWithURL:[NSURL URLWithString:[source[@"image"] avatarHandleWithSize:CGSizeMake(80, 105)]]];
        self.themeLB.text = [NSString stringWithFormat:@"主题：%@",source[@"theme"]];
        self.timeLB.text = [NSString stringWithFormat:@"时间：%@",source[@"time"]];
        self.siteLB.text = [NSString stringWithFormat:@"地点：%@",source[@"address"]];
        NSString *teamCount = [NSString stringWithFormat:@"%@人",source[@"count"]];
        NSString *str = [NSString stringWithFormat:@"活动人数  %@",teamCount];
        self.groupCountLB.text = str;
        [Utility richTextLabel:self.groupCountLB fontNumber:Font(14) andRange:NSMakeRange(str.length-teamCount.length, teamCount.length) andColor:BlueLeverColor1];
        int status = [source[@"status"] intValue];
        if (status == 3) {
            self.rightBtn.backgroundColor = BlueLeverColor1;
            [self.rightBtn setTitle:@"加入群聊" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(67);
            }];
        }
        else
        {
            self.rightBtn.backgroundColor = BlackLeverColor1;
            [self.rightBtn setTitle:@"进入活动群聊" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(88);
            }];
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

- (UILabel *)creatLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 1;
    return label;
}

- (UITapGestureRecognizer *)tapGuester {
    if (!_tapGuester) {
        _tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuesterAction:)];
        _tapGuester.numberOfTapsRequired = 1;
    }
    return _tapGuester;
}

@end

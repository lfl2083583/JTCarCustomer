//
//  JTActivityCommentTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityCommentTableViewCell.h"

@interface JTActivityCommentTableViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGuester;

@end

@implementation JTActivityCommentTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self layoutViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configJTActivityCommentTableViewCellCommentInfo:(id)commentInfo indexPath:(NSIndexPath *)indexPath {
    if (commentInfo && [commentInfo isKindOfClass:[NSDictionary class]]) {
        self.indexPath = indexPath;
        [self.avatarView setAvatarByUrlString:[commentInfo[@"avatar"] avatarHandleWithSquare:40] defaultImage:DefaultSmallAvatar];
        self.userNameLB.text = commentInfo[@"nick_name"];
        self.commentLB.text = commentInfo[@"content"];
        self.timeLB.text = [Utility showTime:[commentInfo[@"create_time"] integerValue] showDetail:NO];
        BOOL isComment = [commentInfo[@"is_comment"] boolValue];
        __weak typeof(self)weakSelf = self;
        if (!isComment)
        {
            self.replyNameLB.text = commentInfo[@"comment"][@"nick_name"];
            self.replyLB.text = commentInfo[@"comment"][@"content"];
            [self.replyNameLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.commentLB.mas_bottom).offset(10);
            }];
        }
        else
        {
            self.replyNameLB.text = @"";
            self.replyLB.text = @"";
            [self.replyNameLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.commentLB.mas_bottom).offset(0);
            }];
        }
    }
}

- (void)tapGuesterAction:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.contentView];
    if (CGRectContainsPoint(self.commentLB.frame, point) || CGRectContainsPoint(self.userNameLB.frame, point))
    {
        if (_delegate && [_delegate respondsToSelector:@selector(activityCommentCellCommentContentResponse:)]) {
            [_delegate activityCommentCellCommentContentResponse:self.indexPath];
        }
    }
    else if (CGRectContainsPoint(self.replyNameLB.frame, point) || CGRectContainsPoint(self.replyLB.frame, point))
    {
        if (_delegate && [_delegate respondsToSelector:@selector(activityCommentCellReplyContentResponse:)]) {
            [_delegate activityCommentCellReplyContentResponse:self.indexPath];
        }
    }
}

- (void)setupSubviews {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.userNameLB];
    [self.contentView addSubview:self.commentLB];
    [self.contentView addSubview:self.replyNameLB];
    [self.contentView addSubview:self.replyLB];
    [self.contentView addSubview:self.verticalView];
    [self.contentView addSubview:self.horizontalView];
    [self.contentView addSubview:self.genterView];
    [self.contentView addSubview:self.timeLB];
    self.contentView.backgroundColor = BlackLeverColor1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:self.tapGuester];
}

- (void)layoutViews {
    __weak typeof(self)weakSelf = self;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo (weakSelf.contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
    }];
    [self.commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userNameLB.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.top.equalTo(weakSelf.userNameLB.mas_bottom).offset(5);
    }];
    [self.replyNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.commentLB.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.commentLB.mas_left).offset(5);
        make.right.equalTo(weakSelf.commentLB.mas_right);
    }];
    [self.replyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.replyNameLB.mas_bottom);
        make.left.equalTo(weakSelf.replyNameLB.mas_left);
        make.right.equalTo(weakSelf.commentLB.mas_right);
    }];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.left.equalTo(weakSelf.commentLB.mas_left);
        make.top.equalTo(weakSelf.replyNameLB.mas_top);
        make.bottom.equalTo(weakSelf.replyLB.mas_bottom);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.replyLB.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.commentLB.mas_left);
        make.right.equalTo(weakSelf.commentLB.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
    }];
    [self.genterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 12));
        make.left.equalTo(weakSelf.userNameLB.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.userNameLB.mas_centerY);
    }];
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(35);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ZTCirlceImageView alloc] init];
    }
    return _avatarView;
}

- (UILabel *)userNameLB {
    if (!_userNameLB) {
        _userNameLB = [self createLBTextColor:BlackLeverColor3 font:Font(14)];
    }
    return _userNameLB;
}

- (UILabel *)commentLB {
    if (!_commentLB) {
        _commentLB = [self createLBTextColor:BlackLeverColor6 font:Font(18)];
    }
    return _commentLB;
}

- (UILabel *)replyNameLB {
    if (!_replyNameLB) {
        _replyNameLB = [self createLBTextColor:BlackLeverColor3 font:Font(12)];
    }
    return _replyNameLB;
}

- (UILabel *)replyLB {
    if (!_replyLB) {
        _replyLB = [self createLBTextColor:BlackLeverColor3 font:Font(14)];
    }
    return _replyLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [self createLBTextColor:BlackLeverColor3 font:Font(12)];
    }
    return _timeLB;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.backgroundColor = BlackLeverColor2;
    }
    return _horizontalView;
}

- (UIView *)verticalView {
    if (!_verticalView) {
        _verticalView = [[UIView alloc] init];
        _verticalView.backgroundColor = BlueLeverColor1;
    }
    return _verticalView;
}

- (JTGenderGradeImageView *)genterView {
    if (!_genterView) {
        _genterView = [[JTGenderGradeImageView alloc] init];
    }
    return _genterView;
}

- (UILabel *)createLBTextColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = 0;
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

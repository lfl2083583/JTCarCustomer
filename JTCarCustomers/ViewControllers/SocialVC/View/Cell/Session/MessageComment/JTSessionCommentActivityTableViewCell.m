//
//  JTSessionCommentActivityTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionCommentActivityTableViewCell.h"

@implementation JTSessionCommentActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[ZTCirlceImageView alloc] init];
        self.bottomView = [[UIView alloc] init];
        self.bottomView.layer.cornerRadius = 4;
        self.bottomView.layer.masksToBounds = YES;
        self.rightImgeView = [[UIImageView alloc] init];
        self.bottomView.backgroundColor = WhiteColor;
        self.topLB = [self creatLabelWithFont:Font(14) textColor:BlackLeverColor6];
        self.centerLB = [self creatLabelWithFont:Font(16) textColor:BlackLeverColor6];
        self.bottomLB = [self creatLabelWithFont:Font(12) textColor:BlackLeverColor3];
        
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.centerLB];
        [self.contentView addSubview:self.bottomLB];
        [self.contentView addSubview:self.rightImgeView];
        self.contentView.backgroundColor = BlackLeverColor1;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
        tap.numberOfTapsRequired = 1;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        
        __weak typeof(self)weakSelf = self;
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(25);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.left.equalTo(weakSelf.avatarView.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-90);
        }];
        [self.centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLB.mas_left);
            make.right.equalTo(weakSelf.topLB.mas_right);
            make.top.equalTo(weakSelf.topLB.mas_bottom).offset(5);
        }];
        [self.bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLB.mas_left);
            make.right.equalTo(weakSelf.topLB.mas_right);
            make.top.equalTo(weakSelf.centerLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        [self.rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-25);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}


- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.contentView];
    if (CGRectContainsPoint(self.avatarView.frame, point)) {
        if (_delegate && [_delegate respondsToSelector:@selector(sessionCommentActivityTableViewCellAvatarClick:)]) {
            [_delegate sessionCommentActivityTableViewCellAvatarClick:self.indexPath];
        }
    }
    else if (CGRectContainsPoint(self.rightImgeView.frame, point)) {
        if (_delegate && [_delegate respondsToSelector:@selector(sessionCommentActivityTableViewCellCoverClick:)]) {
            [_delegate sessionCommentActivityTableViewCellCoverClick:self.indexPath];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(sessionCommentActivityTableViewCellContentClick:)]) {
            [_delegate sessionCommentActivityTableViewCellContentClick:self.indexPath];
        }
    }
    
}


- (void)setAttachment:(id)attachment
{
    _attachment = attachment;
    if ([attachment isKindOfClass:[JTCommentActivityAttachment class]] ||
        [attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
        JTCommentActivityAttachment *attach = attachment;
        [self.avatarView setAvatarByUrlString:[attach.avatarUrl avatarHandleWithSquare:80] defaultImage:DefaultSmallAvatar];
        NSString *title = [NSString stringWithFormat:@"%@回复了你的评论", attach.name];
        self.topLB.text = title;
        [Utility richTextLabel:self.topLB fontNumber:Font(14) andRange:NSMakeRange(title.length-7, 7) andColor:BlackLeverColor3];
        self.centerLB.text = attach.content;
        self.bottomLB.text = [Utility showTime:attach.time showDetail:NO];
        [self.rightImgeView sd_setImageWithURL:[NSURL URLWithString:[attach.coverUrl avatarHandleWithSquare:120]]];
    }
}

- (UILabel *)creatLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    return label;
}

@end

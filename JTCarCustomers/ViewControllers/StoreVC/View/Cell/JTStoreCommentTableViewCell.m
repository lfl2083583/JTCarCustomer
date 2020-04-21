//
//  JTStoreCommentTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentTableViewCell.h"

@implementation JTStoreCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setModel:(JTStoreCommentModel *)model
{
    _model = model;
    [self.avatar setAvatarByUrlString:[model.userAvatar avatarHandleWithSquare:60] defaultImage:nil];
    self.avatar.frame = model.avatarFrame;
    
    self.titleLB.text = model.userName;
    self.titleLB.frame = model.titleFrame;
    
    self.timeLB.text = [Utility exchageTimeInterval:model.commentTime format:@"YYYY-MM-dd"];
    self.timeLB.frame = model.timeFrame;
    
    [self.starView setScore:[model.commentScore floatValue] / 5 withAnimation:YES];
    self.starView.frame = model.starFrame;
    
    self.scoreLB.text = model.commentScore;
    self.scoreLB.frame = model.scoreFrame;
    
    self.commentLB.text = model.commentText;
    self.commentLB.frame = model.commentFrame;

    for (NSInteger index = 0; index < self.imageViews.count; index ++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:index];
        if (index < self.model.commentPictures.count) {
            imageView.hidden = NO;
            NSString *urlString = [model.commentPictures objectAtIndex:index];
            CGRect rect = [model.imageValues objectAtIndex:index].CGRectValue;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[urlString avatarHandleWithSize:CGSizeMake(rect.size.width*2, rect.size.height*2)]]];
            imageView.frame = rect;
        }
        else
        {
            imageView.hidden = YES;
        }
    }
    
    self.detailLB.text = model.commentCarModel;
    self.detailLB.frame = model.detailFrame;
    
    if (model.replyStatus) {
        self.replyBottom.image = [[UIImage imageNamed:@"background_shop_reply"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 50, 10, 10) resizingMode:UIImageResizingModeStretch];
        self.replyBottom.frame = model.replyBottomFrame;
        
        self.replyLB.text = model.replyText;
        self.replyLB.frame = model.replyFrame;
    }
}

- (void)initSubview
{
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.scoreLB];
    [self.contentView addSubview:self.commentLB];
    for (UIImageView *imageView in self.imageViews) {
        [self.contentView addSubview:imageView];
    }
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.replyBottom];
    [self.contentView addSubview:self.replyLB];
}

- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatar;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.font = Font(16);
    }
    return _titleLB;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.textColor = BlackLeverColor3;
        _timeLB.font = Font(12);
    }
    return _timeLB;
}

- (ZTStarView *)starView
{
    if (!_starView) {
        _starView = [[ZTStarView alloc] initWithFrame:CGRectMake(95, 54, 50, 12) numberOfStar:5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (UILabel *)scoreLB
{
    if (!_scoreLB) {
        _scoreLB = [[UILabel alloc] init];
        _scoreLB.textColor = BlackLeverColor3;
        _scoreLB.font = Font(12);
    }
    return _scoreLB;
}

- (UILabel *)commentLB
{
    if (!_commentLB) {
        _commentLB = [[UILabel alloc] init];
        _commentLB.textColor = BlackLeverColor6;
        _commentLB.font = Font(16);
        _commentLB.numberOfLines = 0;
    }
    return _commentLB;
}

- (NSMutableArray<UIImageView *> *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
        for (NSInteger index = 0; index < 8; index ++) {
            [_imageViews addObject:[[UIImageView alloc] init]];
        }
    }
    return _imageViews;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.textColor = BlackLeverColor3;
        _detailLB.font = Font(12);
    }
    return _detailLB;
}

- (UIImageView *)replyBottom
{
    if (!_replyBottom) {
        _replyBottom = [[UIImageView alloc] init];
    }
    return _replyBottom;
}

- (UILabel *)replyLB
{
    if (!_replyLB) {
        _replyLB = [[UILabel alloc] init];
        _replyLB.textColor = BlackLeverColor3;
        _replyLB.font = Font(16);
    }
    return _replyLB;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

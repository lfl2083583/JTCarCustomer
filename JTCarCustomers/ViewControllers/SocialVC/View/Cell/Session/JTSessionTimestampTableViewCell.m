//
//  JTSessionTimestampTableViewCell.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/9.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTimestampTableViewCell.h"

@implementation JTTimestampModel

- (instancetype)initWithMessageTime:(NSTimeInterval)messageTime
{
    if (self = [self init])
    {
        self.messageTime = messageTime;
    }
    return self;
}

- (void)setMessageTime:(NSTimeInterval)messageTime
{
    _messageTime = messageTime;
    self.timeText = [Utility showTime:messageTime showDetail:YES];
}

@end

@implementation JTSessionTimestampTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
        
        __weak typeof(self) weakself = self;
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(weakself.contentView.mas_centerX);
            make.top.equalTo(@20);
        }];
    }
    return self;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.font = Font(12);
        _timeLB.textColor = BlackLeverColor3;
    }
    return _timeLB;
}

- (void)initSubview
{
    [self.contentView addSubview:self.timeLB];
}

- (void)setModel:(JTTimestampModel *)model
{
    _model = model;
    [self.timeLB setText:model.timeText];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

//
//  JTSessionTipTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTipTableViewCell.h"

@implementation JTSessionTipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
        
        __weak typeof(self) weakself = self;
        [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakself.contentView.mas_centerX);
            make.top.equalTo(@15);
        }];
        
        [self.tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakself.tipLB.mas_left).with.offset(-14);
            make.top.equalTo(weakself.tipLB.mas_top).with.offset(-3);
            make.right.equalTo(weakself.tipLB.mas_right).with.offset(14);
            make.bottom.equalTo(weakself.tipLB.mas_bottom).with.offset(3);
        }];
    }
    return self;
}


- (UIImageView *)tipImg
{
    if (!_tipImg) {
        _tipImg = [[UIImageView alloc] init];
        _tipImg.image = [[UIImage jt_imageInKit:@"icon_session_time"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 20, 8, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _tipImg;
}

- (TTTAttributedLabel *)tipLB
{
    if (!_tipLB) {
        _tipLB = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _tipLB.font = Font(JTTipTextFont);
        _tipLB.textColor = WhiteColor;
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.numberOfLines = 0;
        _tipLB.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO]};
        _tipLB.delegate = self;
    }
    return _tipLB;
}

- (void)initSubview
{
    [self.contentView addSubview:self.tipImg];
    [self.contentView addSubview:self.tipLB];
}

- (void)setModel:(JTSessionMessageModel *)model
{
    _model = model;
    [self.tipLB setAttributedText:model.string];
    if (model.links && [model.links count] > 0) {
        for (NSDictionary *source in model.links) {
            [self.tipLB addLinkToURL:[NSURL URLWithString:source[@"value"]] withRange:[source[@"range"] rangeValue]];
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:didSelectAtMessageModel:didSelectAtValue:)]) {
        [self.delegate sessionTableViewCell:self didSelectAtMessageModel:self.model didSelectAtValue:url.absoluteString];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

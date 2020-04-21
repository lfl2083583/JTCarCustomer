//
//  JTExpressionTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionTableViewCell.h"

@implementation JTExpressionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubview];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)operationClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(expressionTableViewCell:didSelectRowAtIndexPath:)]) {
        [_delegate expressionTableViewCell:self didSelectRowAtIndexPath:self.indexPath];
    }
}

- (void)initSubview
{
    [self addSubview:self.icon];
    [self addSubview:self.nameLB];
    [self addSubview:self.operationBT];
}

- (void)setSourceDic:(NSDictionary *)sourceDic
{
    if (sourceDic && [sourceDic isKindOfClass:[NSDictionary class]]) {
        _sourceDic = sourceDic;
        [self.icon setAvatarByUrlString:[sourceDic[@"cover"] avatarHandleWithSquare:self.icon.height] defaultImage:nil];
        self.nameLB.text = sourceDic[@"name"];
        
        if (self.isEdit) {
            self.operationBT.hidden = YES;
        }
        else
        {
            self.operationBT.hidden = NO;
            if (self.isManage) {
                [self.operationBT setUserInteractionEnabled:YES];
                [self.operationBT setTitle:@"移除" forState:UIControlStateNormal];
                [self.operationBT setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.operationBT setBackgroundColor:BlueLeverColor1];

            }
            else
            {
                BOOL is_download = [[sourceDic objectForKey:@"is_download"] boolValue];
                if (is_download) {
                    
                    [self.operationBT setUserInteractionEnabled:NO];
                    [self.operationBT setTitle:@"已获取" forState:UIControlStateNormal];
                    [self.operationBT setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [self.operationBT setBackgroundColor:BlackLeverColor3];
                    
                }
                else
                {
                    [self.operationBT setUserInteractionEnabled:YES];
                    [self.operationBT setTitle:@"获取" forState:UIControlStateNormal];
                    [self.operationBT setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [self.operationBT setBackgroundColor:BlueLeverColor1];
                }
            }
        }

    }
}

- (ZTCirlceImageView *)icon
{
    if (!_icon) {
        _icon = [[ZTCirlceImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.font = Font(18);
        _nameLB.textColor = BlackLeverColor6;
    }
    return _nameLB;
}

- (UIButton *)operationBT
{
    if (!_operationBT) {
        _operationBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationBT.titleLabel.font = Font(15);
        _operationBT.layer.cornerRadius = 15;
        [_operationBT addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationBT;
}

- (void)setViewAtuoLayout
{
    __weak typeof(self) weakself = self;

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@5);
        make.left.equalTo(@10);
        make.width.and.height.equalTo(@50);
    }];

    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@5);
        make.left.equalTo(weakself.icon.mas_right).with.offset(10);
        make.height.equalTo(@50);
        make.right.equalTo(weakself.operationBT.mas_left).with.offset(-15);
    }];

    [self.operationBT mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@15);
        make.right.equalTo(@-10);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

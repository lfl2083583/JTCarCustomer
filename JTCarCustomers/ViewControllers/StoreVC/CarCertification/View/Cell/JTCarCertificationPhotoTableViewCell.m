//
//  JTCarCertificationPhotoTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define Randio 219/328.0
#import "JTCarCertificationPhotoTableViewCell.h"

@implementation JTCarCertificationPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.certificateBtn];
        
        __weak typeof(self)weakSelf = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(25);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(18);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-25);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(23.5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-23.5);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
            make.height.mas_equalTo(Randio*(App_Frame_Width-47));
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-18);
        }];
        
        [self.certificateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView.mas_left).offset(12);
            make.right.equalTo(weakSelf.bottomView.mas_right).offset(-12);
            make.top.equalTo(weakSelf.bottomView.mas_top).offset(12);
            make.bottom.equalTo(weakSelf.bottomView.mas_bottom).offset(-12);
        }];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)certificateBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(recognizeCard:)]) {
        [_delegate recognizeCard:self.indexPath];
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

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = BlackLeverColor3;
    }
    return _titleLB;
}

- (UIImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] init];
        _bottomView.image = [UIImage imageNamed:@"line_photo"];
    }
    return _bottomView;
}

- (UIButton *)certificateBtn {
    if (!_certificateBtn) {
        _certificateBtn = [[UIButton alloc] init];
        _certificateBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _certificateBtn.clipsToBounds = YES;
        [_certificateBtn addTarget:self action:@selector(certificateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certificateBtn;
}

@end

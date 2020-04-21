//
//  JTCarCertificationHelpTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarCertificationHelpTableViewCell.h"

@implementation JTCarCertificationHelpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLB = [[UILabel alloc] init];
        self.titleLB.font = Font(14);
        self.titleLB.textColor = BlackLeverColor3;
        self.titleLB.numberOfLines = 0;
        
        self.subtitleLB = [[UILabel alloc] init];
        self.subtitleLB.font = Font(14);
        self.subtitleLB.textColor = BlackLeverColor5;
        self.subtitleLB.numberOfLines = 0;
        
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.subtitleLB];
        
        __weak typeof(self)weakSelf = self;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)setSource:(id)source {
    _source = source;
    if (source && [source isKindOfClass:[NSDictionary class]]) {
        [self.titleLB setText:[NSString stringWithFormat:@"Q:%@", source[@"question"]]];
        [self.subtitleLB setText:[NSString stringWithFormat:@"A:%@", source[@"answer"]]];
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

@end

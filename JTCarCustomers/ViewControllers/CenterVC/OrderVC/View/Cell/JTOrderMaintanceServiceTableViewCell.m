//
//  JTOrderMaintanceServiceTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderMaintanceServiceTableViewCell.h"

@implementation JTOrderMaintanceServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.segmentedControl];
        
        __weak typeof(self)weakSelf = self;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        }];
        
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.height.mas_equalTo(kTopBarHeight);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
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

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.font = Font(16);
        _titleLB.text = @"服务项目详情";
    }
    return _titleLB;
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"已完工", @"待质检", @"施工中", @"待施工"]];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : Font(16),
                                                  NSForegroundColorAttributeName : BlackLeverColor5,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : Font(18),
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
    }
    return _segmentedControl;
}


@end

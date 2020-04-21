//
//  JTGlobalSearchLabelTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGlobalSearchLabelTableViewCell.h"

@implementation JTGlobalSearchLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray.count > 0) {
        if (!_dataArray || ![_dataArray isEqual:dataArray]) {
            _dataArray = dataArray;
            NSMutableArray *viewArray = [NSMutableArray array];
            NSMutableArray *sizeArray = [NSMutableArray array];
            
            CGFloat maxColumnLenght_1 = 0.0, maxColumnLenght_2 = 0.0, maxColumnLenght_3 = 0.0, maxColumnLenght_4 = 0.0;
            
            for (int i = 0; i < dataArray.count; i ++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button.titleLabel setFont:Font(16)];
                [button setTitle:[dataArray objectAtIndex:i] forState:UIControlStateNormal];
                [button setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
                [button setTag:i];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:button];
                [viewArray addObject:button];
                
                CGSize labelSize = [Utility getTextString:[dataArray objectAtIndex:i]  textFont:Font(16) frameWidth:MAXFLOAT attributedString:nil];
                [sizeArray addObject:[NSValue valueWithCGSize:labelSize]];
                
                if (i%4 != 3) {
                    UIView *view = [[UIView alloc] init];
                    view.backgroundColor = BlackLeverColor2;
                    [self.contentView addSubview:view];
                    
                    [viewArray addObject:view];
                    [sizeArray addObject:[NSValue valueWithCGSize:CGSizeMake(1, labelSize.height)]];
                }
                
                if (i%4 == 0) {
                    maxColumnLenght_1 = MAX(maxColumnLenght_1, labelSize.width);
                }
                if (i%4 == 1) {
                    maxColumnLenght_2 = MAX(maxColumnLenght_2, labelSize.width);
                }
                if (i%4 == 2) {
                    maxColumnLenght_3 = MAX(maxColumnLenght_3, labelSize.width);
                }
                if (i%4 == 3) {
                    maxColumnLenght_4 = MAX(maxColumnLenght_4, labelSize.width);
                }
            }
            
            CGFloat space = (App_Frame_Width - 56 - maxColumnLenght_1 - maxColumnLenght_2 - maxColumnLenght_3 - maxColumnLenght_4) / 8;
            CGFloat left = 20 + space, top = 20;
            for (int i = 0; i < viewArray.count; i ++) {
                
                CGSize size = [[sizeArray objectAtIndex:i] CGSizeValue];
                UIView *view = [viewArray objectAtIndex:i];
                if (/* DISABLES CODE */ (0) == 1%7) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_1, size.height);
                }
                else if (/* DISABLES CODE */ (2) == 1%7) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_2, size.height);
                }
                else if (/* DISABLES CODE */ (4) == 1%7) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_3, size.height);
                }
                else if (/* DISABLES CODE */ (6) == 1%7) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_4, size.height);
                }
                else
                {
                    view.frame = CGRectMake(left, top, size.width, size.height);
                }
                
                if (6 == i%7) {
                    left = 20 + space;
                    top = CGRectGetMaxY(view.frame) + space;
                }
                else
                {
                    left = CGRectGetMaxX(view.frame) + space;
                }
            }
            
            __weak typeof(self) weakself = self;
            UIView *lastView = viewArray.lastObject;
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastView.left);
                make.top.mas_equalTo(lastView.top);
                make.height.mas_equalTo(lastView.height);
                make.bottom.equalTo(weakself.contentView.mas_bottom).with.offset(-20);
            }];
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(globalSearchLabelTableViewCellLabelClick:)]) {
        [self.delegate globalSearchLabelTableViewCellLabelClick:sender.tag];
    }
}


@end

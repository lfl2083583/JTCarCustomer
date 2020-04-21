//
//  JTCollectionLabelTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionLabelTableViewCell.h"

@implementation JTCollectionLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubview];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.bottomView];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (void)setViewAtuoLayout
{
    __weak typeof(self) weakself = self;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.top.equalTo(@0);
        make.right.equalTo(@-8);
        make.bottom.equalTo(weakself.contentView.mas_bottom);
    }];
}

- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray.count > 0) {
        if (!_dataArray || ![_dataArray isEqual:dataArray]) {
            _dataArray = dataArray;
            if (self.bottomView.subviews.count > 0) {
                for (UIView *view in self.bottomView.subviews) {
                    [view removeFromSuperview];
                }
            }
            NSMutableArray *viewArray = [NSMutableArray array];
            NSMutableArray *sizeArray = [NSMutableArray array];
            
            CGFloat maxColumnLenght_1 = 0.0, maxColumnLenght_2 = 0.0, maxColumnLenght_3 = 0.0;
            
            for (int i = 0; i < dataArray.count; i ++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button.titleLabel setFont:Font(16)];
                [button setTitle:[[dataArray objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
                [button setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
                [button setTag:i];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.bottomView addSubview:button];
                [viewArray addObject:button];
    
                CGSize labelSize = [Utility getTextString:[[dataArray objectAtIndex:i] objectForKey:@"name"] textFont:Font(16) frameWidth:MAXFLOAT attributedString:nil];
                [sizeArray addObject:[NSValue valueWithCGSize:labelSize]];
                
                if (i%3 != 2) {
                    UIView *view = [[UIView alloc] init];
                    view.backgroundColor = BlackLeverColor2;
                    [self.bottomView addSubview:view];
                    
                    [viewArray addObject:view];
                    [sizeArray addObject:[NSValue valueWithCGSize:CGSizeMake(1, labelSize.height)]];
                }
                
                if (i%3 == 0) {
                    maxColumnLenght_1 = MAX(maxColumnLenght_1, labelSize.width);
                }
                if (i%3 == 1) {
                    maxColumnLenght_2 = MAX(maxColumnLenght_2, labelSize.width);
                }
                if (i%3 == 2) {
                    maxColumnLenght_3 = MAX(maxColumnLenght_3, labelSize.width);
                }
            }
            
            CGFloat space = (App_Frame_Width - 56 - maxColumnLenght_1 - maxColumnLenght_2 - maxColumnLenght_3) / 6;
            CGFloat left = 20 + space, top = 20;
            for (int i = 0; i < viewArray.count; i ++) {

                CGSize size = [[sizeArray objectAtIndex:i] CGSizeValue];
                UIView *view = [viewArray objectAtIndex:i];
                if (/* DISABLES CODE */ (0) == 1%5) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_1, size.height);
                }
                else if (/* DISABLES CODE */ (2) == 1%5) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_2, size.height);
                }
                else if (/* DISABLES CODE */ (4) == 1%5) {
                    view.frame = CGRectMake(left, top, maxColumnLenght_3, size.height);
                }
                else
                {
                    view.frame = CGRectMake(left, top, size.width, size.height);
                }
                
                if (4 == i%5) {
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
                make.bottom.equalTo(weakself.bottomView.mas_bottom).with.offset(-20);
            }];
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionLabelTableViewCell:didSelectAtSource:)]) {
        [self.delegate collectionLabelTableViewCell:self didSelectAtSource:[self.dataArray objectAtIndex:sender.tag]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

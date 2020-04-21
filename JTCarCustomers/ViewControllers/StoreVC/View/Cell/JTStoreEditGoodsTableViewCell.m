//
//  JTStoreEditGoodsTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreEditGoodsTableViewCell.h"

@implementation JTStoreEditGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.cover];
    [self.bottomView addSubview:self.editView];
    [self.bottomView addSubview:self.reduceBT];
    [self.bottomView addSubview:self.numLB];
    [self.bottomView addSubview:self.addBT];
    [self.bottomView addSubview:self.deleteBT];
    [self.bottomView addSubview:self.replaceBT];
}

- (void)reduceClick:(id)sender
{
    self.currentNum -- ;
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeEditGoodsTableViewCell:didSelectRowAtIndexPath:didEditGoodsType:)]) {
        [_delegate storeEditGoodsTableViewCell:self didSelectRowAtIndexPath:self.indexPath didEditGoodsType:JTStoreEditGoodsTypeReduce];
    }
}

- (void)addClick:(id)sender
{
    self.currentNum ++ ;
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeEditGoodsTableViewCell:didSelectRowAtIndexPath:didEditGoodsType:)]) {
        [_delegate storeEditGoodsTableViewCell:self didSelectRowAtIndexPath:self.indexPath didEditGoodsType:JTStoreEditGoodsTypeAdd];
    }
}

- (void)deleteClick:(id)sender
{
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeEditGoodsTableViewCell:didSelectRowAtIndexPath:didEditGoodsType:)]) {
        [_delegate storeEditGoodsTableViewCell:self didSelectRowAtIndexPath:self.indexPath didEditGoodsType:JTStoreEditGoodsTypeDelete];
    }
}

- (void)replaceClick:(id)sender
{
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeEditGoodsTableViewCell:didSelectRowAtIndexPath:didEditGoodsType:)]) {
        [_delegate storeEditGoodsTableViewCell:self didSelectRowAtIndexPath:self.indexPath didEditGoodsType:JTStoreEditGoodsTypeReplace];
    }
}

- (void)setModel:(JTStoreGoodsModel *)model
{
    _model = model;
    [self.cover sd_setImageWithURL:[NSURL URLWithString:[model.coverUrlString avatarHandleWithSize:CGSizeMake(self.cover.width*2, self.cover.height*2)]]];
    [self setCurrentNum:model.num];
}

- (void)setCurrentNum:(NSInteger)currentNum
{
    _currentNum = currentNum;
    self.reduceBT.enabled = (currentNum > 1);
    self.addBT.enabled = (currentNum < self.model.stock);
    self.numLB.text = [NSString stringWithFormat:@"%ld", currentNum];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, App_Frame_Width-110, 90)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIImageView *)cover
{
    if (!_cover) {
        _cover = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.clipsToBounds = YES;
    }
    return _cover;
}

- (UIImageView *)editView
{
    if (!_editView) {
        _editView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cover.right+15, 30, 100, 30)];
        _editView.image = [UIImage imageNamed:@"bg_edit_goods"];
    }
    return _editView;
}

- (UIButton *)reduceBT
{
    if (!_reduceBT) {
        _reduceBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBT setImage:[UIImage imageNamed:@"reduce_normal"] forState:UIControlStateNormal];
        [_reduceBT setImage:[UIImage imageNamed:@"reduce_invalid"] forState:UIControlStateDisabled];
        [_reduceBT addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_reduceBT setFrame:CGRectMake(self.editView.left, self.editView.top, 30, 30)];
    }
    return _reduceBT;
}

- (UILabel *)numLB
{
    if (!_numLB) {
        _numLB = [[UILabel alloc] initWithFrame:CGRectMake(self.reduceBT.right, self.reduceBT.top, 40, 30)];
        _numLB.textAlignment = NSTextAlignmentRight;
        _numLB.font = Font(16);
        _numLB.textColor = BlackLeverColor6;
        _numLB.textAlignment = NSTextAlignmentCenter;
    }
    return _numLB;
}

- (UIButton *)addBT
{
    if (!_addBT) {
        _addBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBT setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
        [_addBT setImage:[UIImage imageNamed:@"add_invalid"] forState:UIControlStateDisabled];
        [_addBT addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBT setFrame:CGRectMake(self.numLB.right, self.numLB.top, 30, 30)];
    }
    return _addBT;
}

- (UIButton *)deleteBT
{
    if (!_deleteBT) {
        _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBT setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_deleteBT.titleLabel setFont:Font(12)];
        [_deleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBT setFrame:CGRectMake(self.editView.right+5, self.editView.top, 30, 30)];
    }
    return _deleteBT;
}

- (UIButton *)replaceBT
{
    if (!_replaceBT) {
        _replaceBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replaceBT setTitle:@"更换" forState:UIControlStateNormal];
        [_replaceBT setTitleColor:RedLeverColor1 forState:UIControlStateNormal];
        [_replaceBT.titleLabel setFont:Font(12)];
        [_replaceBT addTarget:self action:@selector(replaceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_replaceBT setFrame:CGRectMake(self.deleteBT.right, self.editView.top, 30, 30)];
    }
    return _replaceBT;
}

@end

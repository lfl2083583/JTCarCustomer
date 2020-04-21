//
//  JTWalletMoneyDetailPickerView.m
//  JTSocial
//
//  Created by lious on 2017/12/9.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTWalletMoneyDetailPickerView.h"

static NSString *walletMoneyDetailCollectionCellID = @"JTBlanceRecordCollectionCell";

@implementation JTWalletMoneyDetailCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLb];
    }
    return self;
}


- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLb.font = Font(16);
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = UIColorFromRGB(0x666666);
        
        _titleLb.layer.cornerRadius = self.bounds.size.height/2.0;
        _titleLb.layer.borderColor = BlueLeverColor1.CGColor;
        _titleLb.layer.borderWidth = 1;
        _titleLb.layer.masksToBounds = YES;
    }
    return _titleLb;
}


@end

@interface JTWalletMoneyDetailPickerView ()<UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *topLb;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomBtn;


@property (nonatomic, assign) NSInteger seletedIndex;

@end

@implementation JTWalletMoneyDetailPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}


- (void)showWithItemArray:(NSArray *)array seletedBlock:(BlanceRecordPickerViewBlock)block{
    __weak typeof (self)weakSelf = self;
    if (array && [array isKindOfClass:[NSArray class]] && array.count) {
        [self.dataArr removeAllObjects];
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.dataArr addObject:[obj objectForKey:@"name"]];
        }];
        [self.dataArr insertObject:@"全部" atIndex:0];
        [self updataFrame];
        [self.collectionView reloadData];
       
        if (block) {
            self.block = block;
        }
  }
}

- (void)updataFrame{
    CGFloat height = (ceil(self.dataArr.count/3.0)) * 38  + 40;
    
    [self.topLb setFrame:CGRectMake(0, 0, App_Frame_Width, 50)];
    
    [self.topLine setFrame:CGRectMake(15, 50, App_Frame_Width-30, 0.5)];
    
    [self.collectionView setFrame:CGRectMake(5, CGRectGetMaxY(self.topLine.frame)+15, App_Frame_Width-10, height)];
    
    [self.bottomLine setFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+15, App_Frame_Width, 2)];
    
    [self.bottomBtn setFrame:CGRectMake(0, CGRectGetMaxY(self.bottomLine.frame), App_Frame_Width, 50)];
    
    [self.contentView setFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, height + 130)];
    
    self.backgroundColor = RGBCOLOR(0, 0, 0, 0.2);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.contentView setY:APP_Frame_Height-CGRectGetHeight(weakSelf.contentView.frame)];
    } completion:nil];
}

- (void)hide{
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setY:APP_Frame_Height];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}

- (void)bottomBtnClick:(UIButton *)sender{
    [self hide];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTWalletMoneyDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:walletMoneyDetailCollectionCellID forIndexPath:indexPath];
    cell.titleLb.text = self.dataArr[indexPath.row];
    cell.titleLb.layer.borderColor = (indexPath.row == self.seletedIndex)?UIColorFromRGB(0xff8b2e).CGColor : UIColorFromRGB(0x989898).CGColor;
    cell.titleLb.textColor = (indexPath.row == self.seletedIndex)?UIColorFromRGB(0xff8b2e) : UIColorFromRGB(0x989898);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.seletedIndex = indexPath.row;
    [collectionView reloadData];
    if (self.block) {
        self.block(self.seletedIndex);
    }
    [self hide];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((App_Frame_Width-40)/ 3.0, 38);
}

- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = WhiteColor;
        [_contentView addSubview:self.topLb];
        [_contentView addSubview:self.topLine];
        [_contentView addSubview:self.collectionView];
        [_contentView addSubview:self.bottomLine];
        [_contentView addSubview:self.bottomBtn];
    }
    return _contentView;
}

- (UILabel *)topLb{
    if (!_topLb) {
        _topLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLb.font = Font(16);
        _topLb.textColor = UIColorFromRGB(0x282828);
        _topLb.textAlignment = NSTextAlignmentCenter;
        _topLb.text = @"选择交易类型";
    }
    return _topLb;
}

- (UIView *)topLine{
    
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
    return _bottomLine;
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_bottomBtn setTitleColor:UIColorFromRGB(0x282828) forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"取消" forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat itemWidth = floorf((App_Frame_Width-40) / 3.0);
        CGFloat itemHeight = 38;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView registerClass:[JTWalletMoneyDetailCollectionCell class] forCellWithReuseIdentifier:walletMoneyDetailCollectionCellID];
    }
    return _collectionView;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end

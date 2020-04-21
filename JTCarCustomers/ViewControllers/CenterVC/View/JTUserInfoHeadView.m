//
//  JTUserInfoHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTUserInfoCollectionViewCell.h"
#import "JTUserInfoCollectionViewFlowLayout.h"
#import "JTUserInfoHeadView.h"

@implementation JTUserInfoSectionHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftLabel];
    }
    return self;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width - 15, 40)];
        _leftLabel.textColor = BlackLeverColor3;
        _leftLabel.font = Font(14);
        _leftLabel.text = @"标题";
    }
    return _leftLabel;
}

@end

@implementation JTElementView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomImgView];
        [self addSubview:self.topBtn];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)topBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(elementViewClick:)]) {
        [_delegate elementViewClick:self];
    }
}

- (UIImageView *)bottomImgView {
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bottomImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bottomImgView;
}

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 44) / 2.0, (self.bounds.size.height - 44) / 2.0, 44, 44)];
        _topBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_topBtn setImage:[UIImage imageNamed:@"photo_add_icon"] forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}


@end

@interface JTUserInfoHeadView () <JTElementViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, JTUserInfoCollectionViewCellDelegate>

@property (nonatomic, strong) JTUserInfoCollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;
@property (nonatomic, strong) UIView * snapshotView; //截屏得到的view
@property (nonatomic, weak) JTUserInfoCollectionViewCell *originalCell;

@end

@implementation JTUserInfoHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self configComponent];
    }
    return self;
}

- (void)setupViews {
    
    CGFloat w1 = (self.width-8) * 2 / 3.0 + 2;
    CGFloat h1 = w1;
    CGFloat h2 = (self.width-8) / 3.0;
    CGFloat w2 = (self.width-8) / 3.0;
    JTElementView *element1 = [[JTElementView alloc] initWithFrame:CGRectMake(2, 2, w1, h1)];
    element1.tag = 1;
    element1.delegate = self;
    element1.backgroundColor = UIColorFromRGB(0xf5f6f7);
    [self addSubview:element1];
    
    for (int i = 0; i < 5; i++) {
        CGFloat btn_x = 0;
        CGFloat btn_y = 0;
        btn_x = (i < 2) ? w1 + 4 : (w2 + 2) * (i - 2) + 2;
        btn_y = (i < 2) ? (h2 + 2) * i + 2 : h1 + 4;
        JTElementView *element2 = [[JTElementView alloc] initWithFrame:CGRectMake(btn_x, btn_y, w2, h2)];
        element2.tag = 2 + i;
        element2.delegate = self;
        element2.backgroundColor = UIColorFromRGB(0xf5f6f7);
        [self addSubview:element2];
    }
    self.backgroundColor = WhiteColor;
}

- (void)configComponent {
    JTElementView *element1 = [self viewWithTag:1];
    [element1.topBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [element1.bottomImgView sd_setImageWithURL:[NSURL URLWithString:[JTUserInfo shareUserInfo].userAvatar]];
    if ([JTUserInfo shareUserInfo].userAblum && [[JTUserInfo shareUserInfo].userAblum isKindOfClass:[NSDictionary class]]) {
            for (int i = 1; i < 6; i++) {
                JTElementView *element = [self viewWithTag:i+1];
                NSString *key = [NSString stringWithFormat:@"image_%d",i];
                NSString *value = [[JTUserInfo shareUserInfo].userAblum objectForKey:key];
                if (value) {
                    [element.topBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [element.bottomImgView sd_setImageWithURL:[NSURL URLWithString:[value avatarHandleWithSize:CGSizeMake(element.size.width, element.size.height)]]];
                }
            }
    }
}

#pragma mark JTElementViewDelegate
- (void)elementViewClick:(id)sender {
    JTElementView *element = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(headViewAddPhoto:)]) {
        [_delegate headViewAddPhoto:element.tag];
    }
}

- (void)refreshView {
    [self configComponent];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTUserInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userInfoCollectionindentifer forIndexPath:indexPath];
    cell.delegate = self;
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    cell.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    NSString *key = [NSString stringWithFormat:@"image_%ld",indexPath.row];
    NSString *value = [[JTUserInfo shareUserInfo].userAblum objectForKey:key];
    [cell.topImgeView sd_setImageWithURL:[NSURL URLWithString:[value avatarHandleWithSize:CGSizeMake(cell.topImgeView.size.width, cell.topImgeView.size.height)]]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat width = (self.width-20)*2/3.0+5;
        return CGSizeMake(width, width);
    }else {
        return CGSizeMake((self.width-20)/3.0, (self.width-20)/3.0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(headViewAddPhoto:)]) {
        [_delegate headViewAddPhoto:indexPath.row+1];
    }
}

#pragma mark JTUserInfoCollectionViewCellDelegate
- (void)collectionViewImgeViewDrag:(UIGestureRecognizer *)gestureRecognizer {
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[JTUserInfoCollectionViewFlowLayout alloc] initWithFrame:self.bounds itemsInRow:3];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[JTUserInfoCollectionViewCell class] forCellWithReuseIdentifier:userInfoCollectionindentifer];
    }
    return _collectionView;
}
@end

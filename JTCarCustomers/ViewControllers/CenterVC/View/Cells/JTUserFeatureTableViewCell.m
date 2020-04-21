///
//  JTUserFeatureTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserFeatureTableViewCell.h"
#import "ZTTagCollectionViewCell.h"
#import "ZTTagAttribute.h"

@interface JTUserFeatureTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation JTUserFeatureTableViewCell

static NSString * const reuseIdentifier = @"ZTTagCollectionViewCellId";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //初始化样式
    _colors = @[UIColorFromRGB(0xec88d7), UIColorFromRGB(0x66a4fe), UIColorFromRGB(0xbd60f5), UIColorFromRGB(0xc48dfa), UIColorFromRGB(0xb1a3f2)];
    _tagAttribute = [ZTTagAttribute new];
    _layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 0.f);
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.rightLable];
    [self.contentView addSubview:self.rightImgeView];
    [self.contentView addSubview:self.collectionView];
    self.clipsToBounds = YES;
}

- (void)setIsRandColor:(BOOL)isRandColor {
    _isRandColor = isRandColor;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewFlowLayout *layout = (ZTTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    NSDictionary *dictionary = _tags[indexPath.item];
    CGRect frame = [[dictionary objectForKey:@"label_name"] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
    return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.titleLabel.textColor = WhiteColor;
    cell.titleLabel.font = Font(14);
    NSDictionary *dictionary = _tags[indexPath.row];
    cell.titleLabel.text = [dictionary objectForKey:@"label_name"];
    if (self.isRandColor) {
        int value = arc4random()%5;
        cell.backgroundColor = self.colors[value];
    } else {
        cell.backgroundColor = self.colors[0];
    }
    return cell;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height);
}

+ (CGFloat)getCellHeightWithTags:(NSArray *)tags width:(CGFloat)width
{
    CGFloat contentHeight = 0;
    ZTTagCollectionViewFlowLayout *layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 0.f);
    ZTTagAttribute *tagAttribute = [[ZTTagAttribute alloc] init];
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    NSInteger itemCount = tags.count;
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        NSDictionary *dictionary = tags[i];
        CGRect frame = [[dictionary objectForKey:@"label_name"] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
        if ((originX + itemSize.width + layout.sectionInset.right) > width) {
            originX = layout.sectionInset.left;
            originY += itemSize.height + layout.minimumLineSpacing;
            
            contentHeight += itemSize.height + layout.minimumLineSpacing;
        }
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    contentHeight += layout.sectionInset.bottom;
    CGFloat offset = tags.count?35:-15;
    return contentHeight + offset;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, 362) collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        [_collectionView registerClass:[ZTTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    _collectionView.collectionViewLayout = _layout;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.frame = CGRectMake(0, 35, self.bounds.size.width, self.bounds.size.height);
    
    return _collectionView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        _topLabel.font = Font(16);
        _topLabel.textColor = BlackLeverColor6;
    }
    return _topLabel;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
        _rightLable = [[UILabel alloc] initWithFrame:CGRectMake(App_Frame_Width-110, 10, 80, 20)];
        _rightLable.font = Font(16);
        _rightLable.textColor = BlackLeverColor3;
        _rightLable.textAlignment = NSTextAlignmentRight;
        _rightLable.text = @"TA的信息";
    }
    return _rightLable;
}

- (UIImageView *)rightImgeView {
    if (!_rightImgeView) {
        _rightImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rightLable.frame)+5, 10, 8, 20)];
        _rightImgeView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImgeView.image = [UIImage imageNamed:@"arrow_right_icon"];
    }
    return _rightImgeView;
}
@end

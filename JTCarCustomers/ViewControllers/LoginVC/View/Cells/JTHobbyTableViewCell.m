//
//  JTHobbyTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTHobbyTableViewCell.h"

#import "ZTTagCollectionViewCell.h"
#import "ZTTagAttribute.h"

@interface JTHobbyTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *lables;

@end

@implementation JTHobbyTableViewCell

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

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    if (tags && [tags isKindOfClass:[NSArray class]]) {
        [self.lables removeAllObjects];
        for (NSDictionary *dictionary in tags) {
            [self.lables addObject:dictionary[@"label_name"]];
        }
    }
}

- (NSMutableArray *)lables {
    if (!_lables) {
        _lables = [NSMutableArray array];
    }
    return _lables;
}

- (void)setup
{
    //初始化样式
    _tagAttribute = [ZTTagAttribute new];
    _layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f);
    [self.contentView addSubview:self.leftImgeV];
    [self.contentView addSubview:self.rightLB];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.bottomView];
    self.clipsToBounds = YES;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _lables.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewFlowLayout *layout = (ZTTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width-layout.sectionInset.left- layout.sectionInset.right, layout.itemSize.height);
    CGRect frame = [_lables[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
    return CGSizeMake(frame.size.width+_tagAttribute.tagSpace, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.tagColor;
    cell.titleLabel.textColor = WhiteColor;
    cell.titleLabel.font = Font(14);
    cell.titleLabel.text = _lables[indexPath.row];
    cell.userInteractionEnabled = NO;
    return cell;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(60, 0, self.bounds.size.width-70, self.bounds.size.height);
    _leftImgeV.centerY = self.contentView.centerY;
    _rightLB.centerY = self.contentView.centerY;
    _bottomView.y = self.bounds.size.height-0.5;
}

+ (CGFloat)getCellHeightWithTags:(NSArray *)tags width:(CGFloat)width
{
    CGFloat contentHeight = 0;
    ZTTagCollectionViewFlowLayout *layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    ZTTagAttribute *tagAttribute = [[ZTTagAttribute alloc] init];
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    NSInteger itemCount = tags.count;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictionary in tags) {
        [array addObject:dictionary[@"label_name"]];
    }
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        CGRect frame = [array[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + layout.sectionInset.right) > width) {
                originX = layout.sectionInset.left;
                originY += itemSize.height + layout.minimumLineSpacing;
                contentHeight += itemSize.height + layout.minimumLineSpacing;
            }
        }
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    
    contentHeight += layout.sectionInset.bottom;
    return contentHeight;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(60, 0, self.frame.size.width-70, self.bounds.size.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = NO;
        _collectionView.backgroundColor = WhiteColor;
        [_collectionView registerClass:[ZTTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.frame = CGRectMake(60, 0, self.bounds.size.width-70, self.bounds.size.height);
    
    return _collectionView;
}

- (UILabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] initWithFrame:CGRectMake(74, 10, App_Frame_Width-74, 20)];
        _rightLB.font = Font(16);
        _rightLB.textColor = BlackLeverColor3;
        _rightLB.centerY = self.contentView.centerY;
    }
    return _rightLB;
}

- (UIImageView *)leftImgeV {
    if (!_leftImgeV) {
        _leftImgeV = [[UIImageView alloc] initWithFrame:CGRectMake(22, 15, 30, 30)];
        _leftImgeV.centerY = self.contentView.centerY;
    }
    return _leftImgeV;
}

- (ZTTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[ZTTagCollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UIView *)bottomView {
    if (!_bottomView) {
         _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, self.height-0.5, App_Frame_Width-15, 0.5)];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

@end


//
//  JTTalentTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/30.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "ZTTagAttribute.h"
#import "JTTalentTableHeadView.h"
#import "ZTTagCollectionViewFlowLayout.h"
#import "ZTTagCollectionViewCell.h"

@interface JTTalentTableHeadView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZTTagCollectionViewFlowLayout *layout;

@end

static NSString *talentCollectionViewCellIndentify = @"ZTTagCollectionViewCell";

@implementation JTTalentTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _layout = [ZTTagCollectionViewFlowLayout new];
    [self addSubview:self.collectionView];
    self.clipsToBounds = YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.talentTags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewFlowLayout *layout = (ZTTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    JTWordItem *item = self.talentTags[indexPath.row];
    CGRect frame = [item.title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
    return CGSizeMake(frame.size.width + 30, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:talentCollectionViewCellIndentify forIndexPath:indexPath];
    JTWordItem *item = self.talentTags[indexPath.row];
    cell.backgroundColor = item.isSeleted?UIColorFromRGB(0xb1a3f2):WhiteColor;
    cell.layer.cornerRadius = 15;
    cell.layer.borderColor = item.isSeleted?WhiteColor.CGColor:BlackLeverColor2.CGColor;
    cell.layer.borderWidth = 1;
    cell.titleLabel.textColor = item.isSeleted?WhiteColor:BlackLeverColor3;
    cell.titleLabel.font = Font(14);
    cell.titleLabel.text = item.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.talentTags[indexPath.row];
    for (JTWordItem *obj in self.talentTags) {
        obj.isSeleted = NO;
    }
    item.isSeleted = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(talentTableHeadViewTagClick:)]) {
        [_delegate talentTableHeadViewTagClick:item.tagID];
    }
    [collectionView reloadData];
}

+ (CGFloat)getViewHeightWithTags:(NSArray *)tags width:(CGFloat)width
{
    CGFloat contentHeight = 0;
    
    ZTTagCollectionViewFlowLayout *layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    ZTTagAttribute *tagAttribute = [[ZTTagAttribute alloc] init];
    
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = tags.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        JTWordItem *item = tags[i];
        CGRect frame = [item.title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
        
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
    return contentHeight;
}

- (void)reloaData {
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.bounds.size.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BlackLeverColor1;
        [_collectionView registerClass:[ZTTagCollectionViewCell class] forCellWithReuseIdentifier:talentCollectionViewCellIndentify];
    }
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    return _collectionView;
}
@end

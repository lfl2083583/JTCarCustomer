//
//  ZTTagCollectionViewFlowLayout.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//


#import "ZTTagCollectionViewFlowLayout.h"

@interface ZTTagCollectionViewFlowLayout()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout>delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGFloat contentWidth;//滑动宽度 水平
@property (nonatomic, assign) CGFloat contentHeight;//滑动高度 垂直

@end

@implementation ZTTagCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(100.f, 30.f);
        self.minimumInteritemSpacing = 5.f;
        self.minimumLineSpacing = 5.f;
        self.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f);
    }
    return self;
}

#pragma mark -

- (void)prepareLayout
{
    [super prepareLayout];
    [self.itemAttributes removeAllObjects];
    //滑动的宽度 = 左边
    self.contentWidth = self.sectionInset.left;
    //cell的高度 = 顶部 + 高度
    self.contentHeight = self.sectionInset.top + self.itemSize.height;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.sectionInset.top;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize itemSize = [self itemSizeForIndexPath:indexPath];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + self.sectionInset.right) > self.collectionView.frame.size.width) {
                originX = self.sectionInset.left;
                originY += itemSize.height + self.minimumLineSpacing;
                self.contentHeight += itemSize.height + self.minimumLineSpacing;
            }
        }
        else
        {
            self.contentWidth += itemSize.width + self.minimumInteritemSpacing;
        }
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
        [self.itemAttributes addObject:attributes];
        originX += itemSize.width + self.minimumInteritemSpacing;
    }
    self.contentHeight += self.sectionInset.bottom;
}

- (CGSize)collectionViewContentSize
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    }
    else
    {
        return CGSizeMake(self.contentWidth,self.collectionView.frame.size.height);
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}


- (id<UICollectionViewDelegateFlowLayout>)delegate
{
    if (_delegate == nil) {
        _delegate =  (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    
    return _delegate;
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        self.itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
   
    return self.itemSize;
}

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

@end

//
//  JTPageItemFlowLayout.m
//  JTSocial
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTPageItemFlowLayout.h"

@interface JTPageItemFlowLayout()

@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, strong) NSMutableArray * attributesArray;

@end

@implementation JTPageItemFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowCount = 2;
        self.columnCount = 4;
    }
    return self;
}

- (instancetype)initWithRowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount
{
    self = [super init];
    if (self) {
        self.rowCount = rowCount;
        self.columnCount = columnCount;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemTotalCount; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat itemWidth = self.collectionView.frame.size.width / self.columnCount;
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    NSInteger itemCount = self.rowCount * self.columnCount;
    NSInteger remainder = itemTotalCount % itemCount;
    NSInteger pageCount = itemTotalCount / itemCount;
    if(remainder != 0){
        pageCount ++;
    }
    CGFloat pageWidth = itemWidth*self.columnCount;
    return  CGSizeMake(pageWidth*pageCount, 0);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = self.collectionView.frame.size.width / self.columnCount;
    CGFloat itemHeight = self.collectionView.frame.size.height / self.rowCount;
    
    NSInteger item = indexPath.item;
    
    NSInteger pageNumber = item / (self.rowCount * self.columnCount);
    NSInteger x = item % self.columnCount + pageNumber * self.columnCount;
    NSInteger y = item / self.columnCount - pageNumber * self.rowCount;
    
    CGFloat itemX = itemWidth * x;
    CGFloat itemY = itemHeight * y;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

- (NSMutableArray *)attributesArray
{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end

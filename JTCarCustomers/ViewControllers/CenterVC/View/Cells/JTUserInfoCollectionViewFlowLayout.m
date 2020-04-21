//
//  JTUserInfoCollectionViewFlowLayout.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define defaultGap 5
#import "JTUserInfoCollectionViewFlowLayout.h"

@interface JTUserInfoCollectionViewFlowLayout ()

@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) CGSize expandSize;
@property (nonatomic, assign) CGFloat squareWithGap;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL setUped;

@end

@implementation JTUserInfoCollectionViewFlowLayout

- (instancetype)initWithFrame:(CGRect)frame itemsInRow:(NSInteger)items
{
    self = [super init];
    if (self) {
        self.itemsInRow = items;
        self.frame = frame;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = defaultGap;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(defaultGap, defaultGap, 0, 0);
        
        [self reloadGrid];
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    self.maxWidth = CGRectGetWidth(self.collectionView.frame);
    self.maxHeight = defaultGap + ceil(((float)[self.collectionView numberOfItemsInSection:0]) / self.itemsInRow) * self.squareWithGap;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect shiftFrame = rect;
    shiftFrame.origin.y -= CGRectGetHeight(self.collectionView.bounds);
    shiftFrame.size.height += CGRectGetHeight(self.collectionView.bounds) * 2;
    NSMutableArray *attributes = [NSMutableArray array];
    NSArray *originAttributes = [super layoutAttributesForElementsInRect:shiftFrame];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 0; i < originAttributes.count; i++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [originAttributes[i] copy];
        CGRect frame = layoutAttributes.frame;
        NSInteger row = layoutAttributes.indexPath.row;
        BOOL isDefaultItem = NO;
        if (indexPath) {
            [self expandAtRow:row indexPath:indexPath isDefaultItem:&isDefaultItem frame:&frame];
            
            if (isDefaultItem) {
                NSInteger shiftIndex = row;
                if (row > indexPath.row) {
                    shiftIndex = row + pow((self.itemsInRow - 1), 2) - 1;
                }
                frame.origin = [self gridPositionAtIndex:shiftIndex];
            }
            
        }
        layoutAttributes.frame = frame;
        [attributes addObject:layoutAttributes];
    }
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.maxWidth, self.maxHeight);
}

#pragma mark - instance method

- (void)reloadGrid {
    
    CGFloat square = (CGRectGetWidth(self.frame) - ((self.itemsInRow + 1) * defaultGap)) / self.itemsInRow;
    self.squareWithGap = square + defaultGap;
    self.originalSize = CGSizeMake(square, square);
    self.expandSize = CGSizeMake(square * (self.itemsInRow - 1) + defaultGap * (self.itemsInRow - 2), square * (self.itemsInRow - 1) + defaultGap * (self.itemsInRow - 2));
}

- (CGPoint)gridPositionAtIndex:(NSInteger)index offsetX:(NSInteger)offsetX offsetY:(NSInteger)offsetY {
    NSInteger gridX = [self gridXFromIndex:index];
    NSInteger gridY = [self gridYFromIndex:index];
    CGFloat positionX = defaultGap + ((gridX + offsetX) * self.squareWithGap);
    CGFloat positionY = defaultGap + ((gridY + offsetY) * self.squareWithGap);
    return CGPointMake(positionX, positionY);
}

- (CGPoint)gridPositionAtIndex:(NSInteger)index {
    return [self gridPositionAtIndex:index offsetX:0 offsetY:0];
}

- (NSInteger)gridXFromIndex:(NSInteger)index {
    return index % self.itemsInRow;
}

- (NSInteger)gridYFromIndex:(NSInteger)index {
    return index / self.itemsInRow;
}

- (void)expandAtRow:(NSInteger)row indexPath:(NSIndexPath *)indexPath isDefaultItem:(BOOL *)isDefaultItem frame:(CGRect *)frame {
    if ([self gridYFromIndex:row] == [self gridYFromIndex:indexPath.row]) {
        NSInteger delta = row - indexPath.row;
        NSInteger indexInRow = row % self.itemsInRow;
        NSInteger offsetX = 0;
        NSInteger offsetY = 0;
        if (delta < 0) {
            NSInteger balance = self.itemsInRow - 1;
            offsetX = balance - indexInRow;
            offsetY = balance - offsetX;
        }
        else if (delta == 0) {
            offsetX = -1 * indexInRow;
        }
        else if (delta > 0) {
            NSInteger balance = self.itemsInRow - 2;
            offsetX = balance - indexInRow + 1;
            offsetY = balance - offsetX;
        }
        frame->origin = [self gridPositionAtIndex:row offsetX:offsetX offsetY:offsetY];
    }
    else {
        *isDefaultItem = YES;
    }
}

@end

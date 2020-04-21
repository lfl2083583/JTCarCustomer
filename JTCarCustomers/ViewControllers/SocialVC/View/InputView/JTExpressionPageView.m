//
//  JTExpressionPageView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionPageView.h"
#import "JTInputEmojiCollectionViewCell.h"
#import "JTInputExpressionCollectionViewCell.h"
#import "UIImage+Chat.h"

@interface JTExpressionPageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation JTExpressionPageView

- (void)drawRect:(CGRect)rect
{
    [self setup];
    [self registerClass:[JTInputEmojiCollectionViewCell class] forCellWithReuseIdentifier:inputEmojiIdentifier];
    [self registerClass:[JTInputExpressionCollectionViewCell class] forCellWithReuseIdentifier:inputExpressionIdentifier];
}

- (void)didMoveToWindow
{
    [self setBackgroundColor:WhiteColor];
    [super didMoveToWindow];
}

- (void)setItem:(JTExpressionItem *)item
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(item.layout.cellWidth, item.layout.cellHeight);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionViewLayout = layout;
    self.contentOffset = CGPointZero;
    _item = item;
    [self reloadData];
}

- (void)setup
{
    self.dataSource = self;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

// 收藏类型 要添加一个添加按钮（位于第一个item）
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.item.expressions.count + (self.item.type == JTExpressionTypeCollection);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.type == JTExpressionTypeEmoji) {
        JTInputEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputEmojiIdentifier forIndexPath:indexPath];
        cell.emoji.size = CGSizeMake(self.item.layout.imageWidth, self.item.layout.imageHeight);
        cell.emoji.center = CGPointMake(cell.width/2, cell.height/2);
        cell.emoji.image = [UIImage jt_emoticonInKit:[self.item.expressions[indexPath.row] localFileName]];
        return cell;
    }
    else
    {
        JTInputExpressionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputExpressionIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0 && self.item.type == JTExpressionTypeCollection) {
            [cell.imageView setImage:[UIImage jt_imageInKit:@"icon_addCollectionEmoticon"]];
            [cell.titleLB setText:@""];
        }
        else
        {
            JTExpression *expression = [self.item.expressions objectAtIndex:indexPath.row - (self.item.type == JTExpressionTypeCollection)];
            cell.imageUrlString = expression.thumbnailUrl;
            cell.title = expression.name;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectExpressionBlock) {
        if (indexPath.row == 0 && self.item.type == JTExpressionTypeCollection) {
            self.didAddCollectionExpressionBlock();
        }
        else
        {
            JTExpression *expression = [self.item.expressions objectAtIndex:indexPath.row - (self.item.type == JTExpressionTypeCollection)];
            self.didSelectExpressionBlock(expression);
        }
    }
}
@end

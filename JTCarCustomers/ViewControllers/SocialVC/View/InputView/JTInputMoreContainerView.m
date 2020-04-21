//
//  JTInputMoreContainerView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputMoreContainerView.h"
#import "JTPageItemFlowLayout.h"
#import "JTInputMediaCollectionViewCell.h"
#import "JTInputGlobal.h"

@interface JTInputMoreContainerView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *mediaItems;
@property (strong, nonatomic) UICollectionView *collectionview;
@end

@implementation JTInputMoreContainerView

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputConfig = config;
        _delegate = delegate;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)setup
{
    if (self.inputConfig && [self.inputConfig respondsToSelector:@selector(mediaItems)]) {
        self.mediaItems = [self.inputConfig mediaItems];
    }
    [self addSubview:self.collectionview];
    [self.collectionview registerClass:[JTInputMediaCollectionViewCell class] forCellWithReuseIdentifier:inputMediaIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.mediaItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTInputMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputMediaIdentifier forIndexPath:indexPath];
    JTMediaItem *item = [self.mediaItems objectAtIndex:indexPath.row];
    [cell.button setImage:item.normalImage forState:UIControlStateNormal];
    [cell.button setImage:item.selectedImage forState:UIControlStateHighlighted];
    [cell.button setTitle:item.title forState:UIControlStateNormal];
    [cell.button centerImageAndTitle];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTMediaItem *item = [self.mediaItems objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapMediaItem:)]) {
        [self.delegate onTapMediaItem:item];
    }
}

- (UICollectionView *)collectionview
{
    if (!_collectionview) {
        JTPageItemFlowLayout *layout = [[JTPageItemFlowLayout alloc] initWithRowCount:2 columnCount:4];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.backgroundColor = WhiteColor;
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.pagingEnabled = YES;
        _collectionview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _collectionview;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, input_containerHeight);
}

@end

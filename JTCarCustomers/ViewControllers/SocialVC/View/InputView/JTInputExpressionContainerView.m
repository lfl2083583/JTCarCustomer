//
//  JTInputExpressionContainerView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputExpressionContainerView.h"
#import "iCarousel.h"
#import "JTExpressionPageView.h"
#import "JTInputEmojiCollectionViewCell.h"
#import "UIImage+Chat.h"
#import "JTInputGlobal.h"

@interface JTInputExpressionContainerView () <iCarouselDelegate, iCarouselDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger selectedIndex;
}
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) UIView *bottomToolView;
@property (strong, nonatomic) UIButton *expressionStoreBT;
@property (strong, nonatomic) UIButton *sendBT;
@property (strong, nonatomic) UIButton *manageBT;
@property (strong, nonatomic) UICollectionView *collectionview;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JTInputExpressionContainerView

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
    /***************
     添加数据
     */
    __weak typeof(self) weakself = self;
    [JTInputExpressionManager sharedManager].loadSuccessBlock = ^(JTExpressionItem *emojiExpressionItem, JTExpressionItem *collectionExpressionItem, NSMutableArray<JTExpressionItem *> *otherExpressionItemArray) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObject:emojiExpressionItem];
        [weakself.dataArray addObject:collectionExpressionItem];
        [weakself.dataArray addObjectsFromArray:otherExpressionItemArray];
        [weakself.carousel reloadData];
        [weakself.collectionview reloadData];
    };
    [self addSubview:self.carousel];
    [self addSubview:self.bottomToolView];
    [self.bottomToolView addSubview:self.expressionStoreBT];
    [self.bottomToolView addSubview:self.sendBT];
    [self.bottomToolView addSubview:self.manageBT];
    [self.manageBT setHidden:YES];
    [self.bottomToolView addSubview:self.collectionview];
    [self.collectionview registerClass:[JTInputEmojiCollectionViewCell class] forCellWithReuseIdentifier:inputEmojiIdentifier];
}

- (void)expressionStoreClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapExpressionStore)]) {
        [self.delegate onTapExpressionStore];
    }
}

- (void)sendClick:(id)sender
{
    SEL selector = NSSelectorFromString(self.didSendMethod);
    ((void (*)(id, SEL))[self.target methodForSelector:selector])(self.target, selector);
}

- (void)manageClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapExpressionManage)]) {
        [self.delegate onTapExpressionStore];
    }
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable JTExpressionPageView *)view
{
    if (view == nil) {
        view = [[JTExpressionPageView alloc] initWithFrame:carousel.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    view.item = [self.dataArray objectAtIndex:index];
    __weak typeof(self) weakself = self;
    view.didAddCollectionExpressionBlock = ^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(onTapExpressionAddCollection)]) {
            [weakself.delegate onTapExpressionAddCollection];
        }
    };
    view.didSelectExpressionBlock = ^(JTExpression *expression) {
        SEL selector = NSSelectorFromString(weakself.didExpressionMethod);
        IMP imp = [weakself.target methodForSelector:selector];
        void (*func)(id, SEL, JTExpression*) = (void *)imp;
        func(weakself.target, selector, expression);
    };
    return view;
}

#pragma mark - iCarouselDelegate
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    selectedIndex = carousel.currentItemIndex;
    if (selectedIndex == 0) {
        self.sendBT.hidden = NO;
        self.manageBT.hidden = YES;
    }
    else
    {
        self.sendBT.hidden = YES;
        self.manageBT.hidden = NO;
    }
    [self.collectionview reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTInputEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputEmojiIdentifier forIndexPath:indexPath];
    JTExpressionItem *item = [self.dataArray objectAtIndex:indexPath.row];
    cell.emoji.size = CGSizeMake(25, 25);
    cell.emoji.center = CGPointMake(cell.width/2, cell.height/2);
    if (item.type == JTExpressionTypeEmoji) {
        cell.emoji.image = [UIImage jt_emoticonInKit:item.icon];
    }
    else if (item.type == JTExpressionTypeCollection) {
        cell.emoji.image = [UIImage jt_imageInKit:item.icon];
    }
    else
    {
        [cell.emoji sd_setImageWithURL:[NSURL URLWithString:[item.icon avatarHandleWithSquare:50]]];
    }
    cell.backgroundColor = (indexPath.row == selectedIndex) ? BlackLeverColor1 : WhiteColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.carousel scrollToItemAtIndex:indexPath.row animated:YES];
}

- (iCarousel *)carousel
{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-self.bottomToolView.height)];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.bounces = NO;
        _carousel.pagingEnabled = YES;
        _carousel.clipsToBounds = YES;
        _carousel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _carousel;
}

- (UIView *)bottomToolView
{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-input_bottomToolHeight, self.width, input_bottomToolHeight)];
    }
    return _bottomToolView;
}

- (UIButton *)expressionStoreBT
{
    if (!_expressionStoreBT) {
        _expressionStoreBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expressionStoreBT setImage:[UIImage jt_imageInKit:@"icon_small_add"] forState:UIControlStateNormal];
        _expressionStoreBT.frame = CGRectMake(0, 0, 50, input_bottomToolHeight);
        [_expressionStoreBT addTarget:self action:@selector(expressionStoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressionStoreBT;
}

- (UIButton *)sendBT
{
    if (!_sendBT) {
        _sendBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBT.backgroundColor = BlueLeverColor1;
        [_sendBT setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        _sendBT.titleLabel.font = Font(15);
        _sendBT.frame = CGRectMake(self.width-60, 0, 60, input_bottomToolHeight);
        [_sendBT addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBT;
}

- (UIButton *)manageBT
{
    if (!_manageBT) {
        _manageBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_manageBT setImage:[UIImage jt_imageInKit:@"icon_small_setting"] forState:UIControlStateNormal];
        _manageBT.frame = CGRectMake(self.width-60, 0, 60, input_bottomToolHeight);
        [_manageBT addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageBT;
}

- (UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(50, input_bottomToolHeight);
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(self.expressionStoreBT.right, 0, self.manageBT.left-self.expressionStoreBT.right, input_bottomToolHeight) collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.backgroundColor = WhiteColor;
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _collectionview;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, input_containerHeight);
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

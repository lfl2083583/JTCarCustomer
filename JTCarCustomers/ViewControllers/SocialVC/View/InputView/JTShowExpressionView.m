//
//  JTShowExpressionView.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTShowExpressionView.h"
#import "JTInputEmojiCollectionViewCell.h"
#import "UIImage+Chat.h"

#define kShowMaxWidth  212

@interface JTShowExpressionView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSTimer *_timer;
}
@property (strong, nonatomic) UIImageView *bubble;
@property (strong, nonatomic) UICollectionView *collectionview;

@end

@implementation JTShowExpressionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
    }
    return self;
}

- (void)setExpressions:(NSArray<JTExpression *> *)expressions
{
    _expressions = expressions;
    if (expressions && expressions.count > 0) {
        self.hidden = NO;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionview.collectionViewLayout;
        double width = MIN(((layout.itemSize.width + layout.sectionInset.right) * expressions.count + layout.sectionInset.left), kShowMaxWidth);
        double height = layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom + 5;
        double left = App_Frame_Width - width;
        self.frame = CGRectMake(left, -height, width, height);
        self.bubble.frame = self.bounds;
        self.bubble.image = [[UIImage jt_imageInKit:@"EomticonBubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 10, 18, 50) resizingMode:UIImageResizingModeStretch];
        self.collectionview.frame = CGRectMake(0, 0, width, (layout.itemSize.width + layout.sectionInset.top  + layout.sectionInset.bottom));
        [self starTimer];
    }
    else
    {
        self.hidden = YES;
        self.frame = CGRectZero;
        self.collectionview.frame = CGRectZero;
    }
    [self.collectionview reloadData];
}

- (void)initSubview
{
    _bubble = [[UIImageView alloc] init];
    [self addSubview:self.bubble];
    
    UICollectionViewFlowLayout *_layout = [UICollectionViewFlowLayout new];
    _layout.itemSize = CGSizeMake(70, 70);
    _layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _layout.minimumLineSpacing = 15;
    _layout.minimumInteritemSpacing = 15;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.showsHorizontalScrollIndicator = NO;
    [self.collectionview registerClass:[JTInputEmojiCollectionViewCell class] forCellWithReuseIdentifier:inputEmojiIdentifier];
    [self addSubview:self.collectionview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.expressions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTInputEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputEmojiIdentifier forIndexPath:indexPath];
    cell.emoji.size = cell.size;
    cell.emoji.center = CGPointMake(cell.width/2, cell.height/2);
    JTExpression *item = [self.expressions objectAtIndex:indexPath.row];
    [cell.emoji sd_setImageWithURL:[NSURL URLWithString:[item.originalUrl avatarHandleWithSize:CGSizeMake(cell.size.width*2, cell.size.height*2)]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SEL selector = NSSelectorFromString(self.didShowExpressionMethod);
    IMP imp = [self.target methodForSelector:selector];
    void (*func)(id, SEL, JTExpression*) = (void *)imp;
    func(self.target, selector, [self.expressions objectAtIndex:indexPath.row]);
    [self stopTimer];
}

- (void)starTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(handleHideTimer:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    [self setExpressions:nil];
}

- (void)handleHideTimer:(NSTimer *)timer
{
    [self stopTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self starTimer];
}

- (void)dealloc
{
    [self stopTimer];
}
@end

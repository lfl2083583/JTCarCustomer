//
//  JTGarageViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTGarageViewController.h"

static NSString *collectionCellID = @"JTGarageCollectionViewCell";

@implementation JTGarageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImgeV];
        [self addSubview:self.bottomImgeV];
        [self addSubview:self.bottomLB];
    }
    return self;
}

- (UIImageView *)topImgeV {
    if (!_topImgeV) {
        _topImgeV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        _topImgeV.backgroundColor = BlackLeverColor1;
    }
    return _topImgeV;
}

- (UIImageView *)bottomImgeV {
    if (!_bottomImgeV) {
        _bottomImgeV = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.topImgeV.frame)+7, 17, 17)];
    }
    return _bottomImgeV;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bottomImgeV.frame)+9, CGRectGetMaxY(self.topImgeV.frame)+7, self.bounds.size.width-CGRectGetMaxX(self.bottomImgeV.frame)-9, 20)];
        _bottomLB.font = Font(14);
        _bottomLB.textColor = BlackLeverColor5;
    }
    return _bottomLB;
}


@end


@interface JTGarageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JTGarageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)acceptMsg:(NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.collectionView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kLeaveTopNotificationName]){
        self.collectionView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        self.block();
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 6, 0, 6);
        CGFloat itemWidth = (App_Frame_Width-20)/2.0;
        CGFloat itemHeight = itemWidth+30;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kTopBarHeight*2-kStatusBarHeight-50) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:WhiteColor];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView registerClass:[JTGarageCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    }
    return _collectionView;
}
@end


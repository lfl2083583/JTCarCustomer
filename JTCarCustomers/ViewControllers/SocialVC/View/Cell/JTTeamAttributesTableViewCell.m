//
//  JTTeamAttributesTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamAttributesTableViewCell.h"

static NSString *teamAttributeCellIdentifier = @"JTTeamAttributesCollectionCell";

@interface JTTeamAttributesCollectionCell ()

@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *topLayer;

@end

@implementation JTTeamAttributesCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.topLayer];
        CGPoint origin = CGPointMake(self.width/2.0, self.width/2.0+2);
        CGFloat radius = self.width/2.0;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:origin radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        self.bottomLayer.path = path.CGPath;
        [self addSubview:self.centerLB];
        [self addSubview:self.bottomLB];
    }
    return self;
}

- (void)configCellWithProgress:(CGFloat)progress strokeColor:(UIColor *)strokeColor title:(NSString *)title{
    self.centerLB.text = [NSString stringWithFormat:@"%0.f%%",progress*100];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0, self.width/2.0+1) radius:self.width/2.0 startAngle:-M_PI_2 endAngle:(-M_PI_2+progress*M_PI*2) clockwise:YES];
    self.topLayer.path = path.CGPath;
    self.topLayer.strokeColor = strokeColor.CGColor;
    self.bottomLB.text = title;
    self.centerLB.textColor = strokeColor;
}

- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.frame = CGRectMake(0, 4, self.width, self.width);
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
        _bottomLayer.strokeColor= BlackLeverColor2.CGColor;
        _bottomLayer.lineWidth = 2;
    }
    return _bottomLayer;
}

- (CAShapeLayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [CAShapeLayer layer];
        _topLayer.frame = CGRectMake(0, 4, self.width, self.width);
        _topLayer.fillColor = [UIColor clearColor].CGColor;
        _topLayer.lineWidth = 2;
    }
    return _topLayer;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.width-20)/2.0+4, self.width, 20)];
        _centerLB.font = Font(16);
        _centerLB.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(0, self.width+7, self.width, 20)];
        _bottomLB.font = Font(14);
        _bottomLB.textColor = BlackLeverColor3;
        _bottomLB.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLB;
}

@end


@interface JTTeamAttributesTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation JTTeamAttributesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.collectionView];
        self.clipsToBounds = YES;
        self.colors = @[UIColorFromRGB(0xec88d7), UIColorFromRGB(0xb1a3f2), UIColorFromRGB(0xc58ffb), UIColorFromRGB(0x66a4fe)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setPropertys:(NSArray *)propertys {
    _propertys = propertys;
    [_collectionView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTTeamAttributesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:teamAttributeCellIdentifier forIndexPath:indexPath];
    NSDictionary *dictionary = self.propertys[indexPath.row];
    CGFloat progress = [[dictionary objectForKey:@"ratio"] floatValue] / 100;
    UIColor *color = indexPath.row < self.colors.count?self.colors[indexPath.row]:self.colors[0];
    NSString *title = [dictionary objectForKey:@"category"];
    [cell configCellWithProgress:progress strokeColor:color title:title];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.propertys.count;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        CGFloat itemWidth = (App_Frame_Width-90)/4.0;
        CGFloat itemHeight = itemWidth+30;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLB.frame)+10, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-50) collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[JTTeamAttributesCollectionCell class] forCellWithReuseIdentifier:teamAttributeCellIdentifier];
    }
    return _collectionView;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, App_Frame_Width-40, 22)];
        _topLB.font = Font(16);
        _topLB.textColor = BlackLeverColor5;
        _topLB.text = @"群组属性";
    }
    return _topLB;
}


@end

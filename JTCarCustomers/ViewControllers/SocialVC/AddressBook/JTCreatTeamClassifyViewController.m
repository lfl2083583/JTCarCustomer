//
//  JTCreatTeamClassifyViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTCreatTeamClassifyViewController.h"

@implementation JTCreatTeamClassifyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topImgView];
        [self addSubview:self.bottomLabel];
    }
    return self;
}

- (void)configCellWithTopImge:(UIImage *)image botttomTitle:(NSString *)title isSeleted:(BOOL)flag {
    self.topImgView.image = image;
    self.bottomLabel.text = title;
    self.layer.borderWidth = 0.5;
    if (flag) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = BlackLeverColor2.CGColor;
    } else {
         self.layer.borderColor = WhiteColor.CGColor;
    }
}

- (UIImageView *)topImgView {
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 44) / 2.0, 5, 44, 44)];
        _topImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImgView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImgView.frame) + 10, self.bounds.size.width, 22)];
        _bottomLabel.font = Font(16);
        _bottomLabel.textColor = BlackLeverColor5;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

@end

@interface JTCreatTeamClassifyViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, assign) JTTeamPositionType positionType;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *address;

@end

@implementation JTCreatTeamClassifyViewController

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamClassifyBlock)callBack {
    if (self = [super init]) {
        self.team = team;
        [self setCallBack:callBack];
    }
    return self;
}

- (instancetype)initWithTeamNearby:(JTTeamPositionType)positionType lng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address {
    if (self = [super init]) {
        self.positionType = positionType;
        self.lng = lng;
        self.lat = lat;
        self.address = address;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?82:62;
    [self setupDatas];
    [self setupComponent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)setupDatas {
    JTWordItem *item1 = [[JTWordItem alloc] init];
    item1.title = @"车友";
    item1.image = [UIImage imageNamed:@"team_car_friends"];
    
    JTWordItem *item2 = [[JTWordItem alloc] init];
    item2.title = @"运动";
    item2.image = [UIImage imageNamed:@"team_sport"];
    
    JTWordItem *item3 = [[JTWordItem alloc] init];
    item3.title = @"交友";
    item3.image = [UIImage imageNamed:@"team_making friends"];
    
    JTWordItem *item4 = [[JTWordItem alloc] init];
    item4.title = @"玩乐";
    item4.image = [UIImage imageNamed:@"team_play"];
    
    JTWordItem *item5 = [[JTWordItem alloc] init];
    item5.title = @"生活";
    item5.image = [UIImage imageNamed:@"team_live"];
    
    JTWordItem *item6 = [[JTWordItem alloc] init];
    item6.title = @"游戏";
    item6.image = [UIImage imageNamed:@"team_game"];
    
    JTWordItem *item7 = [[JTWordItem alloc] init];
    item7.title = @"同城";
    item7.image = [UIImage imageNamed:@"team_slice"];
    
    JTWordItem *item8 = [[JTWordItem alloc] init];
    item8.title = @"兴趣";
    item8.image = [UIImage imageNamed:@"team_interest"];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4, item5, item6, item7, item8]];
}

- (void)setupComponent {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat itemWidth = (App_Frame_Width - 50) / 4.0;
    CGFloat itemHeight = 85;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 30;
    layout.minimumInteritemSpacing = 0;
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 193, App_Frame_Width - 20, self.view.bounds.size.height - 193) collectionViewLayout:layout];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.backgroundColor = WhiteColor;
    [self.collectionview registerClass:[JTCreatTeamClassifyCollectionCell class] forCellWithReuseIdentifier:teamClassfyId];
    [self.view addSubview:self.collectionview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTCreatTeamClassifyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:teamClassfyId forIndexPath:indexPath];
    JTWordItem *item = self.dataArray[indexPath.row];
    [cell configCellWithTopImge:item.image botttomTitle:item.title isSeleted:item.isSeleted];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (JTWordItem *item in self.dataArray) {
        item.isSeleted = NO;
    }
    JTWordItem *item = self.dataArray[indexPath.row];
    item.isSeleted = YES;
    [self.collectionview reloadData];
    if (self.team) {
        if (self.callBack) {
            self.callBack(indexPath.row+1);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController pushViewController:[[JTCreateTeamTitleViewController alloc] initWithTeamNearby:self.positionType lng:self.lng lat:self.lat address:self.address classfy:indexPath.row+1] animated:YES];
    }
    
}
@end

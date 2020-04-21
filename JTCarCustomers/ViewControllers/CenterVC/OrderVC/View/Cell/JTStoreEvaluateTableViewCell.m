//
//  JTStoreEvaluateTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTStarView.h"
#import "GCPlaceholderTextView.h"
#import "JTStoreEvaluateTableViewCell.h"

static NSString *const storeEvaluateCollectionIdentifier = @"JTStoreEvaluateCollectionViewCell";

@protocol JTStoreEvaluateCollectionViewCellDelegate <NSObject>

- (void)collectionViewCellDeleteBtnClick:(NSIndexPath *)indexPath;

@end

@interface JTStoreEvaluateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indedxPath;
@property (nonatomic, assign) BOOL isAddItem;
@property (nonatomic, weak) id<JTStoreEvaluateCollectionViewCellDelegate>delegate;

@end


@implementation JTStoreEvaluateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
        self.bottomView.backgroundColor = BlackLeverColor1;
        [self.contentView addSubview:self.bottomView];
        
        self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
        self.coverView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverView];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-22, 0, 22, 22)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_delete_photo"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
    }
    return self;
}

- (void)deleteBtnClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(collectionViewCellDeleteBtnClick:)]) {
        [_delegate collectionViewCellDeleteBtnClick:self.indedxPath];
    }
}

- (void)setIndedxPath:(NSIndexPath *)indedxPath {
    _indedxPath = indedxPath;
}

- (void)setIsAddItem:(BOOL)isAddItem {
    _isAddItem = isAddItem;
    if (isAddItem) {
        [self.coverView setFrame:CGRectMake((self.width-28)/2.0, (self.height-25)/2.0, 28, 25)];
    } else {
        [self.coverView setFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
    }
}

@end

@interface JTStoreEvaluateTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, JTStoreEvaluateCollectionViewCellDelegate, ZTStarViewDelegate>

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *environmentLB;
@property (nonatomic, strong) UILabel *abilityLB;
@property (nonatomic, strong) UILabel *serviceLB;
@property (nonatomic, strong) UILabel *environmentEvaluate;
@property (nonatomic, strong) UILabel *abilityEvaluate;
@property (nonatomic, strong) UILabel *serviceEvaluate;
@property (nonatomic, strong) ZTStarView *environmentStar;
@property (nonatomic, strong) ZTStarView *abilityStar;
@property (nonatomic, strong) ZTStarView *serviceStar;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) GCPlaceholderTextView *textView;
@property (nonatomic, strong) UILabel *wordsLB;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat environmentScore;
@property (nonatomic, assign) CGFloat abilityScore;
@property (nonatomic, assign) CGFloat serviceScore;

@end

@implementation JTStoreEvaluateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setupViews {
    self.titleLB = [self buildLabel:Font(16) textColor:BlackLeverColor5 frame:CGRectMake(22, 5, App_Frame_Width-44, 20)];
    [self.titleLB setText:@"你对这次的到店服务满意吗？"];
    [self.contentView addSubview:self.titleLB];
    
    self.environmentLB = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(22, CGRectGetMaxY(self.titleLB.frame)+15, 80, 20)];
    [self.environmentLB setText:@"店面环境"];
    [self.contentView addSubview:self.environmentLB];
    
    self.abilityLB = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(22, CGRectGetMaxY(self.environmentLB.frame)+10, 80, 20)];
    [self.abilityLB setText:@"技术能力"];
    [self.contentView addSubview:self.abilityLB];
    
    self.serviceLB = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(22, CGRectGetMaxY(self.abilityLB.frame)+10, 80, 20)];
    [self.serviceLB setText:@"服务态度"];
    [self.contentView addSubview:self.serviceLB];
    
    self.environmentEvaluate = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(App_Frame_Width-60, CGRectGetMaxY(self.titleLB.frame)+15, 40, 20)];
    [self.environmentEvaluate setText:@"较差"];
    [self.environmentEvaluate setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.environmentEvaluate];
    
    self.abilityEvaluate = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(App_Frame_Width-60, CGRectGetMaxY(self.environmentEvaluate.frame)+10, 40, 20)];
    [self.abilityEvaluate setText:@"较差"];
    [self.abilityEvaluate setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.abilityEvaluate];
    
    self.serviceEvaluate = [self buildLabel:Font(16) textColor:BlackLeverColor3 frame:CGRectMake(App_Frame_Width-60, CGRectGetMaxY(self.abilityEvaluate.frame)+10, 40, 20)];
    [self.serviceEvaluate setText:@"较差"];
    [self.serviceEvaluate setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.serviceEvaluate];
    
    self.environmentStar = [[ZTStarView alloc] initWithFrame:CGRectMake(App_Frame_Width-190, CGRectGetMaxY(self.titleLB.frame)+15, 120, 20)];
    self.environmentStar.delegate = self;
    self.environmentStar.tag = 100;
    self.environmentStar.starImageNormal = @"icon_largestar_unlight";
    self.environmentStar.starImageHighlight = @"icon_largestar_light";
    [self.environmentStar setScore:0.0 withAnimation:NO];
    [self.contentView addSubview:self.environmentStar];
    
    self.abilityStar = [[ZTStarView alloc] initWithFrame:CGRectMake(App_Frame_Width-190, CGRectGetMaxY(self.environmentStar.frame)+10, 120, 20)];
    self.abilityStar.delegate = self;
    self.abilityStar.tag = 101;
    self.abilityStar.starImageNormal = @"icon_largestar_unlight";
    self.abilityStar.starImageHighlight = @"icon_largestar_light";
    [self.abilityStar setScore:0.0 withAnimation:NO];
    [self.contentView addSubview:self.abilityStar];
    
    self.serviceStar = [[ZTStarView alloc] initWithFrame:CGRectMake(App_Frame_Width-190, CGRectGetMaxY(self.abilityStar.frame)+10, 120, 20)];
    self.serviceStar.delegate = self;
    self.serviceStar.tag = 102;
    self.serviceStar.starImageNormal = @"icon_largestar_unlight";
    self.serviceStar.starImageHighlight = @"icon_largestar_light";
    [self.serviceStar setScore:0.0 withAnimation:NO];
    [self.contentView addSubview:self.serviceStar];
    
    [self.contentView addSubview:self.inputView];
    
    self.textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.inputView.frame)-10, CGRectGetHeight(self.inputView.frame)-21)];
    [self.textView setPlaceholder:@"输入评价内容（选填）"];
    [self.textView setBackgroundColor:BlackLeverColor1];
    [self.textView setFont:Font(14)];
    [self.inputView addSubview:self.textView];
    
    self.wordsLB = [self buildLabel:Font(14) textColor:BlackLeverColor3 frame:CGRectMake(CGRectGetWidth(self.inputView.frame)-70, CGRectGetHeight(self.inputView.frame)-21, 60, 20)];
    [self.wordsLB setText:@"0/100"];
    [self.wordsLB setTextAlignment:NSTextAlignmentRight];
    [self.inputView addSubview:self.wordsLB];
    
    [self.contentView addSubview:self.collectionView];
}

- (void)setPhotoArray:(NSArray *)photoArray {
    _photoArray = photoArray;
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTStoreEvaluateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:storeEvaluateCollectionIdentifier forIndexPath:indexPath];
    cell.indedxPath = indexPath;
    cell.delegate = self;
    if ((self.photoArray.count < 8 && indexPath.row != self.photoArray.count) || self.photoArray.count == 8) {
        [cell.coverView setImage:self.photoArray[indexPath.row]];
        cell.deleteBtn.hidden = NO;
        cell.isAddItem = NO;
    }
    else if ((self.photoArray.count < 8 && indexPath.row == self.photoArray.count))
    {
        cell.isAddItem = YES;
        cell.deleteBtn.hidden = YES;
        cell.coverView.image = [UIImage imageNamed:@"icon_addphoto"];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.photoArray.count < 8)?self.photoArray.count+1:8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.photoArray.count < 8) && (indexPath.row == self.photoArray.count) && _delegate && [_delegate respondsToSelector:@selector(storeEvaluateTableViewCellAddPhoto)]) {
        [_delegate storeEvaluateTableViewCellAddPhoto];
    }
}

#pragma mark JTStoreEvaluateCollectionViewCellDelegate
- (void)collectionViewCellDeleteBtnClick:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(storeEvaluateTableViewCellDeletePhoto:)]) {
        [_delegate storeEvaluateTableViewCellDeletePhoto:indexPath.row];
    }
}

#pragma mark ZTStarViewDelegate
- (void)starView:(ZTStarView *)view score:(float)score {
    CCLOG(@"%f", score);
    CGFloat realScore = score*5;
    NSString *evaluate = @"较差";
    JTStoreStarType starType = JTStoreStarTypeEnvironment;
    if (realScore < 3) {
        evaluate = @"较差";
    }
    else if (realScore > 4)
    {
        evaluate = @"满意";
    }
    else
    {
        evaluate = @"一般";
    }
    if (view.tag == 100) {
        [self.environmentEvaluate setText:evaluate];
        starType = JTStoreStarTypeEnvironment;
    }
    else if (view.tag == 101)
    {
        [self.abilityEvaluate setText:evaluate];
        starType = JTStoreStarTypeAbility;
    }
    else if (view.tag == 102)
    {
        [self.serviceEvaluate setText:evaluate];
        starType = JTStoreStarTypeService;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(storeEvaluateTableViewCellStarEvaluate:score:)]) {
        [_delegate storeEvaluateTableViewCellStarEvaluate:starType score:realScore];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeightWithPhotos:(NSArray *)photoArray
{
    CGFloat cellHeight = 250;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
    CGFloat itemWidth = (App_Frame_Width-40)/4.0;
    CGFloat itemHeight = itemWidth;
    if (photoArray.count != 8) {
        NSInteger clum = photoArray.count/4;
        cellHeight += layout.sectionInset.top+itemHeight+(itemHeight+10)*clum+layout.sectionInset.bottom;
    } else {
        cellHeight += layout.sectionInset.top+itemHeight+itemHeight+10+layout.sectionInset.bottom;
    }
    return cellHeight;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = BlackLeverColor1;
        _inputView.frame = CGRectMake(20, CGRectGetMaxY(self.serviceLB.frame)+30, App_Frame_Width-40, 90);
        _inputView.layer.cornerRadius = 4;
        _inputView.layer.masksToBounds = YES;
    }
    return _inputView;
}

- (UILabel *)buildLabel:(UIFont *)font textColor:(UIColor *)textColor frame:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = rect;
    label.font = font;
    label.textColor = textColor;
    return label;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        CGFloat itemWidth = (App_Frame_Width-40)/4.0;
        CGFloat itemHeight = itemWidth;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.inputView.frame)+10, App_Frame_Width, 200) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:WhiteColor];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView registerClass:[JTStoreEvaluateCollectionViewCell class] forCellWithReuseIdentifier:storeEvaluateCollectionIdentifier];
    }
    return _collectionView;
}

@end

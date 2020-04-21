//
//  JTTalentEvaluateTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "ZTTagAttribute.h"
#import "JTStarView.h"
#import "ZTTagCollectionViewCell.h"
#import "ZTTagCollectionViewFlowLayout.h"
#import "JTTalentEvaluateTableViewCell.h"

@interface JTTalentEvaluateTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) JTStarView *starView;
@property (nonatomic, strong) ZTTagCollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger index;

@end

static NSString *evaluateCollectionCellIndentify = @"JTTalentEvaluateCollectionViewCell";

@implementation JTTalentEvaluateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(15, CGRectGetMaxY(self.bottomLB.frame)+5, self.bounds.size.width-30, self.bounds.size.height);
}

- (void)setupViews {
    _layout = [ZTTagCollectionViewFlowLayout new];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.bottomLB];
    [self.contentView addSubview:self.collectionView];
    
    __weak typeof(self)weakSelf = self;
    self.index = 0;
    [self.starView setOnStart:^(NSInteger index) {
        if ((self.index == 4 && index == 5) || (self.index == 5 && index == 4)) {
            [weakSelf.seletedArray removeAllObjects];
        }
        weakSelf.index = index;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewCellForMakeStar:)]) {
            [weakSelf.delegate tableViewCellForMakeStar:index];
        }
    }];
    self.clipsToBounds = YES;
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTWordItem *item = self.dataArray[indexPath.row];
    ZTTagCollectionViewFlowLayout *layout = (ZTTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    CGRect frame = [item.title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
    return CGSizeMake(frame.size.width+25, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:evaluateCollectionCellIndentify forIndexPath:indexPath];
    JTWordItem *item = self.dataArray[indexPath.row];
    cell.backgroundColor = item.isSeleted?UIColorFromRGB(0xcad5ff):BlackLeverColor1;
    cell.titleLabel.textColor = item.isSeleted?WhiteColor:BlackLeverColor3;
    cell.titleLabel.font = Font(14);
    cell.titleLabel.text = item.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    item.isSeleted = !item.isSeleted;
    if (item.isSeleted) {
        [self.seletedArray addObject:item.title];
    } else if ([self.seletedArray containsObject:item.title]){
        [self.seletedArray removeObject:item.title];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(tableViewCellForEvaluateContent:)]) {
        [_delegate tableViewCellForEvaluateContent:[self.seletedArray componentsJoinedByString:@","]];
    }
    [collectionView reloadData];
}

+ (CGFloat)getCellHeightWithTags:(NSArray *)tags width:(CGFloat)width
{
    CGFloat contentHeight = 0;
    ZTTagCollectionViewFlowLayout *layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    ZTTagAttribute *tagAttribute = [[ZTTagAttribute alloc] init];
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    NSInteger itemCount = tags.count;
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        JTWordItem *item = tags[i];
        CGRect frame = [item.title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
        if ((originX + itemSize.width + layout.sectionInset.right) > width) {
            originX = layout.sectionInset.left;
            originY += itemSize.height + layout.minimumLineSpacing;
            contentHeight += itemSize.height + layout.minimumLineSpacing;
        }
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    contentHeight += layout.sectionInset.bottom;
    return contentHeight + 105;
}

- (JTStarView *)starView {
    if (!_starView) {
        _starView = [[JTStarView alloc] initWithFrame:CGRectMake(0, 20, App_Frame_Width, 40)];
    }
    return _starView;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.starView.frame)+20, App_Frame_Width, 20)];
        _bottomLB.textAlignment = NSTextAlignmentCenter;
        _bottomLB.font = Font(14);
        _bottomLB.textColor = UIColorFromRGB(0xfd955a);
        _bottomLB.text = @"非常不满意，聊天有障碍";
    }
    return _bottomLB;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 15, self.bounds.size.width-30, self.bounds.size.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        [_collectionView registerClass:[ZTTagCollectionViewCell class] forCellWithReuseIdentifier:evaluateCollectionCellIndentify];
    }
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.frame = CGRectMake(15, CGRectGetMaxY(self.bottomLB.frame) + 5, self.bounds.size.width-30, self.bounds.size.height);
    
    return _collectionView;
}

- (NSMutableArray *)seletedArray {
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}
@end

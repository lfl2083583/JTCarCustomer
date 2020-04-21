//
//  JTEvaluateTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTTagAttribute.h"
#import "ZTTagCollectionViewCell.h"
#import "ZTTagCollectionViewFlowLayout.h"
#import "JTEvaluateTableViewCell.h"

@interface JTEvaluateTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *wordsLB;
@property (nonatomic, strong) ZTTagCollectionViewFlowLayout *layout;

@end

static NSString *evaluateCollectionViewIdentify = @"evaluateCollectionViewIdentify";

@implementation JTEvaluateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _layout = [ZTTagCollectionViewFlowLayout new];
        _layout.minimumInteritemSpacing = 15.f;
        _layout.minimumLineSpacing = 15.f;
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.inputView];
        [self.inputView addSubview:self.textView];
        [self.inputView addSubview:self.wordsLB];
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setEvaluates:(NSArray *)evaluates {
    _evaluates = evaluates;
    [self reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(5, 0, App_Frame_Width-10, self.bounds.size.height-105);
    _inputView.frame = CGRectMake(20, CGRectGetMaxY(self.collectionView.frame)+5, App_Frame_Width-40, 80);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.evaluates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:evaluateCollectionViewIdentify forIndexPath:indexPath];
    cell.backgroundColor = ([self.seletedArray containsObject:indexPath])?UIColorFromRGB(0xcad5ff):UIColorFromRGB(0xf9f9f9);
    cell.layer.cornerRadius = 2;
    cell.layer.borderColor = ([self.seletedArray containsObject:indexPath])?WhiteColor.CGColor:BlackLeverColor2.CGColor;
    cell.layer.borderWidth = 1;
    cell.titleLabel.textColor = ([self.seletedArray containsObject:indexPath])?WhiteColor:BlackLeverColor5;
    cell.titleLabel.font = Font(14);
    cell.titleLabel.text = self.evaluates[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.seletedArray containsObject:indexPath]) {
        [self.seletedArray removeObject:indexPath];
    } else {
        [self.seletedArray addObject:indexPath];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(evalutesChanged:)]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSIndexPath *indexpath in self.seletedArray) {
            [array addObject:self.evaluates[indexpath.row]];
        }
        [_delegate evalutesChanged:array];
    }
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTagCollectionViewFlowLayout *layout = (ZTTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    NSString *str = self.evaluates[indexPath.row];
    CGRect frame = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
    return CGSizeMake(frame.size.width + 30, layout.itemSize.height);
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    self.wordsLB.text = [NSString stringWithFormat:@"%ld/100", textView.text.length];
    if (_delegate && [_delegate respondsToSelector:@selector(textInputChanged:)]) {
        [_delegate textInputChanged:textView.text];
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

+ (CGFloat)getViewHeightWithEvalutes:(NSArray *)evalutes
{
    CGFloat contentHeight = 0;
    
    ZTTagCollectionViewFlowLayout *layout = [[ZTTagCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15.f;
    layout.minimumLineSpacing = 15.f;
    ZTTagAttribute *tagAttribute = [[ZTTagAttribute alloc] init];
    
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = evalutes.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(App_Frame_Width-10 - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        NSString *str = evalutes[i];
        CGRect frame = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Font(14)} context:nil];
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        if ((originX + itemSize.width + layout.sectionInset.right) > App_Frame_Width-10) {
            originX = layout.sectionInset.left;
            originY += itemSize.height + layout.minimumLineSpacing;
            contentHeight += itemSize.height + layout.minimumLineSpacing;
        }
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    contentHeight += layout.sectionInset.bottom;
    return contentHeight+5+80+20;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, App_Frame_Width-10, 120) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        [_collectionView registerClass:[ZTTagCollectionViewCell class] forCellWithReuseIdentifier:evaluateCollectionViewIdentify];
    }
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    return _collectionView;
}

- (GCPlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.inputView.frame)-20, 60)];
        _textView.font = Font(14);
        _textView.placeholder = @"输入评价内容（选填）";
        _textView.delegate = self;
    }
    return _textView;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.collectionView.frame)+5, App_Frame_Width-40, 80)];
        _inputView.backgroundColor = WhiteColor;
        _inputView.layer.borderColor = BlackLeverColor2.CGColor;
        _inputView.layer.borderWidth = 1;
        _inputView.layer.cornerRadius = 4;
        _inputView.layer.masksToBounds = YES;
    }
    return _inputView;
}

- (UILabel *)wordsLB {
    if (!_wordsLB) {
        _wordsLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.inputView.frame)-65, CGRectGetHeight(self.inputView.frame)-21, 60, 20)];
        _wordsLB.font = Font(14);
        _wordsLB.textColor = UIColorFromRGB(0xd2d2d2);
        _wordsLB.text = @"0/100";
        _wordsLB.backgroundColor = WhiteColor;
        _wordsLB.textAlignment = NSTextAlignmentRight;
    }
    return _wordsLB;
}

- (NSMutableArray *)seletedArray
{
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}

@end

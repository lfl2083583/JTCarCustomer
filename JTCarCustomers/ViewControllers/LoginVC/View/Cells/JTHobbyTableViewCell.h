//
//  JTHobbyTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTagCollectionViewFlowLayout.h"

@class ZTTagAttribute;

typedef NS_ENUM(NSInteger, JTUserGender)
{
    JTUserGenderUnKnown = 0,//未知
    JTUserGenderMan     = 1,//男
    JTUserGenderWoman   = 2,//女
};

static NSString *hobbyCellIdentifier = @"JTHobbyTableViewCell";

@interface JTHobbyTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *leftImgeV;
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSArray *tags;//传入的标签数组 字符串数组
@property (nonatomic, strong) ZTTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic, strong) ZTTagAttribute *tagAttribute;//按钮样式对象
@property (nonatomic, strong) UIColor *tagColor;


//刷新界面
- (void)reloadData;

/**
 *  计算Cell的高度
 *
 *  @param tags         标签数组
 *  @param width        计算的最大范围
 */
+ (CGFloat)getCellHeightWithTags:(NSArray *)tags width:(CGFloat)width;


@end

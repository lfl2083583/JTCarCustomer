//
//  JTUserFeatureTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTagCollectionViewFlowLayout.h"

@class ZTTagAttribute;

static NSString *userfeatureCellIdentifier = @"JTUserFeatureTableViewCell";

@interface JTUserFeatureTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *rightLable;
@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) NSArray *tags;//传入的标签数组 字符串数组
@property (nonatomic, strong) ZTTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic, strong) ZTTagAttribute *tagAttribute;//按钮样式对象
@property (nonatomic, assign) BOOL isRandColor;

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

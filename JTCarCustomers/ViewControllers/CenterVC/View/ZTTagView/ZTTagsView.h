//
//  ZTTagsView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTagCollectionViewFlowLayout.h"

@class ZTTagAttribute;

@interface ZTTagsView : UIView

@property (nonatomic,strong) NSArray *tags;//传入的标签数组 字符串数组
@property (nonatomic,strong) ZTTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) ZTTagAttribute *tagAttribute;//按钮样式对象
@property (nonatomic,assign) BOOL isMultiSelect;//是否可以多选 默认:NO 单选

//刷新界面
- (void)reloadData;

/**
 *  计算Cell的高度
 *
 *  @param tags         标签数组
 *  @param layout       布局样式 默认则传nil
 *  @param tagAttribute 标签样式 默认传nil 涉及到计算的主要是titleSize
 *  @param width        计算的最大范围
 */
+ (CGFloat)getHeightWithTags:(NSArray *)tags layout:(ZTTagCollectionViewFlowLayout *)layout tagAttribute:(ZTTagAttribute *)tagAttribute width:(CGFloat)width;

@end

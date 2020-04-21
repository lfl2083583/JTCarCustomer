//
//  JTWordItem.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kGoTopNotificationName = @"goTop";//进入置顶
static NSString *const kLeaveTopNotificationName = @"leaveTop";//离开置顶

@interface JTWordItem : NSObject

/** 标题*/
@property (nonatomic, copy) NSString *title;
/** 标题字体*/
@property (nonatomic, strong) UIFont *titleFont;
/** 标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;

/** 副标题*/
@property (nonatomic, copy) NSString *subTitle;
/** 副标题字体*/
@property (nonatomic, strong) UIFont *subTitleFont;
/** 副标题颜色*/
@property (nonatomic, strong) UIColor *subTitleColor;

/** 左边图片*/
@property (nonatomic, strong) UIImage *image;
/** cell行高*/
@property (nonatomic, assign) CGFloat cellHeight;
/** cell右侧箭头*/
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
/** cell选中状态*/
@property (nonatomic, assign) BOOL isSeleted;
/** 标签数组*/
@property (nonatomic, strong) NSArray *tags;
/** 标签文字颜色*/
@property (nonatomic, strong) UIColor *tagFontColor;
/** 标签背景色*/
@property (nonatomic, strong) UIColor *tagBackGroundColor;
/** 标签ID*/
@property (nonatomic, copy) NSString *tagID;
/** 类名称*/
@property (nonatomic, copy) NSString *className;
/** 提示语*/
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) NSInteger tagType;
@end


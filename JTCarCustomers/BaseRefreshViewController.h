//
//  BaseRefreshViewController.h
//  GCHCustomerMall
//
//  Created by 观潮汇 on 5/8/16.
//  Copyright © 2016 观潮汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

typedef NS_ENUM(NSUInteger, JTTableHeightType) {
    
    JTTableHeightTypeFullScreen = 0,
    JTTableHeightTypeNavigation,
    JTTableHeightTypeTabbar,
    JTTableHeightTypeNavigationAndTabbar
};

@interface BaseRefreshViewController : UIViewController <UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UICollectionView *collectionview;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@property (nonatomic) int page;
@property (strong, nonatomic) UIView *defaultFooterView;

@property (nonatomic) BOOL showTableRefreshHeader;      // Table是否支持下拉刷新
@property (nonatomic) BOOL showTableRefreshFooter;      // Table是否支持上拉加载
@property (nonatomic) BOOL showCollectionRefreshHeader; // Table是否支持下拉刷新
@property (nonatomic) BOOL showCollectionRefreshFooter; // Table是否支持上拉加载

@property (nonatomic) BOOL cellAnimation;

- (void)createTalbeView:(UITableViewStyle)style rowHeight:(CGFloat)rowHeight;
- (void)createTalbeView:(UITableViewStyle)style tableHeightType:(JTTableHeightType)tableHeightType rowHeight:(CGFloat)rowHeight;
- (void)createTalbeView:(UITableViewStyle)style tableHeightType:(JTTableHeightType)tableHeightType rowHeight:(CGFloat)rowHeight sectionHeaderHeight:(CGFloat)sectionHeaderHeight sectionFooterHeight:(CGFloat)sectionFooterHeight;
- (void)createTalbeView:(UITableViewStyle)style tableFrame:(CGRect)tableFrame rowHeight:(CGFloat)rowHeight sectionHeaderHeight:(CGFloat)sectionHeaderHeight sectionFooterHeight:(CGFloat)sectionFooterHeight;
- (void)getListData:(void (^)(void))requestComplete;

/**
 静态加载第一页
 */
- (void)staticRefreshFirstTableListData;

/**
 处理第一次加载
 */
- (void)handleFirstTableListData;
@end

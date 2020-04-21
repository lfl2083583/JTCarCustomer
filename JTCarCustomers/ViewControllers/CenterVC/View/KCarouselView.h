//
//  KCarouselView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCarouselView;

@protocol KCarouselViewDelegate <NSObject>
@optional
// 轮播图的图片被点击时触发的代理方法,index为点击的图片下标
-(void)carouselView:(KCarouselView *)carouselView clickedImageAtIndex:(NSUInteger)index;

@end

typedef void(^ClickedImageBlock)(NSUInteger index);

typedef NS_ENUM(NSInteger, KPageContolPosition) {
    KPageContolPositionBottomCenter,  // 底部中心
    KPageContolPositionBottomRight,   // 底部右边
    KPageContolPositionBottomLeft     // 底部左边
};

typedef NS_ENUM(NSInteger, KCarouselViewImageMode) {
    KCarouselViewImageModeScaleToFill,       // 默认,充满父控件
    KCarouselViewImageModeScaleAKectFit,    // 按图片比例显示,少于父控件的部分会留有空白
    KCarouselViewImageModeScaleAKectFill,   // 按图片比例显示,超出父控件的部分会被剪掉
    KCarouselViewImageModeCenter             // 处于父控件中心,不会被拉伸,按原始大小显示
};

@interface KCarouselView : UIView



// 提供类方法创建轮播图 这种创建方式有个局限性，那就是必须在创建时就传入数组。
/** 本地图片 */
+ (KCarouselView *)carouselScrollViewWithFrame:(CGRect)frame localImages:(NSArray<NSString *> *)localImages;

/** 网络图片 */
+ (KCarouselView *)carouselScrollViewWithFrame:(CGRect)frame urlImages:(NSArray<NSString *> *)urlImages;


// 为了消除类方法创建的局限性，提供下面两个属性，轮播图的图片数组。适用于创建时用alloc init，然后在以后的某个时刻传入数组。
// 本地图片
@property(strong, nonatomic) NSArray<NSString *> *localImages;
// 网络图片
@property(strong, nonatomic) NSArray<NSString *> *urlImages;

// 代理
@property(weak, nonatomic) id<KCarouselViewDelegate>delegate;

// 轮播图的图片被点击时回调的block，与代理功能一致，开发者可二选其一.如果两种方式不小心同时实现了，则默认block方式
@property (nonatomic, copy) ClickedImageBlock clickedImageBlock;

// 当前小圆点的颜色
@property (strong, nonatomic) UIColor *currentPageColor;
// 其余小圆点的颜色
@property (strong, nonatomic) UIColor *pageColor;

// pageControl的位置,分左,中,右
@property (assign, nonatomic) KPageContolPosition pageControlPosition;

// 是否显示pageControl
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

// 轮播图上的图片显示模式
@property (assign, nonatomic) KCarouselViewImageMode imageMode;

/** 设置小圆点的图片 */
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage;


@end


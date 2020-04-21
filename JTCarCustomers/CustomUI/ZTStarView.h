//
//  ZTStarView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStarImageNormal @"icon_star_unlight"
#define kStarImageHighlight @"icon_star_light"
#define kStarNumber  5

@class ZTStarView;

@protocol ZTStarViewDelegate <NSObject>
@optional

-(void)starView:(ZTStarView *)view score:(float)score;

@end

@interface ZTStarView : UIView

@property (nonatomic, strong) NSString *starImageNormal;
@property (nonatomic, strong) NSString *starImageHighlight;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <ZTStarViewDelegate> delegate;

/**
 *  Init TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

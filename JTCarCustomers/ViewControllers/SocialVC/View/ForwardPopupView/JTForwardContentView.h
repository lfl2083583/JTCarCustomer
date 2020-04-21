//
//  JTForwardContentView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#define Popup_Width 315.0
#define X_Margin 25.0
#define Y_Margin 15.0
#import "ZTStarView.h"
#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface JTForwardContentView : UIView

@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;

@property (nonatomic, copy) id source;

- (instancetype)initWithSource:(id)source;
- (void)setupView;
- (CGSize)contentSize:(CGSize)originalSize;

@end

//文字类型内容
@interface JTForwardTextView : JTForwardContentView


@end

//图片类型内容
@interface JTForwardImgeView : JTForwardContentView

@end

//视频类型内容
@interface JTForwardVideoView : JTForwardContentView

@property (nonatomic, strong) UIImageView *playImgeView;

@end

//位置类型内容
@interface JTForwardLoctionView : JTForwardContentView

@end

//个人名片类型内容
@interface JTForwardUserCardView : JTForwardContentView

@end

//表情类型内容
@interface JTForwardExpressionView : JTForwardContentView

@end

//群名片类型内容
@interface JTForwardTeamCardView : JTForwardContentView

@end

//门店类型内容
@interface JTForwardStoreView : JTForwardContentView

@property (nonatomic, strong) UILabel *siteLB;
@property (nonatomic, strong) UILabel *scoreLB;
@property (nonatomic, strong) ZTStarView *starView;

@end

//活动类型内容
@interface JTForwardActivityView : JTForwardContentView

@property (nonatomic, strong) UILabel *themeLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *siteLB;

@end

//资讯类型内容
@interface JTForwardInfomationView : JTForwardContentView

@end


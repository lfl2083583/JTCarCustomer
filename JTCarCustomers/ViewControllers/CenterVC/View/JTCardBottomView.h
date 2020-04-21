//
//  JTCardBottomView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol JTCardBottomViewDelegate <NSObject>

@optional
- (void)bottomViewToLeft:(id)sender;

- (void)bottomViewToRight:(id)sender;

- (void)bottomViewToCenter:(id)sender;


@end

@interface JTCardBottomViewConfig : NSObject

@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *centerTitle;
@property (nonatomic, copy) NSString *leftImageName;
@property (nonatomic, copy) NSString *rightImgeName;
@property (nonatomic, strong) UIColor *lTColor;
@property (nonatomic, strong) UIColor *rTColot;
@property (nonatomic, strong) UIColor *cColor;
@property (nonatomic, assign) UIEdgeInsets leftImageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets rightImageEdgeInsets;

@end

@interface JTCardBottomView : UIView

@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, weak) id<JTCardBottomViewDelegate>delegate;

- (void)setupParameter:(JTCardBottomViewConfig *)config;

@end



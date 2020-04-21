//
//  JTUserInfoHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTUserInfoHeadViewDelegate <NSObject>

- (void)headViewAddPhoto:(NSUInteger)index;

@end

static NSString *const userInfoSectionIdentifier = @"JTUserInfoSectionHeadView";

@interface JTUserInfoSectionHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *leftLabel;

@end;

@protocol JTElementViewDelegate <NSObject>

- (void)elementViewClick:(id)sender;

@end

@interface JTElementView : UIView;

@property (nonatomic, strong) UIImageView *bottomImgView;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, weak) id<JTElementViewDelegate>delegate;


@end

@interface JTUserInfoHeadView : UIView

@property (nonatomic, weak) id<JTUserInfoHeadViewDelegate>delegate;

- (void)refreshView;

@end

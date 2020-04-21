//
//  JTCardViewHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCarouselView.h"


typedef NS_ENUM(NSInteger, JTBulletFuctionType)
{
    JTBulletMenuShow       = 0,//显示弹幕菜单
    JTBulletMenuDismiss    = 1,//隐藏弹幕菜单
    JTBulletSendMsg        = 2,//发送弹幕
    JTBulletTurnOn         = 3,//开启弹幕
    JTBulletTurnOff        = 4,//关闭弹幕
};

@protocol JTBulletMenuDelegate <NSObject>

- (void)bulletMenuResponse:(JTBulletFuctionType)fucType;

@end

@interface JTBulletMenu : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UISwitch *rightSwitch;
@property (nonatomic, weak) id<JTBulletMenuDelegate>delegate;

@end

@interface JTCardViewHeadView : UIView

@property (nonatomic, strong) KCarouselView *carouselView;
@property (nonatomic, strong) JTBulletMenu *bulletMenu;
@property (nonatomic, weak) id<JTBulletMenuDelegate>delegate;
@property (nonatomic, copy) NSString *fuid;

- (instancetype)initWithFrame:(CGRect)frame fuid:(NSString *)fuid;
- (void)configHeadViewImgs:(NSArray *)imgs avatarUrl:(NSString *)avatarUrl;

@end


//
//  JTWalletMoneyDetailPickerView.h
//  JTSocial
//
//  Created by lious on 2017/12/9.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTWalletMoneyDetailType) {
    JTWalletMoneyDetailTypeDefault         = 0,//全部
    JTWalletMoneyDetailTypeRedPacket       = 1,//红包
    JTWalletMoneyDetailTypeRecharge        = 2,//第三方充值
    JTWalletMoneyDetailTypeCollections     = 3,//群收款
    JTWalletMoneyDetailTypeMoneyConsume    = 4,//娱券消费
    JTWalletMoneyDetailTypeGameConsume     = 5,//游戏币消费
    JTWalletMoneyDetailTypeActivtyGet      = 6,//活动领取
};

typedef void (^BlanceRecordPickerViewBlock)(JTWalletMoneyDetailType type);

@interface JTWalletMoneyDetailCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLb;


@end

@interface JTWalletMoneyDetailPickerView : UIView

@property (nonatomic, copy) BlanceRecordPickerViewBlock block;

@property (nonatomic, strong) NSMutableArray *dataArr;

- (void)showWithItemArray:(NSArray *)array seletedBlock:(BlanceRecordPickerViewBlock)block;

- (void)hide;

@end

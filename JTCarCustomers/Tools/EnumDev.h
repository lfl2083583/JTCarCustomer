//
//  EnumDev.m
//  Bugoo
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 LoveGuoGuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTCarOperationType) {
    JTCarOperationTypeAdd,         // 添加操作
    JTCarOperationTypeDefault,     // 默认操作
    JTCarOperationTypeAuth,        // 认证操作
    JTCarOperationTypeEdit,        // 编辑操作
    JTCarOperationTypeDelete,      // 删除操作
};

typedef NS_ENUM(NSInteger, JTBonusType)
{
    JTBonusTypeNormal = 1,    // 普通红包
    JTBonusTypeTeamLuck,      // 群手气红包
    JTBonusTypeTeamAverage,   // 群均分红包
};

typedef NS_ENUM(NSInteger, JTRescueType)
{
    JTRescueTypeLiftElectricity, // 搭电
    JTRescueTypeTrailer,         // 拖车
};


//typedef NS_ENUM(NSInteger, JTCodeType) {
//    JTCodeTypeRegister = 0, // 注册
//    JTCodeTypeReset,        // 重置
//    JTCodeTypePay,          // 支付
//    JTCodeTypeSecurity,     // 安全
//    JTCodeTypeChangePhone,  // 更换手机
//    JTCodeTypeH5Pay         // H5支付
//};
//
//typedef NS_ENUM(NSInteger, JTPayType) {
//    JTPayTypeRed   = 1,      // 红包支付
//    JTPayTypeTransfer,       // 转账
//    JTPayTypeHelp,           // 江湖救急
//    JTPayTypeFund,           // 经费群
//};
//
////游戏类型
//typedef NS_ENUM(NSInteger, JTLiveGameType) {
//    JTLiveGameTypeNone,         //无
//    JTLiveGameTypeCrapGame,     //骰子游戏
//    JTLiveGameTypeFishGame,     //鱼虾游戏
//    JTLiveGameTypeCatMouseGame, //猫鼠游戏(棋牌大小)
//    JTLiverGameTypeRacingGame,  //赛车游戏
//};
//
////美颜
//typedef NS_ENUM(NSInteger, JTBeautyChangeType) {
//    JTBeautyChangeTypeSwitch,           //美颜开关
//    JTBeautyChangeTypeSelectedBlur,     //磨皮
//    JTBeautyChangeTypeBeautyLevel,      //美白
//    JTBeautyChangeTypeRedLevel,         //红润
//    JTBeautyChangeTypeThinningLevel,    //瘦脸
//    JTBeautyChangeTypeEnlargingLevel,   //大眼
//};
//
////礼物类型
//typedef NS_ENUM(NSInteger, JTGiftType) {
//    JTGiftTypeImage = 0,           //静态礼物(普通图片)
//    JTGiftTypeImageGroup = 1,      //动态礼物(gif/图片组)
//    JTGiftTypeImageDoubleHit = 2,  //连击礼物
//};

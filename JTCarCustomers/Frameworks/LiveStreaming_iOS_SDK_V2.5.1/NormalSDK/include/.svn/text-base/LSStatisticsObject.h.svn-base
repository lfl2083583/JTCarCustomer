//
//  LSStatisticsObject.h
//  LSMediaCapture
//
//  Created by taojinliang on 2017/11/16.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStatisticsObject : NSObject

/**
 视频发送帧率
 */
@property(nonatomic, assign) unsigned int videoSendFrameRate;

/**
 视频发送码率
 */
@property(nonatomic, assign) unsigned int videoSendBitRate;

/**
 视频发送分辨率的宽
 */
@property(nonatomic, assign) unsigned int videoSendWidth;

/**
 视频发送分辨率的高
 */
@property(nonatomic, assign) unsigned int videoSendHeight;

/**
 设置的视频帧率
 */
@property(nonatomic, assign) unsigned int videoSetFrameRate;

/**
 设置的视频码率
 */
@property(nonatomic, assign) unsigned int videoSetBitRate;

/**
 设置的分辨率宽
 */
@property(nonatomic, assign) unsigned int videoSetWidth;

/**
 设置的分辨率高
 */
@property(nonatomic, assign) unsigned int videoSetHeight;

/**
 音频的发送码率
 */
@property(nonatomic, assign) unsigned int audioSendBitRate;

/**
 视频编码一帧的时间
 */
@property(nonatomic, assign) unsigned int videoEncodeTime;

/**
 视频发送一帧的时间
 */
@property(nonatomic, assign) unsigned int videoMuxAndSendTime;

/**
 音频编码一帧的时间
 */
@property(nonatomic, assign) unsigned int audioEncodeTime;

/**
 音频发送一帧的时间
 */
@property(nonatomic, assign) unsigned int audioMuxAndSendTime;

/**
 如果卡顿累积了数据，则上报卡顿的平均耗时；否则上报非卡顿的平均耗时
 */
@property(nonatomic, assign) unsigned int writeFrameTime;

/**
 网络状况类型
 */
@property(nonatomic, assign) LS_QOSLVL_TYPE type;
@end

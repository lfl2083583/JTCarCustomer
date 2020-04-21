//
//  JTCameraResultView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

//游戏类型
typedef NS_ENUM(NSInteger, JTCameraResultType) {
    JTCameraResultTypeImage,
    JTCameraResultTypeVideo,
};

@protocol JTCameraResultDelegate <NSObject>

@optional

/**
 重拍
 */
- (void)remake;
/**
 发送图片

 @param image 图片
 */
- (void)sendImage:(UIImage *)image;
/**
 发送视频

 @param videoPath 视频地址
 */
- (void)sendVideo:(NSString *)videoPath;

@end

@interface JTCameraResultView : UIView

@property (nonatomic, weak) id<JTCameraResultDelegate> delegate;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, assign) JTCameraResultType cameraResultType;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCameraResultDelegate>)delegate;

@end

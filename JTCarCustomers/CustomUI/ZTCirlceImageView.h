//
//  ZTCirlceImageView.h
//  NIMKit
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIView+WebCacheOperation.h"
#import "uiview+WebCache.h"

// 默认不能交互
@interface ZTCirlceImageView : UIControl

@property (nonatomic, strong)    UIImage *image;
@property (nonatomic, assign)    BOOL    clipPath;

- (void)setAvatarByUrlString:(NSString *)urlString defaultImage:(UIImage *)defaultImage;

@end


@interface ZTCirlceImageView (SDWebImageCache)
- (NSURL *)zt_imageURL;

- (void)zt_setImageWithURL:(NSURL *)url;
- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)zt_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock;
- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock;
- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock;
- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock;
- (void)zt_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock;
- (void)zt_cancelCurrentImageLoad;
- (void)zt_cancelCurrentAnimationImagesLoad;
@end

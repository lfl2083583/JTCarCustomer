//
//  ZTCirlceImageView.m
//  NIMKit
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ZTCirlceImageView.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@interface ZTCirlceImageView()

@end

@implementation ZTCirlceImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        [self setNeedsDisplay];
    }
}


- (CGPathRef)path
{
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                       cornerRadius:CGRectGetWidth(self.bounds) / 2] CGPath];
}


#pragma mark Draw
- (void)drawRect:(CGRect)rect
{
    if (!self.width || !self.height) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    if (_clipPath)
    {
        CGContextAddPath(context, [self path]);
        CGContextClip(context);
    }
    UIImage *image = _image;
    if (image && image.size.height && image.size.width)
    {
        //ScaleAspectFill模式
        CGPoint center   = CGPointMake(self.width * .5f, self.height * .5f);
        //哪个小按哪个缩
        CGFloat scaleW   = image.size.width  / self.width;
        CGFloat scaleH   = image.size.height / self.height;
        CGFloat scale    = scaleW < scaleH ? scaleW : scaleH;
        CGSize  size     = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGRect  drawRect = NIMKit_CGRectWithCenterAndSize(center, size);
        CGContextDrawImage(context, drawRect, image.CGImage);
        
    }
    CGContextRestoreGState(context);
}

CGRect NIMKit_CGRectWithCenterAndSize(CGPoint center, CGSize size){
    return CGRectMake(center.x - (size.width/2), center.y - (size.height/2), size.width, size.height);
}

- (void)setAvatarByUrlString:(NSString *)urlString defaultImage:(UIImage *)defaultImage
{
    NSURL *url = urlString ? [NSURL URLWithString:urlString] : nil;
    [self zt_setImageWithURL:url placeholderImage:defaultImage];
}

@end

@implementation ZTCirlceImageView (SDWebImageCache)

- (void)zt_setImageWithURL:(NSURL *)url {
    [self zt_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self zt_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self zt_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)zt_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock {
    [self zt_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock {
    [self zt_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock {
    [self zt_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)zt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {
    NSString *validOperationKey = NSStringFromClass([self class]);
    [self sd_cancelImageLoadOperationWithKey:validOperationKey];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self zt_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:nil];
        });
    }
    
    if (url) {
        // check if activityView is enabled or not
        if ([self sd_showActivityIndicatorView]) {
            [self sd_addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong __typeof (wself) sself = wself;
            [sself sd_removeActivityIndicator];
            if (!sself) {
                return;
            }
            dispatch_main_async_safe(^{
                if (!sself) {
                    return;
                }
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                    completedBlock(image, error, cacheType, url);
                    return;
                } else if (image) {
                    [sself zt_setImage:image imageData:data basedOnClassOrViaCustomSetImageBlock:nil];
                    [sself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        [sself zt_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:nil];
                        [sself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
        dispatch_main_async_safe(^{
            [self sd_removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)zt_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self zt_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)zt_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock {
    if (setImageBlock) {
        setImageBlock(image, imageData);
        return;
    }
    self.image = image;
}

- (NSURL *)zt_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)zt_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)zt_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

@end

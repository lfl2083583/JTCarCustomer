//
//  ImageDisplayTool.m
//  GCHCustomerMall
//
//  Created by 观潮汇 on 2016/11/5.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import "ImageDisplayTool.h"
#import "CLAlertController.h"
#import "JTImageAttachment.h"
//#import "ScanCodeQRSystemFunctions.h"
//#import "JTUserListViewController.h"
//#import "JTGroupListViewController.h"
//#import "JTMessageMaker.h"
//#import "JTBaseNavigationController.h"
//#import "NormalWebViewController.h"
//#import "JTCardViewController.h"
//#import "JTSessionViewController.h"
//#import "JTTeamCardViewController.h"

static ImageDisplayTool *imageDisplayTool;

@interface ImageDisplayTool ()

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbPhotos;
@property (nonatomic, strong) CIDetector *detector;

@end

@implementation ImageDisplayTool

+ (instancetype)shareImageDisplayTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageDisplayTool = [[ImageDisplayTool alloc] init];
    });
    return imageDisplayTool;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.photoBrowser.currentIndex < self.dataArray.count) {
            
            MWPhoto *photo = [self.photos objectAtIndex:self.photoBrowser.currentIndex];
            if (photo.underlyingImage && [photo.underlyingImage isKindOfClass:[UIImage class]]) {
                __weak typeof(self) weakself = self;
                CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
                [alertMore addAction:[CLAlertModel actionWithTitle:@"保存到相册" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    UIImageWriteToSavedPhotosAlbum(photo.underlyingImage, weakself, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }]];
                [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                }]];
                [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                }]];
                [alertMore addAction:[CLAlertModel actionWithTitle:@"收藏" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {

                    NIMMessage *message = [weakself.dataArray objectAtIndex:self.photoBrowser.currentIndex];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    if (message.messageType == NIMMessageTypeImage) {
                        NIMImageObject *object = (NIMImageObject *)[message messageObject];
                        NSString *content = [@{@"image": object.url, @"thumbnail": object.thumbUrl, @"width": [NSString stringWithFormat:@"%.2f", object.size.width], @"height": [NSString stringWithFormat:@"%.2f", object.size.height]} mj_JSONString];
                        [parameters setObject:content forKey:@"content"];
                        [parameters setObject:@"5" forKey:@"type"];
                    }
                    else if (message.messageType == NIMMessageTypeCustom) {
                        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                        if ([object.attachment isKindOfClass:[JTImageAttachment class]])
                        {
                            JTImageAttachment *attachment = (JTImageAttachment *)object.attachment;
                            NSString *content = [@{@"image": attachment.imageUrl, @"thumbnail": attachment.imageThumbnail, @"width": attachment.imageWidth, @"height": attachment.imageHeight} mj_JSONString];
                            [parameters setObject:content forKey:@"content"];
                            [parameters setObject:@"5" forKey:@"type"];
                        }
                    }
                    NSString *source = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
                    [parameters setObject:source forKey:@"source"];
                    if (message.session.sessionType == NIMSessionTypeP2P) {
                        NSString *joinID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId]];
                        [parameters setObject:joinID forKey:@"join_id"];
                        [parameters setObject:@"1" forKey:@"join_type"];
                    }
                    else
                    {
                        [parameters setObject:message.session.sessionId forKey:@"join_id"];
                        [parameters setObject:@"2" forKey:@"join_type"];
                    }
                    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AddFavoriteApi) parameters:parameters success:^(id responseObject, ResponseState state) {
                        [[HUDTool shareHUDTool] showHint:@"收藏成功"];
                    } failure:^(NSError *error) {
                        
                    }];
                }]];
                NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:photo.underlyingImage.CGImage]];
                if (features && features.count > 0) {
                    [alertMore addAction:[CLAlertModel actionWithTitle:@"识别图中二维码" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    }]];
                }
                [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
                }]];
                [self.rootViewController presentToViewController:alertMore completion:nil];
            }
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [[HUDTool shareHUDTool] showHint:error?@"保存相册失败":@"保存相册成功"];
}

- (void)handleTapPress:(UITapGestureRecognizer *)tapGesture
{
    [self.photoBrowser dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)showInViewController:(UIViewController *)viewController dataArray:(NSArray *)dataArray currentPhotoIndex:(NSInteger)currentPhotoIndex imageDisplayType:(JTImageDisplayType)imageDisplayType
{
    [self setRootViewController:viewController];
    [self setDataArray:dataArray];
    [self loadData];
    [self setImageDisplayType:imageDisplayType];
    __weak typeof(self) weakself = self;
    [viewController presentViewController:self.photoBrowser animated:YES completion:^{
        
        UIScrollView *scrollview = [weakself.photoBrowser valueForKey:@"_pagingScrollView"];
        UIToolbar *toolbar = [weakself.photoBrowser valueForKey:@"_toolbar"];
        
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(handleTapPress:)];
        _tapGesture.numberOfTouchesRequired = 1; 
        _tapGesture.numberOfTapsRequired = 1;
        [scrollview addGestureRecognizer:_tapGesture];
        UILongPressGestureRecognizer *_longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:weakself action:@selector(handleLongPress:)];
        [scrollview addGestureRecognizer:_longGesture];
        
        toolbar.hidden = YES;
    }];
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentPhotoIndex];
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.displayNavArrows = NO;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = NO;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        _photoBrowser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    return _photoBrowser;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.thumbPhotos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < self.thumbPhotos.count)
    {
        return [self.thumbPhotos objectAtIndex:index];
    }
    return nil;
}

- (void)loadData
{
    [self.photos removeAllObjects];
    [self.thumbPhotos removeAllObjects];
    if (self.dataArray.count > 0) {
        for (NSInteger index = 0; index < self.dataArray.count; index ++) {
            if (self.imageDisplayType == JTImageDisplayTypeSession) {
                NIMMessage *imageMessage = [self.dataArray objectAtIndex:index];
                MWPhoto *photo, *thumbPhoto;
                if (imageMessage.messageType == NIMMessageTypeImage) {
                    NIMImageObject *object = (NIMImageObject *)imageMessage.messageObject;
                    photo = [[NSFileManager defaultManager] fileExistsAtPath:object.path]?[[MWPhoto alloc] initWithImage:[UIImage imageNamed:object.path]]:[[MWPhoto alloc] initWithURL:[NSURL URLWithString:object.url]];
                    thumbPhoto = [[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]?[[MWPhoto alloc] initWithImage:[UIImage imageNamed:object.thumbPath]]:[[MWPhoto alloc] initWithURL:[NSURL URLWithString:object.thumbUrl]];
                }
                else
                {
                    JTImageAttachment *attachmen = (JTImageAttachment *)[(NIMCustomObject *)imageMessage.messageObject attachment];
                    photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:attachmen.imageUrl]];
                    thumbPhoto = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:attachmen.imageThumbnail]];
                }
                if (photo) {
                    [self.photos addObject:photo];
                }
                if (thumbPhoto) {
                    [self.thumbPhotos addObject:thumbPhoto];
                }
            }
        }
    }
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return @"";
}

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)thumbPhotos
{
    if (!_thumbPhotos) {
        _thumbPhotos = [NSMutableArray array];
    }
    return _thumbPhotos;
}

- (CIDetector *)detector
{
    if (!_detector) {
        _detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:nil] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    }
    return _detector;
}
@end

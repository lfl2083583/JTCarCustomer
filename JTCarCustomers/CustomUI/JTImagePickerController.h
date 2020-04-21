//
//  JTImagePickerController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>
#import "JTSystemAlbumTool.h"

@interface JTImagePickerController : TZImagePickerController

@property (assign, nonatomic) BOOL isJTTheme; // 使用郡腾主题

@property (nonatomic, copy) void (^didFinishPhotosHandle)(NSArray<UIImage *> *photos);
@property (nonatomic, copy) void (^didFinishVideoHandle)(NSString *outputPath);

@end

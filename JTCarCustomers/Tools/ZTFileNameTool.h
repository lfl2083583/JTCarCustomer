//
//  ZTFileNameTool.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTFileNameTool : NSObject

/**
 上传用户头像

 @return 上传用户头像文件名数组
 */
+ (NSArray *)showFileNamesForAvatar;


/**
 上传用户相册文件

 @param num 文件数量
 @return 上传用户相册文件名数组
 */
+ (NSArray *)showFileNamesForAlbumFileNum:(int)num;


/**
 上传用户认证图片

 @param num 文件数量
 @return 上传用户认证图片文件名数组
 */
+ (NSArray *)showFileNamesForVeriFileNum:(int)num;


/**
 上传群头像

 @return 上传群头像文件名数组
 */
+ (NSArray *)showFileNamesForTeamAvatar;


/**
 上传群相册文件

 @param num 文件数量
 @return 上传群相册文件名数组
 */
+ (NSArray *)showFileNamesForTeamAlbumFileNum:(int)num;


/**
 上传用户车辆认证图片

 @param num 文件数量
 @return 上传用户车辆认证图片文件名数组
 */
+ (NSArray *)showFileNamesForCarAuthFileNum:(int)num;


/**
 上传用户申诉图片

 @param num 文件数量
 @return 上传用户申诉图片文件名数组
 */
+ (NSArray *)showFileNamesForVeriComplainFileNum:(int)num;

@end

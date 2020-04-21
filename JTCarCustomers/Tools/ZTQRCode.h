//
//  ZTQRCode.h
//  JTSocial
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTQRCode : NSObject

+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size;
+ (UIImage *)createQRImageWithString:(NSString *)string linkSmallIcon:(UIImage *)icon size:(CGSize)size;

@end

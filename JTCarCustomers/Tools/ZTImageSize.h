//
//  ZTImageSize.h
//  QTNewIMApp
//
//  Created by apple on 2017/3/30.
//  Copyright © 2017年 z. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZTImageSize : NSObject

+ (void)imageWithURL:(id)imageURL complete:(void(^)(CGSize size))complete;
@end

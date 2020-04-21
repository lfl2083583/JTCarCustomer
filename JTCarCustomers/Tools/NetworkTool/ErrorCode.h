//
//  ErrorCode.h
//  BOOOP
//
//  Created by booop on 15/2/5.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorCode : NSObject <UIAlertViewDelegate>

+ (void)errorCodeAnalytical:(NSError *)error;

@end

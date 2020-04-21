//
//  ErrorCode.m
//  BOOOP
//
//  Created by booop on 15/2/5.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import "ErrorCode.h"
#import "AppDelegate+AppService.h"

@implementation ErrorCode

+ (void)errorCodeAnalytical:(NSError *)error
{
    if (error && error.userInfo && [error.userInfo isKindOfClass:[NSDictionary class]] && [error.userInfo objectForKey:@"msg"]) {
        [[HUDTool shareHUDTool] showHint:error.userInfo[@"msg"] yOffset:0];
    }
}
@end

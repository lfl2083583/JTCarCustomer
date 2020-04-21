//
//  JTSessionConfig.h
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JTSessionProtocol.h"

@interface JTSessionConfig : NSObject <JTSessionProtocol>

@property (nonatomic, strong) NIMSession *session;

- (instancetype)initWithSession:(NIMSession *)session;

@end

//
//  JTHttpEncryptionTool.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const JTHttpAppID;
extern NSString *const JTHttpAppKey;

@interface JTHttpEncryptionModel : NSObject

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *noncestr;

@end

@interface JTHttpEncryptionTool : NSObject

+ (JTHttpEncryptionModel *)encryptionModel;
+ (NSString *)signParameters:(NSString *)parameters;

@end

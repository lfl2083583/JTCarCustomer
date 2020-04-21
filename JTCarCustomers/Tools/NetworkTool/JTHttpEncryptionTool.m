//
//  JTHttpEncryptionTool.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTHttpEncryptionTool.h"
#import "NSString+AES256.h"

NSString * const JTHttpAppID = @"590846447";
NSString * const JTHttpAppKey = @"4b9d027d0aa50cfc";

@implementation JTHttpEncryptionModel

@end

@implementation JTHttpEncryptionTool

+ (JTHttpEncryptionModel *)encryptionModel
{
    JTHttpEncryptionModel *model = [[JTHttpEncryptionModel alloc] init];
    model.appid = JTHttpAppID;
    model.timestamp = [Utility currentTime:[NSDate date]];
    model.noncestr = [NSString stringWithFormat:@"%@%@", [self randomNumber], [self randomNumber]];
    return model;
}

+ (NSString *)signParameters:(NSString *)parameters
{
    NSString *results;
    if (![parameters isBlankString]) {
        results = [NSString stringWithFormat:@"%@%@%@", JTHttpAppKey, parameters, [JTUserInfo shareUserInfo].userToken];
    }
    return [[results MD5String] uppercaseString];
}

+ (NSString *)randomNumber
{
    long long randomNum = [self getRandomNumber:(long long)1000000000000000 to:(long long)9999999999999999];
    return [NSString stringWithFormat:@"%lld", randomNum];
}

+ (long long)getRandomNumber:(long long)from to:(long long)to
{
    return (long long)(from + (arc4random() % (to - from)));
}

@end

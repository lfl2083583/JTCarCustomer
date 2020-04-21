//
//  JTUserInfo.m
//  JTDirectSeeding
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTUserInfo.h"

static JTUserInfo *_userinfo = nil;
static inline NSString * JTDocumentsFilePath(NSString *fileName)
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [directories[0] stringByAppendingPathComponent:fileName];
}

static NSString *kJTUserInfoPersistentPath = @"JTUserInfo";

@implementation JTUserInfo

+ (NSString *)deviceUDID {
    return [OpenUDID value].length > 0 ? [OpenUDID value] : @"";
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userinfo = [super allocWithZone:zone];
    });
    return _userinfo;
}

+ (instancetype)shareUserInfo
{
    @synchronized(self)
    {
        if (_userinfo == nil)
        {
            if ([NSKeyedUnarchiver unarchiveObjectWithFile:JTDocumentsFilePath(kJTUserInfoPersistentPath)]) {
                return [NSKeyedUnarchiver unarchiveObjectWithFile:JTDocumentsFilePath(kJTUserInfoPersistentPath)];
            }
            else
            {
                return [[self alloc] init];
            }
        }
        return _userinfo;
    }
}

- (void)save
{
    NSString *path = JTDocumentsFilePath(kJTUserInfoPersistentPath);
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userID"         : @"uid",
             @"userToken"      : @"token",
             @"userAvatar"     : @"avatar",
             @"userBirth"      : @"birth",
             @"userCompany"    : @"company",
             @"userGenter"     : @"gender",
             @"userGrade"      : @"grade",
             @"userName"       : @"nick_name",
             @"userPhone"      : @"phone",
             @"userSign"       : @"sign",
             @"userNumberCode" : @"user_name",
             @"userYXAccount"  : @"yx_accid",
             @"userYXToken"    : @"yx_token",
             @"isUserPaymentPassword"     : @"is_password",
             @"userBalance"    : @"baccount",
             @"userAuthStatus" : @"is_auth",
             };
}

- (NSMutableArray<JTCarModel *> *)myCarList
{
    if (!_myCarList) {
        _myCarList = [NSMutableArray array];
    }
    return _myCarList;
}

- (NSMutableArray<JTCarModel *> *)kvcMyCarList {
    return [self mutableArrayValueForKeyPath:NSStringFromSelector(@selector(myCarList))];
}

- (NSMutableArray *)sessionTops
{
    if (!_sessionTops) {
        _sessionTops = [NSMutableArray array];
    }
    return _sessionTops;
}

- (void)clear
{
    [[JTUserInfo shareUserInfo] setIsLogin:NO];
    [self.myCarList removeAllObjects];
    [self save];
}

- (void)addCarModels:(NSArray<JTCarModel *> *)carModels {
    if (self.myCarList.count > 0) {
        [self.myCarList removeAllObjects];
    }
    if (carModels.count > 0) {
        for (JTCarModel *model in carModels) {
            if (model.isDefault) {
                [self.myCarList insertObject:model atIndex:0];
            }
            else
            {
                [self.myCarList addObject:model];
            }
        }
    }
}

- (void)resetDefaultCarModel:(JTCarModel *)carModel
{
    if ([self.myCarList containsObject:carModel]) {
        [self.myCarList removeObject:carModel];
        [self.myCarList insertObject:carModel atIndex:0];
        for (JTCarModel *model in self.myCarList) {
            model.isDefault = (model.carID == carModel.carID);
        }
    }
}
@end

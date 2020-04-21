//
//  AppDelegate.m
//  ZTIceHockey
//
//  Created by 观潮汇 on 6/7/22.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import "HttpRequestTool.h"
#import "ErrorCode.h"
#import "QiniuSDK.h"

NSString * const spm_dataIdentifier = @"jt.datacache.tg";

#define CustomErrorDomain @"com.JTDirectSeeding.test"
#define kTimeInterval     @"timeInterval"

@implementation UploadParam

@end

@implementation ConfigParam

- (instancetype)initWithPlaceholder:(NSString *)placeholder atCacheEnabled:(BOOL)cacheEnabled
{
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
        self.cacheEnabled = cacheEnabled;
    }
    return self;
}
@end

@implementation HttpRequestTool

static id _instance = nil;

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        __weak typeof(self) weakself = self;
        _networkStatus = [Utility networkDetection];
        _timeInterval = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeInterval] ? [[[NSUserDefaults standardUserDefaults] objectForKey:kTimeInterval] doubleValue] : 0;
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakself.networkStatus = status;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 未知网络
                    CCLOG(@"未知网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    CCLOG(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // 手机自带网络
                    CCLOG(@"当前使用的是2G/3G/4G网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // WIFI
                    CCLOG(@"当前在WIFI网络下");
                }
                    break;
            }
        }];
    });
    return _instance;
}

- (void)setNetworkStatus:(AFNetworkReachabilityStatus)networkStatus
{
    _networkStatus = networkStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityStatusChangeNotification object:@(networkStatus)];
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        /**
         *  可以接受的类型
         */
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        /**
         *  请求队列的最大并发数
         */
        _manager.operationQueue.maxConcurrentOperationCount = 5;
        /**
         *  请求超时的时间
         */
        _manager.requestSerializer.timeoutInterval = 30;
        
        [_manager.requestSerializer setValue:App_Version forHTTPHeaderField:@"versioncode"];
        [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"os"];
        [_manager.requestSerializer setValue:CHANNEL_ID forHTTPHeaderField:@"source"];
        [_manager.requestSerializer setValue:App_BundleID forHTTPHeaderField:@"bundle_id"];
        [_manager.requestSerializer setValue:[[NSLocale preferredLanguages] objectAtIndex:0] forHTTPHeaderField:@"accept_language"];
        [_manager.requestSerializer setValue:System_Version forHTTPHeaderField:@"osVersion"];
        [_manager.requestSerializer setValue:System_Model forHTTPHeaderField:@"osModel"];
    }
    return _manager;
}

- (DataCache *)cache
{
    if (!_cache) {
        _cache = [[DataCache alloc] init];
    }
    return _cache;
}

// 组合URL后面带的参数
- (NSString *)combinationParams:(NSDictionary *)params isCache:(BOOL)isCache
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([JTUserInfo shareUserInfo].isLogin && isCache) {
        [dict setObject:[JTUserInfo shareUserInfo].userID forKey:@"uid"];
    }
    if (dict.count == 0) {
        return @"";
    }
    else
    {
        NSMutableArray *resultArr = [NSMutableArray array];
        NSArray *keys = [dict allKeys];
        NSArray *sortArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        for (NSString *key in sortArray) {
            [resultArr addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
        }
        return [resultArr componentsJoinedByString:@"&"];
    }
}

#pragma mark -- 请求 --
- (void)startRequestURLString:(NSString *)URLString
                   parameters:(id)parameters
                     httpType:(HttpRequestType)httpType
                  configParam:(ConfigParam *)configParam
                      success:(void (^)(id responseObject, ResponseState state))success
                      failure:(void (^)(NSError *error))failure
{
    CCLOG(@"currentURL:%@  params:%@", URLString, parameters);
    
    __weak typeof(self) weakself = self;
    if (configParam && configParam.cacheEnabled) {
        [self obtainLocalCache:URLString parameters:parameters success:success];
    }
    if (_networkStatus == AFNetworkReachabilityStatusUnknown || _networkStatus == AFNetworkReachabilityStatusNotReachable) {
        CCLOG(@"网络断开");
        dispatch_async_main_safe(^{
            if (failure) {
                NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain code:500 userInfo:nil];
                failure(error);
            }
        });
    }
    else
    {
        if (configParam && configParam.placeholder)
        {
            dispatch_main_async_safe(^{
                [[HUDTool shareHUDTool] showHint:configParam.placeholder yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            });
        }
        
        JTHttpEncryptionModel *encryptionModel = [JTHttpEncryptionTool encryptionModel];
        NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [requestParameters setObject:encryptionModel.appid forKey:@"appid"];
        [requestParameters setObject:encryptionModel.timestamp forKey:@"timestamp"];
        [requestParameters setObject:encryptionModel.noncestr forKey:@"noncestr"];
        
        if ([JTUserInfo shareUserInfo].isLogin || configParam.isNeedUserTokenAndUserID) {
            [self.manager.requestSerializer setValue:[JTUserInfo shareUserInfo].userID forHTTPHeaderField:@"uid"];
            if (configParam.isEncrypt) {
                [requestParameters setObject:[JTHttpEncryptionTool signParameters:[self combinationParams:requestParameters isCache:NO]] forKey:@"sign"];
            }
        } else {
            [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"uid"];
        }
    
        switch (httpType) {
            case HttpRequestTypeGet:
            {
                [self.manager GET:URLString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [weakself handleNetworkResponseObject:responseObject URLString:URLString parameters:parameters configParam:configParam success:success failure:failure];
                
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [ErrorCode errorCodeAnalytical:error];
                    if (failure) {
                        failure(error);
                    }
                }];
            }
                break;
            case HttpRequestTypePost:
            {
                [self.manager POST:URLString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [weakself handleNetworkResponseObject:responseObject URLString:URLString parameters:parameters configParam:configParam success:success failure:failure];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [ErrorCode errorCodeAnalytical:error];
                    if (failure) {
                        failure(error);
                    }
                }];
            }
                break;
        }
    }
}

#pragma mark -- GET请求 --
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure
{
    [self getWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:nil success:success failure:failure];
}

- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
             placeholder:(NSString *)placeholder
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure
{
    [self getWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:placeholder success:success failure:failure];
}

- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 cacheEnabled:(BOOL)cacheEnabled
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *))failure
{
    [self getWithURLString:URLString parameters:parameters cacheEnabled:cacheEnabled placeholder:nil success:success failure:failure];
}

- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
            cacheEnabled:(BOOL)cacheEnabled
             placeholder:(NSString *)placeholder
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure
{
    ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:placeholder atCacheEnabled:cacheEnabled];
    configParam.isEncrypt = YES;
    [self startRequestURLString:URLString parameters:parameters httpType:HttpRequestTypeGet configParam:configParam success:success failure:failure];
}

#pragma mark -- POST请求 --
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *))failure
{
    [self postWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:nil success:success failure:failure];
}

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
              placeholder:(NSString *)placeholder
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure
{
    [self postWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:placeholder success:success failure:failure];
}

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             cacheEnabled:(BOOL)cacheEnabled
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure
{
    [self postWithURLString:URLString parameters:parameters cacheEnabled:cacheEnabled placeholder:nil success:success failure:failure];
}

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             cacheEnabled:(BOOL)cacheEnabled
              placeholder:(NSString *)placeholder
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure
{
    ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:placeholder atCacheEnabled:cacheEnabled];
    configParam.isEncrypt = YES;
    [self startRequestURLString:URLString parameters:parameters httpType:HttpRequestTypePost configParam:configParam success:success failure:failure];
}

#pragma mark -- POST/GET网络请求 --
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                    httpType:(HttpRequestType)httpType
                     success:(void (^)(id responseObject, ResponseState state))success
                     failure:(void (^)(NSError *error))failure {
    
    switch (httpType) {
        case HttpRequestTypeGet:
        {
            [self getWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:nil success:success failure:failure];
        }
            break;
        case HttpRequestTypePost:
        {
            [self postWithURLString:URLString parameters:parameters cacheEnabled:NO placeholder:nil success:success failure:failure];
        }
            break;
    }
}

#pragma mark -- 上传图片 --
- (void)uploadWithFileNames:(NSArray *)fileNames
              uploadFileArr:(NSArray *)fileArr
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    dispatch_async_main_safe(^{
        [[HUDTool shareHUDTool] showHint:@"请稍等..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    });
    __weak typeof(self) weakself = self;
    [self postWithURLString:kBase_url(GetQiNiuTokenApi) parameters:nil success:^(id responseObject, ResponseState state) {
        NSString *token = [NSString stringWithFormat:@"%@", responseObject[@"token"]];
        __block NSUInteger currentIndex = 0;
        __block NSMutableArray *urls = [NSMutableArray array];
        weakself.singleUploadSuccess = ^(NSString *url) {
            [urls addObject:url];
            if (urls.count == fileArr.count) {
                [[HUDTool shareHUDTool] hideHUD];
                if (success) {
                    success(urls);
                }
            }
            else
            {
                currentIndex ++;
                [weakself uploadFile:fileArr[currentIndex]
                            fileName:fileNames?fileNames[currentIndex]:nil
                               token:token
                             success:weakself.singleUploadSuccess
                             failure:weakself.singleUploadFailure];
            }
        };
        weakself.singleUploadFailure = ^{
            [[HUDTool shareHUDTool] showHint:@"上传失败"];
            if (failure) {
                failure(nil);
            }
        };
        [weakself uploadFile:fileArr[currentIndex]
                    fileName:fileNames?fileNames[currentIndex]:nil
                       token:token
                     success:weakself.singleUploadSuccess
                     failure:weakself.singleUploadFailure];
    } failure:^(NSError *error) {
        [[HUDTool shareHUDTool] showHint:@"上传失败"];
    }];

}

- (void)uploadFile:(id)file
          fileName:(NSString *)fileName
             token:(NSString *)token
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSData *data;
    if ([file isKindOfClass:[UIImage class]]) {
        data = UIImageJPEGRepresentation(file, .5);
    }
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        QNZone *zone = [QNFixedZone zone2];
        builder.zone = zone;
    }];
    QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:config];
    [uploadManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.statusCode == 200 && resp) {
            NSString *url = [NSString stringWithFormat:@"%@", resp[@"key"]];
            if (success) {
                success(url);
            }
        }
        else
        {
            if (failure) {
                failure(nil);
            }
        }
    } option:nil];
}

#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString
                   parameters:(id)parameters
                     progerss:(void (^)(CGFloat progressValue))progress
                      success:(void (^)(id source))success
                      failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            NSInteger progressValue = downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
            progress(progressValue);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else
        {
            if (success) {
                success([filePath path]);
            }
        }
    }];
    [downLoadTask resume];
}

#pragma mark - 获取本地缓存
- (void)obtainLocalCache:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject, ResponseState state))success
{
    NSDictionary *cacheSource = [self.cache getDataForURL:[URLString stringByAppendingString:[self combinationParams:parameters isCache:YES]]];
    if (cacheSource) {
        CCLOG(@"获取缓存数据成功");
        dispatch_async_main_safe(^{
            if (success) {
                success(cacheSource, ResponseStateCache);
            }
        });
    }
}

#pragma mark - 处理接口返回数据
- (void)handleNetworkResponseObject:(id)responseObject
                          URLString:(NSString *)URLString
                         parameters:(id)parameters
                        configParam:(ConfigParam *)configParam
                            success:(void (^)(id responseObject, ResponseState state))success
                            failure:(void (^)(NSError *))failure
{
    if (configParam && configParam.placeholder) {
        [[HUDTool shareHUDTool] hideHUD];
    }
    
    id source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    CCLOG(@"responseObject=%@", source);
    
    if ([URLString isEqualToString:LBS_SearchApi] ||
        [URLString isEqualToString:LBS_WalkApi] ||
        [URLString isEqualToString:LBS_DrivingApi]) {
        if (success) {
            success(source, ResponseStateNormal);
        }
    }
    else
    {
        NSInteger status = [source objectForKey:@"code"] ? [[source objectForKey:@"code"] integerValue] : -9527;
        if (status == 0) {
            if (source && [source objectForKey:@"time"]) {
                self.timeInterval = [[NSDate date] timeIntervalSince1970] - [source[@"time"] integerValue];
            }
            if (source && [source objectForKey:@"data"] && [source[@"data"] isKindOfClass:[NSDictionary class]]) {
                CCLOG(@"请求数据成功");
                if (configParam && configParam.cacheEnabled) {
                    CCLOG(@"缓存网络数据");
                    /* 缓存网络数据 */
                    [self.cache setData:source[@"data"] forURL:[URLString stringByAppendingString:[self combinationParams:parameters isCache:YES]]];
                }
                if (success) {
                    success(source[@"data"], ResponseStateNormal);
                }
            }
            else
            {
                NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain code:-1 userInfo:@{@"msg": @"服务器开小差了"}];
                if (failure) {
                    failure(error);
                }
                [ErrorCode errorCodeAnalytical:error];
            }
        }
        else
        {
            CCLOG(@"数据返回失败");
            NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain code:status userInfo:@{@"msg": source?source[@"msg"]:@"服务器错误"}];
            if (failure) {
                failure(error);
            }
            [ErrorCode errorCodeAnalytical:error];
        }
    }
}

- (void)setTimeInterval:(double)timeInterval
{
    _timeInterval = timeInterval;
    [[NSUserDefaults standardUserDefaults] setObject:@(timeInterval) forKey:kTimeInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - NSDictionary->Model
+ (NSMutableArray *)modelTransformationWithResponseObject:(id)responseObject modelClass:(Class)modelClass
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *appcications = responseObject[@"applications"];
    for (NSDictionary *dict in appcications)
    {
        [array addObject:[modelClass mj_objectWithKeyValues:dict]];
    }
    
    return array;
}

@end

@implementation DataCache

- (instancetype)init {
    self = [super init];
    if(self) {
        NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *rootCachePath = [paths firstObject];
        
        _fileManager    = [NSFileManager defaultManager];
        _cachePath      = [rootCachePath stringByAppendingPathComponent:spm_dataIdentifier];
        
        if(![_fileManager fileExistsAtPath:spm_dataIdentifier]) {
            [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    return self;
}

- (void)setData:(NSDictionary *)dic forURL:(NSString *)URL
{
    if (!dic || dic.count == 0 || !URL || URL.length == 0) {
        return;
    }
    NSString *fileExtension = [[URL componentsSeparatedByString:@"/"] lastObject];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:@"Some_Key_Value"];
    [archiver finishEncoding];
    [data writeToFile:[_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]] atomically:YES];
}

- (NSDictionary *)getDataForURL:(NSString *)URL
{
    if (!URL || URL.length == 0) {
        return nil;
    }
    NSString *fileExtension = [[URL componentsSeparatedByString:@"/"] lastObject];
    NSString *path = [_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]];
    if([_fileManager fileExistsAtPath:path]) {
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some_Key_Value"];
        [unarchiver finishDecoding];
        return myDictionary;
    }
    return nil;
}

- (void)removeCache
{
    if ([_fileManager fileExistsAtPath:_cachePath]) {
        [_fileManager removeItemAtPath:_cachePath error:nil];
    }
}
@end

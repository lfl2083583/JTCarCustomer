//
//  AppDelegate.m
//  ZTIceHockey
//
//  Created by 观潮汇 on 6/7/22.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JTHttpEncryptionTool.h"

@class DataCache;

@interface UploadParam : NSObject
/**
 *  图片的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  服务器对应的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件的名称(上传到服务器后，服务器保存的文件名)
 */
@property (nonatomic, copy) NSString *filename;
/**
 *  文件的MIME类型(image/png,image/jpg等)
 */
@property (nonatomic, copy) NSString *mimeType;

@end

@interface ConfigParam : NSObject

/**
 *  加载提示语
 */
@property (nonatomic, strong) NSString *placeholder; // default is nil

/**
 *  是否缓存请求数据
 */
@property (nonatomic, assign) BOOL cacheEnabled;  // default is YES 在没有网络的情况下获取缓存数据

/**
 *  是否加密
 */
@property (nonatomic, assign) BOOL isEncrypt;

/**
 *  是否需要用户token及用户id
 */
@property (nonatomic, assign) BOOL isNeedUserTokenAndUserID;


- (instancetype)initWithPlaceholder:(NSString *)placeholder atCacheEnabled:(BOOL)cacheEnabled;

@end

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger, HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

/**
 *  响应状态
 */
typedef NS_ENUM(NSUInteger, ResponseState) {
    /**
     *  网络响应
     */
    ResponseStateNormal = 0,
    /**
     *  缓存响应
     */
    ResponseStateCache,
    /**
     *  无响应
     */
    ResponseStateNone
};

@interface HttpRequestTool : NSObject

/**
 *  网络状态
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

/**
 *  请求会话管理
 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/**
 *  网络缓存类
 */
@property (strong, nonatomic) DataCache *cache;

/**
 *  单个上传成功
 */
@property (copy, nonatomic) void (^singleUploadSuccess)(NSString *url);

/**
 *  单个上传失败
 */
@property (copy, nonatomic) void (^singleUploadFailure)();

/**
 *  与服务器的时间间隔
 */
@property (assign, nonatomic) double timeInterval;

+ (instancetype)sharedInstance;

/**
 *  发送请求 对请求进行拓展
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param httpType    请求的类型
 *  @param configParam 请求的拓展
 *  @param success     请求成功的回调
 *  @param failure     请求失败的回调
 */
- (void)startRequestURLString:(NSString *)URLString
                   parameters:(id)parameters
                     httpType:(HttpRequestType)httpType
                  configParam:(ConfigParam *)configParam
                      success:(void (^)(id responseObject, ResponseState state))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  发送get请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送get请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param placeholder  加载提示语
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
             placeholder:(NSString *)placeholder
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送get请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param cacheEnabled 是否缓存请求数据
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
            cacheEnabled:(BOOL)cacheEnabled
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送get请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param cacheEnabled 是否缓存请求数据
 *  @param placeholder  加载提示语
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
            cacheEnabled:(BOOL)cacheEnabled
             placeholder:(NSString *)placeholder
                 success:(void (^)(id responseObject, ResponseState state))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param placeholder  加载提示语
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
              placeholder:(NSString *)placeholder
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param cacheEnabled 是否缓存请求数据
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             cacheEnabled:(BOOL)cacheEnabled
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param cacheEnabled 是否缓存请求数据
 *  @param placeholder  加载提示语
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             cacheEnabled:(BOOL)cacheEnabled
              placeholder:(NSString *)placeholder
                  success:(void (^)(id responseObject, ResponseState state))success
                  failure:(void (^)(NSError *error))failure;
/**
 *  发送网络请求
 *
 *  @param URLString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param httpType     请求的类型
 */
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                    httpType:(HttpRequestType)httpType
                     success:(void (^)(id responseObject, ResponseState state))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  七牛上传
 *
 *  @param fileNames    文件名
 *  @param fileArr     上传文件数据
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
- (void)uploadWithFileNames:(NSArray *)fileNames
              uploadFileArr:(NSArray *)fileArr
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;


/**
 *  下载数据
 *
 *  @param URLString   下载数据的网址
 *  @param parameters  下载数据的参数
 *  @param success     下载成功的回调
 *  @param failure     下载失败的回调
 */
- (void)downLoadWithURLString:(NSString *)URLString
                   parameters:(id)parameters
                     progerss:(void (^)(CGFloat progressValue))progress
                      success:(void (^)(id source))success
                      failure:(void (^)(NSError *error))failure;

/**
 获取本地缓存
 
 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param success 请求成功的回调
 */
- (void)obtainLocalCache:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject, ResponseState state))success;

/**
 处理接口返回数据

 @param responseObject 请求返回对象
 @param URLString 请求的网址字符串
 @param parameters 请求的参数
 @param configParam 请求的拓展
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
- (void)handleNetworkResponseObject:(id)responseObject
                          URLString:(NSString *)URLString
                         parameters:(id)parameters
                        configParam:(ConfigParam *)configParam
                            success:(void (^)(id responseObject, ResponseState state))success
                            failure:(void (^)(NSError *))failure;
/**
 *  这个方法主要是将下载的responseObject转换为模型，这个方法可以基于自己JSON数据结构来写
 *
 *  @param responseObject 网络请求下来的数据
 *  @param modelClass     模型
 *
 *  @return 返回一个转换后的模型
 */
+ (NSMutableArray *)modelTransformationWithResponseObject:(id)responseObject modelClass:(Class)modelClass;
@end

@interface DataCache : NSObject

@property (nonatomic, strong) NSString      *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;

/**
 *  设置缓存数据
 *
 *  @param dic 缓存数据
 *  @param URL 缓存路径
 */
- (void)setData:(NSDictionary *)dic forURL:(NSString *)URL;

/**
 *  获取缓存数据
 *
 *  @param URL 缓存路径
 *
 *  @return 缓存数据
 */
- (NSDictionary *)getDataForURL:(NSString *)URL;

/**
 *  删除缓存
 */
- (void)removeCache;

@end

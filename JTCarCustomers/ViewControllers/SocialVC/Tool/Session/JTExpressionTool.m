//
//  JTExpressionTool.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionTool.h"
#import "NSData+Extension.h"

static inline NSString * JTDocumentsFilePath(NSString *fileName)
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [directories[0] stringByAppendingPathComponent:fileName];
}

@interface JTExpressionTool ()

@property (strong, nonatomic) NSString *collectionFilePath;
@property (strong, nonatomic) NSString *otherFilePath;
@property (strong, nonatomic) NSFileManager *fileManager;

@end


@implementation JTExpressionTool

+ (instancetype)sharedManager
{
    static JTExpressionTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTExpressionTool alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSArray *collectionExpressions = [self unArchiverPath:self.collectionFilePath];
    if (collectionExpressions && collectionExpressions.count > 0) {
        [self.collectionExpressions addObjectsFromArray:collectionExpressions];
    }
    NSArray *otherExpressions = [self unArchiverPath:self.otherFilePath];
    if (otherExpressions && otherExpressions.count > 0) {
        [self.otherExpressions addObjectsFromArray:otherExpressions];
    }
}

- (void)synchronizationData:(void (^)(void))success
                    failure:(void (^)(void))failure
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(MyEmoticonsApi) parameters:nil success:^(id responseObject, ResponseState state) {
        
        [weakself.otherExpressions removeAllObjects];
        if ([responseObject objectForKey:@"data"] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            [weakself.otherExpressions addObjectsFromArray:responseObject[@"data"]];
            [weakself.otherExpressions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                if ([obj1[@"sort"] integerValue] > [obj1[@"sort"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1[@"sort"] integerValue] < [obj1[@"sort"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            [weakself downloadModels:weakself.otherExpressions];
            if ([weakself writeDocuments:weakself.otherExpressions fileName:kOtherExpressionFileName]) {
                if (success) success();
            }
            else
            {
                if (failure) failure();
            }
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)addSingleModel:(NSDictionary *)model
               success:(void (^)(void))success
               failure:(void (^)(void))failure
{
    [self.otherExpressions insertObject:model atIndex:0];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakself downloadModel:model];
    });
    if ([weakself writeDocuments:self.otherExpressions fileName:kOtherExpressionFileName]) {
        if (success) success();
    }
    else
    {
        if (failure) failure();
    }
}

- (void)downloadModels:(NSArray *)models
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *model in models) {
            [weakself downloadModel:model];
        }
    });
}

- (void)downloadModel:(NSDictionary *)model
{
    if ([model objectForKey:@"list"] && [model[@"list"] isKindOfClass:[NSArray class]] && [model[@"list"] count]) {
        NSArray *array = [model objectForKey:@"list"];
        for (NSDictionary *dic in array) {
            [Utility downloadImageWithURLString:dic[@"gif"] success:nil];
        }
    }
}

- (BOOL)writeDocuments:(NSArray *)expressions fileName:(NSString *)fileName
{
    NSData *data = [self archiverExpressions:expressions];
    NSString *url = [data writeDocumentsFolderName:@"Input" fileName:fileName];
    return (url != nil);
}

- (void)reloadCollectionExpressions:(NSArray *)expressions
{
    if ([self writeDocuments:expressions fileName:kCollectionExpressionFileName]) {
        [self.collectionExpressions removeAllObjects];
        [self.collectionExpressions addObjectsFromArray:expressions];
    }
}

- (void)reloadOtherExpressions:(NSArray *)expressions
{
    if ([self writeDocuments:expressions fileName:kOtherExpressionFileName]) {
        [self.otherExpressions removeAllObjects];
        [self.otherExpressions addObjectsFromArray:expressions];
    }
}

/**
 解档本地表情

 @param path 本地路径
 @return 表情数组
 */
- (NSArray *)unArchiverPath:(NSString *)path
{
    if (![self.fileManager fileExistsAtPath:path]) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *expressions = [unarchiver decodeObjectForKey:kJTExpressionKey];
    [unarchiver finishDecoding];
    return expressions;
}

/**
 归档表情

 @param expressions 表情数据
 @return 归档后的数据
 */
- (NSData *)archiverExpressions:(NSArray *)expressions
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:expressions forKey:kJTExpressionKey];
    [archiver finishEncoding];
    return data;
}

- (NSMutableArray *)collectionExpressions
{
    if (!_collectionExpressions) {
        _collectionExpressions = [NSMutableArray array];
    }
    return _collectionExpressions;
}

- (NSMutableArray *)otherExpressions
{
    if (!_otherExpressions) {
        _otherExpressions = [NSMutableArray array];
    }
    return _otherExpressions;
}

- (NSString *)collectionFilePath
{
    if (!_collectionFilePath) {
        _collectionFilePath = JTDocumentsFilePath([@"Input" stringByAppendingPathComponent:kCollectionExpressionFileName]);
    }
    return _collectionFilePath;
}

- (NSString *)otherFilePath
{
    if (!_otherFilePath) {
        _otherFilePath = JTDocumentsFilePath([@"Input" stringByAppendingPathComponent:kOtherExpressionFileName]);
    }
    return _otherFilePath;
}

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end

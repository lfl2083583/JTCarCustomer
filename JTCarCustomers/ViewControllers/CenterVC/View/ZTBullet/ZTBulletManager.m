//
//  ZTBulletManager.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTBulletManager.h"
#import "ZTBulletView.h"

@interface ZTBulletManager()

// 弹幕使用过程中的数组变量(已经创建出来的弹幕数据)
@property (nonatomic, strong) NSMutableArray *bulletComments;
// 存储弹幕 view 的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;

// 标记是否停止状态: YES已停止，NO还未停止
@property (nonatomic, assign) BOOL bStopAnimation;

@end

@implementation ZTBulletManager

#pragma mark - init

static ZTBulletManager *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**
 单例方法
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // 默认已经停止
        self.bStopAnimation = YES;
    }
    return self;
}

#pragma mark - logic deal

/**
 开始弹幕运动
 */
- (void)zt_startBulletsAction
{
    // 还未停止不创建
    if (!self.bStopAnimation) return;
    
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSources];
    
    [self initBulletComment];
}

/**
 停止弹幕运动
 */
- (void)zt_stopAction
{
    if (self.bStopAnimation) return;
    
    self.bStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZTBulletView *bulletView = obj;
        [bulletView zt_stopAnimation];
        bulletView = nil;
    }];
    [self.bulletViews removeAllObjects];
}

// 初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment
{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2)]];
    for (int i = 0; i < 3; i++) {
        
        if (self.bulletComments.count > 0)
        {
            // 1.随机数获取弹道轨迹
            NSInteger randomTrajecIndex = random() % trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:randomTrajecIndex] intValue];
            [trajectorys removeObjectAtIndex:randomTrajecIndex];

            // 2.从弹幕数组中逐一取出弹幕数据
            NSDictionary *commentInfo = [self.bulletComments objectAtIndex:0];
            [self.bulletComments removeObjectAtIndex:0];
           
             // 3.创建弹幕view
            [self createBulletView:commentInfo trajectory:trajectory];
        }
    };
}

// 插入一条弹幕

- (void)zt_insertBulletView:(NSDictionary *)commentInfo {
    
    if (![self.dataSources containsObject:commentInfo]) {
        [self.dataSources addObject:commentInfo];
        [self.bulletComments insertObject:commentInfo atIndex:0];
    }
}

// 创建弹幕view
- (void)createBulletView:(NSDictionary *)commentInfo trajectory:(int)trajectory
{
    if (self.bStopAnimation) return;
    
    ZTBulletView *bulletView = [[ZTBulletView alloc] initWithComment:commentInfo];
    bulletView.trajectory = trajectory;
    [self.bulletViews addObject:bulletView];
    
    __weak typeof (bulletView) weakBulletView = bulletView;
    __weak typeof (self) weakSelf = self;
    bulletView.moveStatusBlock = ^(ZTBulletStatus status) {
        if(self.bStopAnimation) return;
        switch (status) {
            case Start: {
                // 弹幕开始进入屏幕，将view 加入到弹幕管理变量 bulletViews 中
                [weakSelf.bulletViews addObject:weakBulletView];
                break;
            }
            case Enter: {
                // 弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中再创建一个
                NSDictionary *comment = [weakSelf nextComment];
                if(comment)
                {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case Exit: {
                // 弹幕完全飞出屏幕后从bulletViews 中删除，释放资源
                if([self.bulletViews containsObject:weakBulletView]) {
                    [weakBulletView zt_stopAnimation];
                    [weakSelf.bulletViews removeObject:weakBulletView];
                }
                
                // 是否开始循环
                if(self.bulletViews.count == 0) {
                // 说明没有屏幕上已经没有的弹幕了，开始循环滚动
                    weakSelf.bStopAnimation = YES;
                    [weakSelf zt_startBulletsAction];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock)
    {
        self.generateViewBlock(bulletView);
    }
}

// 下一条弹幕
- (NSDictionary *)nextComment
{
    if (self.bulletComments.count == 0) return nil;
    
    NSDictionary *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    
    return comment;
}

#pragma layz-load

- (NSMutableArray *)dataSources
{
    if (!_dataSources)
    {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (NSMutableArray *)bulletComments
{
    if (!_bulletComments)
    {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews
{
    if (!_bulletViews)
    {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end

//
//  JTInputExpressionManager.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputExpressionManager.h"
#import "JTInputGlobal.h"
#import "JTExpressionTool.h"
#import "UIImage+Chat.h"

@interface JTInputExpressionManager ()

@property (strong, nonatomic) JTExpressionItem *emojiExpressionItem;
@property (strong, nonatomic) JTExpressionItem *collectionExpressionItem;
@property (strong, nonatomic) NSMutableArray<JTExpressionItem *> *otherExpressionItemArray;

@end

@implementation JTInputExpressionManager

+ (instancetype)sharedManager
{
    static JTInputExpressionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTInputExpressionManager alloc] init];
    });
    return instance;
}

- (JTExpression *)emojiInName:(NSString *)name
{
    if (name.length > 0 && [name isSpecialCharacter]) {
        if (self.emojiExpressionItem && self.emojiExpressionItem.expressionNameDic.count > 0) {
            JTExpression *expression = [self.emojiExpressionItem.expressionNameDic objectForKey:name];
            if (expression) {
                return expression;
            }
        }
    }
    return nil;
}

- (NSArray<JTExpression *> *)expressionInName:(NSString *)name
{
    NSMutableArray *items = [NSMutableArray array];
    if (name.length > 0 && ![name isSpecialCharacter]) {
        for (JTExpressionItem *expressionItem in self.otherExpressionItemArray) {
            JTExpression *expression = [expressionItem.expressionNameDic objectForKey:name];
            if (expression) {
                [items addObject:expression];
            }
        }
    }
    return items;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kResetInputExpressionNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetInputExpressionNotification:) name:kResetInputExpressionNotification object:nil];
    }
    return self;
}

- (void)setLoadSuccessBlock:(void (^)(JTExpressionItem *, JTExpressionItem *, NSMutableArray<JTExpressionItem *> *))loadSuccessBlock
{
    _loadSuccessBlock = loadSuccessBlock;
    _loadSuccessBlock(self.emojiExpressionItem, self.collectionExpressionItem, self.otherExpressionItemArray);
}

- (void)setup
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        [weakself.otherExpressionItemArray removeAllObjects];
        [weakself loadEmojiCatalog];
        [weakself loadCollectionCatalog];
        [weakself loadOtherCatalog];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (weakself.loadSuccessBlock) {
                weakself.loadSuccessBlock(weakself.emojiExpressionItem, weakself.collectionExpressionItem, weakself.otherExpressionItemArray);
            }
        });
    });
}

- (void)resetInputExpressionNotification:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        [weakself.otherExpressionItemArray removeAllObjects];
        [weakself loadCollectionCatalog];
        [weakself loadOtherCatalog];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (weakself.loadSuccessBlock) {
                weakself.loadSuccessBlock(weakself.emojiExpressionItem, weakself.collectionExpressionItem, weakself.otherExpressionItemArray);
            }
        });
    });
}

// 加载Emoji表情
- (void)loadEmojiCatalog
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:EmoticonBundleName withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *filepath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:JTKit_ExpressionEmoji];
    if (filepath) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
        NSDictionary *info = dict[@"info"];
        NSMutableArray *expressions = [NSMutableArray array];
        NSMutableDictionary *expressionIDDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *expressionNameDic = [NSMutableDictionary dictionary];
        for (NSDictionary *element in dict[@"data"]) {
            JTExpression *expression = [[JTExpression alloc] init];
            expression.type = JTExpressionTypeEmoji;
            expression.expressionID = element[@"id"];
            expression.name = element[@"tag"];
            expression.localFileName = element[@"file"];
            if (expression.expressionID) {
                [expressions addObject:expression];
                [expressionIDDic setObject:expression forKey:expression.expressionID];
            }
            if (expression.name) {
                [expressionNameDic setObject:expression forKey:expression.name];
            }
        }
        self.emojiExpressionItem.layout = [[JTExpressionLayout alloc] initWithEmojiLayout];
        self.emojiExpressionItem.type = JTExpressionTypeEmoji;
        self.emojiExpressionItem.catalogID = info[@"id"];
        self.emojiExpressionItem.title = info[@"title"];
        self.emojiExpressionItem.expressions = expressions;
        self.emojiExpressionItem.expressionIDDic = expressionIDDic;
        self.emojiExpressionItem.expressionNameDic = expressionNameDic;
        self.emojiExpressionItem.icon = info[@"normal"];
        self.emojiExpressionItem.iconPressed = info[@"pressed"];
    }
}

// 加载收藏表情
- (void)loadCollectionCatalog
{
    NSMutableArray *expressions = [NSMutableArray array];
    NSMutableDictionary *expressionIDDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *expressionNameDic = [NSMutableDictionary dictionary];
    for (NSDictionary *element in [JTExpressionTool sharedManager].collectionExpressions) {
        JTExpression *expression = [[JTExpression alloc] init];
        expression.type = JTExpressionTypeCollection;
        expression.expressionID = element[@"id"];
        expression.name = @"";
        expression.thumbnailUrl = element[@"thumb"];
        expression.originalUrl = element[@"image"];
        if (expression.expressionID) {
            [expressions addObject:expression];
            [expressionIDDic setObject:expression forKey:expression.expressionID];
        }
        if (expression.name) {
            [expressionNameDic setObject:expression forKey:expression.name];
        }
        expression.width = [NSString stringWithFormat:@"%@", element[@"width"]];
        expression.height = [NSString stringWithFormat:@"%@", element[@"height"]];
    }
    self.collectionExpressionItem.layout = [[JTExpressionLayout alloc] initWithPhotoLayout];
    self.collectionExpressionItem.type = JTExpressionTypeCollection;
    self.collectionExpressionItem.catalogID = @"collection";
    self.collectionExpressionItem.title = @"收藏";
    self.collectionExpressionItem.expressions = expressions;
    self.collectionExpressionItem.expressionIDDic = expressionIDDic;
    self.collectionExpressionItem.expressionNameDic = expressionNameDic;
    self.collectionExpressionItem.icon = @"tab_collection";
    self.collectionExpressionItem.iconPressed = @"tab_collection";
}

// 加载其他表情
- (void)loadOtherCatalog
{
    for (NSDictionary *source in [JTExpressionTool sharedManager].otherExpressions) {
        NSMutableArray *expressions = [NSMutableArray array];
        NSMutableDictionary *expressionIDDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *expressionNameDic = [NSMutableDictionary dictionary];
        for (NSDictionary *element in source[@"list"]) {
            JTExpression *expression = [[JTExpression alloc] init];
            expression.type = JTExpressionTypeOther;
            expression.expressionID = element[@"id"];
            expression.name = element[@"name"];
            expression.thumbnailUrl = element[@"img_static"];
            expression.originalUrl = element[@"img_gif"];
            if (expression.expressionID) {
                [expressions addObject:expression];
                [expressionIDDic setObject:expression forKey:expression.expressionID];
            }
            if (expression.name) {
                [expressionNameDic setObject:expression forKey:expression.name];
            }
            expression.width = [NSString stringWithFormat:@"%@", element[@"width"]];
            expression.height = [NSString stringWithFormat:@"%@", element[@"height"]];
        }
        JTExpressionItem *item = [[JTExpressionItem alloc] init];
        item.layout = [[JTExpressionLayout alloc] initWithPhotoLayout];
        item.type = JTExpressionTypeOther;
        item.catalogID = source[@"id"];
        item.title = source[@"name"];
        item.expressions = expressions;
        item.expressionIDDic = expressionIDDic;
        item.expressionNameDic = expressionNameDic;
        item.icon = source[@"cover"];
        item.iconPressed = source[@"cover"];
        [self.otherExpressionItemArray addObject:item];
    }
}

- (JTExpressionItem *)emojiExpressionItem
{
    if (!_emojiExpressionItem) {
        _emojiExpressionItem = [[JTExpressionItem alloc] init];
    }
    return _emojiExpressionItem;
}

- (JTExpressionItem *)collectionExpressionItem
{
    if (!_collectionExpressionItem) {
        _collectionExpressionItem = [[JTExpressionItem alloc] init];
    }
    return _collectionExpressionItem;
}

- (NSMutableArray<JTExpressionItem *> *)otherExpressionItemArray
{
    if (!_otherExpressionItemArray) {
        _otherExpressionItemArray = [NSMutableArray array];
    }
    return _otherExpressionItemArray;
}
@end

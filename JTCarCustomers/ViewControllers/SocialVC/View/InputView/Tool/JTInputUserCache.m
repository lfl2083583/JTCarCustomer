//
//  JTInputUserCache.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputUserCache.h"

@implementation JTInputUserCache

- (NSArray *)getYunXinIDArray:(NSString *)text
{
    NSArray *names = [self matchString:text];
    NSMutableArray *yunxinIDs = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        JTInputUserItem *item = [self objectInName:name];
        if (item) {
            [yunxinIDs addObject:item.yunxinID];
        }
    }
    return yunxinIDs;
}

- (void)clean
{
    [self.items removeAllObjects];
}

- (void)addItem:(JTInputUserItem *)item
{
    [self.items addObject:item];
}

- (void)addItems:(NSArray *)items
{
    [self.items addObjectsFromArray:items];
}

- (JTInputUserItem *)objectInName:(NSString *)name
{
    __block JTInputUserItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTInputUserItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    return item;
}

- (JTInputUserItem *)removeObjectAtName:(NSString *)name
{
    __block JTInputUserItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTInputUserItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    if (item) {
        [_items removeObject:item];
    }
    return item;
}

- (NSArray *)matchString:(NSString *)text
{
    NSString *pattern = [NSString stringWithFormat:@"%@([^%@]+)%@", JTInputStartChar, JTInputEndChar, JTInputEndChar];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *matchs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in results) {
        NSString *name = [text substringWithRange:result.range];
        name = [name substringFromIndex:1];
        name = [name substringToIndex:name.length -1];
        [matchs addObject:name];
    }
    return matchs;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end

//
//  ZTAdminister.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ZTAdminister.h"

@implementation ZTAdminister

+ (void)sqlite_insert:(id<JTDataBaseConfig>)model
{
    ZTDataBase *_base = [[ZTDataBase alloc] init];
    [_base openDB];
    if ([model respondsToSelector:@selector(createSQLite)]) {
        [_base execute:[model createSQLite]];
    }
    if ([model respondsToSelector:@selector(insertSQLite)]) {
        [_base execute:[model insertSQLite]];
    }
    [_base closeDB];
}

+ (void)sqlite_batchInsert:(NSArray *)modelArray
{
    
}

+ (void)sqlite_delete:(id<JTDataBaseConfig>)model
{
    ZTDataBase *_base = [[ZTDataBase alloc] init];
    [_base openDB];
    if ([model respondsToSelector:@selector(deleteSQLite)]) {
        [_base execute:[model deleteSQLite]];
    }
    [_base closeDB];
}

+ (void)sqlite_update:(id<JTDataBaseConfig>)model
{
    ZTDataBase *_base = [[ZTDataBase alloc] init];
    [_base openDB];
    if ([model respondsToSelector:@selector(updateSQLite)]) {
        [_base execute:[model updateSQLite]];
    }
    [_base closeDB];
}

+ (id)sqlite_search:(id<JTDataBaseConfig>)model
{
    NSMutableArray *_array = [NSMutableArray array];
    ZTDataBase *_base = [[ZTDataBase alloc] init];
    [_base openDB];
    if ([model respondsToSelector:@selector(searchSQLite)]) {
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_base.db, [[model createSQLite] UTF8String], -1, &stmt, nil)) {
        }
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            if ([model isKindOfClass:[JTSessionBackgroundModel class]]) {
                JTSessionBackgroundModel *item = [[JTSessionBackgroundModel alloc] init];
                item.sessionID = [NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 1))];
                item.background = [NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 2))];
                [_array addObject:model];
            }
        }
        sqlite3_finalize(stmt);
    }
    [_base closeDB];
    return _array;
}

+ (void)sqlite_truncate:(NSString *)tableName
{
    ZTDataBase *_base = [[ZTDataBase alloc] init];
    [_base openDB];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from %@", tableName];
    [_base execute:sql];
    [_base closeDB];
}
@end

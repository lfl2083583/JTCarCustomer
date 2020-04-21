//
//  JTSessionBackgroundModel.m
//  JTSocial
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionBackgroundModel.h"

@implementation JTSessionBackgroundModel

- (instancetype)initWithSessionID:(NSString *)sessionID
{
    return [self initWithSessionID:sessionID background:nil];
}

- (instancetype)initWithSessionID:(NSString *)sessionID background:(NSString *)background
{
    self = [super init];
    if (self) {
        _sessionID = sessionID;
        _background = background;
    }
    return self;
}

- (NSString *)createSQLite
{
    return [[NSString alloc] initWithFormat:@"create table if not exists %@ (numberID Integer primary key, sessionID text, background text)", kSessionBackgroundTable];
}

- (NSString *)insertSQLite
{
    return [[NSString alloc] initWithFormat:@"insert into %@ (sessionID, background) values ('%@', '%@')", kSessionBackgroundTable, self.sessionID, self.background];
}

- (NSString *)deleteSQLite
{
    return [[NSString alloc] initWithFormat:@"delete from %@ where sessionID = '%@'", kSessionBackgroundTable, self.sessionID];
}

- (NSString *)updateSQLite
{
    return [[NSString alloc] initWithFormat:@"update %@ set background = '%@' where sessionID = '%@'", kSessionBackgroundTable, self.background, self.sessionID];
}

- (NSString *)searchSQLite
{
    return [[NSString alloc] initWithFormat:@"select *from %@ where sessionID like '%@' order by numberID desc", kSessionBackgroundTable, self.sessionID];
}

@end

//
//  ZTDataBase.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ZTDataBase.h"

@implementation ZTDataBase

- (void)openDB
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"IphoneDB"];
    if (sqlite3_open([path UTF8String], &_db)==SQLITE_OK) {
        NSLog(@"sqlite3_open: success");
    }
}

- (void)closeDB
{
    if (_db) {
        if (sqlite3_close(_db)==SQLITE_OK) {
            NSLog(@"sqlite3_close: success");
        }
    }
}

- (void)execute:(NSString *)sql
{
    char *message;
    
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &message)==SQLITE_OK) {
        
        NSLog(@"sqlite3_exec: success");
    }
    sqlite3_free(message);
}

@end

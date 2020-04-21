//
//  ZTDataBase.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "JTSessionBackgroundModel.h"

@interface ZTDataBase : NSObject

@property (assign, atomic) sqlite3 *db;

- (void)openDB;
- (void)closeDB;
- (void)execute:(NSString *)sql;

@end

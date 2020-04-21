//
//  JTInputUserItem.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JTInputUserStartChar  @"@"
#define JTInputUserEndChar    @"\u2004"

@interface JTInputUserItem : NSObject 

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *yunxinID;
@property (nonatomic, assign) NSRange range;

@end

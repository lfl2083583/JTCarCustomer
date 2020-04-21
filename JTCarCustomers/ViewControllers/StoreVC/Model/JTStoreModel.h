//
//  JTStoreModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTStoreModel : NSObject

@property (copy, nonatomic) NSString *storeID;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *color;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (copy, nonatomic) NSArray *labels;
@property (assign, nonatomic) BOOL is_favorite;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *h5Url;

@end

//
//  JTStoreInformationModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTEngineerModel : NSObject

@property (copy, nonatomic) NSString *engineerID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *avatar;

@end

@interface JTStoreInformationModel : NSObject

@property (copy, nonatomic) NSArray *coverImages;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSArray<JTEngineerModel *> *engineers;

@end

//
//  JTStoreServiceCollectionView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreSeviceClassModel.h"

@interface JTStoreServiceCollectionView : UICollectionView

@property (copy, nonatomic) NSString *storeID;
@property (copy, nonatomic) NSMutableArray<JTStoreSeviceClassModel *> *storeSeviceClassModels;;

@end

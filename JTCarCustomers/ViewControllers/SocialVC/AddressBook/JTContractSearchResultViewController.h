//
//  JTContractSearchResultViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/29.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
typedef NS_ENUM(NSInteger, JTContractSearchType)
{
    /** 搜人 **/
    JTContractSearchTypeUser = 1,
    /** 搜群 **/
    JTContractSearchTypeTeam,
};

@interface JTContractSearchResultViewController : BaseRefreshViewController

@property (nonatomic, assign) JTContractSearchType searchType;
@property (nonatomic, copy) NSString *keywords;

- (instancetype)initWithSearchType:(JTContractSearchType)searchType keywords:(NSString *)keywords;

@end

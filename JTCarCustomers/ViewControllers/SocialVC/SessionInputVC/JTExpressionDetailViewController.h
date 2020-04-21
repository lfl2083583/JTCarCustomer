//
//  JTExpressionDetailViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTExpressionDetailCollectionHeaderView : UICollectionReusableView

@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UILabel *detailLB;
@property (strong, nonatomic) UIButton *downloadBT;

@property (strong, nonatomic) NSMutableDictionary *sourceDic;
@property (copy, nonatomic) void (^didSelectDownloadBlock)(void);

@end

@interface JTExpressionDetailViewController : BaseRefreshViewController

@property (strong, nonatomic) NSMutableDictionary *sourceDic;

- (instancetype)initWithSourceDic:(NSDictionary *)sourceDic;
@end

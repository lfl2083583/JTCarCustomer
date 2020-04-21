//
//  JTStoreEvaluateTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JTStoreStarType)
{
    /** 环境评分 **/
    JTStoreStarTypeEnvironment = 1,
    /** 技术评分 **/
    JTStoreStarTypeAbility     = 2,
    /** 服务评分 **/
    JTStoreStarTypeService     = 3,
};

static NSString *const storeEvaluateIdentifier = @"JTStoreEvaluateTableViewCell";

@protocol JTStoreEvaluateTableViewCellDelegate <NSObject>

- (void)storeEvaluateTableViewCellAddPhoto;
- (void)storeEvaluateTableViewCellDeletePhoto:(NSInteger)index;
- (void)storeEvaluateTableViewCellStarEvaluate:(JTStoreStarType)starType score:(CGFloat)score;

@end


@interface JTStoreEvaluateTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, weak) id<JTStoreEvaluateTableViewCellDelegate>delegate;

+ (CGFloat)getCellHeightWithPhotos:(NSArray *)photoArray;

@end

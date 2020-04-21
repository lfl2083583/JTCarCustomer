//
//  JTTalentEvaluateTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTalentEvaluateTableViewCellDelegate <NSObject>

- (void)tableViewCellForMakeStar:(NSInteger)star;

- (void)tableViewCellForEvaluateContent:(NSString *)content;

@end

static NSString *evaluateTableViewCellIndentify = @"JTTalentEvaluateTableViewCell";

@interface JTTalentEvaluateTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *seletedArray;
@property (nonatomic, weak) id<JTTalentEvaluateTableViewCellDelegate>delegate;

+ (CGFloat)getCellHeightWithTags:(NSArray *)tags width:(CGFloat)width;

@end

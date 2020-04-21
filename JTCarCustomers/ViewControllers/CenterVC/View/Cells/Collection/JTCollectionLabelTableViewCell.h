//
//  JTCollectionLabelTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTCollectionLabelTableViewCell;

@protocol JTCollectionLabelTableViewCellDelegate <NSObject>

- (void)collectionLabelTableViewCell:(JTCollectionLabelTableViewCell *)collectionLabelTableViewCell didSelectAtSource:(id)source;

@end

static NSString *collectionLabelIdentifier = @"JTCollectionLabelTableViewCell";

@interface JTCollectionLabelTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (copy, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) id<JTCollectionLabelTableViewCellDelegate> delegate;

@end

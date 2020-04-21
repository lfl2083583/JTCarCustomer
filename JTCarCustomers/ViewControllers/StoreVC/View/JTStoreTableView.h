//
//  JTStoreTableView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreTableViewCell.h"

@class JTStoreTableView;

@protocol JTStoreTableViewDelegate <NSObject>

- (void)storeTableView:(JTStoreTableView *)storeTableView didSelectRowStoreModel:(JTStoreModel *)storeModel;
- (void)storeTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface JTStoreTableView : UITableView

@property (weak, nonatomic) id<JTStoreTableViewDelegate> scrollDelegate;
@property (assign, nonatomic) NSInteger type;
@end

//
//  JTWalletMoneyDetailTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *walletDeatailCellIndentify = @"JTWalletMoneyDetailTableViewCell";

@interface JTWalletMoneyDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftTopLB;
@property (nonatomic, strong) UILabel *leftBottomLB;
@property (nonatomic, strong) UILabel *rightTopLB;
@property (nonatomic, strong) UILabel *rightBottomLB;

- (void)configWalletMoneyDetailTableViewCellWithInfo:(id)info;

@end

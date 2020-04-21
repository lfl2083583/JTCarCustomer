//
//  ZTPopoverViewController.h
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTPopoverModel : NSObject

@property (copy, nonatomic) UIFont *textFont;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIColor *selectTextColor;
@property (strong, nonatomic) NSArray *iconArr;
@property (strong, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) void(^doneBlock)(NSInteger selectedIndex);

- (instancetype)initWithTextFont:(UIFont *)textfont textColor:(UIColor *)textColor selectTextColor:(UIColor *)selectTextColor iconArr:(NSArray *)iconArr titleArr:(NSArray *)titleArr doneBlock:(void (^)(NSInteger selectedIndex))doneBlock;
@end

@interface ZTPopoverViewController : UIViewController

@property (strong, nonatomic) ZTPopoverModel *model;
@property (strong, nonatomic) UITableView *tableview;
@property (assign, nonatomic) NSInteger selectIndex;
@end

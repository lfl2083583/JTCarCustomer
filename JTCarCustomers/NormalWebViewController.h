//
//  NormalWebViewController.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalWebViewController : UIViewController

@property (strong, nonatomic) NSString *navTitle;
@property (strong, nonatomic) NSString *urlString;
@property (copy, nonatomic) void(^callback)(id source);

- (instancetype)initWithNavTitle:(NSString *)navTitle urlString:(NSString *)urlString;
- (instancetype)initWithNavTitle:(NSString *)navTitle urlString:(NSString *)urlString callback:(void (^)(id source))callback;
@end

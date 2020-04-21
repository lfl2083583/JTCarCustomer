//
//  JTPersonalTagInputViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ZTTagInputBlock) (NSDictionary *dictionary);
typedef void (^ZTTextInputBlock) (NSString *content, NSIndexPath *indexPath);

@interface JTPersonalTagInputViewController : UIViewController

@property (nonatomic, copy) ZTTagInputBlock callBack;
@property (nonatomic, copy) ZTTextInputBlock textCallBack;

- (instancetype)initWithJTTagType:(NSInteger)tagType tagInput:(ZTTagInputBlock)callBack;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title textInput:(ZTTextInputBlock)textCallBack;

@end

//
//  JTInputView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTInputGlobal.h"
#import "JTSessionProtocol.h"
#import "JTInputActionDelegate.h"
#import "JTInputUserCache.h"
#import "ZTImageSize.h"

#import "JTInputToolBar.h"
#import "JTInputMoreContainerView.h"
#import "JTInputExpressionContainerView.h"
#import "JTInputAlbumContainerView.h"
#import "JTInputVoiceContainerView.h"
#import "JTShowExpressionView.h"

@interface JTInputView : UIView

@property (nonatomic, weak) id<JTSessionProtocol> inputConfig;
@property (nonatomic, weak) id<JTInputActionDelegate> delegate;
@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, assign) JTInputStatus currentInputStatus;
@property (nonatomic, assign) NSInteger maxTextLength;

@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) JTInputUserCache *userCache;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate;

- (void)viewWillAppear;

- (void)viewWillDisappear;

/**
 放下输入框
 */
- (void)drop;

/**
 显示键盘
 */
- (void)showKeyboard;

/**
 插入@

 @param yunxinIDs 用户云信ID
 @param isChar 是否带@字符
 */
- (void)insertInputUserItem:(NSArray *)yunxinIDs isChar:(BOOL)isChar;
@end

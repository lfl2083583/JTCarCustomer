//
//  JTInputToolBar.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGrowingTextView.h"
#import "JTSessionProtocol.h"

@class JTInputToolBar;

typedef NS_ENUM(NSInteger, JTInputStatus)
{
    JTInputStatusText,
    JTInputStatusReward,
    JTInputStatusVoice,
    JTInputStatusAlbum,
    JTInputStatusCamera,
    JTInputStatusBonus,
    JTInputStatusExpression,
    JTInputStatusMore
};

@protocol JTInputToolBarDelegate <NSObject>

- (BOOL)inputToolBar:(JTInputToolBar *)inputToolBar selectInputStatus:(JTInputStatus)inputStatus;
- (BOOL)inputToolBar:(JTInputToolBar *)inputToolBar changeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;
- (void)inputToolBar:(JTInputToolBar *)inputToolBar changeText:(NSString *)text;
- (void)inputToolBar:(JTInputToolBar *)inputToolBar changeHeight:(CGFloat)changeHeight;
@end

@interface JTInputToolBar : UIView

@property (strong, nonatomic) JTGrowingTextView *inputTextView;

@property (strong, nonatomic) UIButton *rewardBtn;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (strong, nonatomic) UIButton *albumBtn;
@property (strong, nonatomic) UIButton *cameraBtn;
@property (strong, nonatomic) UIButton *bonusBtn;
@property (strong, nonatomic) UIButton *expressionBtn;
@property (strong, nonatomic) UIButton *moreBtn;

@property (nonatomic, weak) id<JTSessionProtocol> inputConfig;
@property (weak, nonatomic) id<JTInputToolBarDelegate> delegate;
@property (copy, nonatomic) NSArray *inputBarItemTypes;
@property (copy, nonatomic) NSString *placeHolder;
@property (assign, nonatomic, readonly) BOOL isDisplayKeyboard;
@property (copy, nonatomic) NSString *contentText;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputToolBarDelegate>)delegate;

- (void)reset;
@end

@interface JTInputToolBar (InputText)

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end

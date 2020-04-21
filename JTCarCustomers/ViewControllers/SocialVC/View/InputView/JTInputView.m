//
//  JTInputView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputView.h"
#import "JTDeviceAccess.h"
#import "JTContracSelectViewController.h"
#import "JTBaseNavigationController.h"

@interface JTInputView () <JTInputToolBarDelegate>
{
    BOOL isShowKeyboard;
}
@property (strong, nonatomic) JTInputToolBar *toolBar;
@property (strong, nonatomic) JTInputMoreContainerView *moreContainerView;
@property (strong, nonatomic) JTInputExpressionContainerView *expressionContainerView;
@property (strong, nonatomic) JTInputAlbumContainerView *albumContainerView;
@property (strong, nonatomic) JTInputVoiceContainerView *voiceContainerView;
@property (strong, nonatomic) JTShowExpressionView *showExpressionView;
@property (assign, nonatomic) CGFloat keyBoardFrameTop;

@property (weak, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSDictionary *stautsClickDict;

@end

@implementation JTInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputConfig = config;
        _delegate = delegate;
        [self setCurrentInputStatus:JTInputStatusText];
        [self setMaxTextLength:input_maxLength];
        [self setBackgroundColor:WhiteColor];
        
        self.stautsClickDict = @{
                                 @(JTInputStatusText): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarText:"},
                                 @(JTInputStatusReward): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarReward:"},
                                 @(JTInputStatusVoice): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarVoice:"},
                                 @(JTInputStatusAlbum): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarAlbum:"},
                                 @(JTInputStatusCamera): @{@"isSwitchStatus": @(NO), @"selector": @"onTapToolBarCamera:"},
                                 @(JTInputStatusBonus): @{@"isSwitchStatus": @(NO), @"selector": @"onTapToolBarBonus:"},
                                 @(JTInputStatusExpression): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarExpression:"},
                                 @(JTInputStatusMore): @{@"isSwitchStatus": @(YES), @"selector": @"onTapToolBarMore:"}
                                 };
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear
{
    if (isShowKeyboard) {
        [self showKeyboard];
    }
}

- (void)viewWillDisappear
{
}

- (void)drop
{
    [self.toolBar reset];
    if (self.containerView) {
        [self.containerView removeFromSuperview];
        [self setContainerView:nil];
    }
    [self setCurrentInputStatus:JTInputStatusText];
}

- (void)showKeyboard
{
    [self.toolBar.inputTextView becomeFirstResponder];
}

- (void)onTapToolBarText:(JTInputToolBar *)inputToolBar
{

}

- (void)onTapToolBarReward:(JTInputToolBar *)inputToolBar
{
    
}

- (void)onTapToolBarVoice:(JTInputToolBar *)inputToolBar
{
    self.containerView = self.voiceContainerView;
    self.containerView.top = self.toolBar.bottom;
    if (self.containerView) {
        [self addSubview:self.containerView];
    }
}

- (void)onTapToolBarAlbum:(JTInputToolBar *)inputToolBar
{
    self.containerView = self.albumContainerView;
    self.containerView.top = self.toolBar.bottom;
    if (self.containerView) {
        [self addSubview:self.containerView];
    }
}

- (void)onTapToolBarCamera:(JTInputToolBar *)inputToolBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapCamera)]) {
        [self.delegate onTapCamera];
    }
}

- (void)onTapToolBarBonus:(JTInputToolBar *)inputToolBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapBonus)]) {
        [self.delegate onTapBonus];
    }
}

- (void)onTapToolBarExpression:(JTInputToolBar *)inputToolBar
{
    self.containerView = self.expressionContainerView;
    self.containerView.top = self.toolBar.bottom;
    if (self.containerView) {
        [self addSubview:self.containerView];
    }
}

- (void)onTapToolBarMore:(JTInputToolBar *)inputToolBar
{
    self.containerView = self.moreContainerView;
    self.containerView.top = self.toolBar.bottom;
    if (self.containerView) {
        [self addSubview:self.containerView];
    }
}

- (void)didMoveToWindow
{
    if (self.window) {
        [self addSubview:self.toolBar];
        [self addSubview:self.showExpressionView];
    }
    [super didMoveToWindow];
}

#pragma mark JTInputToolBarDelegate
- (BOOL)inputToolBar:(JTInputToolBar *)inputToolBar selectInputStatus:(JTInputStatus)inputStatus
{
    if (inputStatus == JTInputStatusVoice) {
        if (self.session.sessionType == NIMSessionTypeP2P && [JTUserInfoHandle showUserContactType:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]] != JTUserContactTypeFriends) {
            [[HUDTool shareHUDTool] showHint:@"啊哦~相互关注后，才能使用语音信息"];
            return NO;
        }
    }
    NSDictionary *dict = [self.stautsClickDict objectForKey:@(inputStatus)];
    BOOL isSwitchStatus = [dict[@"isSwitchStatus"] boolValue];
    if (isSwitchStatus && self.containerView) {
        [self.containerView removeFromSuperview];
        [self setContainerView:nil];
    }
    SEL selctor = NSSelectorFromString(dict[@"selector"]);
    BOOL handled = selctor && [self respondsToSelector:selctor];
    if (handled) {
        JTKit_SuppressPerformSelectorLeakWarning([self performSelector:selctor withObject:inputToolBar]);
    }
    if (inputStatus != JTInputStatusText) {  // 防止界面跳动
        self.currentInputStatus = inputStatus;
        isShowKeyboard = NO;
    }
    else
    {
        isShowKeyboard = YES;
    }
    return isSwitchStatus;
}

- (BOOL)inputToolBar:(JTInputToolBar *)inputToolBar changeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    if ([replacementText isEqualToString:@"\n"]) {
        [self didPressSend];
        return NO;
    }
    if ([replacementText isEqualToString:@""] && range.length == 1) {
        return [self didPressDelete];
    }
    if ([replacementText isEqualToString:JTInputStartChar] && self.session.sessionType == NIMSessionTypeTeam) {
        //弹出用户选择界面
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError *error, NSArray *members)
         {
             if (!error)
             {
                 JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
                 config.contactSelectType = JTContactSelectTypeMulti;
                 config.needMutiSelected = YES;
                 config.members = members;
                 config.teamId = weakself.session.sessionId;
                 JTContracSelectViewController *contracSelectVC = [[JTContracSelectViewController alloc] initWithConfig:config];
                 contracSelectVC.finshBlock = ^(NSArray *yunxinIDs, NSArray *userIDs) {
                     [weakself.toolBar.inputTextView becomeFirstResponder];
                     [weakself insertInputUserItem:yunxinIDs isChar:YES];
                 };
                 JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:contracSelectVC];
                 [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
             }
         }];
    }
    NSString *str = [self.toolBar.contentText stringByAppendingString:replacementText];
    return (str.length <= self.maxTextLength);
}

- (void)inputToolBar:(JTInputToolBar *)inputToolBar changeText:(NSString *)text
{
    if (text.length <= 5) {
        self.showExpressionView.expressions = [[JTInputExpressionManager sharedManager] expressionInName:text];
    }
    else
    {
        self.showExpressionView.expressions = nil;
    }
}

- (void)inputToolBar:(JTInputToolBar *)inputToolBar changeHeight:(CGFloat)changeHeight
{
    self.currentInputStatus = self.currentInputStatus;
    if ([self.containerView isDescendantOfView:self]) {
        [self.containerView setTop:self.toolBar.bottom];
    }
}

- (BOOL)didPressDelete
{
    NSRange range = [self rangeForExpression];
    if (range.length == 1) {
        //删的不是表情，可能是@
        JTInputUserItem *item = [self deleteInputUserItem];
        if (item) {
            range = item.range;
        }
    }
    if (range.length > 1) {
        [self.toolBar deleteText:range];
        return NO;
    }
    return YES;
}

- (void)didPressSend
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSendText:atUsers:)] && self.toolBar.contentText.length > 0) {
        [self.delegate onSendText:self.toolBar.contentText atUsers:[self.userCache getYunXinIDArray:self.toolBar.contentText]];
        [self.userCache clean];
        [self.toolBar setContentText:@""];
        [self.toolBar layoutIfNeeded];
    }
}

- (void)didPressExpression:(JTExpression *)expression
{
    if (expression.type == JTExpressionTypeEmoji) {
        [self.toolBar insertText:expression.name];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTapExpression:)]) {
            if (expression.width && expression.width.length && expression.height && expression.height.length) {
                [self.delegate onTapExpression:expression];
            }
            else
            {
                __weak typeof(self) weakself = self;
                [ZTImageSize imageWithURL:expression.originalUrl complete:^(CGSize size) {
                    expression.width = [NSString stringWithFormat:@"%.2f", size.width];
                    expression.height = [NSString stringWithFormat:@"%.2f", size.height];
                    [weakself.delegate onTapExpression:expression];
                }];
            }
        }
    }
}

- (void)didPressShowExpression:(JTExpression *)expression
{
    [self.toolBar setContentText:@""];
    [self didPressExpression:expression];
}

#pragma mark - UIKeyboardNotification
- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    if (!self.window) {
        return;//如果当前vc不是堆栈的top vc，则不需要监听
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardFrameTop = endFrame.origin.y;
    self.currentInputStatus = self.currentInputStatus;
}

- (void)setCurrentInputStatus:(JTInputStatus)currentInputStatus
{
    _currentInputStatus = currentInputStatus;
    CGFloat height = self.toolBar.height;
    CGFloat width = self.superview ? self.superview.width : self.width;
    if (self.containerView) {
        height += input_containerHeight;
    }
    CGFloat top = (self.toolBar.isDisplayKeyboard ? self.keyBoardFrameTop : ((self.superview ? self.superview.height : APP_Frame_Height) - (kIsIphonex?34:0))) - height;
    if (top != self.top || height != self.height || width != self.width) {
        __weak typeof(self) weakself = self;
        void(^animations)(void) = ^{
            weakself.top = top;
            weakself.height = height;
            weakself.width = width;
        };
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        [UIView animateWithDuration:0.15 delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:^(BOOL finished) {
            if (finished && weakself.delegate && [weakself.delegate respondsToSelector:@selector(keyboardStatus:)])
            {
                [weakself.delegate keyboardStatus:((weakself.superview ? weakself.superview.height : APP_Frame_Height) - weakself.top > (weakself.toolBar.height + 1))];
            }
        }];
        if (_delegate && [_delegate respondsToSelector:@selector(callDidChangeHeight:)]) {
            [_delegate callDidChangeHeight:(self.superview ? self.superview.height : APP_Frame_Height) - self.top];
        }
    }
}

- (NSString *)contentText
{
    return self.toolBar.contentText;
}

- (void)setContentText:(NSString *)contentText
{
    [self.toolBar setContentText:contentText];
    [self showKeyboard];
}

- (JTInputUserCache *)userCache
{
    if (!_userCache) {
        _userCache = [[JTInputUserCache alloc] init];
    }
    return _userCache;
}

- (JTInputToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[JTInputToolBar alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) config:self.inputConfig delegate:self];
        _toolBar.placeHolder = input_placeholder;
        if ([_inputConfig respondsToSelector:@selector(inputBarItemTypes)]) {
            [_toolBar setInputBarItemTypes:[_inputConfig inputBarItemTypes]];
        }
        _toolBar.size = [_toolBar sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _toolBar;
}

- (JTInputMoreContainerView *)moreContainerView
{
    if (!_moreContainerView) {
        _moreContainerView = [[JTInputMoreContainerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) config:self.inputConfig delegate:self.delegate];
        _moreContainerView.size = [_moreContainerView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _moreContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _moreContainerView;
}

- (JTInputExpressionContainerView *)expressionContainerView
{
    if (!_expressionContainerView) {
        _expressionContainerView = [[JTInputExpressionContainerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) config:self.inputConfig delegate:self.delegate];
        _expressionContainerView.size = [_expressionContainerView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _expressionContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _expressionContainerView.target = self;
        _expressionContainerView.didSendMethod = @"didPressSend";
        _expressionContainerView.didExpressionMethod = @"didPressExpression:";
    }
    return _expressionContainerView;
}

- (JTInputAlbumContainerView *)albumContainerView
{
    if (!_albumContainerView) {
        _albumContainerView = [[JTInputAlbumContainerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) delegate:self.delegate];
        _albumContainerView.size = [_albumContainerView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _albumContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _albumContainerView;
}

- (JTInputVoiceContainerView *)voiceContainerView
{
    if (!_voiceContainerView) {
        _voiceContainerView = [[JTInputVoiceContainerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) config:self.inputConfig delegate:self.delegate];
        _voiceContainerView.size = [_voiceContainerView sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        _voiceContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _voiceContainerView;
}

- (JTShowExpressionView *)showExpressionView
{
    if (!_showExpressionView) {
        _showExpressionView = [[JTShowExpressionView alloc] init];
        _showExpressionView.target = self;
        _showExpressionView.didShowExpressionMethod = @"didPressShowExpression:";
    }
    return _showExpressionView;
}

/**
 表情范围

 @return 范围
 */
- (NSRange)rangeForExpression
{
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    if (range.length > 1)
    {
        NSString *name = [self.toolBar.contentText substringWithRange:range];
        JTExpression *expression = [[JTInputExpressionManager sharedManager] emojiInName:name];
        range = expression ? range : NSMakeRange([self.toolBar selectedRange].location - 1, 1);
    }
    return range;
}

/**
 插入@用户

 @param yunxinIDs 云信ID数组
 @param isChar 是否加入@字符
 */
- (void)insertInputUserItem:(NSArray *)yunxinIDs isChar:(BOOL)isChar
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:isChar?JTInputStartChar:@""];
    for (NSString *yunxinID in yunxinIDs)
    {
        NSString *nick = [JTUserInfoHandle showNick:yunxinID inSession:self.session];
        [str appendString:nick];
        [str appendString:JTInputEndChar];
        if (![yunxinIDs.lastObject isEqualToString:yunxinID]) {
            [str appendString:JTInputStartChar];
        }
        JTInputUserItem *item = [[JTInputUserItem alloc] init];
        item.name = nick;
        item.yunxinID  = yunxinID;
        [self.userCache addItem:item];
    }
    [self.toolBar insertText:str];
}

/**
 删掉的@用户

 @return @用户模型
 */
- (JTInputUserItem *)deleteInputUserItem
{
    NSRange range = [self rangeForPrefix:JTInputStartChar suffix:JTInputEndChar];
    JTInputUserItem *item = nil;
    if (range.length > 1)
    {
        NSString *set = [JTInputStartChar stringByAppendingString:JTInputEndChar];
        NSString *name = [[self.toolBar.contentText substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
        item = [self.userCache objectInName:name];
        range = item ? range : NSMakeRange([self.toolBar selectedRange].location - 1, 1);
    }
    item.range = range;
    return item;
}

/**
 表情范围

 @param prefix 表情的前缀
 @param suffix 表情的后缀
 @return 范围
 */
- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSString *text = self.toolBar.contentText;
    NSRange range = [self.toolBar selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        // 往前搜最多20个字符，一般来讲是够了...
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    return index == -1 ? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point) || CGRectContainsPoint(self.showExpressionView.frame, point)) {
        return YES;
    }
    return NO;
}
@end

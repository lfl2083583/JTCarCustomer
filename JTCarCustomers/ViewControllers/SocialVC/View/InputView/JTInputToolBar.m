//
//  JTInputToolBar.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputToolBar.h"
#import "JTInputBarItemType.h"
#import "UIImage+Chat.h"
#import "JTInputGlobal.h"

@interface JTInputToolBar() <JTGrowingTextViewDelegate>

@property (nonatomic, strong) NSDictionary *viewDict;

@end

@implementation JTInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputToolBarDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputBarItemTypes = @[@(JTInputBarItemTypeVoice),
                                   @(JTInputBarItemTypeAlbum),
                                   @(JTInputBarItemTypeCamera),
                                   @(JTInputBarItemTypeBonus),
                                   @(JTInputBarItemTypeExpression),
                                   @(JTInputBarItemTypeMore)
                                   ];
        self.viewDict = @{
                          @(JTInputBarItemTypeReward) : self.rewardBtn,
                          @(JTInputBarItemTypeVoice)  : self.voiceBtn,
                          @(JTInputBarItemTypeAlbum)  : self.albumBtn,
                          @(JTInputBarItemTypeCamera) : self.cameraBtn,
                          @(JTInputBarItemTypeBonus)  : self.bonusBtn,
                          @(JTInputBarItemTypeExpression)  : self.expressionBtn,
                          @(JTInputBarItemTypeMore)  : self.moreBtn
                          };
        self.inputConfig = config;
        self.delegate = delegate;
    }
    return self;
}

- (void)setInputBarItemTypes:(NSArray *)inputBarItemTypes
{
    _inputBarItemTypes = inputBarItemTypes;
    [self setNeedsLayout];
}

- (BOOL)isDisplayKeyboard
{
    return [self.inputTextView isFirstResponder];
}

- (void)setIsDisplayKeyboard:(BOOL)isDisplayKeyboard
{
    if (isDisplayKeyboard) {
        [self.inputTextView becomeFirstResponder];
    }
    else
    {
        [self.inputTextView resignFirstResponder];
    }
}

- (NSString *)contentText
{
    return self.inputTextView.text;
}

- (void)setContentText:(NSString *)contentText
{
    self.inputTextView.text = contentText;
}

- (void)reset
{
    for (id type in self.inputBarItemTypes) {
        UIButton *button = [self.viewDict objectForKey:type];
        button.selected = NO;
    }
    [self.inputTextView resignFirstResponder];
}

#pragma mark - NIMGrowingTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(JTGrowingTextView *)growingTextView
{
    BOOL should = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:selectInputStatus:)]) {
        should = [self.delegate inputToolBar:self selectInputStatus:JTInputStatusText];
        for (id type in self.inputBarItemTypes) {
            UIButton *button = [self.viewDict objectForKey:type];
            button.selected = NO;
        }
    }
    return should;
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(inputToolBar:changeTextInRange:replacementText:)]) {
        should = [self.delegate inputToolBar:self changeTextInRange:range replacementText:replacementText];
    }
    return should;
}

- (void)textViewDidChange:(JTGrowingTextView *)growingTextView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:changeText:)]) {
        [self.delegate inputToolBar:self changeText:growingTextView.text];
    }
}

- (void)didChangeHeight:(CGFloat)height
{
    self.height = height + input_functionSpacing + input_functionWidth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:changeHeight:)]) {
        [self.delegate inputToolBar:self changeHeight:self.height];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:selectInputStatus:)]) {
        self.isDisplayKeyboard = NO;
        BOOL isSwitch = [self.delegate inputToolBar:self selectInputStatus:sender.tag];
        if (isSwitch) {
            for (id type in self.inputBarItemTypes) {
                UIButton *button = [self.viewDict objectForKey:type];
                if ([button isEqual:sender]) {
                    button.selected = YES;
                }
                else
                {
                    button.selected = NO;
                }
            }
        }
    }
}

- (JTGrowingTextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[JTGrowingTextView alloc] initWithFrame:CGRectMake(input_textPadding, input_functionSpacing, 0, 0)];
        _inputTextView.width = self.width-2*input_textPadding;
        _inputTextView.font = Font(16);
        _inputTextView.maxNumberOfLines = 4;
        _inputTextView.minNumberOfLines = 1;
        _inputTextView.textColor = BlackLeverColor5;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.size = [_inputTextView intrinsicContentSize];
        _inputTextView.textViewDelegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (UIButton *)rewardBtn
{
    if (!_rewardBtn) {
        _rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rewardBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_reward_normal"] forState:UIControlStateNormal];
        [_rewardBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_reward_pressed"] forState:UIControlStateSelected];
        [_rewardBtn setTag:JTInputStatusReward];
        [_rewardBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rewardBtn;
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_voice_normal"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_voice_pressed"] forState:UIControlStateSelected];
        [_voiceBtn setTag:JTInputStatusVoice];
        [_voiceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIButton *)albumBtn
{
    if (!_albumBtn) {
        _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_album_normal"] forState:UIControlStateNormal];
        [_albumBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_album_pressed"] forState:UIControlStateSelected];
        [_albumBtn setTag:JTInputStatusAlbum];
        [_albumBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBtn;
}

- (UIButton *)cameraBtn
{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_camera_normal"] forState:UIControlStateNormal];
        [_cameraBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_camera_pressed"] forState:UIControlStateSelected];
        [_cameraBtn setTag:JTInputStatusCamera];
        [_cameraBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIButton *)bonusBtn
{
    if (!_bonusBtn) {
        _bonusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bonusBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_bonus_normal"] forState:UIControlStateNormal];
        [_bonusBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_bonus_pressed"] forState:UIControlStateSelected];
        [_bonusBtn setTag:JTInputStatusBonus];
        [_bonusBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bonusBtn;
}

- (UIButton *)expressionBtn
{
    if (!_expressionBtn) {
        _expressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expressionBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_expression_normal"] forState:UIControlStateNormal];
        [_expressionBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_expression_pressed"] forState:UIControlStateSelected];
        [_expressionBtn setTag:JTInputStatusExpression];
        [_expressionBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressionBtn;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_more_normal"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage jt_imageInKit:@"icon_toolview_more_pressed"] forState:UIControlStateSelected];
        [_moreBtn setTag:JTInputStatusMore];
        [_moreBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat viewHeight = 0.0f;
    // TextView 自适应高度
    [self.inputTextView layoutIfNeeded];
    viewHeight = self.inputTextView.frame.size.height;
    //得到 ToolBar 自身高度
    viewHeight = viewHeight + input_functionSpacing + input_functionWidth;
    return CGSizeMake(size.width, viewHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.inputTextView];
    CGFloat left = 0;
    for (NSNumber *type in self.inputBarItemTypes) {
        UIView *view = [self.viewDict objectForKey:type];
        [self addSubview:view];
        view.top = self.inputTextView.bottom;
        view.width = input_functionWidth;
        view.height = input_functionHeight;
        if ([type integerValue] == JTInputBarItemTypeMore) {
            view.right = self.width - input_functionSpacing;
        }
        else
        {
            view.left = left + ((kScreenWidth == 320) ? 5 : input_functionSpacing);
        }
        left = view.right;
    }
    self.layer.borderColor = BlackLeverColor2.CGColor;
    self.layer.borderWidth = .5f;
}

@end

@implementation JTInputToolBar (InputText)

- (NSRange)selectedRange
{
    return self.inputTextView.selectedRange;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.inputTextView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: BlackLeverColor3, NSFontAttributeName: Font(16)}];
}

- (void)insertText:(NSString *)text
{
    NSRange range = self.inputTextView.selectedRange;
    NSString *replaceText = [self.inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    range = NSMakeRange(range.location + text.length, 0);
    self.inputTextView.text = replaceText;
    self.inputTextView.selectedRange = range;
}

- (void)deleteText:(NSRange)range
{
    NSString *text = self.contentText;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        self.inputTextView.text = newText;
        self.inputTextView.selectedRange = newSelectRange;
    }
}

@end

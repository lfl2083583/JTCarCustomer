//
//  JTForwardPopupView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "GCPlaceholderTextView.h"
#import "JTForwardPopupView.h"
#import "ZTCirlceImageView.h"
#import "JTForwardContentView.h"
#import "UIView+Spring.h"
#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTImageAttachment.h"
#import "JTVideoAttachment.h"
#import "JTActivityAttachment.h"
#import "JTInformationAttachment.h"
#import "JTShopAttachment.h"

@interface JTForwardPopupView () <UITextViewDelegate>

@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) GCPlaceholderTextView *notesView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) CGFloat bottomY;


@property (nonatomic, copy) id source;

@end

@implementation JTForwardPopupView

- (void)dealloc {
    CCLOG(@"JTForwardPopupView销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithSource:(id)source selectType:(JTSelectType)selectType sessionType:(NIMSessionType)sessionType {
    self = [super initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    if (self) {
        _source = source;
        _selectType = selectType;
        _sessionType = sessionType;
        [self setupCustomView];
        [self setupContentView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)cancelBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [self dismissViewAnimated:YES completion:^{
        if (weakSelf.callBack) {
            weakSelf.callBack(weakSelf.notesView.text, JTPopupActionTypeCancel);
        }
    }];
}

- (void)comfirmBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [self dismissViewAnimated:YES completion:^{
        if (weakSelf.callBack) {
            weakSelf.callBack(weakSelf.notesView.text, JTPopupActionTypeDefault);
        }
    }];
}

#pragma mark Notice
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (CGRectGetMaxY(self.contentView.frame)+15.0 > frame.origin.y) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentView setCenterY:self.height/2.0- (CGRectGetMaxY(self.contentView.frame)+15.0-frame.origin.y)];
            self.bottomY = CGRectGetMaxY(self.contentView.frame);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setCenterY:self.height/2.0];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setupCustomView {
    switch (self.selectType) {
        case JTSelectTypeRepeatMessage:
        {
            if ([self.source objectForKey:@"message"] && [[self.source objectForKey:@"message"] isKindOfClass:[NIMMessage class]]) {
                NIMMessage *message = [self.source objectForKey:@"message"];
                if (message.messageType == NIMMessageTypeText) {
                    self.customView = [[JTForwardTextView alloc] initWithSource:message];
                }
                else if (message.messageType == NIMMessageTypeImage)
                {
                    self.customView = [[JTForwardImgeView alloc] initWithSource:message];
                }
                else if (message.messageType == NIMMessageTypeVideo)
                {
                    self.customView = [[JTForwardVideoView alloc] initWithSource:message];
                }
                else if (message.messageType == NIMMessageTypeLocation)
                {
                    self.customView = [[JTForwardLoctionView alloc] initWithSource:message];
                }
                else if (message.messageType == NIMMessageTypeCustom)
                {
                    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                    if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
                        self.customView = [[JTForwardExpressionView alloc] initWithSource:message];
                    }
                    else if ([object.attachment isKindOfClass:[JTCardAttachment class]])
                    {
                        self.customView = [[JTForwardUserCardView alloc] initWithSource:[self.source objectForKey:@"message"]];
                    }
                    else if ([object.attachment isKindOfClass:[JTImageAttachment class]])
                    {
                        self.customView = [[JTForwardImgeView alloc] initWithSource:message];
                    }
                    else if ([object.attachment isKindOfClass:[JTVideoAttachment class]])
                    {
                        self.customView = [[JTForwardVideoView alloc] initWithSource:message];
                    }
                    else if ([object.attachment isKindOfClass:[JTActivityAttachment class]])
                    {
                        self.customView = [[JTForwardActivityView alloc] initWithSource:message];
                    }
                    else if ([object.attachment isKindOfClass:[JTInformationAttachment class]])
                    {
                        self.customView = [[JTForwardInfomationView alloc] initWithSource:message];
                    }
                    else if ([object.attachment isKindOfClass:[JTShopAttachment class]])
                    {
                        self.customView = [[JTForwardStoreView alloc] initWithSource:message];
                    }
                }
            }
        }
            break;
        case JTSelectTypeSendCard:
        {
            if ([self.source objectForKey:@"session"] && [[self.source objectForKey:@"session"] isKindOfClass:[NIMSession class]]) {
                self.customView = [[JTForwardUserCardView alloc] initWithSource:[self.source objectForKey:@"contract"]];
            }
            
        }
            break;
        case JTSelectTypeShareActivity:
        {
            self.customView = [[JTForwardActivityView alloc] initWithSource:[self.source objectForKey:@"activity"]];
            
        }
            break;
        case JTSelectTypeShareStore:
        {
            self.customView = [[JTForwardStoreView alloc] initWithSource:[self.source objectForKey:@"store"]];
        }
            break;
        case JTSelectTypeShareInfomation:
        {
            self.customView = [[JTForwardInfomationView alloc] initWithSource:[self.source objectForKey:@"infomation"]];
        }
            break;
        case JTSelectTypeShareTeam:
        {
            self.customView = [[JTForwardTeamCardView alloc] initWithSource:[self.source objectForKey:@"teamcard"]];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height < 40) {
        [textView setHeight:40];
    } else{
        [textView setHeight:MIN(size.height, 60)];
    }
    CGFloat contentHeight = Y_Margin+24+Y_Margin+CGRectGetHeight(_avatarView.frame)+Y_Margin+CGRectGetHeight(_customView.frame)+Y_Margin+CGRectGetHeight(_notesView.frame)+Y_Margin+CGRectGetHeight(_bottomView.frame);
    [self.contentView setHeight:contentHeight];
    [self.bottomView setY:Y_Margin+CGRectGetMaxY(textView.frame)];
    [self.contentView setY:self.bottomY-contentHeight];
}

- (void)setupContentView {
    NSMutableDictionary *contract = [NSMutableDictionary dictionary];
    if (self.selectType == JTSelectTypeSendCard) {
        if ([self.source objectForKey:@"session"] && [[self.source objectForKey:@"session"] isKindOfClass:[NIMSession class]])
        {
            NIMSession *session = [self.source objectForKey:@"session"];
            NSString *toName;
            NSString *avatarUrl;
            if (session.sessionType == NIMSessionTypeP2P) {
                NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
                toName = [JTUserInfoHandle showNick:session.sessionId];
                avatarUrl = user.userInfo.avatarUrl;
            }
            else if (session.sessionType == NIMSessionTypeTeam)
            {
                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
                toName = team.teamName;
                avatarUrl = team.avatarUrl;
            }
            [contract setValue:toName?toName:@"" forKey:@"name"];
            [contract setValue:avatarUrl?avatarUrl:@"" forKey:@"avatar"];
        }
    }
    else
    {
        if (self.sessionType == NIMSessionTypeP2P) {
            [contract addEntriesFromDictionary:[self.source objectForKey:@"contract"]];
        }
        else
        {
            NIMTeam *team = [self.source objectForKey:@"team"];
            [contract setValue:team.teamName forKey:@"name"];
            [contract setValue:team.avatarUrl forKey:@"avatar"];
        }
    }
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = WhiteColor;
    _contentView.layer.cornerRadius = 10;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLB.textColor = BlackLeverColor6;
    titleLB.text = @"发送给：";
    titleLB.frame = CGRectMake(X_Margin, Y_Margin, Popup_Width-2*X_Margin, 24.0);
    [_contentView addSubview:titleLB];
    
    _avatarView = [[ZTCirlceImageView alloc] init];
    _avatarView.frame = CGRectMake(X_Margin, CGRectGetMaxY(titleLB.frame)+Y_Margin, 30.0, 30.0);
    [_avatarView setAvatarByUrlString:[contract[@"avatar"] avatarHandleWithSquare:30] defaultImage:DefaultSmallAvatar];
    [_contentView addSubview:_avatarView];
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.frame = CGRectMake(CGRectGetMaxX(_avatarView.frame)+10.0, CGRectGetMidY(_avatarView.frame)-10.0, Popup_Width-2*X_Margin-40.0, 20.0);
    _nameLB.font = Font(16);
    _nameLB.textColor = BlackLeverColor6;
    _nameLB.text = contract[@"name"];
    [_contentView addSubview:_nameLB];
    
    UIView *horizontalLine1 = [[UIView alloc] init];
    horizontalLine1.frame = CGRectMake(0, CGRectGetMaxY(_avatarView.frame)+Y_Margin, Popup_Width, 1.0);
    horizontalLine1.backgroundColor = BlackLeverColor2;
    [_contentView addSubview:horizontalLine1];
    
    UIView *tempView;
    if (_customView) {
        [_customView setY:CGRectGetMaxY(horizontalLine1.frame)];
        [_customView setHeight:MIN(190.0, CGRectGetHeight(_customView.frame))];
        [_contentView addSubview:_customView];
        tempView = _customView;
    } else {
        tempView = horizontalLine1;
    }
    
    _notesView = [[GCPlaceholderTextView alloc] init];
    _notesView.frame = CGRectMake(X_Margin, CGRectGetMaxY(tempView.frame)+Y_Margin, Popup_Width-2*X_Margin, 40.0);
    _notesView.font = Font(16);
    _notesView.placeholder = @"给朋友留言";
    _notesView.layer.cornerRadius = 4.0;
    _notesView.layer.masksToBounds = YES;
    _notesView.layer.borderWidth = 1.0;
    _notesView.layer.borderColor = BlackLeverColor2.CGColor;
    _notesView.delegate = self;
    [_contentView addSubview:_notesView];
 
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_notesView.frame)+Y_Margin, Popup_Width, 45)];
    [_contentView addSubview:_bottomView];
    
    UIView *horizontalLine2 = [[UIView alloc] init];
    horizontalLine2.frame = CGRectMake(0, 0, Popup_Width, 1.0);
    horizontalLine2.backgroundColor = BlackLeverColor2;
    [_bottomView addSubview:horizontalLine2];
    
    UIButton *cancelBtn = [self createBtnWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLine2.frame), Popup_Width/2.0, 44.0) title:@"取消" titleColor:BlackLeverColor6 font:Font(16) actionMethod:@selector(cancelBtnClick:)];
    [_bottomView addSubview:cancelBtn];
    
    UIButton *comfirmBtn = [self createBtnWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(horizontalLine2.frame), Popup_Width/2.0, 44.0) title:@"确定" titleColor:BlueLeverColor1 font:Font(16) actionMethod:@selector(comfirmBtnClick:)];
    [_bottomView addSubview:comfirmBtn];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(Popup_Width/2.0-0.5, CGRectGetMaxY(horizontalLine2.frame)+4.0, 1.0, 36.0);
    verticalLine.backgroundColor = BlackLeverColor2;
    [_bottomView addSubview:verticalLine];
    
    CGFloat contentHeight = Y_Margin+CGRectGetHeight(titleLB.frame)+Y_Margin+CGRectGetHeight(_avatarView.frame)+Y_Margin+CGRectGetHeight(tempView.frame)+Y_Margin+CGRectGetHeight(_notesView.frame)+Y_Margin+CGRectGetHeight(_bottomView.frame);
    [_contentView setFrame:CGRectMake((self.width-Popup_Width)/2.0, (self.height-contentHeight)/2.0, Popup_Width, contentHeight)];
    self.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
}

- (UIButton *)createBtnWithFrame:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)titleColor  font:(UIFont *)font actionMethod:(SEL)sel {
    UIButton *button = [[UIButton alloc] init];
    button.frame = rect;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

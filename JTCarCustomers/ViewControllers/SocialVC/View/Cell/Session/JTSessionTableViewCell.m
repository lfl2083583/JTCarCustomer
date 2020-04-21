//
//  JTSessionTableViewCell.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"
#import "JTSessionUtil.h"
#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTBonusAttachment.h"

@implementation JTSessionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
        
        UITapGestureRecognizer *singlePressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGesturePress:)];
        [self addGestureRecognizer:singlePressGesture];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (ZTCirlceImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(0, 15, 40, 40)];
    }
    return _headImageView;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.font = Font(13);
        _nameLB.opaque = YES;
        _nameLB.frame = CGRectMake(0, 15, 200, 20);
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.hidden = YES;
    }
    return _nameLB;
}

- (UIImageView *)bubbleImageView
{
    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] init];
    }
    return _bubbleImageView;
}

- (UIActivityIndicatorView *)traningActivityIndicator
{
    if (!_traningActivityIndicator) {
        _traningActivityIndicator = [[UIActivityIndicatorView alloc] init];
        _traningActivityIndicator.size = CGSizeMake(20, 20);
        _traningActivityIndicator.color = BlackLeverColor5;
    }
    return _traningActivityIndicator;
}

- (UIButton *)retryButton
{
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.size = CGSizeMake(25, 25);
        [_retryButton setImage:[UIImage jt_imageInKit:@"icon_message_cell_error"] forState:UIControlStateNormal];
        [_retryButton setImage:[UIImage jt_imageInKit:@"icon_message_cell_error"] forState:UIControlStateHighlighted];
        [_retryButton addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (UIButton *)choiceButton
{
    if (!_choiceButton) {
        _choiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _choiceButton.frame = CGRectMake(0, 0, 44, 44);
        [_choiceButton setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
        [_choiceButton setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateSelected];
        [_choiceButton addTarget:self action:@selector(onChoiceMessage:) forControlEvents:UIControlEventTouchUpInside];
        _choiceButton.hidden = YES;
    }
    return _choiceButton;
}

- (void)initSubview
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.bubbleImageView];
    [self.contentView addSubview:self.traningActivityIndicator];
    [self.contentView addSubview:self.retryButton];
    [self.contentView addSubview:self.choiceButton];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(JTSessionMessageModel *)model
{
    _model = model;
    self.message = model.message;
    self.isOutgoingMessage = self.message.isOutgoingMsg;
}

- (void)layoutSubviews
{
    BOOL showTeamNickName = [[JTSessionLayoutConfig shareJTSessionLayoutConfig] isShowTeamNickName:self.message.session.sessionId];
    BOOL hideBubbleImage = [[JTSessionLayoutConfig shareJTSessionLayoutConfig] isHideBubbleImage:_model.message];
    
    NIMUserInfo *userInfo = [[[NIMSDK sharedSDK].userManager userInfo:self.message.from] userInfo];
    [self.headImageView setAvatarByUrlString:[userInfo.avatarUrl avatarHandleWithSquare:self.headImageView.width*2] defaultImage:DefaultSmallAvatar];

    if (showTeamNickName) {
        self.nameLB.text = [JTUserInfoHandle showNick:self.message.from inSession:self.message.session];
        self.nameLB.textColor = [[NIMSDK sharedSDK].userManager isMyFriend:self.message.from] ? YellowColor : BlackLeverColor3;
    }
    if (self.message.deliveryState == NIMMessageDeliveryStateFailed) {
        [self.retryButton setHidden:NO];
        [self.traningActivityIndicator setHidden:YES];
        [self.traningActivityIndicator stopAnimating];
    }
    else if (self.message.deliveryState == NIMMessageDeliveryStateDelivering) {
        [self.retryButton setHidden:YES];
        [self.traningActivityIndicator setHidden:NO];
        [self.traningActivityIndicator startAnimating];
    }
    else
    {
        [self.retryButton setHidden:YES];
        [self.traningActivityIndicator setHidden:YES];
        [self.traningActivityIndicator stopAnimating];
    }
    
    self.choiceButton.hidden = !self.isEditMessage;
    
    if (self.isOutgoingMessage) {
        self.nameLB.hidden = YES;
        self.headImageView.right = App_Frame_Width - 8;
        self.bubbleImageView.size = CGSizeMake(self.model.contentSize.width, self.model.contentSize.height);
        self.bubbleImageView.right = self.headImageView.left - 8;
        self.bubbleImageView.top = self.headImageView.top;
        self.traningActivityIndicator.right = self.bubbleImageView.left - 8;
        self.traningActivityIndicator.centerY = self.bubbleImageView.centerY;
        self.retryButton.right = self.bubbleImageView.left - 8;
        self.retryButton.centerY = self.bubbleImageView.centerY;
        
        if (hideBubbleImage) {
            _bubbleImageView.hidden = YES;
        }
        else
        {
            _bubbleImageView.hidden = NO;
            if (_model.bubbleImage && _model.bubbleImage.length > 0) {
                _bubbleImageView.image = [[UIImage jt_imageInKit:_model.bubbleImage] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 17, 25) resizingMode:UIImageResizingModeStretch];
            }
            else
            {
                _bubbleImageView.image = [[UIImage jt_imageInKit:@"icon_sender_node_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 17, 25) resizingMode:UIImageResizingModeStretch];
            }
        }
    }
    else
    {
        self.headImageView.left = (self.isEditMessage ? self.choiceButton.width : 0) + 8;
        if (showTeamNickName) {
            self.nameLB.hidden = NO;
            self.nameLB.left = self.headImageView.right + 8;
        }
        else
        {
            self.nameLB.hidden = YES;
        }
        self.bubbleImageView.size = CGSizeMake(self.model.contentSize.width, self.model.contentSize.height);
        self.bubbleImageView.left = self.headImageView.right + 8;
        self.bubbleImageView.top = showTeamNickName ? (self.nameLB.bottom + 5) : self.headImageView.top;
        self.traningActivityIndicator.left = self.bubbleImageView.right + 8;
        self.traningActivityIndicator.centerY = self.bubbleImageView.centerY;
        self.retryButton.left = self.bubbleImageView.right + 8;
        self.retryButton.centerY = self.bubbleImageView.centerY;
        
        if (hideBubbleImage) {
            _bubbleImageView.hidden = YES;
        }
        else
        {
            _bubbleImageView.hidden = NO;
            if (_model.bubbleImage && _model.bubbleImage.length > 0) {
                _bubbleImageView.image = [[UIImage jt_imageInKit:_model.bubbleImage] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 17, 25) resizingMode:UIImageResizingModeStretch];
            }
            else
            {
                _bubbleImageView.image = [[UIImage jt_imageInKit:@"icon_receiver_node_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 17, 25) resizingMode:UIImageResizingModeStretch];
            }
        }
    }
    [super layoutSubviews];
}

// 点击事件
- (void)singleGesturePress:(UIGestureRecognizer *)gestureRecognizer
{
    // 编辑消息的时候取消掉其他点击事件
    if (self.isEditMessage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:didChoiceAtMessageModel:)]) {
            [self.delegate sessionTableViewCell:self didChoiceAtMessageModel:self.model];
        }
    }
    else
    {
        CGPoint currentPoint = [gestureRecognizer locationInView:self];
        // 点击气泡进入消息下一级页面
        if (CGRectContainsPoint(self.bubbleImageView.frame, currentPoint)) {
            if ([self respondsToSelector:@selector(onTouchUpInside:)]) {
                [self onTouchUpInside:gestureRecognizer];
            }
        }
        // 点击头像进入用户详情页面
        else if (CGRectContainsPoint(self.headImageView.frame, currentPoint)) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:clickInAvatarAtYunxinID:)]) {
                [self.delegate sessionTableViewCell:self clickInAvatarAtYunxinID:self.message.from];
            }
        }
    }
}

// 长按事件
- (void)longGesturePress:(UIGestureRecognizer *)gestureRecognizer
{
    // 成功的消息才支持长按操作
    if (self.message.deliveryState == NIMMessageDeliveryStateDeliveried) {
        // 长按开始时
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            // 编辑消息的时候取消掉其他长按事件
            if (self.isEditMessage) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:didChoiceAtMessageModel:)]) {
                    [self.delegate sessionTableViewCell:self didChoiceAtMessageModel:self.model];
                }
            }
            else
            {
                CGPoint currentPoint = [gestureRecognizer locationInView:self];
                // 长按头像@用户
                if (CGRectContainsPoint(self.headImageView.frame, currentPoint)) {
                    if (self.message.session.sessionType == NIMSessionTypeTeam && ![self.message.from isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]) {
                        if (self.dataSource && [self.dataSource respondsToSelector:@selector(teamPowerModelInSessionTableViewCell:)]) {
                            NSArray *items = [self headMenusItems:[self.dataSource teamPowerModelInSessionTableViewCell:self]];
                            if ([items count] && [self becomeFirstResponder]) {
                                UIMenuController *controller = [UIMenuController sharedMenuController];
                                [controller setMenuItems:items];
                                [controller setTargetRect:self.headImageView.bounds inView:self.headImageView];
                                [controller setMenuVisible:YES animated:YES];
                            }
                            else
                            {
                                if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:longInAvatarAtYunxinID:)]) {
                                    [self.delegate sessionTableViewCell:self longInAvatarAtYunxinID:self.message.from];
                                }
                            }
                        }
                        else
                        {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:longInAvatarAtYunxinID:)]) {
                                [self.delegate sessionTableViewCell:self longInAvatarAtYunxinID:self.message.from];
                            }
                        }
                    }
                }
                // 长按气泡弹出MENU
                else if (CGRectContainsPoint(self.bubbleImageView.frame, currentPoint)) {
                    NSArray *items = [self bubbleMenusItems];
                    if ([items count] && [self becomeFirstResponder]) {
                        UIMenuController *controller = [UIMenuController sharedMenuController];
                        [controller setMenuItems:items];
                        [controller setTargetRect:self.bubbleImageView.bounds inView:self.bubbleImageView];
                        [controller setMenuVisible:YES animated:YES];
                    }
                }
            }
        }
    }
}

- (void)onTouchUpInside:(id)sender
{
    if ([self.model.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateFailed) {
        if ([self respondsToSelector:@selector(onRetryMessage:)]) {
            [self onRetryMessage:sender];
        }
    }
    else
    {
        if ([self.model.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloaded) {
            [self onValidTouchUpInside:sender];
        }
    }
}

// 有效的touch事件
- (void)onValidTouchUpInside:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:didSelectAtMessageModel:)]) {
        [self.delegate sessionTableViewCell:self didSelectAtMessageModel:self.model];
    }
}

// 重新加载消息
- (void)onRetryMessage:(id)sender
{
    if (self.message.isReceivedMsg) {
        [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:self.message error:nil];
    }
    else
    {
        [[[NIMSDK sharedSDK] chatManager] resendMessage:self.message error:nil];
    }
}

- (void)onChoiceMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:didChoiceAtMessageModel:)]) {
        [self.delegate sessionTableViewCell:self didChoiceAtMessageModel:self.model];
    }
}

- (NSArray *)headMenusItems:(JTTeamPowerModel *)powerModel
{
    NSMutableArray *items = [NSMutableArray array];
    UIMenuItem *removeItem = [[UIMenuItem alloc] initWithTitle:@"移除" action:@selector(reomveUser:)];
    UIMenuItem *banItem = [[UIMenuItem alloc] initWithTitle:@"禁言" action:@selector(banUser:)];
    UIMenuItem *cancelBanItem = [[UIMenuItem alloc] initWithTitle:@"取消禁言" action:@selector(cancelBanUser:)];
    UIMenuItem *selectedItem = [[UIMenuItem alloc] initWithTitle:@"选中" action:@selector(selectedUser:)];
    NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:self.message.from]];
    BOOL isBanned = ([powerModel.bannedUserdict objectForKey:userID] && [[powerModel.bannedUserdict objectForKey:userID] integerValue] > [[NSDate date] timeIntervalSince1970]);
    
    if (powerModel.isGroupMain || (powerModel.isRemovePower && ![powerModel.removePowerUserArray containsObject:userID] && ![userID isEqualToString:powerModel.ownerID])) {
        [items addObject:removeItem];
    }
    if (powerModel.isGroupMain || (powerModel.isBanPower && ![powerModel.banPowerUserArray containsObject:userID] && ![userID isEqualToString:powerModel.ownerID])) {
        if (isBanned)
            [items addObject:cancelBanItem];
        else
            [items addObject:banItem];
    }
    if (items.count > 0) {
        [items addObject:selectedItem];
    }
    return items;
}

- (NSArray *)bubbleMenusItems
{
    NSMutableArray *items = [NSMutableArray array];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    UIMenuItem *repeatItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(repeatMessage:)];
    UIMenuItem *collectionItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(collectionMessage:)];
    UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤销" action:@selector(revokeMessage:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    UIMenuItem *addItem = [[UIMenuItem alloc] initWithTitle:@"添加到表情" action:@selector(addMessage:)];
    UIMenuItem *multiselectItem = [[UIMenuItem alloc] initWithTitle:@"多选" action:@selector(multiselectMessage:)];
    
    BOOL isSupportBeRevoked = YES;
    switch (self.message.messageType) {
        case NIMMessageTypeText:
        {
            [items addObjectsFromArray:@[copyItem, repeatItem, collectionItem, deleteItem, multiselectItem]];
        }
            break;
        case NIMMessageTypeImage:
        {
            [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
        }
            break;
        case NIMMessageTypeAudio:
        {
            [items addObjectsFromArray:@[collectionItem, deleteItem, multiselectItem]];
        }
            break;
        case NIMMessageTypeVideo:
        {
            [items addObjectsFromArray:@[repeatItem, collectionItem, deleteItem, multiselectItem]];
        }
            break;
        case NIMMessageTypeLocation:
        {
            [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
        }
            break;
        case NIMMessageTypeNotification:
        {
            NIMNotificationObject *object = (NIMNotificationObject *)[self.model message].messageObject;
            if (object.notificationType == NIMNotificationTypeNetCall) {
                isSupportBeRevoked = NO;
                [items addObjectsFromArray:@[deleteItem, multiselectItem]];
            }
        }
            break;
        case NIMMessageTypeFile:
            break;
        case NIMMessageTypeTip:
            break;
        case NIMMessageTypeCustom:
        {
            NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
            if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
                [items addObjectsFromArray:@[repeatItem, collectionItem, deleteItem, addItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTCardAttachment class]]) {
                [items addObjectsFromArray:@[deleteItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTBonusAttachment class]]) {
                isSupportBeRevoked = NO;
                [items addObjectsFromArray:@[deleteItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTFunsAttachment class]]) {
                [items addObjectsFromArray:@[copyItem, repeatItem, collectionItem, deleteItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTVideoAttachment class]]) {
                [items addObjectsFromArray:@[repeatItem, collectionItem, deleteItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTGroupAttachment class]]) {
                [items addObjectsFromArray:@[deleteItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTInformationAttachment class]]) {
                [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTActivityAttachment class]]) {
                [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
            }
            else if ([object.attachment isKindOfClass:[JTShopAttachment class]]) {
                [items addObjectsFromArray:@[collectionItem, deleteItem, repeatItem, multiselectItem]];
            }
        }
            break;
        default:
            break;
    }
    if (items.count > 0 && isSupportBeRevoked) {
        
        if ([JTSessionUtil canMessageBeRevoked:self.message]) {
            CGFloat timeSpace = [[NSDate date] timeIntervalSince1970] - self.message.timestamp;
            if (timeSpace <= 120) {
                [items addObject:revokeItem];
            }
        }
    }
    return items;
}

- (void)reomveUser:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeRemove];
    }
}

- (void)banUser:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeBan];
    }
}

- (void)cancelBanUser:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeCancelBan];
    }
}

- (void)selectedUser:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeSelected];
    }
}

- (void)copyMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeCopy];
    }
}

- (void)repeatMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeRepeat];
    }
}

- (void)collectionMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeCollection];
    }
}

- (void)revokeMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeRevoke];
    }
}

- (void)deleteMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeDelete];
    }
}

- (void)addMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeAdd];
    }
}

- (void)multiselectMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTableViewCell:menuType:)]) {
        [self.delegate sessionTableViewCell:self menuType:JTMenuTypeMultiselect];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSArray *items = [[UIMenuController sharedMenuController] menuItems];
    for (UIMenuItem *item in items) {
        if (action == [item action]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end

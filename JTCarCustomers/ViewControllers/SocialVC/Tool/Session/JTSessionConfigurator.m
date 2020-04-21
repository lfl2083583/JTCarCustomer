//
//  JTSessionConfigurator.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionConfigurator.h"
#import "JTSessionViewController.h"
#import "CLAlertController.h"
#import "JTSessionTextTableViewCell.h"
#import "JTSessionImageTableViewCell.h"
#import "JTSessionAudioTableViewCell.h"
#import "JTSessionVideoTableViewCell.h"
#import "JTSessionLocationTableViewCell.h"
#import "JTSessionTipTableViewCell.h"
#import "JTSessionExpressionTableViewCell.h"
#import "JTSessionCardTableViewCell.h"
#import "JTSessionBonusTableViewCell.h"
#import "JTSessionGroupTableViewCell.h"
#import "JTSessionInformationTableViewCell.h"
#import "JTSessionActivityTableViewCell.h"
#import "JTSessionShopTableViewCell.h"
#import "JTSessionTimestampTableViewCell.h"
#import "JTCardViewController.h"
#import "JTContracSelectViewController.h"
#import "JTBaseNavigationController.h"
#import "MJRefresh.h"

#define messageLimit  20
static const CGFloat kDefaultBottomInterval = .2;

@interface JTSessionConfigurator () <JTSessionTableViewCellDelegate, JTSessionTableViewCellDataSource, JTSessionTipTableViewCellDelegate, NIMMediaManagerDelegate>
{
    BOOL isEditMessage;
}
@property (strong, nonatomic) NIMMessageSearchOption *option;
@property (weak, nonatomic) JTSessionViewController *sessionVC;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NIMSession *currentSession;
@property (strong, nonatomic) NSMutableArray *pendingAudioMessages;
@property (strong, nonatomic) NSMutableArray *choiceMessageModels;
@property (nonatomic, strong) NSDate *lastBottomDate;
@end

@implementation JTSessionConfigurator

- (void)dealloc
{
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (void)resetMessages
{
    __block JTSessionMessageModel *currentOldestMessage = nil;
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[JTSessionMessageModel class]]) {
            currentOldestMessage = (JTSessionMessageModel *)obj;
            *stop = YES;
        }
    }];
    NSArray *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:self.currentSession
                                                                            message:currentOldestMessage.message
                                                                              limit:messageLimit];
    [self insertMessages:messages];
}

- (void)moreMessages
{
    self.option.startTime = [self lastTimeInterval];
    self.option.endTime = 0;
    __weak typeof(self) weakself = self;
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.currentSession option:self.option result:^(NSError *error, NSArray *messages) {
        if (messages && messages.count > 0) {
            [weakself addMessages:messages autoBottom:NO];
        }
        else
        {
            [weakself.tableView.mj_footer setHidden:YES];
        }
    }];
}

- (void)insertMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages.reverseObjectEnumerator.allObjects) {
        [self insertMessage:message];
    }
    [self layoutAfterRefresh];
}

- (void)insertMessage:(NIMMessage *)message
{
    if (![self.sessionVC.sessionConfig isFilterMessage:message]) {
        JTSessionMessageModel *model = [[JTSessionMessageModel alloc] initWithMessage:message];
        if (model) {
            NSTimeInterval firstTimeInterval = [self firstTimeInterval];
            [self.items insertObject:model atIndex:0];
            if (firstTimeInterval == 0 || firstTimeInterval - message.timestamp > 300) {
                [self.items insertObject:[[JTTimestampModel alloc] initWithMessageTime:message.timestamp] atIndex:0];
            }
        }
    }
}

- (void)addMessages:(NSArray *)messages autoBottom:(BOOL)autoBottom
{
    if (messages && messages.count != 0 && ![self.sessionVC.sessionConfig isFilterMessage:messages.lastObject]) {
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSTimeInterval messageFirstTimeInterval = [(NIMMessage *)[messages firstObject] timestamp];
        NSTimeInterval itemLastTimeInterval = [self lastTimeInterval];
        if (itemLastTimeInterval && messageFirstTimeInterval - itemLastTimeInterval > 300) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.items.count inSection:0]];
            [self.items addObject:[[JTTimestampModel alloc] initWithMessageTime:messageFirstTimeInterval]];
        }
        for (NIMMessage *message in messages) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.items.count inSection:0]];
            [self.items addObject:[[JTSessionMessageModel alloc] initWithMessage:message]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        if (autoBottom) {
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self scrollTableViewBottom:YES];
        }
    }
}

- (void)updateMessage:(NIMMessage *)message
{
    JTSessionMessageModel *model = [self findMessage:message];
    if (model) {
        NSInteger index = [self.items indexOfObject:model];
        [self.items replaceObjectAtIndex:index withObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (JTSessionMessageModel *)findMessage:(NIMMessage *)message
{
    if ([message isKindOfClass:[NIMMessage class]]) {
        JTSessionMessageModel *model;
        for (JTSessionMessageModel *item in self.items.reverseObjectEnumerator.allObjects) {
            if ([item isKindOfClass:[JTSessionMessageModel class]] && [item.message.messageId isEqual:message.messageId]) {
                model = item;
                //防止那种进了会话又退出去再进来这种行为，防止SDK里回调上来的message和会话持有的message不是一个，导致刷界面刷跪了的情况
                model.message = message;
                break;
            }
        }
        return model;
    }
    return nil;
}

- (JTSessionMessageModel *)deleteMessage:(NIMMessage *)message
{
    JTSessionMessageModel *model = [self findMessage:message];
    if (model) {
        NSInteger index = [self.items indexOfObject:model];
        [self.items removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        if (index >= 1) {
            id lastItem = [self.items objectAtIndex:index-1];
            BOOL isDeleteTime = ([lastItem isKindOfClass:[JTTimestampModel class]] && (self.items.count < index+1 || [[self.items objectAtIndex:index] isKindOfClass:[JTTimestampModel class]]));
            if (isDeleteTime) {
                [self.items removeObjectAtIndex:index-1];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    return model;
}

- (void)scrollTableViewBottom:(BOOL)animation
{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL isBottom = NO;
        if (weakself.tableView.contentSize.height > weakself.tableView.frame.size.height) {
            if (weakself.tableView.frame.size.height < APP_Frame_Height - kStatusBarHeight - kTopBarHeight - 100) {
                isBottom = YES;
            }
            else
            {
                if (weakself.tableView.contentOffset.y > weakself.tableView.contentSize.height - 1.5*weakself.tableView.frame.size.height) {
                    isBottom = YES;
                }
            }
        }
        if (isBottom) {
            [weakself.tableView setContentOffset:CGPointMake(0, weakself.tableView.contentSize.height - weakself.tableView.frame.size.height) animated:animation];
        }
    });
}

- (void)startEdit
{
    isEditMessage = YES;
    [self.tableView reloadData];
}

- (void)stopEdit
{
    isEditMessage = NO;
    [self.choiceMessageModels removeAllObjects];
    [self.tableView reloadData];
}

- (void)deleteChoose
{
    if (self.choiceMessageModels.count > 0) {
        __weak typeof(self) weakself = self;
        CLAlertController *alert = [CLAlertController alertControllerWithTitle:@"删除后将不会出现在你的消息记录中" message:nil preferredStyle:CLAlertControllerStyleSheet];
        [alert addAction:[CLAlertModel actionWithTitle:@"删除" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            for (JTSessionMessageModel *model in weakself.choiceMessageModels) {
                [weakself deleteMessage:model.message];
                [[NIMSDK sharedSDK].conversationManager deleteMessage:model.message];
            }
            [weakself.choiceMessageModels removeAllObjects];
            [weakself.sessionVC setIsEditStatus:NO];
        }]];
        [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
        }]];
        [self.sessionVC presentToViewController:alert completion:nil];
    }
}

- (void)setup:(JTSessionViewController *)vc locationMessage:(NIMMessage *)locationMessage
{
    [self setSessionVC:vc];
    [self setTableView:vc.tableView];
    [self setCurrentSession:vc.session];
    [vc.tableView setDelegate:self];
    [vc.tableView setDataSource:self];
    [vc.tableView registerClass:[JTSessionTextTableViewCell class] forCellReuseIdentifier:sessionTextIdentifier];
    [vc.tableView registerClass:[JTSessionImageTableViewCell class] forCellReuseIdentifier:sessionImageIdentifier];
    [vc.tableView registerClass:[JTSessionAudioTableViewCell class] forCellReuseIdentifier:sessionAudioIdentifier];
    [vc.tableView registerClass:[JTSessionVideoTableViewCell class] forCellReuseIdentifier:sessionVideoIdentifier];
    [vc.tableView registerClass:[JTSessionLocationTableViewCell class] forCellReuseIdentifier:sessionLocationIdentifier];
    [vc.tableView registerClass:[JTSessionTipTableViewCell class] forCellReuseIdentifier:sessionTipIdentifier];
    [vc.tableView registerClass:[JTSessionExpressionTableViewCell class] forCellReuseIdentifier:sessionExpressionIdentifier];
    [vc.tableView registerClass:[JTSessionCardTableViewCell class] forCellReuseIdentifier:sessionCardIdentifier];
    [vc.tableView registerClass:[JTSessionBonusTableViewCell class] forCellReuseIdentifier:sessionBonusIdentifier];
    [vc.tableView registerClass:[JTSessionGroupTableViewCell class] forCellReuseIdentifier:sessionGroupIdentifier];
    [vc.tableView registerClass:[JTSessionInformationTableViewCell class] forCellReuseIdentifier:sessionInformationIdentifier];
    [vc.tableView registerClass:[JTSessionActivityTableViewCell class] forCellReuseIdentifier:sessionActivityIdentifier];
    [vc.tableView registerClass:[JTSessionShopTableViewCell class] forCellReuseIdentifier:sessionShopIdentifier];
    [vc.tableView registerClass:[JTSessionTimestampTableViewCell class] forCellReuseIdentifier:sessionTimestampIdentifier];
    [self setupHeaderRefreshControl];
//    if (locationMessage) {
//        isHiddenInput = YES;
//        [self setupFooterRefreshControl];
//        [self.items addObject:[[JTSessionMessageModel alloc] initWithMessage:locationMessage]];
//    }
    [self resetMessages];
    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id model = [self.items objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[JTSessionMessageModel class]])
    {
        NSInteger messageType = [(JTSessionMessageModel *)model message].messageType;
        if (messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)model message].messageObject;
            if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionExpressionIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTCardAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionCardIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTBonusAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionBonusIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTCallBonusAttachment class]] ||
                     [object.attachment isKindOfClass:[JTTeamOperationAttachment class]] ||
                     [object.attachment isKindOfClass:[JTTeamOwnerTipAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionTipIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTFunsAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionTextIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTVideoAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionVideoIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionImageIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTGroupAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionGroupIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTInformationAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionInformationIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTActivityAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionActivityIdentifier];
            }
            else if ([object.attachment isKindOfClass:[JTShopAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionShopIdentifier];
            }
        }
        else
        {
            if (messageType == NIMMessageTypeNotification) {
                NIMNotificationObject *object = (NIMNotificationObject *)[(JTSessionMessageModel *)model message].messageObject;
                if (object.notificationType == NIMNotificationTypeNetCall) {
                    cell = [tableView dequeueReusableCellWithIdentifier:sessionTextIdentifier];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:sessionTipIdentifier];
                }
            }
            else if (messageType == NIMMessageTypeTip) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionTipIdentifier];
            }
            else
            {
                switch (messageType)
                {
                    case NIMMessageTypeText:     cell = [tableView dequeueReusableCellWithIdentifier:sessionTextIdentifier];      break;
                    case NIMMessageTypeImage:    cell = [tableView dequeueReusableCellWithIdentifier:sessionImageIdentifier];     break;
                    case NIMMessageTypeAudio:    cell = [tableView dequeueReusableCellWithIdentifier:sessionAudioIdentifier];     break;
                    case NIMMessageTypeVideo:    cell = [tableView dequeueReusableCellWithIdentifier:sessionVideoIdentifier];     break;
                    case NIMMessageTypeLocation: cell = [tableView dequeueReusableCellWithIdentifier:sessionLocationIdentifier];  break;
                    default: NSAssert(0, @"not support model"); break;
                }
            }
        }
    }
    else if ([model isKindOfClass:[JTTimestampModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:sessionTimestampIdentifier];
    }
    else
    {
        NSAssert(0, @"not support model");
    }
    
    if ([cell isKindOfClass:[JTSessionTableViewCell class]]) {
        [(JTSessionTableViewCell *)cell setModel:model];
        [(JTSessionTableViewCell *)cell setIsEditMessage:isEditMessage];
        [(JTSessionTableViewCell *)cell choiceButton].selected = [self.choiceMessageModels containsObject:model];
        [(JTSessionTableViewCell *)cell setDelegate:self];
        [(JTSessionTableViewCell *)cell setDataSource:self];
    }
    else if ([cell isKindOfClass:[JTSessionTipTableViewCell class]]) {
        [(JTSessionTipTableViewCell *)cell setModel:model];
        [(JTSessionTipTableViewCell *)cell setDelegate:self];
    }
    else if ([cell isKindOfClass:[JTSessionTimestampTableViewCell class]]) {
        [(JTSessionTimestampTableViewCell *)cell setModel:model];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.items objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[JTSessionMessageModel class]]) {
        BOOL showTeamNickName = [[JTSessionLayoutConfig shareJTSessionLayoutConfig] isShowTeamNickName:self.sessionVC.session.sessionId];
        CGFloat surplusHeight = (showTeamNickName && ![(JTSessionMessageModel *)model message].isOutgoingMsg)?25:0;
        NSInteger messageType = [(JTSessionMessageModel *)model message].messageType;
        if (messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)model message].messageObject;
            if ([object.attachment isKindOfClass:[JTCallBonusAttachment class]] ||
                [object.attachment isKindOfClass:[JTTeamOperationAttachment class]] ||
                [object.attachment isKindOfClass:[JTTeamOwnerTipAttachment class]]) {
                return [model contentSize].height+15;
            }
            else
            {
                return MAX([model contentSize].height+15, 55)+surplusHeight;
            }
        }
        else
        {
            if (messageType == NIMMessageTypeNotification) {
                NIMNotificationObject *object = (NIMNotificationObject *)[(JTSessionMessageModel *)model message].messageObject;
                if (object.notificationType == NIMNotificationTypeNetCall) {
                    return MAX([model contentSize].height+15, 55)+surplusHeight;
                }
                else
                {
                    return [model contentSize].height+15;
                }
            }
            else if (messageType == NIMMessageTypeTip) {
                return [model contentSize].height+15;
            }
            else
            {
                return MAX([model contentSize].height+15, 55)+surplusHeight;
            }
        }
    }
    else
    {
        return 25;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - JTSessionTableViewCellDelegate
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell clickInAvatarAtYunxinID:(NSString *)yunxinID
{
    [self.sessionVC.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:[JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:yunxinID]]] animated:YES];
}

- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell longInAvatarAtYunxinID:(NSString *)yunxinID
{
    [self.sessionVC.sessionInputView showKeyboard];
    [self.sessionVC.sessionInputView insertInputUserItem:@[yunxinID] isChar:YES];
}

- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell didSelectAtMessageModel:(JTSessionMessageModel *)messageModel
{
    NSInteger messageType = messageModel.message.messageType;
    switch (messageType)
    {
        case NIMMessageTypeText:
            break;
        case NIMMessageTypeImage:
        {
            [self.sessionVC.sessionTool cellImagePressed:messageModel.message];
        }
            break;
        case NIMMessageTypeAudio: {
            if ([JTSocialStautsUtil sharedCenter].liveStatus != JTLiveStatusNone) {
                [[HUDTool shareHUDTool] showHint:@"直播进行中，您暂时不能操作语音"];
            }
            else
            {
                if (![[NIMSDK sharedSDK].mediaManager isPlaying]) {
                    [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
                    self.pendingAudioMessages = [self findRemainAudioMessages:messageModel.message];
                    [[JTAudioCenter instance] play:messageModel.message];
                } else {
                    self.pendingAudioMessages = nil;
                    [[NIMSDK sharedSDK].mediaManager stopPlay];
                }
            }
        }
            break;
        case NIMMessageTypeVideo:
            [self.sessionVC.sessionTool cellVideoPressed:messageModel.message];
            break;
        case NIMMessageTypeLocation:
            [self.sessionVC.sessionTool cellLocationPressed:messageModel.message];
            break;
        case NIMMessageTypeNotification: {
            NIMNotificationObject *object = (NIMNotificationObject *)messageModel.message.messageObject;
            if (object.notificationType == NIMNotificationTypeNetCall) {
                [self.sessionVC.sessionTool cellNetCallPressed:messageModel.message];
            }
        }
            break;
        case NIMMessageTypeCustom: {
            NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)messageModel message].messageObject;
            if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
                [self.sessionVC.sessionTool cellExpressionPressed:(JTExpressionAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTCardAttachment class]]) {
                [self.sessionVC.sessionTool cellCardPressed:(JTCardAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTBonusAttachment class]]) {
                [self.sessionVC.sessionTool cellBonusPressed:(JTBonusAttachment *)object.attachment message:messageModel.message];
            }
            else if ([object.attachment isKindOfClass:[JTVideoAttachment class]]) {
                [self.sessionVC.sessionTool cellNetworkVideoPressed:(JTVideoAttachment *)object.attachment message:messageModel.message];
            }
            else if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                [self.sessionVC.sessionTool cellImagePressed:messageModel.message];
            }
            else if ([object.attachment isKindOfClass:[JTGroupAttachment class]]) {
                [self.sessionVC.sessionTool cellGroupPressed:(JTGroupAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTInformationAttachment class]]) {
                [self.sessionVC.sessionTool cellInformationPressed:(JTInformationAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTActivityAttachment class]]) {
                [self.sessionVC.sessionTool cellActivityPressed:(JTActivityAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTShopAttachment class]]) {
                [self.sessionVC.sessionTool cellShopPressed:(JTShopAttachment *)object.attachment];
            }
        }
            break;
        default:
            break;
    }
}

- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell menuType:(JTMenuType)menuType
{
    switch (menuType) {
        case JTMenuTypeRemove:
            [self.sessionVC.sessionTool enumItemRemovePressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeBan:
            [self.sessionVC.sessionTool enumItemBanPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeCancelBan:
            [self.sessionVC.sessionTool enumItemCancelBanPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeSelected:
            [self.sessionVC.sessionTool enumItemSelectedPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeCopy:
            [self.sessionVC.sessionTool enumItemCopyPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeRepeat:
            [self.sessionVC.sessionTool enumItemRepeatPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeCollection:
            [self.sessionVC.sessionTool enumItemCollectionPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeRevoke:
            [self.sessionVC.sessionTool enumItemRevokePressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeDelete:
            [self.sessionVC.sessionTool enumItemDeletePressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeAdd:
            [self.sessionVC.sessionTool enumItemAddPressed:sessionTableViewCell.message];
            break;
        case JTMenuTypeMultiselect:
            [self.choiceMessageModels addObject:sessionTableViewCell.model];
            [self.sessionVC.sessionTool enumItemMultiselectPressed:sessionTableViewCell.message];
            break;
        default:
            break;
    }
}

- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell didChoiceAtMessageModel:(JTSessionMessageModel *)messageModel
{
    if ([self.items containsObject:messageModel]) {
        if ([self.choiceMessageModels containsObject:messageModel]) {
            [self.choiceMessageModels removeObject:messageModel];
        }
        else
        {
            [self.choiceMessageModels addObject:messageModel];
        }
        NSInteger index = [self.items indexOfObject:messageModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - JTSessionTableViewCellDataSource
- (JTTeamPowerModel *)teamPowerModelInSessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell
{
    return self.sessionVC.powerModel;
}

#pragma mark - JTSessionTipTableViewCellDelegate
- (void)sessionTableViewCell:(JTSessionTipTableViewCell *)sessionTableViewCell didSelectAtMessageModel:(JTSessionMessageModel *)messageModel didSelectAtValue:(id)value
{
    NSInteger messageType = messageModel.message.messageType;
    switch (messageType)
    {
        case NIMMessageTypeCustom: {
            NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)messageModel message].messageObject;
            if ([object.attachment isKindOfClass:[JTCallBonusAttachment class]]) {
                [self.sessionVC.sessionTool cellCallBonusPressed:(JTCallBonusAttachment *)object.attachment];
            }
            else if ([object.attachment isKindOfClass:[JTTeamOperationAttachment class]]) {
                [self.sessionVC.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:[JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:value]]] animated:YES];
            }
            else if ([object.attachment isKindOfClass:[JTTeamOwnerTipAttachment class]]) {
                if ([value integerValue] == TeamOwnerTipOperationActionTypeInvite) {
                    __weak typeof(self) weakself = self;
                    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.sessionVC.session.sessionId completion:^(NSError *error, NSArray *members) {
                        
                        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
                        config.contactSelectType = JTContactSelectTypeAddTeamMember;
                        config.needMutiSelected = YES;
                        NSMutableArray *memberIDs = [NSMutableArray array];
                        for (NIMTeamMember *member in members) {
                            [memberIDs addObject:member.userId];
                        }
                        config.alreadySelectedMemberId = memberIDs;
                        config.teamId = weakself.sessionVC.session.sessionId;
                        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
                        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
                        [weakself.sessionVC presentViewController:navigationController animated:YES completion:nil];
                    }];
                }
                else
                {
                    
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - NIMMediaManagerDelegate
- (void)playAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error
{
    if (!error) {
        NIMMessage *message = self.pendingAudioMessages.lastObject;
        if (self.pendingAudioMessages.count)
        {
            [self.pendingAudioMessages removeLastObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JTAudioCenter instance] play:message];
            });
        }
    }
}

- (NSTimeInterval)firstTimeInterval
{
    if (!self.items.count) {
        return 0;
    }
    if ([[self.items firstObject] isKindOfClass:[JTSessionMessageModel class]]) {
        JTSessionMessageModel *model = [self.items firstObject];
        return model.message.timestamp;
    }
    else
    {
        JTTimestampModel *model = [self.items firstObject];
        return model.messageTime;
    }
}

- (NSTimeInterval)lastTimeInterval
{
    if (!self.items.count) {
        return 0;
    }
    if ([[self.items lastObject] isKindOfClass:[JTSessionMessageModel class]]) {
        JTSessionMessageModel *model = self.items.lastObject;
        return model.message.timestamp;
    }
    else
    {
        JTTimestampModel *model = self.items.lastObject;
        return model.messageTime;
    }
}

- (void)layoutAfterRefresh
{
    if (self.tableView) {
        CGFloat offset = MAX(self.tableView.contentSize.height, self.tableView.height) - self.tableView.contentOffset.y;
        [self.tableView reloadData];
        if (self.tableView.contentSize.height > self.tableView.height)
        {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - offset) animated:NO];
        }
    }
}

- (BOOL)isThanSoundInterval
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastBottomDate];
    if (self.lastBottomDate && timeInterval < kDefaultBottomInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastBottomDate);
        return NO;
    }
    // 保存最后一次响铃时间
    self.lastBottomDate = [NSDate date];
    return YES;
}

- (NSMutableArray *)findRemainAudioMessages:(NIMMessage *)message
{
    if (message.isPlayed || [message.from isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        //如果这条音频消息被播放过了 或者这条消息是属于自己的消息，则不进行轮播
        return nil;
    }
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    [self.items enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JTSessionMessageModel class]]) {
            JTSessionMessageModel *model = (JTSessionMessageModel *)obj;
            BOOL isFromMe = [model.message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
            if ([model.message.messageId isEqualToString:message.messageId])
            {
                *stop = YES;
            }
            else if (model.message.messageType == NIMMessageTypeAudio && !isFromMe && !model.message.isPlayed)
            {
                [messages addObject:model.message];
            }
        }
    }];
    return messages;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NIMMessageSearchOption *)option
{
    if (!_option) {
        _option = [[NIMMessageSearchOption alloc] init];
        _option.limit = 20;
        _option.order = NIMMessageSearchOrderDesc;
        _option.allMessageTypes = YES;
    }
    return _option;
}

- (NSMutableArray *)choiceMessageModels
{
    if (!_choiceMessageModels) {
        _choiceMessageModels = [NSMutableArray array];
    }
    return _choiceMessageModels;
}

- (void)setupHeaderRefreshControl
{
    __weak typeof(self) weakself = self;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakself resetMessages];
        [weakself.tableView.mj_header endRefreshing];
    }];
    [header.lastUpdatedTimeLabel setHidden:YES];
    [header.stateLabel setHidden:YES];
    [header setHeight:20];
    [self.tableView setMj_header:header];
}

- (void)setupFooterRefreshControl
{
    __weak typeof(self) weakself = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself.tableView.mj_footer endRefreshing];
        [weakself moreMessages];
    }];
    [footer.stateLabel setHidden:YES];
    [footer setHeight:20];
    [self.tableView setMj_footer:footer];
}

@end

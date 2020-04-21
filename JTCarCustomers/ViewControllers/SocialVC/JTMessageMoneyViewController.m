//
//  JTMessageMoneyViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMessageMoneyViewController.h"
#import "JTSessionMoneyBonusReturnTableViewCell.h"
#import "JTSessionTimestampTableViewCell.h"
#import "MJRefresh.h"
#import "JTWalletMoneyDetailViewController.h"

#define messageLimit  20

@interface JTMessageMoneyViewController () <UITableViewDelegate, UITableViewDataSource, JTSessionTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation JTMessageMoneyViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)setupHeaderRefreshControl
{
    __weak typeof(self) weakself = self;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [weakself resetMessages];
        [weakself.tableview.mj_header endRefreshing];
    }];
    
    [header.lastUpdatedTimeLabel setHidden:YES];
    [header.stateLabel setHidden:YES];
    [header setHeight:20];
    [self.tableview setMj_header:header];
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
    NSArray *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:self.session
                                                                            message:currentOldestMessage.message
                                                                              limit:messageLimit];
    [self insertMessages:messages];
}

- (void)insertMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages.reverseObjectEnumerator.allObjects)
    {
        [self insertMessage:message];
    }
    [self layoutAfterRefresh];
}

- (void)insertMessage:(NIMMessage *)message
{
    JTSessionMessageModel *model = [[JTSessionMessageModel alloc] initWithMessage:message];
    if (model) {
        NSTimeInterval firstTimeInterval = [self firstTimeInterval];
        [self.items insertObject:model atIndex:0];
        if (firstTimeInterval == 0 || firstTimeInterval - message.timestamp > 300) {
            [self.items insertObject:[[JTTimestampModel alloc] initWithMessageTime:message.timestamp] atIndex:0];
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

- (void)layoutAfterRefresh
{
    if (self.tableview) {
        CGFloat offset = MAX(self.tableview.contentSize.height, self.tableview.height) - self.tableview.contentOffset.y;
        [self.tableview reloadData];
        if (self.tableview.contentSize.height > self.tableview.height)
        {
            [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height - offset) animated:NO];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.items objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[JTSessionMessageModel class]]) {
        return [model contentSize].height+15;
    }
    else
    {
        return 25;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id model = [self.items objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[JTSessionMessageModel class]]) {
        NSInteger messageType = [(JTSessionMessageModel *)model message].messageType;
        if (messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)model message].messageObject;
            if ([object.attachment isKindOfClass:[JTMoneyBonusReturnAttachment class]]) {
                cell = [tableView dequeueReusableCellWithIdentifier:sessionMoneyBonusReturnIdentifier];
            }
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:sessionTimestampIdentifier];
    }
    
    if ([cell isKindOfClass:[JTSessionTableViewCell class]]) {
        [(JTSessionTableViewCell *)cell setModel:model];
        [(JTSessionTableViewCell *)cell setDelegate:self];
    }
    else if ([cell isKindOfClass:[JTSessionTimestampTableViewCell class]]) {
        [(JTSessionTimestampTableViewCell *)cell setModel:model];
    }
    
    return cell;
}

- (void)sessionTableViewCell:(id)sessionTableViewCell didSelectAtMessageModel:(JTSessionMessageModel *)messageModel
{
    [self.navigationController pushViewController:[[JTWalletMoneyDetailViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:BlackLeverColor1];
    NIMUserInfo *userInfo = [[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId] userInfo];
    [self.navigationItem setTitle:userInfo.nickName];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[JTSessionMoneyBonusReturnTableViewCell class] forCellReuseIdentifier:sessionMoneyBonusReturnIdentifier];
    [self.tableview registerClass:[JTSessionTimestampTableViewCell class] forCellReuseIdentifier:sessionTimestampIdentifier];
    [self setupHeaderRefreshControl];
    [self resetMessages];
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
    }
    return _tableview;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

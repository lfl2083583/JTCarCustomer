//
//  JTMessageSearchViewController.m
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMessageSearchViewController.h"
#import "UIImage+Extension.h"
#import "JTGlobalSearchMessageTableViewCell.h"
#import "JTSessionViewController.h"

@interface JTMessageSearchViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NIMMessageSearchOption *option;

@end

@implementation JTMessageSearchViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    [self createTalbeView:UITableViewStylePlain rowHeight:70];
    [self.tableview setDataSource:self];
    [self.tableview setFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.searchBar.frame))];
    [self.tableview registerClass:[JTGlobalSearchMessageTableViewCell class] forCellReuseIdentifier:globalSearchMessageIdentifier];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setShowTableRefreshFooter:YES];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTGlobalSearchMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:globalSearchMessageIdentifier];
    NIMMessage *message = self.dataArray[indexPath.row];
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
    cell.timeLabel.text = [Utility showTime:message.timestamp showDetail:NO];
    cell.nameLabel.text = message.senderName;
    cell.messageLabel.text = message.text;
    [cell.avatarImageView setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMMessage *message = [self.dataArray objectAtIndex:indexPath.row];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:[[JTSessionViewController alloc] initWithSession:self.session locationMessage:message] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.option.searchContent = searchBar.text;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.dataArray removeAllObjects];
    [self staticRefreshFirstTableListData];
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    self.option.endTime = (self.dataArray.count)?[(NIMMessage *)[self.dataArray lastObject] timestamp]:0;
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:self.option result:^(NSError *error, NSArray *messages) {
        if (messages.count) {
            [weakself.dataArray addObjectsFromArray:messages.reverseObjectEnumerator.allObjects];
        }
        if (weakself.dataArray.count == 0) {
            [[HUDTool shareHUDTool] showHint:@"搜索无结果" yOffset:0];
        }
        [super getListData:requestComplete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundColor = WhiteColor;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar becomeFirstResponder];
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (NIMMessageSearchOption *)option
{
    if (!_option) {
        _option = [[NIMMessageSearchOption alloc] init];
        _option.limit = 20;
        _option.messageTypes = @[[NSNumber numberWithInteger:NIMMessageTypeText]];
        _option.order = NIMMessageSearchOrderDesc;
    }
    return _option;
}

@end

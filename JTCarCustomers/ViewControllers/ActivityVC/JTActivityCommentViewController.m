//
//  JTActivityCommentViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTActivityCommentTableViewCell.h"
#import "JTActivityCommentViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JTActivityCommentViewController () <UITableViewDataSource, UITextFieldDelegate, JTActivityCommentTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *centerLB;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UITextField *textField;

@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, copy) NSString *replyID;
@property (nonatomic, copy) NSString *replyName;

@end

@implementation JTActivityCommentViewController

- (void)dealloc {
    CCLOG(@"JTActivityCommentViewController释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithActivityID:(NSString *)activityID {
    self = [super init];
    if (self) {
        self.activityID = activityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, CGRectGetMinY(self.contentView.frame)+CGRectGetHeight(self.centerLB.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMinY(self.contentView.frame)-CGRectGetHeight(self.centerLB.frame)-CGRectGetHeight(self.inputView.frame)) rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[JTActivityCommentTableViewCell class] forCellReuseIdentifier:commentIdentifier];
    self.showTableRefreshFooter = YES;
    self.showTableRefreshHeader = YES;
    
    [self.view addSubview:self.inputView];
    
    [self staticRefreshFirstTableListData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ActivityCommentListApi) parameters:@{@"activity_id" : self.activityID, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        if (responseObject[@"count"]) {
            weakSelf.totalCount = [responseObject[@"count"] integerValue];
            weakSelf.centerLB.text = [NSString stringWithFormat:@"%@条评论",responseObject[@"count"]];
        }
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTActivityCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    cell.delegate = self;
    [cell configJTActivityCommentTableViewCellCommentInfo:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    CGFloat height = [tableView fd_heightForCellWithIdentifier:commentIdentifier cacheByIndexPath:indexPath configuration:^(JTActivityCommentTableViewCell *cell) {
        [cell configJTActivityCommentTableViewCellCommentInfo:dictionary indexPath:indexPath];
    }];
    return height;
}

#pragma mark JTActivityCommentTableViewCellDelegate
-(void)activityCommentCellReplyContentResponse:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    NSString *userID = [NSString stringWithFormat:@"%@",dictionary[@"comment"][@"uid"]];
    self.replyID = [NSString stringWithFormat:@"%@",dictionary[@"comment"][@"comment_id"]];
    if (![userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
        self.isReply = YES;
        self.replyName = [NSString stringWithFormat:@"%@",dictionary[@"comment"][@"nick_name"]];
        [self.textField becomeFirstResponder];
    } else {
        [self deleteActivityComment:self.replyID];
    }
}

- (void)activityCommentCellCommentContentResponse:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    NSString *userID = [NSString stringWithFormat:@"%@",dictionary[@"uid"]];
    self.replyID = [NSString stringWithFormat:@"%@",dictionary[@"comment_id"]];
    if (![userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
        self.isReply = YES;
        self.replyName = [NSString stringWithFormat:@"%@",dictionary[@"nick_name"]];
        [self.textField becomeFirstResponder];
    } else {
        [self deleteActivityComment:self.replyID];
    }
}

- (void)deleteActivityComment:(NSString *)commentID {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(DetActivityCommentApi) parameters:@{@"comment_id" : commentID} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"删除成功！" yOffset:0];
            [weakSelf.tableview.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]){
        if (!textField.text.length) {
            NSString *msg = self.isReply?@"请输入回复内容":@"请输入评论内容";
            [[HUDTool shareHUDTool] showHint:msg yOffset:0];
            return NO;
        }
        NSMutableDictionary *progem = [NSMutableDictionary dictionaryWithDictionary:@{@"activity_id" : self.activityID,@"content" : textField.text}];
        if (self.replyID) {
            [progem setValue:self.replyID forKey:@"reply_id"];
        }
        NSString *tip = self.isReply?@"回复成功！":@"评论成功！";
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(PostActivityCommentApi) parameters:progem success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:tip yOffset:0];
            [weakSelf.tableview.mj_header beginRefreshing];
            [textField resignFirstResponder];
        } failure:^(NSError *error) {

        }];

        return NO;
    }

    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.callBack) {
        self.callBack(self.totalCount);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark NSNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.23 animations:^{
        [self.inputView setY:APP_Frame_Height-frame.size.height-45];
        NSString *placeHolder = @"吐槽~";
        if (self.isReply) {
            placeHolder = [NSString stringWithFormat:@"回复：%@", self.replyName];
        }
        self.textField.placeholder = placeHolder;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.23 animations:^{
        [self.inputView setY:APP_Frame_Height-45];
        self.textField.text = @"";
        self.isReply = NO;
        self.replyID = nil;
        self.replyName = @"";
        self.textField.placeholder = @"吐槽~";
    } completion:^(BOOL finished) {
        
    }];
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45)];
        _inputView.layer.shadowColor = BlackLeverColor6.CGColor;
        _inputView.layer.shadowOpacity = 0.8;
        _inputView.layer.shadowOffset = CGSizeMake(2, 2);
        _inputView.backgroundColor = WhiteColor;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width-30, 45)];
        _textField.delegate = self;
        _textField.placeholder = @"吐槽~";
        _textField.returnKeyType = UIReturnKeySend;
        [_inputView addSubview:_textField];
    }
    return _inputView;
}

@end

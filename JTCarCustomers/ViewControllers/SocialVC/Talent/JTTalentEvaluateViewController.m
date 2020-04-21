//
//  JTTalentEvaluateViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTEvaluateTableViewCell.h"
#import "JTTalentEvaluateTableHeadView.h"

#import "JTTalentEvaluateViewController.h"

@interface JTTalentEvaluateViewController () <UITableViewDataSource, JTTalentEvaluateTableHeadViewDelegate, JTEvaluateTableViewCellDelegate>

@property (nonatomic, strong) JTTalentEvaluateTableHeadView *tableHeadView;
@property (nonatomic, strong) JTTalentEvaluateView *evaluateFinishView;
@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSArray *evaluates1;
@property (nonatomic, strong) NSArray *evaluates2;
@property (nonatomic, strong) NSArray *evaluateChoose;
@property (nonatomic, copy) NSString *evaluateContent;

@end

@implementation JTTalentEvaluateViewController

- (void)dealloc {
    CCLOG(@"JTTalentEvaluateViewController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userID = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self.navigationItem setTitle:@"评价"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:60];
    [self.tableview setDataSource:self];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview registerClass:[JTEvaluateTableViewCell class] forCellReuseIdentifier:evaluateTableViewCellIdentifier];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.evaluateFinishView];
    
    [self requestTalentInfo];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)requestTalentInfo {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/chat/expert/getExpertInfo") parameters:@{@"expert_uid" : self.userID} success:^(id responseObject, ResponseState state) {
        weakSelf.tableHeadView.talentInfo = responseObject;
    } failure:^(NSError *error) {
        
    }];
}

- (void)bottomBtnClick:(id)sender {
    if (self.score > 0) {
        __weak typeof(self)weakSelf = self;
        NSMutableDictionary *progem = [NSMutableDictionary dictionaryWithDictionary:@{@"expert_uid" : self.userID, @"score" : @(self.score)}];
        if (self.evaluateContent && [self.evaluateContent isKindOfClass:[NSArray class]]) {
            [progem setValue:self.evaluateContent forKey:@"content"];
        }
        if (self.evaluateChoose && [self.evaluateChoose isKindOfClass:[NSArray class]]) {
            [progem setValue:[self.evaluateChoose componentsJoinedByString:@","] forKey:@"score_type"];
        }
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ExpertCommentApi) parameters:progem success:^(id responseObject, ResponseState state) {
            weakSelf.tableview.hidden = YES;
            weakSelf.bottomBtn.hidden = YES;
            weakSelf.evaluateFinishView.hidden = NO;
        } failure:^(NSError *error) {

        }];
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"请给达人评分后再提交评价" yOffset:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupComponent {
    self.score = 0;
    self.evaluates1 = @[@"服务态度恶劣", @"业务不熟", @"语言谩骂", @"宣传其他平台", @"索要好评"];
    self.evaluates2 = @[@"聊天愉快", @"业务很专一"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluateTableViewCellIdentifier];
    cell.delegate = self;
    cell.evaluates = self.dataArray;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JTEvaluateTableViewCell getViewHeightWithEvalutes:self.dataArray];
}

#pragma mark JTTalentEvaluateTableHeadViewDelegate
- (void)talentEvaluateWithScore:(NSInteger)score {
    self.score = score;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    JTEvaluateTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (score == 0) {
        self.dataArray = [@[] mutableCopy];
    } else if (self.score <= 4) {
        self.evaluateChoose = @[];
        [cell.seletedArray removeAllObjects];
        self.dataArray = [NSMutableArray arrayWithArray:self.evaluates1];
    } else {
        self.evaluateChoose = @[];
        [cell.seletedArray removeAllObjects];
        self.dataArray = [NSMutableArray arrayWithArray:self.evaluates2];
    }
    [self.tableview reloadData];
}

#pragma mark JTEvaluateTableViewCellDelegate
- (void)evalutesChanged:(NSArray *)evaluates {
    self.evaluateChoose = evaluates;
    CCLOG(@"%@", evaluates);
}

- (void)textInputChanged:(NSString *)content {
    self.evaluateContent = content;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGRect rectInTableView = [self.tableview rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableview convertRect:rectInTableView toView:[self.tableview superview]];
    CGFloat tempY = rect.origin.y+[JTEvaluateTableViewCell getViewHeightWithEvalutes:self.dataArray];
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (tempY > frame.origin.y) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setY:(frame.origin.y-tempY)];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setY:0];
    }];
}

- (JTTalentEvaluateTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView  = [[JTTalentEvaluateTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 190)];
        _tableHeadView.delegate = self;
    }
    return _tableHeadView;
}

- (JTTalentEvaluateView *)evaluateFinishView {
    if (!_evaluateFinishView) {
        _evaluateFinishView = [[JTTalentEvaluateView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + kTopBarHeight, App_Frame_Width, APP_Frame_Height - kStatusBarHeight - kTopBarHeight)];
        _evaluateFinishView.hidden = YES;
    }
    return _evaluateFinishView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitle:@"匿名提交" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end

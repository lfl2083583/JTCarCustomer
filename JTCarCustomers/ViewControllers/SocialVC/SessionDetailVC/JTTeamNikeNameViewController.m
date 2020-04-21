//
//  JTTeamNikeNameViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamNikeNameViewController.h"

@implementation JTTeamNikeNameTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLB];
    }
    return self;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.width-44, self.height)];
        _topLB.font = Font(24);
        _topLB.text = @"设置群名片";
    }
    return _topLB;
}

@end


@implementation JTTeamNikeNameTableFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
    }
    return self;
}

- (ZTTextField *)textField {
    if (!_textField) {
        _textField = [[ZTTextField alloc] initWithFrame:CGRectMake(22, 20, App_Frame_Width - 44, 40)];
        _textField.font = Font(14);
        _textField.layer.borderWidth = 1;
        _textField.layer.cornerRadius = 4;
        _textField.layer.borderColor = BlackLeverColor2.CGColor;
        _textField.layer.masksToBounds = YES;
        _textField.placeholder = @"群昵称支持2~10字符输入";
    }
    return _textField;
}


@end


@interface JTTeamNikeNameViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTTeamNikeNameTableFootView *tableFootView;
@property (nonatomic, strong) JTTeamNikeNameTableHeadView *tableHeadView;

@end

@implementation JTTeamNikeNameViewController

- (instancetype)initWithSession:(NIMSession *)session userNick:(NSString *)userName {
    self = [super init];
    if (self) {
        self.session = session;
        self.userName = userName;
    }
    return self;
}

- (void)rightBarButtonItemClick:(id)sender {
    NSString *userName = self.tableFootView.textField.text;
    if (userName && [userName isEqualToString:self.userName]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (userName && userName.length >= 2 && userName.length <= 10) {
        __weak typeof(self) weakself = self;
        [self.tableFootView.textField resignFirstResponder];
        [[HUDTool shareHUDTool] showHint:@"请稍等..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetGroupCardApi) parameters:@{@"group_id" : self.session.sessionId, @"card" : userName} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"修改昵称成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
       [[HUDTool shareHUDTool] showHint:@"请输入2-10位昵称" yOffset:0];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:44];
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.tableHeadView;
    self.tableview.tableFooterView = self.tableFootView;
    self.view.backgroundColor = WhiteColor;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    self.tableFootView.textField.text = self.userName;
    [self.tableFootView.textField becomeFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenfier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenfier];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (JTTeamNikeNameTableFootView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[JTTeamNikeNameTableFootView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    }
    return _tableFootView;
}

- (JTTeamNikeNameTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTTeamNikeNameTableHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 60)];
    }
    return _tableHeadView;
}

@end

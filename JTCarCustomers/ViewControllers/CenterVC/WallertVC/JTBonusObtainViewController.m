//
//  JTBonusObtainViewController.m
//  JTCarCustomers
//
//  Created by liufulin on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTBonusObtainTableViewCell.h"
#import "JTBonusContainerHeadView.h"
#import "JTBonusObtainViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "JTBonusDetailViewController.h"

@interface JTBonusObtainViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTBonusContainerHeadView *tableHeadView;

@end

@implementation JTBonusObtainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, 81, App_Frame_Width, APP_Frame_Height-81) rowHeight:58 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview registerClass:[JTBonusObtainTableViewCell class] forCellReuseIdentifier:bonusObtainCellIdentifier];
    self.tableview.tableHeaderView = self.tableHeadView;
    self.tableview.dataSource = self;
    self.showTableRefreshFooter = YES;
    self.showTableRefreshHeader = YES;
    [self.tableview.mj_header beginRefreshing];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetRobPacketApi) parameters:@{@"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        if (responseObject[@"total"] && [responseObject[@"total"] isKindOfClass:[NSDictionary class]]) {
            [weakSelf configTableHeadViewWithSource:responseObject[@"total"]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTBonusObtainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bonusObtainCellIdentifier];
    [self configCellDataSource:self.dataArray[indexPath.row] bonusCell:cell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:bonusObtainCellIdentifier cacheByIndexPath:indexPath configuration:^(JTBonusObtainTableViewCell *cell) {
        [weakSelf configCellDataSource:weakSelf.dataArray[indexPath.row] bonusCell:cell];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    [self getBonusDetailWithBonusId:[NSString stringWithFormat:@"%@",dictionary[@"packet_id"]]];
    
}

- (void)getBonusDetailWithBonusId:(NSString *)bonusId {
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetPacketApi) parameters:@{@"packet_id": bonusId} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] hideHUD];
        if (responseObject[@"info"]) {
            JTBonusDetailModel *bonusDetailModel = [JTBonusDetailModel mj_objectWithKeyValues:responseObject[@"info"]];
            if ([responseObject objectForKey:@"list"]) {
                NSArray *bonusList = [JTBonusListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                JTBonusDetailViewController *redPacketDetailViewController = [[JTBonusDetailViewController alloc] initWithBonusDetailModel:bonusDetailModel bonusList:bonusList];
                [weakself.parentController.navigationController pushViewController:redPacketDetailViewController animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)configCellDataSource:(NSDictionary *)source bonusCell:(JTBonusObtainTableViewCell *)cell {
    if (source) {
        
        cell.leftBottomLB.text = source[@"create_time"];
        cell.rightTopLB.text = [NSString stringWithFormat:@"%@溜车币", source[@"rob_amount"]];
        NSString *title = [NSString stringWithFormat:@"%@",source[@"name"]];
        NSMutableAttributedString *atributeStr;
        int type = [source[@"type"] intValue];
        if (type == 2) {
            atributeStr = [[NSMutableAttributedString alloc] initWithString:title];
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(5, -2, 15, 15);
            attach.image = [UIImage imageNamed:@"icon_fight"];
            NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
            [atributeStr insertAttributedString:strAtt atIndex:title.length];
            
        }
        else
        {
            atributeStr = [[NSMutableAttributedString alloc] initWithString:title];
        }
        cell.leftTopLB.attributedText = atributeStr;
       
    }
}

- (void)configTableHeadViewWithSource:(id)source {
    if (source[@"totalamount"]) {
        NSString *amount = [NSString stringWithFormat:@"%@",source[@"totalamount"]];
        self.tableHeadView.topLB.text = [NSString stringWithFormat:@"%@溜车币",amount];
        self.tableHeadView.bonusTotalCountLB.text = [NSString stringWithFormat:@"%@",source[@"totalcount"]];
        self.tableHeadView.bonusBestCountLB.text = [NSString stringWithFormat:@"%@",source[@"best"]];
        [Utility richTextLabel:self.tableHeadView.topLB fontNumber:[UIFont fontWithName:@"Avenir Next Condensed Medium" size:48] andRange:NSMakeRange(0, amount.length) andColor:BlueLeverColor1];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (JTBonusContainerHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusContainerHeadView" owner:nil options:nil] firstObject];
    }
    return _tableHeadView;
}

@end

//
//  JTLocalContactsViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTHandleAddressBook.h"
#import "JTLocalContactsTableViewCell.h"
#import "JTLocalContactsViewController.h"
#import <MessageUI/MessageUI.h>

@implementation JTLocalContactsHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.bounds.size.width - 22 , 40)];
        _leftLabel.font = Font(24);
    }
    return _leftLabel;
}

@end

@interface JTLocalContactsViewController () <UITableViewDataSource, JTLocalContactsTableViewCellDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) JTLocalContactsHeadView *headView;

@property (nonatomic, strong) NSMutableDictionary *personInfoDictionary;
@property (nonatomic, strong) NSMutableArray *groupTitles;

@end

@implementation JTLocalContactsViewController

- (JTLocalContactsHeadView *)headView {
    if (!_headView) {
        _headView = [[JTLocalContactsHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
        _headView.leftLabel.text = @"添加手机联系人";
    }
    return _headView;
}

- (NSMutableArray *)groupTitles {
    if (!_groupTitles) {
        _groupTitles = [NSMutableArray array];
    }
    return _groupTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:48 sectionHeaderHeight:15 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.sectionIndexColor = BlackLeverColor3;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableHeaderView = self.headView;
    [self.tableview registerClass:[JTLocalContactsTableViewCell class] forCellReuseIdentifier:localContactsId];
    __weak typeof(self) weakself = self;
    [JTHandleAddressBook addressBookAuthorization:^(NSMutableDictionary *personInfoDictionary) {
        if (personInfoDictionary && [personInfoDictionary isKindOfClass:[NSDictionary class]] && personInfoDictionary.allKeys > 0) {
            weakself.personInfoDictionary = personInfoDictionary;
            NSString *phone = [weakself transitionPersonInfo:personInfoDictionary];
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(MatchingAddressListApi) parameters:@{@"phone" : phone} success:^(id responseObject, ResponseState state) {
                CCLOG(@"%@",responseObject);
                if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                    [weakself sortLocalContacts:responseObject[@"list"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)sortLocalContacts:(NSArray *)contacts {
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    [self.groupTitles removeAllObjects];
    for (NSInteger i = 0; i < 27; i ++) {
        //给临时数组创建27个数组作为元素，用来存放A-Z和#开头的联系人
        [tempArray addObject:[[NSMutableArray alloc] init]];
    }
    
    [contacts enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *userName = [obj objectForKey:@"name"];
        int firstWord = [[userName transformToPinyinFirst] characterAtIndex:0];
        if (firstWord >= 65 && firstWord <= 90) {
            //如果首字母是A-Z，直接放到对应数组
            [tempArray[firstWord - 65] addObject:obj];
        }
        else
        {
            //如果不是，就放到最后一个代表#的数组
            [[tempArray lastObject] addObject:obj];
        }
    }];
    
    //此时数据已按首字母排序并分组
    //遍历数组，删掉空数组
    for (NSMutableArray *mutArr in tempArray) {
        //如果数组不为空就添加到数据源当中
        if (mutArr.count != 0) {
            [self.dataArray addObject:mutArr];
            NSDictionary *source = mutArr[0];
            NSString *make = [source[@"name"] transformToPinyinFirst];
            int firstWord = [make characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                make = @"#";
            }
            [self.groupTitles addObject:make];
        }
    }
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dictionary = array[indexPath.row];
    JTLocalContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:localContactsId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configCellInfo:dictionary indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 15)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, App_Frame_Width - 22, 15)];
    label.font = Font(12);
    label.textColor = BlackLeverColor3;
    label.text = self.groupTitles.count?self.groupTitles[section]:@"";
    [view addSubview:label];
    return view;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.groupTitles;
}

#pragma mark JTLocalContactsTableViewCellDelegate
- (void)tableCellRightButtonClickWithIndexpath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dictionary = array[indexPath.row];
    NSString *fid = [dictionary objectForKey:@"uid"];
    NSString *phone = [dictionary objectForKey:@"phone"];
    JTServiceType serviceType = [[dictionary objectForKey:@"type"] integerValue];
    if (serviceType == JTServiceUnFocus)
    {
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(FocusApi) parameters:@{@"fid" : fid, @"type" : @(YES)} success:^(id responseObject, ResponseState state) {
            CCLOG(@"%@",responseObject);
            NSMutableArray *array = [weakSelf.dataArray[indexPath.section] mutableCopy];
            NSDictionary *dictionary = array[indexPath.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [dict setValue:@"1" forKey:@"type"];
            [array replaceObjectAtIndex:indexPath.row withObject:dict];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:array];
            [weakSelf.tableview reloadData];
            [[HUDTool shareHUDTool] showHint:@"关注成功" yOffset:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
    else if (serviceType == JTServiceUnRegister)
    {
        
        if ([MFMessageComposeViewController canSendText] && phone) {
            MFMessageComposeViewController *MsgController = [[MFMessageComposeViewController alloc] init];
            MsgController.recipients = [NSArray arrayWithObject:phone];
            MsgController.body = [NSString stringWithFormat:@"我正在使用《%@》这款应用,邀请你也来使用。详情请访问 %@", App_Name, @"http://www.boshangquan.com"];
            MsgController.messageComposeDelegate = self;
            [self presentViewController:MsgController animated:YES completion:nil];
        }
    }
    
}


#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)transitionPersonInfo:(NSMutableDictionary *)personInfoDictionary {
    NSMutableArray *arrary = [NSMutableArray array];
    [personInfoDictionary.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:[JTUserInfo shareUserInfo].userPhone]) {
            NSString *userName = [personInfoDictionary objectForKey:obj];
            NSMutableDictionary *source = [NSMutableDictionary dictionary];
            [source setValue:obj forKey:@"phone"];
            [source setObject:userName forKey:@"name"];
            [arrary addObject:source];
        }
    }];
    NSString *jasonString = [self arrayToJSONString:arrary];
    return jasonString;
}
@end


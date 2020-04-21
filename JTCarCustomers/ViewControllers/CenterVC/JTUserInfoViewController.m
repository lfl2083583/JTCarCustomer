//
//  JTUserInfoViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ITDatePicker.h"
#import "ZTFileNameTool.h"
#import "JTTagsModel.h"
#import "JTWordItem.h"

#import "JTUserInfoHeadView.h"
#import "ZTObtainPhotoTool.h"
#import "JTTFTitleTableViewCell.h"
#import "JTHobbyTableViewCell.h"

#import "CLAlertController.h"
#import "ITContainerController.h"
#import "JTUserInfoViewController.h"
#import "ZTTagCollectionViewFlowLayout.h"
#import "JTPersonalTagChooseViewController.h"
#import "JTPersonalTagInputViewController.h"
#import "UIViewController+BackButtonHandler.h"


static NSString *customIdentfier = @"UITableViewCell";

@interface JTUserInfoViewController () <UITableViewDataSource, JTUserInfoHeadViewDelegate, ITAlertBoxDelegate>

@property (nonatomic, strong) JTUserInfoHeadView *headView;

@property (nonatomic, strong) JTTagsModel *tagModel;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSIndexPath *editeIndexPath;
@property (nonatomic, assign) BOOL isEdite;


@end

@implementation JTUserInfoViewController

- (void)dealloc {
    CCLOG(@"JTUserInfoViewController销毁了");
}

- (void)rightItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self.view endEditing:YES];
    [[HUDTool shareHUDTool] showHint:@"修改资料中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    if (self.tagModel.name) {
        [progem setValue:self.tagModel.name forKey:@"nick_name"];
    }
    if (self.tagModel.birth) {
        [progem setValue:self.tagModel.birth forKey:@"birth"];
    }
    if (self.tagModel.company) {
        [progem setValue:self.tagModel.company forKey:@"company"];
    }
    if (self.tagModel.sign) {
        [progem setValue:self.tagModel.sign forKey:@"user_sign"];
    }
    
    [progem setValue:@(self.tagModel.gender) forKey:@"gender"];

    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EditeUserInfoApi) parameters:progem success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        [[HUDTool shareHUDTool] showHint:@"修改成功" yOffset:0];
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *company = responseObject[@"company"];
            NSString *sign = responseObject[@"sign"];
            NSString *userName = responseObject[@"nick_name"];
            NSString *userBirth = responseObject[@"birth"];
            NSString *userGender = responseObject[@"gender"];
            if (userBirth) {
                 [JTUserInfo shareUserInfo].userBirth = [NSString stringWithFormat:@"%@",userBirth];
            }
            if (company) {
                [JTUserInfo shareUserInfo].userCompany = [NSString stringWithFormat:@"%@",company];
            }
            if (userName) {
                [JTUserInfo shareUserInfo].userName = [NSString stringWithFormat:@"%@",userName];
            }
            if (sign) {
                [JTUserInfo shareUserInfo].userSign = [NSString stringWithFormat:@"%@",sign];
            }
            [JTUserInfo shareUserInfo].userGenter = [userGender integerValue];
            [[JTUserInfo shareUserInfo] save];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdateNotificationName object:nil];
    
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)navigationShouldPopOnBackButton {
    if (self.isEdite) {
        __weak typeof(self)weakSelf = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"将此次编辑保存" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf rightItemClick:nil];
        }]];
        [self presentToViewController:alertVC completion:nil];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self.navigationItem setTitle:@"编辑个人资料"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:60 sectionHeaderHeight:40 sectionFooterHeight:0];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setTableHeaderView:self.headView];
    [self.tableview setDataSource:self];
    [self.tableview registerNib:[UINib nibWithNibName:@"JTTFTitleTableViewCell" bundle:nil] forCellReuseIdentifier:tfTitleIdentifier];
    [self.tableview registerClass:[JTHobbyTableViewCell class] forCellReuseIdentifier:hobbyCellIdentifier];
    [self.tableview registerClass:[JTUserInfoSectionHeadView class] forHeaderFooterViewReuseIdentifier:userInfoSectionIdentifier];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
}

- (void)reloadData {
    [self setupComponent];
    [self.headView refreshView];
    [self.tableview reloadData];
}

- (void)setupComponent {
    self.dataArray = [NSMutableArray arrayWithArray:[self.tagModel buidItemArrayWith:[JTUserInfo shareUserInfo]]];
    self.sectionTitles = @[@"", @"我的信息（选填）", @"我的个性标签（选填）", @"我的兴趣（选填）"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrary = self.dataArray[indexPath.section];
    JTWordItem *item = arrary[indexPath.row];
    if (indexPath.section == 0 )
    {
        JTTFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
        [cell configCellTitle:item.title subtitle:item.subTitle placeHolder:item.placeholder indexPath:indexPath textfieldEnable:NO];
        cell.accessoryType = item.accessoryType;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:customIdentfier];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.textColor = BlackLeverColor5;
            cell.textLabel.font = Font(16);
            cell.detailTextLabel.font = Font(16);
            cell.detailTextLabel.textColor = BlackLeverColor3;
            UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, App_Frame_Width-15, 0.5)];
            horizontalView.backgroundColor = BlackLeverColor2;
            [cell.contentView addSubview:horizontalView];
        }
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.subTitle;
        cell.accessoryType = item.accessoryType;
        return cell;
    }
    else
    {
        JTHobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyCellIdentifier];
        cell.rightLB.text = item.title;
        cell.leftImgeV.image = item.image;
        cell.accessoryType = item.accessoryType;
        cell.collectionView.hidden = !item.tags.count;
        cell.rightLB.hidden = item.tags.count;
        cell.tags = item.tags;
        if ([item.title isEqualToString:@"选择我的个性标签"])
        {
            cell.tagColor = UIColorFromRGB(0xec88d7);
        }
        else if ([item.title isEqualToString:@"我喜欢的爱车"])
        {
            cell.tagColor = UIColorFromRGB(0x66a4fe);
        }
        else if ([item.title isEqualToString:@"我喜欢的音乐"])
        {
            cell.tagColor = UIColorFromRGB(0xbd60f5);
        }
        else if ([item.title isEqualToString:@"我喜欢的运动"])
        {
            cell.tagColor = UIColorFromRGB(0xc48dfa);
        }
        else if ([item.title isEqualToString:@"我喜欢的电影"])
        {
           cell.tagColor = UIColorFromRGB(0xb1a3f2);
        }
        [cell reloadData];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrary = self.dataArray[section];
    return arrary.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrary = self.dataArray[indexPath.section];
    JTWordItem *item = arrary[indexPath.row];
    return item.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?0.01:40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JTUserInfoSectionHeadView *sectionHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:userInfoSectionIdentifier];
    sectionHead.leftLabel.text = self.sectionTitles[section];
    return sectionHead;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        CLAlertController *alert = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
        [alert addAction:[CLAlertModel actionWithTitle:@"男" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            weakSelf.tagModel.gender = JTUserGenderMan;
            JTWordItem *item = self.dataArray[0][1];
            item.subTitle = @"男";
            weakSelf.isEdite = YES;
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }]];
        [alert addAction:[CLAlertModel actionWithTitle:@"女" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            weakSelf.tagModel.gender = JTUserGenderWoman;
            JTWordItem *item = self.dataArray[0][1];
            item.subTitle = @"女";
            weakSelf.isEdite = YES;
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }]];
        [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
        }]];
        [self presentToViewController:alert completion:nil];
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        self.editeIndexPath = indexPath;
        ITDatePicker *datePicker = [[ITDatePicker alloc] init];
        datePicker.mode = ITDatePickerModeyyyyMMdd;
        datePicker.delegate = self;
        datePicker.showToday = NO;
        datePicker.showOutsideDate = NO;
        datePicker.maximumDate = [Utility exchageDate:[NSDate date] format:@"YYYY.MM.dd"];
        [self presentViewController:[[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom] animated:YES completion:nil];
    }
    else if ((indexPath.section == 1 && indexPath.row == 0) ||
             (indexPath.section == 1 && indexPath.row == 1) ||
              indexPath.section == 2 ||
              indexPath.section == 3)
    {
        JTWordItem *item = self.dataArray[indexPath.section][indexPath.row];
        
        [self.navigationController pushViewController:[[JTPersonalTagChooseViewController alloc] initWithTitle:item.title tagType:item.tagType indexPath:indexPath tags:item.tags tagChoose:^(NSArray<NSDictionary *> *tags, NSIndexPath *indexPath) {
            NSArray *array = weakSelf.dataArray[indexPath.section];
            JTWordItem *item = array[indexPath.row];
            if ([item.title isEqualToString:@"行业"])
            {
                NSDictionary *dict = [tags firstObject];
                item.subTitle = dict[@"label_name"];
                weakSelf.tagModel.industrys = [NSMutableArray arrayWithObject:[tags firstObject]];
            }
            else if ([item.title isEqualToString:@"职业"])
            {
                NSDictionary *dict = [tags firstObject];
                item.subTitle = dict[@"label_name"];
                weakSelf.tagModel.professions = [NSMutableArray arrayWithObject:[tags firstObject]];
            }
            else if ([item.title isEqualToString:@"选择我的个性标签"])
            {
                weakSelf.tagModel.characters = [NSMutableArray arrayWithArray:tags];
            }
            else if ([item.title isEqualToString:@"我喜欢的车"])
            {
                weakSelf.tagModel.cars = [NSMutableArray arrayWithArray:tags];
            }
            else if ([item.title isEqualToString:@"我喜欢的音乐"])
            {
                weakSelf.tagModel.musics = [NSMutableArray arrayWithArray:tags];
            }
            else if ([item.title isEqualToString:@"我喜欢的电影"])
            {
                weakSelf.tagModel.films = [NSMutableArray arrayWithArray:tags];
            }
            else if ([item.title isEqualToString:@"我喜欢的运动"])
            {
                weakSelf.tagModel.sports = [NSMutableArray arrayWithArray:tags];
            }
            item.tags = tags;
            item.cellHeight = [JTTagsModel clculateRowHeight:tags];
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }] animated:YES];
    }
    else if ((indexPath.section == 0 && indexPath.row == 0) ||
             (indexPath.section == 1 && indexPath.row == 2) ||
             (indexPath.section == 1 && indexPath.row == 3))
    {
        JTWordItem *item = self.dataArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:[[JTPersonalTagInputViewController alloc] initWithIndexPath:indexPath title:item.title textInput:^(NSString *content, NSIndexPath *indexPath) {
            item.subTitle = content;
            weakSelf.isEdite = YES;
            if (indexPath.row == 0) {
                weakSelf.tagModel.name = content;
            }
            else if (indexPath.row == 2)
            {
                weakSelf.tagModel.company = content;
            }
            else if (indexPath.row == 3)
            {
                weakSelf.tagModel.sign = content;
            }
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }] animated:YES];
    }
}


#pragma mark ITAlertBoxDelegate
- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(NSString *)dateString
{
    NSArray *array = [dateString componentsSeparatedByString:@"."];
    self.tagModel.birth = [NSString stringWithFormat:@"%@-%@-%@",array[0], array[1], array[2]];
    JTWordItem *item = self.dataArray[self.editeIndexPath.section][self.editeIndexPath.row];
    item.subTitle = [NSString stringWithFormat:@"%@-%@-%@",array[0], array[1], array[2]];
    self.isEdite = YES;
    [self.tableview reloadRowsAtIndexPaths:@[self.editeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark JTUserInfoHeadViewDelegate
- (void)headViewAddPhoto:(NSUInteger)index {
    __weak typeof(self)weakSelf = self;
    NSString *requestUrl = (index == 1)?EditeUserInfoApi:SetUserAlbumApi;
    NSString *imageName = (index == 1)?@"avatar":[NSString stringWithFormat:@"image_%ld",index-1];
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self success:^(UIImage *image) {
        NSArray *fileNames = (index == 1)?[ZTFileNameTool showFileNamesForAvatar]:[ZTFileNameTool showFileNamesForAlbumFileNum:1];
        [[HttpRequestTool sharedInstance] uploadWithFileNames:fileNames uploadFileArr:@[image] success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                NSArray *urlArrary = responseObject;
                ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
                configParam.isEncrypt = YES;
                configParam.isNeedUserTokenAndUserID = YES;
                [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(requestUrl) parameters:@{ imageName : [urlArrary firstObject]} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
                    CCLOG(@"%@",responseObject);
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        NSString *ablumUrl = responseObject[imageName];
                        if (index > 1)
                        {
                            NSMutableDictionary *mudict;
                            if ( [JTUserInfo shareUserInfo].userAblum)
                            {
                                mudict = [NSMutableDictionary dictionaryWithDictionary:[JTUserInfo shareUserInfo].userAblum];
                                [mudict setObject:ablumUrl forKey:imageName];
                            }
                            else
                            {
                                mudict = [NSMutableDictionary dictionary];
                                [mudict setObject:ablumUrl forKey:imageName];
                            }
                            [JTUserInfo shareUserInfo].userAblum = mudict;
                        }
                        else
                        {
                            [JTUserInfo shareUserInfo].userAvatar = ablumUrl;
                        }
                        [[JTUserInfo shareUserInfo] save];
                        [weakSelf reloadData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdateNotificationName object:nil];
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    } cancel:^{
        
    }];
}

- (JTUserInfoHeadView *)headView {
    if (!_headView) {
        _headView = [[JTUserInfoHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width)];
        _headView.delegate = self;
    }
    return _headView;
}

- (JTTagsModel *)tagModel {
    if (!_tagModel) {
        _tagModel = [[JTTagsModel alloc] init];
    }
    return _tagModel;
}

@end


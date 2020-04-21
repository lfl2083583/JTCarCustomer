//
//  JTRegisterPersonTagViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTProfessionTableViewCell.h"
#import "JTHobbyTableViewCell.h"
#import "JTRegisterPersonTagViewController.h"
#import "JTPersonalTagChooseViewController.h"
#import "JTPersonalTagInputViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>

@implementation JTRegisterPersonTagTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLB];
        [self addSubview:self.bottomLB];
        self.topLB.text = @"个人标签（选填）";
        self.bottomLB.text = @"完善你的个人标签\n让更多志同道合的朋友认识你";
        [Utility richTextLabel:self.topLB fontNumber:Font(16) andRange:NSMakeRange(4, 4) andColor:BlackLeverColor3];
    }
    return self;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.width-30, 40)];
        _topLB.font = Font(24);
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.topLB.frame)+5, self.width-30, 42)];
        _bottomLB.font = Font(16);
        _bottomLB.textColor = BlackLeverColor3;
        _bottomLB.numberOfLines = 0;
    }
    return _bottomLB;
}

@end

@interface JTRegisterPersonTagViewController () < UITableViewDataSource>

@property (nonatomic, strong) JTRegisterPersonTagTableHeadView *tableHaedView;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *sign;

@end

static NSString *customIndentify = @"UITableViewCell";

@implementation JTRegisterPersonTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:60];
    self.tableview.tableHeaderView = self.tableHaedView;
    [self.tableview setSeparatorColor:BlackLeverColor2];
    [self.tableview registerClass:[JTHobbyTableViewCell class] forCellReuseIdentifier:hobbyCellIdentifier];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setupComponent{
    JTWordItem *item1 = [self createWordItem:@"行业" subTitle:@"添加所在行业" image:nil];
    
    JTWordItem *item2 = [self createWordItem:@"职业" subTitle:@"添加您的职业" image:nil];
    
    JTWordItem *item3 = [self createWordItem:@"公司" subTitle:@"添加所在公司" image:nil];
    
    JTWordItem *item4 = [self createWordItem:@"个性签名" subTitle:@"还未填写个性签名" image:nil];
    
    JTWordItem *item5 = [self createWordItem:@"选择我的个性标签" subTitle:@"还未填写个性标签" image:[UIImage imageNamed:@"tag_char_icon"]];
    
    JTWordItem *item6 = [self createWordItem:@"我喜欢的车" subTitle:nil image:[UIImage imageNamed:@"tag_car_icon"]];
    
    JTWordItem *item7 = [self createWordItem:@"我喜欢的音乐" subTitle:nil image:[UIImage imageNamed:@"tag_music_icon"]];
    
    JTWordItem *item8 = [self createWordItem:@"我喜欢的电影" subTitle:nil image:[UIImage imageNamed:@"tag_film_icon"]];
    
    JTWordItem *item9 = [self createWordItem:@"我喜欢的运动" subTitle:nil image:[UIImage imageNamed:@"tag_move_icon"]];
    
    self.dataArray = [@[item1, item2, item3, item4, item5, item6, item7, item8, item9] mutableCopy];
    
}

- (JTWordItem *)createWordItem:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image{
    JTWordItem *wordItem = [[JTWordItem alloc] init];
    wordItem.title = title;
    wordItem.subTitle = subTitle;
    wordItem.image = image;
    wordItem.tags = @[];
    return wordItem;
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

/**
 跳过
 
 @param sender 跳过按钮
 */
- (void)rightItemClick:(id)sender{
    if (self.company || self.sign) {
        ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
        configParam.isEncrypt = YES;
        configParam.isNeedUserTokenAndUserID = YES;
        [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(EditeUserInfoApi) parameters:@{@"company" : self.company?self.company:@"", @"user_sign" : self.sign?self.sign:@""} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
            CCLOG(@"%@",responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *company = responseObject[@"company"];
                NSString *sign = responseObject[@"sign"];
                [JTUserInfo shareUserInfo].userCompany = [NSString stringWithFormat:@"%@",company?company:@""];
                [JTUserInfo shareUserInfo].userSign = [NSString stringWithFormat:@"%@",sign?sign:@""];
                [[JTUserInfo shareUserInfo] save];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    UIViewController *root = self.navigationController.viewControllers[0];
    self.navigationController.viewControllers = @[root];
    [root dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    if (indexPath.row < 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIndentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:customIndentify];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.textColor = BlackLeverColor5;
            cell.textLabel.font = Font(16);
        }
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.subTitle;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        JTHobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyCellIdentifier];
        cell.rightLB.text = item.title;
        cell.leftImgeV.image = item.image;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.collectionView.hidden = !item.tags.count;
        cell.rightLB.hidden = item.tags.count;
        cell.tags = item.tags;
        if ([item.title isEqualToString:@"选择我的个性标签"]) {
            cell.tagColor = UIColorFromRGB(0xec88d7);
        } else if ([item.title isEqualToString:@"我喜欢的爱车"]) {
            cell.tagColor = UIColorFromRGB(0x66a4fe);
        } else if ([item.title isEqualToString:@"我喜欢的音乐"]) {
            cell.tagColor = UIColorFromRGB(0xbd60f5);
        } else if ([item.title isEqualToString:@"我喜欢的运动"]) {
            cell.tagColor = UIColorFromRGB(0xb1a3f2);
        } else if ([item.title isEqualToString:@"我喜欢的电影"]) {
            cell.tagColor = UIColorFromRGB(0xc48dfa);
        }
        [cell reloadData];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 2 || indexPath.row == 3) {
        [self.navigationController pushViewController:[[JTPersonalTagInputViewController alloc] initWithIndexPath:indexPath title:item.title textInput:^(NSString *content, NSIndexPath *indexPath) {
            item.subTitle = content;
            if (indexPath.row == 2) {
                self.company = content;
            } else if (indexPath.row == 3) {
                self.sign = content;
            }
            [weakSelf.tableview reloadData];
        }] animated:YES];
    } else {
        [self.navigationController pushViewController:[[JTPersonalTagChooseViewController alloc] initWithTitle:item.title tagType:[self exchangeIndexPath:indexPath] indexPath:indexPath tags:item.tags tagChoose:^(NSArray<NSDictionary *> *tags, NSIndexPath *indexPath) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                NSDictionary *dict = [tags firstObject];
                item.subTitle = dict[@"label_name"];
            }else if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) {
                item.tags = tags;
            }
            [weakSelf.tableview reloadData];
        }] animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 4) {
        return 60;
    } else {
        JTWordItem *item =self.dataArray[indexPath.row];
        return [JTHobbyTableViewCell getCellHeightWithTags:item.tags width:tableView.frame.size.width-70]>60?[JTHobbyTableViewCell getCellHeightWithTags:item.tags width:tableView.frame.size.width-70]:60;
    }
}

- (JTTagType)exchangeIndexPath:(NSIndexPath *)indexPath{
    JTTagType tagType;
    switch (indexPath.row) {
        case 0:
            tagType = JTTagTypeIndustry;
            break;
        case 1:
            tagType = JTTagTypeProfession;
            break;
        case 4:
            tagType = JTTagTypeCharacter;
            break;
        case 5:
            tagType = JTTagTypeCar;
            break;
        case 6:
            tagType = JTTagTypeMusic;
            break;
        case 7:
            tagType = JTTagTypeFilm;
            break;
        case 8:
            tagType = JTTagTypeMove;
            break;
        default:
            tagType = JTTagTypeMusic;
            break;
    }
    return tagType;
}

- (JTRegisterPersonTagTableHeadView *)tableHaedView {
    if (!_tableHaedView) {
        _tableHaedView = [[JTRegisterPersonTagTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 82)];
    }
    return _tableHaedView;
}

@end


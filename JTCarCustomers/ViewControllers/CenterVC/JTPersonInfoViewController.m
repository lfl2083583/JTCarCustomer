//
//  JTPersonInfoViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTTagsModel.h"
#import "JTPersonInfoViewController.h"

#import "JTHobbyTableViewCell.h"
#import "JTUserFeatureTableViewCell.h"
#import "JTTFTitleTableViewCell.h"

@interface JTPersonInfoViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTTagsModel *tagModel;

@end

static NSString *indentifier = @"UITableViewCell";

@implementation JTPersonInfoViewController

- (instancetype)initWithUserInfo:(JTNormalUserInfo *)userInfo {
    self = [super init];
    if (self) {
        self.userInfo = userInfo;
        self.tagModel.userTags = userInfo.userTags;
        self.tagModel.commons = [NSMutableArray arrayWithArray:userInfo.userSameTags?userInfo.userSameTags:@[]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    self.navigationItem.title = @"TA的信息";
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:60 sectionHeaderHeight:10 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"JTTFTitleTableViewCell" bundle:nil] forCellReuseIdentifier:tfTitleIdentifier];
    [self.tableview registerClass:[JTHobbyTableViewCell class] forCellReuseIdentifier:hobbyCellIdentifier];
    [self.tableview registerClass:[JTUserFeatureTableViewCell class] forCellReuseIdentifier:userfeatureCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupComponent {
    
    NSString *company = (self.userInfo.userCompany && ![self.userInfo.userCompany isBlankString])?self.userInfo.userCompany:@"未设置";
    NSString *sign = (self.userInfo.userSign && ![self.userInfo.userSign isBlankString])?self.userInfo.userSign:@"未设置";

    NSString *profession = @"";
    if (self.tagModel.professions.count) {
        NSDictionary *dict = self.tagModel.professions[0];
        profession = dict[@"label_name"];
    } else{
        profession = @"未设置";
    }
    NSString *industry = @"";
    if (self.tagModel.industrys.count) {
        NSDictionary *dict = self.tagModel.industrys[0];
        industry = dict[@"label_name"];
    } else{
        industry = @"未设置";
    }
    if (self.tagModel.professions.count) {
        NSDictionary *dict = self.tagModel.professions[0];
        profession = dict[@"label_name"];
    } else{
        profession = @"未设置";
    }
    

    JTWordItem *item1 = [self createWordItem:@"行业" subTitle:industry image:nil tags:self.tagModel.industrys tagID:tfTitleIdentifier];
    
    JTWordItem *item2 = [self createWordItem:@"职业" subTitle:profession image:nil tags:self.tagModel.professions tagID:tfTitleIdentifier];
    
    JTWordItem *item3 = [self createWordItem:@"公司" subTitle:company image:nil tags:nil tagID:tfTitleIdentifier];
    
    JTWordItem *item4 = [self createWordItem:@"个性签名" subTitle:sign image:nil tags:nil tagID:tfTitleIdentifier];
    
    JTWordItem *item5 = [self createWordItem:@"TA的个性标签" subTitle:@"" image:[UIImage imageNamed:@"tag_char_icon"] tags:self.tagModel.characters tagID:userfeatureCellIdentifier];
    
    JTWordItem *item6 = [self createWordItem:@"喜欢的车" subTitle:nil image:[UIImage imageNamed:@"tag_car_icon"] tags:self.tagModel.cars tagID:hobbyCellIdentifier];
    
    JTWordItem *item7 = [self createWordItem:@"喜欢的音乐" subTitle:nil image:[UIImage imageNamed:@"tag_music_icon"] tags:self.tagModel.musics tagID:hobbyCellIdentifier];
    
    JTWordItem *item8 = [self createWordItem:@"喜欢的电影" subTitle:nil image:[UIImage imageNamed:@"tag_film_icon"] tags:self.tagModel.films tagID:hobbyCellIdentifier];
    
    JTWordItem *item9 = [self createWordItem:@"喜欢的运动" subTitle:nil image:[UIImage imageNamed:@"tag_move_icon"] tags:self.tagModel.sports tagID:hobbyCellIdentifier];
    
    JTWordItem *item10 = [self createWordItem:@"共同点" subTitle:nil image:nil tags:self.tagModel.commons tagID:userfeatureCellIdentifier];
    
    JTWordItem *item11 = [self createWordItem:@"TA的兴趣" subTitle:nil image:nil tags:nil tagID:indentifier];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@[item1, item2, item3, item4],
                                                      @[item5],
                                                      @[item11, item6, item7, item8, item9],
                                                      @[item10]]];
   
}

- (JTWordItem *)createWordItem:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image tags:(NSMutableArray *)tags tagID:(NSString *)tagID {
    JTWordItem *wordItem = [[JTWordItem alloc] init];
    wordItem.title = title;
    wordItem.subTitle = subTitle;
    wordItem.image = image;
    wordItem.tags = tags;
    wordItem.tagID = tagID;
    return wordItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.tagID isEqualToString:tfTitleIdentifier]) {
        JTTFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellTitle:item.title subtitle:item.subTitle placeHolder:nil indexPath:indexPath textfieldEnable:NO];
        return cell;
    }
    else if ([item.tagID isEqualToString:userfeatureCellIdentifier])
    {
        JTUserFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userfeatureCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([item.title isEqualToString:@"TA的个性标签"]) {
            cell.tags = self.tagModel.characters;
            if (!self.tagModel.characters.count) {
                NSString *content = @"TA的个性标签   暂无";
                cell.topLabel.text = content;
                [Utility richTextLabel:cell.topLabel fontNumber:Font(16) andRange:NSMakeRange(content.length-2, 2) andColor:BlackLeverColor3];
            } else {
                cell.topLabel.text = @"TA的个性标签";
            }
            cell.isRandColor = NO;
        }
        else if ([item.title isEqualToString:@"共同点"])
        {
            cell.tags = self.tagModel.commons;
            NSString *content = [NSString stringWithFormat:@"我们有%ld个共同点",self.tagModel.commons.count];
            NSString *num = [NSString stringWithFormat:@"%ld",self.tagModel.commons.count];
            cell.topLabel.text = content;
            [Utility richTextLabel:cell.topLabel fontNumber:Font(16) andRange:NSMakeRange(3, num.length) andColor:BlueLeverColor1];
            cell.isRandColor = YES;
        }
        cell.rightLable.hidden = YES;
        cell.rightImgeView.hidden = YES;
        [cell reloadData];
        return cell;
    }
    else if ([item.tagID isEqualToString:hobbyCellIdentifier])
    {
        JTHobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLB.text = @"暂无";
        cell.leftImgeV.image = item.image;
        cell.collectionView.hidden = !item.tags.count;
        cell.rightLB.hidden = item.tags.count;
        cell.tags = item.tags;
        if ([item.title isEqualToString:@"喜欢的爱车"]) {
            cell.tagColor = UIColorFromRGB(0x66a4fe);
        } else if ([item.title isEqualToString:@"喜欢的音乐"]) {
            cell.tagColor = UIColorFromRGB(0xbd60f5);
        } else if ([item.title isEqualToString:@"喜欢的运动"]) {
            cell.tagColor = UIColorFromRGB(0xc48dfa);
        } else if ([item.title isEqualToString:@"喜欢的电影"]) {
            cell.tagColor = UIColorFromRGB(0xb1a3f2);
        }
        [cell reloadData];
        return cell;
    }
    else
    {
        static NSString *indentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = Font(16);
            cell.textLabel.textColor = BlackLeverColor6;
        }
        cell.textLabel.text = item.title;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.tagID isEqualToString:tfTitleIdentifier]) {
        return 60;
    }
    else if ([item.tagID isEqualToString:userfeatureCellIdentifier])
    {
        CGFloat height = [JTUserFeatureTableViewCell getCellHeightWithTags:item.tags width:App_Frame_Width];
        return height;
    }
    else if ([item.tagID isEqualToString:hobbyCellIdentifier])
    {
        CGFloat height = [JTHobbyTableViewCell getCellHeightWithTags:item.tags width:tableView.frame.size.width-70];
        return height>60?height:60;
    }
    else
    {
        return 40;
    }
}


- (JTTagsModel *)tagModel {
    if (!_tagModel) {
        _tagModel = [[JTTagsModel alloc] init];
    }
    return _tagModel;
}
@end

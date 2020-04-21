//
//  JTTagsModel.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTTagsModel.h"
#import "JTHobbyTableViewCell.h"
#import "JTPersonalTagChooseViewController.h"


@implementation JTTagsModel

- (void)setUserTags:(NSArray *)userTags {
    _userTags = userTags;
    if (userTags && [userTags isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in userTags) {
            JTTagType tagType = [[dictionary objectForKey:@"type_id"] integerValue];
            NSArray *bind = [dictionary objectForKey:@"bind"];
            switch (tagType) {
                case JTTagTypeIndustry:
                    self.industrys = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeProfession:
                    self.professions = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeCharacter:
                    self.characters = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeCar:
                    self.cars = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeMusic:
                    self.musics = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeFilm:
                    self.films = [NSMutableArray arrayWithArray:bind];
                    break;
                case JTTagTypeMove:
                    self.sports = [NSMutableArray arrayWithArray:bind];
                    break;
                default:
                    break;
            }
        }
    }
}

- (NSArray *)buidItemArrayWith:(JTUserInfo *)userInfo {
    self.userTags = userInfo.userTags;
    NSString *sign = ![userInfo.userSign isBlankString]?userInfo.userSign:@"未设置";
    NSString *company = ![userInfo.userCompany isBlankString]?userInfo.userCompany:@"未设置";
    NSString *profession = @"";
    if (self.professions.count) {
        NSDictionary *dict = self.professions[0];
        profession = dict[@"label_name"];
    } else {
        profession = @"未设置";
    }
    NSString *industry = @"";
    if (self.industrys.count) {
        NSDictionary *dict = self.industrys[0];
        industry = dict[@"label_name"];
    } else {
        industry = @"未设置";
    }
    if (self.professions.count) {
        NSDictionary *dict = self.professions[0];
        profession = dict[@"label_name"];
    } else {
        profession = @"未设置";
    }
    
    JTWordItem *item1 = [self createWordItem:@"昵称" subTitle:userInfo.userName accessoryType:UITableViewCellAccessoryDisclosureIndicator image:nil placeholder:@"请输入你的昵称" tags:nil tagType:JTTagTypeUnknow rowHeight:60];
    NSString *userGender = (userInfo.userGenter == JTUserGenderWoman )?@"女":@"男";
    JTWordItem *item2 = [self createWordItem:@"性别" subTitle:userGender accessoryType:UITableViewCellAccessoryNone image:nil placeholder:@"请输入你的性别" tags:nil tagType:JTTagTypeUnknow rowHeight:60];
    
    JTWordItem *item3 = [self createWordItem:@"生日" subTitle:userInfo.userBirth accessoryType:UITableViewCellAccessoryNone image:nil placeholder:@"请选择你的年龄" tags:nil tagType:JTTagTypeUnknow rowHeight:60];
    
    JTWordItem *item4 = [self createWordItem:@"行业" subTitle:industry accessoryType:UITableViewCellAccessoryDisclosureIndicator image:nil placeholder:@"添加所在行业" tags:self.industrys tagType:JTTagTypeIndustry rowHeight:60];
    
    JTWordItem *item5 = [self createWordItem:@"职业" subTitle:profession accessoryType:UITableViewCellAccessoryDisclosureIndicator image:nil placeholder:@"添加您的职业" tags:self.professions tagType:JTTagTypeProfession rowHeight:60];
    
    JTWordItem *item6 = [self createWordItem:@"公司" subTitle:company accessoryType:UITableViewCellAccessoryDisclosureIndicator image:nil placeholder:@"添加所在公司" tags:nil tagType:JTTagTypeUnknow rowHeight:60];
    
    JTWordItem *item7 = [self createWordItem:@"个性签名" subTitle:sign accessoryType:UITableViewCellAccessoryDisclosureIndicator image:nil placeholder:@"还未填写个性签名" tags:nil tagType:JTTagTypeUnknow rowHeight:60];
    
    JTWordItem *item8 = [self createWordItem:@"选择我的个性标签" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator image:[UIImage imageNamed:@"tag_char_icon"] placeholder:nil tags:self.characters tagType:JTTagTypeCharacter rowHeight:[JTTagsModel clculateRowHeight:self.characters]];
    
    JTWordItem *item9 = [self createWordItem:@"我喜欢的车" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator image:[UIImage imageNamed:@"tag_car_icon"] placeholder:nil tags:self.cars tagType:JTTagTypeCar rowHeight:[JTTagsModel clculateRowHeight:self.cars]];
    
    JTWordItem *item10 = [self createWordItem:@"我喜欢的音乐" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator image:[UIImage imageNamed:@"tag_music_icon"] placeholder:nil tags:self.musics tagType:JTTagTypeMusic rowHeight:[JTTagsModel clculateRowHeight:self.musics]];
    
    JTWordItem *item11 = [self createWordItem:@"我喜欢的电影" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator image:[UIImage imageNamed:@"tag_film_icon"] placeholder:nil tags:self.films tagType:JTTagTypeFilm rowHeight:[JTTagsModel clculateRowHeight:self.films]];
    
    JTWordItem *item12 = [self createWordItem:@"我喜欢的运动" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator image:[UIImage imageNamed:@"tag_move_icon"] placeholder:nil tags:self.sports tagType:JTTagTypeMove rowHeight:[JTTagsModel clculateRowHeight:self.sports]];
    
    return @[@[item1, item2, item3],
             @[item4, item5, item6, item7],
             @[item8],
             @[item9, item10, item11, item12]];
}

- (JTWordItem *)createWordItem:(NSString *)title subTitle:(NSString *)subTitle accessoryType:(UITableViewCellAccessoryType)accessoryType image:(UIImage *)image placeholder:(NSString *)placeholder tags:(NSMutableArray *)tags tagType:(JTTagType)tagType rowHeight:(CGFloat)rowHeight {
    JTWordItem *wordItem = [[JTWordItem alloc] init];
    wordItem.title = title;
    wordItem.subTitle = subTitle;
    wordItem.accessoryType = accessoryType;
    wordItem.image = image;
    wordItem.placeholder = placeholder;
    wordItem.tags = tags;
    wordItem.tagType = tagType;
    wordItem.cellHeight = rowHeight;
    return wordItem;
}

+ (CGFloat)clculateRowHeight:(NSArray *)labels {
    CGFloat hight = [JTHobbyTableViewCell getCellHeightWithTags:labels width:App_Frame_Width-70];
    return hight>60?hight:60;
}

- (NSMutableArray *)characters {
    if (!_characters) {
        _characters = [NSMutableArray array];
    }
    return _characters;
}

- (NSMutableArray *)cars {
    if (!_cars) {
        _cars = [NSMutableArray array];
    }
    return _cars;
}

- (NSMutableArray *)musics {
    if (!_musics) {
        _musics = [NSMutableArray array];
    }
    return _musics;
}

- (NSMutableArray *)films {
    if (!_films) {
        _films = [NSMutableArray array];
    }
    return _films;
}

- (NSMutableArray *)professions {
    if (!_professions) {
        _professions = [NSMutableArray array];
    }
    return _professions;
}

- (NSMutableArray *)sports {
    if (!_sports) {
        _sports = [NSMutableArray array];
    }
    return _sports;
}

- (NSMutableArray *)industrys {
    if (!_industrys) {
        _industrys = [NSMutableArray array];
    }
    return _industrys;
}

- (NSMutableArray *)commons {
    if (!_commons) {
        _commons = [NSMutableArray array];
    }
    return _commons;
}
@end

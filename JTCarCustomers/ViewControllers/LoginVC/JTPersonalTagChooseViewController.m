//
//  JTPersonalTagChooseViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGroupTool.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTImageTableViewCell.h"
#import "JTPersonalTagInputViewController.h"
#import "JTPersonalTagChooseViewController.h"

@implementation JTPersonalTagChooseHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        self.backgroundColor  = WhiteColor;
    }
    return self;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width - 15 , self.bounds.size.height)];
        _titleLabel.font = Font(24);
    }
    return _titleLabel;
}

@end

@interface JTPersonalTagChooseViewController ()<UITableViewDataSource>

@property (nonatomic, strong) JTPersonalTagChooseHeadView *headView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *seletedArrary;
@property (nonatomic, strong) NSMutableArray *tempIDs;
@property (nonatomic, strong) NSArray *tempTags;
@property (nonatomic, assign) JTChooseType chooseType;
@property (nonatomic, assign) BOOL showCar;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, copy) NSString *content;


@end

@implementation JTPersonalTagChooseViewController

- (void)dealloc {
    CCLOG(@"JTPersonalTagChooseViewController销毁了");
}

- (instancetype)initWithTitle:(NSString *)title tagType:(JTTagType)tagType indexPath:(NSIndexPath *)indexPath tags:(NSArray *)tags tagChoose:(ZTTagChooseBlock)zt_tagChooseBlock {
    if ([super init]) {
        _content = title;
        _tagType = tagType;
        _indexPath = indexPath;
        _tempTags = tags;
        if ([title isEqualToString:@"行业"] || [title isEqualToString:@"职业"])
        {
            _chooseType = JTSingleChooseType;
        }
        else
        {
            _chooseType = JTMultiChooseType;
        }
        _showCar = [title isEqualToString:@"我喜欢的车"];
        _rowHeight = _showCar?44:60;
        [self setZt_tagChooseBlock:zt_tagChooseBlock];
        if (tags && [tags isKindOfClass:[NSArray class]]) {
            __weak typeof(self)weakSelf = self;
            [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.tempIDs addObject:[NSString stringWithFormat:@"%@", [obj objectForKey:@"label_id"]]];
            }];
        }
        
    }
    return self;
}

- (void)setupPersonTagsNeedPop:(BOOL)flag {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetUserExtInfoApi) parameters:@{@"type" : @(self.tagType) , @"value" : [self.seletedArrary mj_JSONString]} success:^(id responseObject, ResponseState state) {
        if (weakSelf.zt_tagChooseBlock) {
            weakSelf.zt_tagChooseBlock(weakSelf.seletedArrary, weakSelf.indexPath);
        }
        NSString *kUserInfoUpdateNotificationName = @"kUserInfoUpdateNotificationName";
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdateNotificationName object:nil];
        if (flag) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:self.showCar?UITableViewStyleGrouped:UITableViewStylePlain tableFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.headView.frame)) rowHeight:self.rowHeight sectionHeaderHeight:self.showCar?25:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSectionIndexColor:BlackLeverColor3];
    [self.tableview registerClass:[JTImageTableViewCell class] forCellReuseIdentifier:imageTableIndentifier];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",self.content,(self.chooseType == JTSingleChooseType)?@"（单选）":@"（多选）"]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:NSMakeRange(attributeStr.length - 4, 4)];
    [attributeStr addAttribute:NSFontAttributeName value:Font(16) range:NSMakeRange(attributeStr.length - 4, 4)];
    self.headView.titleLabel.attributedText = attributeStr;
   
    __weak typeof(self)weakSelf = self;
    ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
    configParam.isEncrypt = YES;
    configParam.isNeedUserTokenAndUserID = YES;
    NSString *url = self.showCar?kBase_url(getCarBrandApi):kBase_url(GetSystemTagApi);
    NSDictionary *progem = self.showCar?nil:@{@"type" : @(self.tagType)};
    
    [[HttpRequestTool sharedInstance] startRequestURLString:url parameters:progem httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
        if ((responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]])) {
            if (weakSelf.showCar) {
                JTGroupTool *tool = [[JTGroupTool alloc] initWithGroupKey:@"bfirstletter" originalArray:responseObject[@"list"]];
                weakSelf.titleArray = tool.titleArray;
                weakSelf.dataArray = tool.memberArray;
            }
            else
            {
                NSArray *list = responseObject[@"list"];
                [weakSelf.dataArray addObjectsFromArray:list];
                if (weakSelf.tempIDs.count) {
                    [list enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *labelID = [NSString stringWithFormat:@"%@", [obj objectForKey:@"label_id"]];
                        if ([weakSelf.tempIDs containsObject:labelID]) {
                            [weakSelf.seletedArrary addObject:obj];
                            [weakSelf.tempIDs removeObject:labelID];
                        }
                    }];
                    if (weakSelf.tempIDs.count) {
                        [weakSelf.tempTags enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *labelID = [NSString stringWithFormat:@"%@", [obj objectForKey:@"label_id"]];
                            if ([weakSelf.tempIDs containsObject:labelID]) {
                                [weakSelf.seletedArrary insertObject:obj atIndex:0];
                                [weakSelf.dataArray insertObject:obj atIndex:0];
                            }
                        }];
                    }
                }
            }
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.showCar) {
        static NSString *personTagIdentfier = @"JTPersonalTagChooseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personTagIdentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personTagIdentfier];
            cell.textLabel.font = Font(16);
            cell.textLabel.textColor = BlackLeverColor5;
            UIImageView *checkBox = [[UIImageView alloc] init];
            [checkBox setHidden:YES];
            [checkBox setImage:[UIImage imageNamed:@"icon_accessory_selected"]];
            checkBox.frame = CGRectMake(App_Frame_Width-44, (self.rowHeight-22)/2.0, 22, 22);
            [checkBox setTag:10];
            [cell.contentView addSubview:checkBox];
        }
        UIImageView *checkBox = [cell viewWithTag:10];
        if (indexPath.row == 0)
        {
            [checkBox setHidden:YES];
            cell.textLabel.text = [NSString stringWithFormat:@"创建自定义%@标签",self.content];
            cell.imageView.image = [UIImage imageNamed:@"tag_add_icon"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dictionary = self.dataArray[indexPath.row-1];
            cell.textLabel.text = dictionary[@"label_name"];
            cell.imageView.image = nil;
            BOOL isContain = [self.seletedArrary containsObject:dictionary];
            [checkBox setHidden:!isContain];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else
    {
        NSDictionary *dictionary = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        JTImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageTableIndentifier];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:[dictionary[@"img"] avatarHandleWithSquare:60]]];
        [cell.titleLB setText:dictionary[@"name"]];
        BOOL isContain = [self.seletedArrary containsObject:dictionary];
        cell.accessoryType = isContain?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showCar) {
        NSArray *array = [self.dataArray objectAtIndex:section];
        return array.count;
    }
    else
    {
       return self.dataArray.count+1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showCar?self.dataArray.count:1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.showCar) {
        NSDictionary *dictionary = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        BOOL isContain = [self.seletedArrary containsObject:dictionary];
        if (isContain) {
            [self.seletedArrary removeObject:dictionary];
        } else {
            if (self.seletedArrary.count < JTMultiChooseType) {
                [self.seletedArrary addObject:dictionary];
            } else {
                [[HUDTool shareHUDTool] showHint:@"标签最多只能设置20个" yOffset:0];
            }
        }
        [self.tableview reloadData];
    }
    else
    {
        if (indexPath.row > 0)
        {
            if (self.chooseType == JTSingleChooseType)
            {
                //单选
                [self.seletedArrary removeAllObjects];
                [self.seletedArrary addObject:self.dataArray[indexPath.row-1]];
                [self setupPersonTagsNeedPop:YES];
            }
            else
            {
                //多选
                NSDictionary *dictionary = self.dataArray[indexPath.row-1];
                BOOL isContain = [self.seletedArrary containsObject:dictionary];
                if (isContain) {
                    [self.seletedArrary removeObject:dictionary];
                } else {
                    if (self.seletedArrary.count < JTMultiChooseType) {
                        [self.seletedArrary addObject:dictionary];
                    } else {
                        [[HUDTool shareHUDTool] showHint:@"标签最多只能设置20个" yOffset:0];
                    }
                }
                [self setupPersonTagsNeedPop:NO];
                
            }
            [self.tableview reloadData];
            
        }
        else
        {
            if (self.chooseType == JTSingleChooseType)
            {
                __weak typeof(self)weakSelf = self;
                [self.navigationController pushViewController:[[JTPersonalTagInputViewController alloc] initWithJTTagType:self.tagType tagInput:^(NSDictionary *dictionary) {
                    [weakSelf.seletedArrary removeAllObjects];
                    [weakSelf.dataArray insertObject:dictionary atIndex:0];
                    [weakSelf.seletedArrary insertObject:dictionary atIndex:0];
                    [weakSelf setupPersonTagsNeedPop:YES];
                }] animated:YES];
            }
            else
            {
                if (self.seletedArrary.count < JTMultiChooseType) {
                    __weak typeof(self)weakSelf = self;
                    [self.navigationController pushViewController:[[JTPersonalTagInputViewController alloc] initWithJTTagType:self.tagType tagInput:^(NSDictionary *dictionary) {
                        if (weakSelf.chooseType == JTSingleChooseType) {
                            [weakSelf.seletedArrary removeAllObjects];
                        }
                        [weakSelf.dataArray insertObject:dictionary atIndex:0];
                        [weakSelf.seletedArrary insertObject:dictionary atIndex:0];
                        [weakSelf setupPersonTagsNeedPop:NO];
                        [weakSelf.tableview reloadData];
                    }] animated:YES];
                } else {
                    [[HUDTool shareHUDTool] showHint:@"标签最多只能设置20个" yOffset:0];
                }
            }
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleArray;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.showCar) {
        ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
        footer.promptLB.text = self.titleArray[section];
        return footer;
    } else {
        return nil;
    }
}

- (JTPersonalTagChooseHeadView *)headView{
    if (!_headView) {
        _headView = [[JTPersonalTagChooseHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
    }
    return _headView;
}

- (NSMutableArray *)seletedArrary{
    if (!_seletedArrary) {
        _seletedArrary = [NSMutableArray array];
    }
    return _seletedArrary;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)tempIDs {
    if (!_tempIDs) {
        _tempIDs = [NSMutableArray array];
    }
    return _tempIDs;
}


@end

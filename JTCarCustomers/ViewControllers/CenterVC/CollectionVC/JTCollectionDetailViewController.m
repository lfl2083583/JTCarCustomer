//
//  JTCollectionDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ImageDisplayTool.h"
#import "JTMessageMaker.h"
#import "JTCollectionDetailTextTableViewCell.h"
#import "JTCollectionDetailImageTableViewCell.h"
#import "JTCollectionDetailVideoTableViewCell.h"
#import "JTCollectionDetailAudioTableViewCell.h"
#import "JTCollectionDetailExpressionTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTContracSelectViewController.h"
#import "JTCollectionDetailViewController.h"
#import "JTBaseNavigationController.h"
#import "JTTeamSelectViewController.h"
#import "JTPlayVideoViewController.h"

@interface JTCollectionDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) NIMMessage *message;

@end

@implementation JTCollectionDetailViewController

- (instancetype)initWithCollectionModel:(JTCollectionModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)rightBarButtonItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTCollectionModel *model = [weakSelf.dataArray objectAtIndex:0];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(delfavoriteApi) parameters:@{@"id": model.collectionID} placeholder:@"" success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"删除成功" yOffset:0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
        }];
    }]];
    if (self.model.collectionType != JTCollectionTypeAudio) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"转发至好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf repeateCollection:NIMSessionTypeP2P];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"转发至群" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf repeateCollection:NIMSessionTypeTeam];
        }]];
    }
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)repeateCollection:(NIMSessionType)sessionType {
   
    if (sessionType == NIMSessionTypeP2P) {
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeRepeatMessage;
        config.needMutiSelected = NO;
        config.source = self.message;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:self.message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
            }
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeRepeatMessage;
        config.needMutiSelected = NO;
        config.source = self.message;
        JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
        teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:self.message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
            }
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"详情"];
    self.view.backgroundColor = WhiteColor;
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:100 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setDataSource:self];
    self.tableview.backgroundColor = WhiteColor;
    [self.tableview registerClass:[JTCollectionDetailTextTableViewCell class] forCellReuseIdentifier:collectionDetailTextIdentifier];
    [self.tableview registerClass:[JTCollectionDetailImageTableViewCell class] forCellReuseIdentifier:collectionDetailImageIdentifier];
    [self.tableview registerClass:[JTCollectionDetailVideoTableViewCell class] forCellReuseIdentifier:collectionDetailVideoIdentifier];
    [self.tableview registerClass:[JTCollectionDetailExpressionTableViewCell class] forCellReuseIdentifier:collectionDetailExpressionIdentifier];
    [self.tableview registerClass:[JTCollectionDetailAudioTableViewCell class] forCellReuseIdentifier:collectionDetailAudioIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/user/favorite/favoriteInfo") parameters:@{@"favorite_id" : self.model.collectionID} success:^(id responseObject, ResponseState state) {
        [weakSelf.dataArray addObject:[JTCollectionModel mj_objectWithKeyValues:responseObject]];
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTCollectionTableViewCell * cell;
    if (self.model.collectionType == JTCollectionTypeText) {
        cell = [tableView dequeueReusableCellWithIdentifier:collectionDetailTextIdentifier];
    } else if (self.model.collectionType == JTCollectionTypeImage) {
        cell = [tableView dequeueReusableCellWithIdentifier:collectionDetailImageIdentifier];
    } else if (self.model.collectionType == JTCollectionTypeVideo) {
        cell = [tableView dequeueReusableCellWithIdentifier:collectionDetailVideoIdentifier];
    } else if (self.model.collectionType == JTCollectionTypeExpression) {
        cell = [tableView dequeueReusableCellWithIdentifier:collectionDetailExpressionIdentifier];
    } else if (self.model.collectionType == JTCollectionTypeAudio) {
        cell = [tableView dequeueReusableCellWithIdentifier:collectionDetailAudioIdentifier];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0;
    JTCollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.collectionType == JTCollectionTypeText) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionDetailTextIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionDetailTextTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeAudio) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionDetailAudioIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionDetailAudioTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeExpression) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionDetailExpressionIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionDetailExpressionTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeImage) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionDetailImageIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionDetailImageTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeVideo) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionDetailVideoIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionDetailVideoTableViewCell *cell) {
            cell.model = model;
        }];
    }

    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTCollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.collectionType == JTCollectionTypeImage) {
        
    }
    else if (model.collectionType == JTCollectionTypeVideo) {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video"];
        NSString *name = [NSString stringWithFormat:@"%@.mp4", [[model.contentDic objectForKey:@"url"] MD5String]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        JTPlayVideoViewController *playVideoVC = [[JTPlayVideoViewController alloc] initWithVideoUrl:[model.contentDic objectForKey:@"url"] videoPath:[path stringByAppendingPathComponent:name] coverUrl:[model.contentDic objectForKey:@"coverUrl"] coverPath:@"" longPressBlock:^(UIViewController *viewController) {
            
        }];
        playVideoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:playVideoVC animated:YES completion:nil];
        
    }
}

- (NIMMessage *)message {
    if (!_message) {
        if (self.dataArray.count) {
            JTCollectionModel *model = [self.dataArray objectAtIndex:0];
            if (model.collectionType == JTCollectionTypeText) {
                _message = [JTMessageMaker messageWithText:model.contentDic[@"text"]];
            }
            else if (model.collectionType == JTCollectionTypeExpression) {
                _message = [JTMessageMaker messageWithExpression:@"" expressionName:model.contentDic[@"name"] expressionUrl:model.contentDic[@"image"] expressionThumbnail:model.contentDic[@"thumbnail"] expressionWidth:model.contentDic[@"width"] expressionHeight:model.contentDic[@"height"]];
            }
            else if (model.collectionType == JTCollectionTypeImage) {
                _message = [JTMessageMaker messageWithImageUrl:model.contentDic[@"image"] imageThumbnail:model.contentDic[@"thumbnail"] imageWidth:model.contentDic[@"width"] imageHeight:model.contentDic[@"height"]];
                
            }
            else if (model.collectionType == JTCollectionTypeVideo) {
                _message = [JTMessageMaker messageWithVideoUrl:model.contentDic[@"url"] videoCoverUrl:model.contentDic[@"coverUrl"] videoWidth:model.contentDic[@"width"] videoHeight:model.contentDic[@"height"]];
            }
        }
        else
        {
            _message = [[NIMMessage alloc] init];
        }
    }
    return _message;
}

@end

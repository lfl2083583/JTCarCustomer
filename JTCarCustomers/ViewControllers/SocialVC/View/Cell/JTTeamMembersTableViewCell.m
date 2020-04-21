//
//  JTTeamMembersTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMemberCollectionViewCell.h"
#import "JTTeamMembersTableViewCell.h"

@interface JTTeamMembersTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *leftLB;
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation JTTeamMembersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    self.leftLB = [[UILabel alloc] initWithFrame:CGRectMake(22, 18, 120, 20)];
    self.leftLB.font = Font(16);
    self.leftLB.text = @"群聊成员";
    self.leftLB.textColor = BlackLeverColor5;
    [self.contentView addSubview:self.leftLB];
    
    self.rightLB = [[UILabel alloc] initWithFrame:CGRectMake(App_Frame_Width-150, 18, 120, 20)];
    self.rightLB.font = Font(16);
    self.rightLB.textAlignment = NSTextAlignmentRight;
    self.rightLB.textColor = BlackLeverColor3;
    [self.contentView addSubview:self.rightLB];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 18, 12, 15)];
    self.rightImageView.image = [UIImage imageNamed:@"arrow_right_icon"];
    self.rightImageView.hidden = YES;
    self.rightImageView.alpha = 0.8;
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightImageView.centerY = self.rightLB.centerY;
    [self.contentView addSubview:self.rightImageView];
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.scrollEnabled = NO;
    
    [self.collectionview registerClass:[JTMemberCollectionViewCell class] forCellWithReuseIdentifier:memberIdentifier];
    [self.contentView addSubview:self.collectionview];
    
    self.itemCount = 2;
    self.collectionview.frame = CGRectMake(0, 38, self.bounds.size.width, self.bounds.size.height);
    
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionview.frame = CGRectMake(0, 38, self.bounds.size.width, self.bounds.size.height);
}

- (void)configMembersWithSession:(NIMSession *)session delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate {
    [self configMembersWithSession:session powerModel:nil delegate:delegate];
}

- (void)configMembersWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate {
    self.session = session;
    self.delegate = delegate;
    self.powerModel = powerModel;
    if (self.session.sessionType == NIMSessionTypeP2P) {
        self.powerModel.isInvitePower = YES;
    }
    else
    {
        self.rightImageView.hidden = NO;
        [self reloadTeamData];
    }
}

- (void)configMembersWithSession:(NIMSession *)session teamMembers:(NSArray *)members isVisitor:(BOOL)isVisitor delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate {
    self.session = session;
    self.delegate = delegate;
    self.isVisitor = isVisitor;
    self.itemCount = members.count;
    [self.showMembers removeAllObjects];
    [self.showMembers addObjectsFromArray:members];
    self.rightLB.text = [NSString stringWithFormat:@"共%ld人",members.count];
    [self.collectionview reloadData];
    self.rightImageView.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(teamDetailHeaderViewLoadComplete)]) {
        [self.delegate teamDetailHeaderViewLoadComplete];
    }
}

- (void)reloadTeamData
{
    __weak typeof(self) weakself = self;
    [weakself.members removeAllObjects];
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError *error, NSArray *members) {
        
        weakself.itemCount = (weakself.powerModel.isGroupMain)?1:(weakself.powerModel.isInvitePower);
        [weakself.members removeAllObjects];
        [weakself.showMembers removeAllObjects];
        NSInteger count = MIN(45-weakself.itemCount, members.count);
        [weakself.members addObjectsFromArray:members];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == 1"];
        NSArray *array = [weakself.members filteredArrayUsingPredicate:predicate];
        if (array.count) {
            id object = array.firstObject;
            [weakself.members removeObject:object];
            [weakself.members insertObject:object atIndex:0];
        }
        [weakself.showMembers addObjectsFromArray:[weakself.members subarrayWithRange:NSMakeRange(0, count)]];
        weakself.itemCount += weakself.showMembers.count;
        weakself.rightLB.text = [NSString stringWithFormat:@"共%ld人",members.count];
        [weakself.collectionview reloadData];
        
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(teamDetailHeaderViewLoadComplete)]) {
            [weakself.delegate teamDetailHeaderViewLoadComplete];
        }
    }];
}

+ (CGFloat)getCellHeightWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel  isVisitor:(BOOL)isVisitor teamMembersCount:(NSInteger)teamMembersCount
{
   
    NSInteger count;
    if (!isVisitor) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
        count = ((powerModel.isGroupMain)?1:(powerModel.isInvitePower))+team.memberNumber;
    }
    else
    {
        count = teamMembersCount;
    }
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(50, 80);
    float space = floorf((App_Frame_Width-250)/6.0);
    layout.sectionInset = UIEdgeInsetsMake(space/2, space, space/2, space);
    layout.minimumInteritemSpacing = space;
    NSInteger rows = ceilf(count/5.0);
    CGFloat height = rows*(layout.itemSize.height+layout.sectionInset.top)+((rows == 1)?layout.sectionInset.top:0)+38;
    return height;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:memberIdentifier forIndexPath:indexPath];
    if (self.session.sessionType == NIMSessionTypeP2P) {
        if (indexPath.row == 0) {
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId];
            [cell.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:100] defaultImage:DefaultSmallAvatar];
            [cell.nameLB setText:[JTUserInfoHandle showNick:user member:nil]];
        }
        else
        {
            [cell.avatar setImage:[UIImage imageNamed:@"group_addperson"]];
            [cell.nameLB setText:@""];
        }
    }
    else
    {
        if (!self.isVisitor) {
            if (indexPath.row < self.showMembers.count) {
                NIMTeamMember *member = [self.showMembers objectAtIndex:indexPath.row];
                NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
                [cell.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:100] defaultImage:[UIImage imageNamed:@"nav_default"]];
                [cell.nameLB setText:[JTUserInfoHandle showNick:user member:member]];
            }
            else if (indexPath.row == self.showMembers.count && (self.powerModel.isInvitePower || self.powerModel.isGroupMain)) {
                [cell.avatar setImage:[UIImage imageNamed:@"group_addperson"]];
                [cell.nameLB setText:@""];
            }
        }
        else
        {
            NSDictionary *dictionary = [self.showMembers objectAtIndex:indexPath.row];
            [cell.avatar setAvatarByUrlString:[dictionary[@"avatar"]?dictionary[@"avatar"]:@"" avatarHandleWithSquare:100] defaultImage:[UIImage imageNamed:@"nav_default"]];
            [cell.nameLB setText:dictionary[@"nick_name"]];
        }
        

    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.itemCount;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.session.sessionType == NIMSessionTypeP2P) {
        if (indexPath.row == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(teamDetailMembersCell:clickTeamUserID:)]) {
                [_delegate teamDetailMembersCell:self clickTeamUserID:self.session.sessionId];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(teamDetailMembersCell:clickTeamOperation:)]) {
                [_delegate teamDetailMembersCell:self clickTeamOperation:JTTeamOperationTypeAdd];
            }
        }
    }
    else
    {
        if (indexPath.row < self.showMembers.count) {
            NSString *userID;
            if (!self.isVisitor) {
                NIMTeamMember *member = [self.showMembers objectAtIndex:indexPath.row];
                userID = member.userId;
            }
            else
            {
                NSDictionary *dictionary = [self.showMembers objectAtIndex:indexPath.row];
                userID = [dictionary objectForKey:@"accid"];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(teamDetailMembersCell:clickTeamUserID:)]) {
                [_delegate teamDetailMembersCell:self clickTeamUserID:userID];
            }
        }
        else if (indexPath.row == self.showMembers.count && (self.powerModel.isInvitePower || self.powerModel.isGroupMain))
        {
            if (_delegate && [_delegate respondsToSelector:@selector(teamDetailMembersCell:clickTeamOperation:)]) {
                [_delegate teamDetailMembersCell:self clickTeamOperation:JTTeamOperationTypeAdd];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(teamDetailMembersCell:clickTeamOperation:)]) {
                [_delegate teamDetailMembersCell:self clickTeamOperation:JTTeamOperationTypeDel];
            }
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)members
{
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}

- (NSMutableArray *)showMembers
{
    if (!_showMembers) {
        _showMembers = [NSMutableArray array];
    }
    return _showMembers;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(50, 80);
        float space = floorf((App_Frame_Width - 250) / 6.0);
        _layout.sectionInset = UIEdgeInsetsMake(space/2, space, space/2, space);
        _layout.minimumInteritemSpacing = space;
    }
    return _layout;
}
@end

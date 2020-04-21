//
//  JTPersonalTagChooseViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef NS_ENUM(NSInteger, JTTagType)
{
    JTTagTypeUnknow      = 0,//未知类型
    JTTagTypeMusic       = 1,//音乐
    JTTagTypeFilm        = 2,//电影
    JTTagTypeIndustry    = 3,//行业
    JTTagTypeMove        = 4,//运动
    JTTagTypeCharacter   = 5,//性格
    JTTagTypeProfession  = 6,//职业
    JTTagTypeCar         = 7,//车
    
};

typedef NS_ENUM(NSInteger, JTChooseType)
{
    JTSingleChooseType       = 1, //单选
    JTMultiChooseType        = 20,//多选
};

typedef void (^ZTTagChooseBlock) (NSArray<NSDictionary *> *tags,NSIndexPath *indexPath);

@interface JTPersonalTagChooseHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface JTPersonalTagChooseViewController : BaseRefreshViewController

@property (nonatomic, copy) ZTTagChooseBlock zt_tagChooseBlock;

@property (nonatomic, assign) JTTagType tagType;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithTitle:(NSString *)title tagType:(JTTagType)tagType indexPath:(NSIndexPath *)indexPath tags:(NSArray *)tags tagChoose:(ZTTagChooseBlock)zt_tagChooseBlock;

@end

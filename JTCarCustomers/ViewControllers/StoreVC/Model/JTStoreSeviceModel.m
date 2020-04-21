//
//  JTStoreSeviceModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreSeviceModel.h"

@interface JTStoreSeviceModel ()

@property (assign, nonatomic) CGFloat cellWidth;

@end

@implementation JTStoreSeviceModel

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    JTStoreSeviceModel *model = [[[self class] allocWithZone:zone] init];
    model.serviceID = [_serviceID mutableCopy];
    model.classID = [_classID mutableCopy];
    model.mainID = [_mainID mutableCopy];
    model.disable = _disable;
    model.status = _status;
    model.name = [_name mutableCopy];
    model.introduce = [_introduce mutableCopy];
    model.maxPrice = _maxPrice;
    model.minPrice = _minPrice;
    model.price = _price;
    model.maxGoodsPrice = _maxGoodsPrice;
    model.minGoodsPrice = _minGoodsPrice;
    model.goodsPrice = _goodsPrice;
    model.maxWorksPrice = _maxWorksPrice;
    model.minWorksPrice = _minWorksPrice;
    model.worksPrice = _worksPrice;
    model.storeGoodsModel = [[NSArray alloc] initWithArray:self.storeGoodsModel copyItems:YES];
    
    model.bottomFrame = _bottomFrame;
    model.choiceFrame = _choiceFrame;
    model.editFrame = _editFrame;
    model.titleFrame = _titleFrame;
    model.priceFrame = _priceFrame;
    model.goodsPriceFrame = _goodsPriceFrame;
    model.worksPriceFrame = _worksPriceFrame;
    model.detailFrame = _detailFrame;
    
    model.cellHeight = _cellHeight;
    return model;
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"storeGoodsModel": [JTStoreGoodsModel class]
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"serviceID"        : @"s_id",
             @"classID"          : @"c_id",
             @"mainID"           : @"main_id",
             @"disable"          : @"disable",
             @"status"           : @"status",
             @"name"             : @"name",
             @"introduce"        : @"introduce",
             @"maxPrice"         : @"price_max",
             @"minPrice"         : @"price_min",
             @"price"            : @"spec_price",
             @"maxGoodsPrice"    : @"goods_price_max",
             @"minGoodsPrice"    : @"goods_price_min",
             @"goodsPrice"       : @"spec_goods_price",
             @"maxWorksPrice"    : @"hours_price_max",
             @"minWorksPrice"    : @"hours_price_min",
             @"worksPrice"       : @"spec_hours_price",
             @"storeGoodsModel"  : @"goods_list",
             };
}

- (CGRect)bottomFrame
{
    if (CGRectEqualToRect(_bottomFrame, CGRectZero)) {
        _bottomFrame = CGRectMake(5, 0, self.cellWidth-10, CGRectGetMaxY(self.detailFrame)+15);
    }
    return _bottomFrame;
}

- (CGRect)choiceFrame
{
    if (CGRectEqualToRect(_choiceFrame, CGRectZero)) {
        _choiceFrame = CGRectMake(self.cellWidth-54, 0, 44, 44);
    }
    return _choiceFrame;
}

- (CGRect)editFrame
{
    if (CGRectEqualToRect(_editFrame, CGRectZero)) {
        _editFrame = CGRectMake(self.cellWidth-98, 0, 44, 44);
    }
    return _editFrame;
}

- (CGRect)titleFrame
{
    if (CGRectEqualToRect(_titleFrame, CGRectZero)) {
        _titleFrame = CGRectMake(10, 15, CGRectGetMinX(self.editFrame)-20, 20);
    }
    return _titleFrame;
}

- (CGRect)priceFrame
{
    if (CGRectEqualToRect(_priceFrame, CGRectZero)) {
        if (self.price > 0 || (self.maxPrice > 0 && self.minPrice > 0)) {
            _priceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.titleFrame), CGRectGetMinX(self.choiceFrame)-20, 20);
        }
        else
        {
            _priceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.titleFrame), 0, 0);
        }
    }
    return _priceFrame;
}

- (CGRect)goodsPriceFrame
{
    if (CGRectEqualToRect(_goodsPriceFrame, CGRectZero)) {
        if (self.goodsPrice > 0 || (self.maxGoodsPrice > 0 && self.minGoodsPrice > 0)) {
            _goodsPriceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.titleFrame), CGRectGetMinX(self.choiceFrame)-20, 20);
        }
        else
        {
            _goodsPriceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.titleFrame), 0, 0);
        }
    }
    return _goodsPriceFrame;
}

- (CGRect)worksPriceFrame
{
    if (CGRectEqualToRect(_worksPriceFrame, CGRectZero)) {
        if ((self.worksPrice > 0 || (self.maxWorksPrice > 0 && self.minWorksPrice > 0)) && self.status) {
            _worksPriceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.goodsPriceFrame), CGRectGetMinX(self.choiceFrame)-20, 20);
        }
        else
        {
            _worksPriceFrame = CGRectMake(self.titleFrame.origin.x, CGRectGetMaxY(self.goodsPriceFrame), 0, 0);
        }
    }
    return _worksPriceFrame;
}

- (CGRect)detailFrame
{
    if (CGRectEqualToRect(_detailFrame, CGRectZero)) {
        CGSize size = [Utility getTextString:self.introduce textFont:Font(14) frameWidth:self.cellWidth-30 attributedString:nil];
        _detailFrame = CGRectMake(self.titleFrame.origin.x, MAX(CGRectGetMaxY(self.priceFrame), CGRectGetMaxY(self.worksPriceFrame))+15, size.width, size.height);
    }
    return _detailFrame;
}

- (CGFloat)cellWidth
{
    if (_cellWidth == 0) {
        _cellWidth = App_Frame_Width-100;
    }
    return _cellWidth;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        _cellHeight = CGRectGetMaxY(self.bottomFrame);
    }
    return _cellHeight;
}

@end

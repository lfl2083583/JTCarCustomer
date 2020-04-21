//
//  JTSessionTool.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTSessionMessageModel.h"

@interface JTSessionTool : NSObject

@property (weak, nonatomic) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

/*****点击更多*****/

- (void)mediaBonusPressed:(id)sender;

- (void)mediaCardPressed:(id)sender;

- (void)mediaCollectionPressed:(id)sender;

- (void)mediaVideoChatPressed:(id)sender;

- (void)mediaLocationPressed:(id)sender;


//*****点击Cell*****/

- (void)cellImagePressed:(NIMMessage *)message;

- (void)cellAudioPressed:(NIMMessage *)message;

- (void)cellVideoPressed:(NIMMessage *)message;

- (void)cellLocationPressed:(NIMMessage *)message;

- (void)cellNetCallPressed:(NIMMessage *)message;

- (void)cellExpressionPressed:(JTExpressionAttachment *)attachment;

- (void)cellCardPressed:(JTCardAttachment *)attachment;

- (void)cellBonusPressed:(JTBonusAttachment *)attachment message:(NIMMessage *)message;

- (void)cellCallBonusPressed:(JTCallBonusAttachment *)attachment;

- (void)cellNetworkVideoPressed:(JTVideoAttachment *)attachment message:(NIMMessage *)message;

- (void)cellGroupPressed:(JTGroupAttachment *)attachment;

- (void)cellInformationPressed:(JTInformationAttachment *)attachment;

- (void)cellActivityPressed:(JTActivityAttachment *)attachment;

- (void)cellShopPressed:(JTShopAttachment *)attachment;

/*****enum事件*****/

- (void)enumItemRemovePressed:(NIMMessage *)message;

- (void)enumItemBanPressed:(NIMMessage *)message;

- (void)enumItemCancelBanPressed:(NIMMessage *)message;

- (void)enumItemSelectedPressed:(NIMMessage *)message;

- (void)enumItemCopyPressed:(NIMMessage *)message;

- (void)enumItemRepeatPressed:(NIMMessage *)message;

- (void)enumItemCollectionPressed:(NIMMessage *)message;

- (void)enumItemRevokePressed:(NIMMessage *)message;

- (void)enumItemDeletePressed:(NIMMessage *)message;

- (void)enumItemAddPressed:(NIMMessage *)message;

- (void)enumItemMultiselectPressed:(NIMMessage *)message;
@end

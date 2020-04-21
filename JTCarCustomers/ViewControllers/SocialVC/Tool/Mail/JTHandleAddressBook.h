//
//  JTHandleAddressBook.h
//  JTSocial
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AddressBookInfoBlock)(NSMutableDictionary *personInfoDictionary);

@interface JTHandleAddressBook : NSObject

/**
 *  手机授权App用户获取通讯录权限
 *  想装逼可以用block传值，不想装逼可以直接用返回值的方式传递通讯录内容
 */
+ (void)addressBookAuthorization:(AddressBookInfoBlock)block;

@end

//
//  JTHandleAddressBook.m
//  JTSocial
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTHandleAddressBook.h"
#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>

#define iOS9_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 ? YES : NO

@implementation JTHandleAddressBook

#pragma mark -- 授权
//授权
+ (void)addressBookAuthorization:(AddressBookInfoBlock)block
{
    if(iOS9_LATER) // 在iOS9之后获取通讯录用CNContactStore
    {
        // 已经授权了 直接返回
        if([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
        {
            [self fetchAddressBookInformation:block];
            return;
        }
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if(granted) {
                [self fetchAddressBookInformation:block];
            }
            else
            {
                [Utility showAlertMessage:@"没有获取通讯录权限,请到通用里面去设置"];
            }
        }];
    }
    else // 在iOS9之前 用ABAddressBookRef获取通讯录
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if(status == kABAuthorizationStatusAuthorized) //已经授权了 直接返回
        {
            [self fetchAddressBookInformation:block];
            return;
        }
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if(granted) {
                [self fetchAddressBookInformation:block];
            }
            else
            {
                [Utility showAlertMessage:@"没有获取通讯录权限,请到通用里面去设置"];
            }
        });
#pragma clang diagnostic pop
    }
}


#pragma mark -- 获取联系人信息
/**
 *  获取通讯录中信息
 */
+ (void)fetchAddressBookInformation:(AddressBookInfoBlock)block
{
    if(iOS9_LATER) {
        [self fetchAddressBookInformationWhenSystemVersionIsiOS9_later:block];
    }
    else
    {
        [self fetchAddressBookInformationWhenSystemVersionIsiOS9_before:block];
    }
}

/**
 *  iOS9之后获取通讯录信息的方法
 */
+ (void)fetchAddressBookInformationWhenSystemVersionIsiOS9_later:(AddressBookInfoBlock)block
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    // 由keys决定获取联系人的那些信息：姓名 手机号
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    NSError *error = nil;
    [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        // 联系人姓名
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName ? contact.familyName : @"", contact.givenName ? contact.givenName : @""];
        name = name ? name : @"你叫啥呢";
        
        // 联系人手机号
        for(CNLabeledValue *labeledValue in contact.phoneNumbers)
        {
            CNPhoneNumber *phoneNumber = labeledValue.value;
            NSString *phone = phoneNumber.stringValue ? phoneNumber.stringValue : @"我也不知道";
            phone = [[[phone stringByReplacingOccurrencesOfString:@"+86" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

            if (name && phone) {
                [dictionary setObject:name forKey:phone];
            }
        }
    }];
    // 把获取到的联系人信息传过去
    block(dictionary);
}

/**
 *  iOS9之前获取通讯录信息的方法
 */
+ (void)fetchAddressBookInformationWhenSystemVersionIsiOS9_before:(AddressBookInfoBlock)block
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // 创建通讯录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 从通讯录中将所有人的信息拷贝出来
    CFArrayRef allPersonInfoArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 获取联系人的个数
    CFIndex personCount = CFArrayGetCount(allPersonInfoArray);
    
    for(int i = 0; i < personCount; i ++)
    {
        // 获取其中每个联系人的信息
        ABRecordRef person = CFArrayGetValueAtIndex(allPersonInfoArray, i);
        
        // 联系人姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
        name = name ? name : @"你叫啥呢";
        
        // 联系人电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCout = ABMultiValueGetCount(phones);
        for(int j = 0; j < phoneCout; j ++)
        {
            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            phone = phone ? phone : @"我也不知道";
            phone = [[[phone stringByReplacingOccurrencesOfString:@"+86" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

            if (name && phone) {
                [dictionary setObject:name forKey:phone];
            }
        }
        CFRelease(phones);
    }
    // 把获取到的联系人信息传过去
    block(dictionary);
    
    CFRelease(allPersonInfoArray);
    CFRelease(addressBook);
#pragma clang diagnostic pop
}
@end

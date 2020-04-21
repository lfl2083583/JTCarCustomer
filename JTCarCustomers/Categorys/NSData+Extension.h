//
//  NSData+Extension.h
//  JTSocial
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)

- (NSString *)writeDocumentsFolderName:(NSString *)folderName fileName:(NSString *)fileName;

- (NSString *)MD5String;

@end

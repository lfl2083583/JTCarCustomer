//
//  JTCallOnViewController.h
//  JTSocial
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCallViewController.h"

@interface JTCallOnViewController : JTCallViewController

- (instancetype)initWithNetCallMediaType:(NIMNetCallMediaType)callType caller:(NSString *)caller callId:(uint64_t)callID;

@end

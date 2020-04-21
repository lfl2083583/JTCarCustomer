//
//  JTInputGlobal.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#ifndef JTInputGlobal_h
#define JTInputGlobal_h

#define input_placeholder      @"请输入"
#define input_maxLength        1000
#define input_enterMaxHeight   45   // 文字输入框无文字默认最大高度
#define input_functionWidth    47   // 功能按钮宽度
#define input_functionHeight   47   // 功能按钮高度
#define input_functionSpacing  10   // 工具条间隔
#define input_textPadding      15   // 文字输入框上线左右间隔
#define input_containerHeight  271  // 容器高度
#define input_bottomToolHeight 44   // 底部工具的高度
#define recordMaxDuration      60   // 录音的最大时长
#define recordMinDuration      1    // 录音的最小时长

#define JTKit_ExpressionEmoji                                  @"Emoji"

#define JTKit_EmojCellHeight       45.0
#define JTKit_EmojCellWidth        45.0
#define JTKit_EmojImageHeight      28.0
#define JTKit_EmojImageWidth       28.0

#define JTKit_PhotoCellHeight        80.0
#define JTKit_PhotoCellWidth         80.0
#define JTKit_PhotoImageHeight       60.0
#define JTKit_PhotoImageWidth        60.0

#define ResourceBundleName     @"JTKitResource.bundle"
#define EmoticonBundleName     @"JTKitEmoticon.bundle"

#define JTKit_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* JTInputGlobal_h */

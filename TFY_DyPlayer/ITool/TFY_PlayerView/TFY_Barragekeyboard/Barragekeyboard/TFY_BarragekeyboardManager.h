//
//  TFY_BarragekeyboardManager.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ChatBoxConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ChatBoxStatus) {
    ChatBoxStatusNothing,     // 默认状态
    ChatBoxStatusShowVoLXe,   // 录音状态
    ChatBoxStatusShowFace,    // 输入表情状态
    ChatBoxStatusShowMore,    // 显示“更多”页面状态
    ChatBoxStatusShowKeyboard,// 正常键盘
    ChatBoxStatusShowVideo    // 录制视频
};
@protocol ChatBoxDelegate <NSObject>

-(void)changeStatusChat:(CGFloat)chatBoxY;
-(void)chatBoxSendTextMessage:(NSString *)message;

@end

@interface TFY_BarragekeyboardManager : UIView

@property(nonatomic,assign)ChatBoxStatus status;

@property(nonatomic,assign)NSInteger maxVisibleLine;

@property(nonatomic,weak)id<ChatBoxDelegate>delegate;

/**弹出键盘*/
- (void)popToolbar;
@end

NS_ASSUME_NONNULL_END

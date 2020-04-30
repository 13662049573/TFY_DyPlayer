//
//  UIControl+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/12/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (TFY_Chain)
/**添加事件*/
- (void)addControlEvents:(UIControlEvents)controlEvents withAction:(void(^)(id sender))action;

/**移除事件*/
- (void)removeControlEvents:(UIControlEvents)controlEvents;

/**添加事件 for key*/
- (void)addControlEvents:(UIControlEvents)controlEvents withAction:(void(^)(id sender))action forKey:(NSString *__nullable)key;

/**移除事件 for key*/
- (void)removeControlEvents:(UIControlEvents)controlEvents forKey:(NSString *__nullable)key;

/**添加点击事件 UIControlEventTouchUpInside*/
- (void)addAction:(void(^)(id sender))action;

/**移除点击事件 UIControlEventTouchUpInside*/
- (void)removeAction;

/**移除全部事件*/
- (void)removeAllActions;
@end

NS_ASSUME_NONNULL_END

//
//  UIWindow+TFY_Chain.h
//  TFY_Category
//
//  Created by tiandengyou on 2020/3/27.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TFY_Chain)
- (void)showOnCurrentScene;

- (void)showOnScene:(id)scene;
@end

NS_ASSUME_NONNULL_END

//
//  UIButton+ButtonItem.h
//  TFY_Navigation
//
//  Created by tiandengyou on 2020/4/7.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ButtonImageDirection) {
    ButtonImageDirectionTop,
    ButtonImageDirectionLeft,
    ButtonImageDirectionRight,
    ButtonImageDirectionBottom,
};

@interface UIButton (ButtonItem)

- (void)imageDirection:(ButtonImageDirection)direction space:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END

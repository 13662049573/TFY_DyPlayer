//
//  TfySY_TabBarBadge.h
//  TFY_TabarController
//
//  Created by tiandengyou on 2019/11/25.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TfySY_TabBarDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface TfySY_TabBarBadge : UILabel
/**文字或者数字*/
@property (nonatomic, strong) NSString *badgeText;
/**为零是否自动隐藏 默认不隐藏*/
@property(nonatomic, assign)BOOL automaticHidden;
/**气泡高度，默认15*/
@property(nonatomic, assign)CGFloat badgeHeight;
/**气泡宽度，默认0 设置宽度后由你来决定要多宽*/
@property(nonatomic , assign)CGFloat badgeWidth;
@end

NS_ASSUME_NONNULL_END

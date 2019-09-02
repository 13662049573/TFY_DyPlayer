//
//  TFY_SpeedLoadingView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_SpeedLoadingView : UIView
/**
 *  开始菊花带网速监听
 */
- (void)startAnimating;
/**
 *  结束菊花带网速监听
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END

//
//  TFY_PlayerTopBar.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PlayerToolsHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlayerTopBarDelegate <NSObject>
/**
 *  返回按钮
 */
-(void)topBarBackBtnClicked;
/**
 * 分享
 */
-(void)report_btnClick;
@end


@interface TFY_PlayerTopBar : UIView

@property(weak,nonatomic) id<PlayerTopBarDelegate>delegate;
/**
 *  头部文本标题
 */
@property(nonatomic , copy)NSString *title_string;

@end

NS_ASSUME_NONNULL_END

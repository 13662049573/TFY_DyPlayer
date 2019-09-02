//
//  TFY_PlayerVideoherderView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PlayerVideo_Model.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HerderDelegate <NSObject>
@optional
/*功能实现方法*/
-(void)CollectionDelegateClick:(BOOL)selected;

@end

@interface TFY_PlayerVideoherderView : UIView

@property (nonatomic,assign) id <HerderDelegate> delegate;

@property (nonatomic, strong)VideoData *models;

@property (nonatomic, strong)UIImageView *coverImageView;

+(CGFloat)heerderCGFlot:(NSString *)text;

@property (nonatomic, assign)BOOL selected_btn;
@end

NS_ASSUME_NONNULL_END

//
//  TFY_InputboxView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_InputboxView : UIView

@property (nonatomic, copy) void(^phonefiledBlock)(NSString *text);

@property (nonatomic, copy) void(^passwordfiledBlock)(NSString *text);

@property (nonatomic , copy)NSString *phone_str;

@property (nonatomic , copy)NSString *password_str;

@property (nonatomic , copy)NSString *phonetext_str;
@end

NS_ASSUME_NONNULL_END

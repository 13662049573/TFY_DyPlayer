//
//  TFY_Displayprompt.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/17.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_Displayprompt : NSObject

+(instancetype)showWithdisplayprompt:(UIView *)backView back_imageView:(NSString *)imagestr WithCGSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

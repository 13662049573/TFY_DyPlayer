//
//  NSNumber+TFY_Number.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (TFY_Number)
/**
 * 字符串转换为 NSNumber，转换失败返回nil
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END

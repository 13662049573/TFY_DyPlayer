//
//  TFY_ImagePicker.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ImagePickerFinishAction)(UIImage * _Nonnull image,NSString * _Nonnull imageName);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImagePicker : NSObject
/**
 * 用于present UIImagePickerController对象
 * allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction;
@end

NS_ASSUME_NONNULL_END

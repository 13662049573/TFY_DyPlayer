//
//  TFY_KVOController.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_KVOController : NSObject

- (instancetype _Nonnull)initWithTarget:(NSObject * _Nonnull)target;

- (void)safelyAddObserver:(NSObject * _Nonnull)observer forKeyPath:(NSString * _Nonnull)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;


- (void)safelyRemoveObserver:(NSObject * _Nonnull)observer forKeyPath:(NSString * _Nonnull)keyPath;

- (void)safelyRemoveAllObservers;
@end

NS_ASSUME_NONNULL_END

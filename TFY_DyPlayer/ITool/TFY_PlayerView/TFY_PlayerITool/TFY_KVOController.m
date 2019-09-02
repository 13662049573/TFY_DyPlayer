//
//  TFY_KVOController.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_KVOController.h"

@interface TFY_KVOEntry : NSObject
@property (nonatomic, weak)   NSObject *observer;
@property (nonatomic, strong) NSString *keyPath;

@end

@implementation TFY_KVOEntry
@synthesize observer;
@synthesize keyPath;

@end

@interface TFY_KVOController ()
@property (nonatomic, weak) NSObject *target;
@property (nonatomic, strong) NSMutableArray *observerArray;
@end

@implementation TFY_KVOController

- (instancetype)initWithTarget:(NSObject *_Nonnull)target {
    self = [super init];
    if (self) {
        _target = target;
        _observerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)safelyAddObserver:(NSObject * _Nonnull)observer forKeyPath:(NSString * _Nonnull)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    NSObject *target = _target;
    if (target == nil) return;
    
    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        // duplicated register
        NSLog(@"duplicated observer");
    }
    
    @try {
        [target addObserver:observer forKeyPath:keyPath options:options context:context];
        
        TFY_KVOEntry *entry = [[TFY_KVOEntry alloc] init];
        entry.observer = observer;
        entry.keyPath  = keyPath;
        [_observerArray addObject:entry];
    } @catch (NSException *e) {
        NSLog(@"ZFKVO: failed to add observer for %@\n", keyPath);
    }
}

- (void)safelyRemoveObserver:(NSObject * _Nonnull)observer
                  forKeyPath:(NSString * _Nonnull)keyPath {
    NSObject *target = _target;
    if (target == nil) return;
    
    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        // duplicated register
        NSLog(@"duplicated observer");
    }
    
    @try {
        if (removed) {
            [target removeObserver:observer
                        forKeyPath:keyPath];
        }
    } @catch (NSException *e) {
        NSLog(@"ZFKVO: failed to remove observer for %@\n", keyPath);
    }
}

- (void)safelyRemoveAllObservers {
    __block NSObject *target = _target;
    if (target == nil) return;
    [_observerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TFY_KVOEntry *entry = obj;
        if (entry == nil) return;
        NSObject *observer = entry.observer;
        if (observer == nil) return;
        @try {
            [target removeObserver:observer
                        forKeyPath:entry.keyPath];
        } @catch (NSException *e) {
            NSLog(@"ZFKVO: failed to remove observer for %@\n", entry.keyPath);
        }
    }];
    
    [_observerArray removeAllObjects];
}

- (BOOL)removeEntryOfObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath {
    __block NSInteger foundIndex = -1;
    [_observerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TFY_KVOEntry *entry = (TFY_KVOEntry *)obj;
        if (entry.observer == observer &&
            [entry.keyPath isEqualToString:keyPath]) {
            foundIndex = idx;
            *stop = YES;
        }
    }];
    
    if (foundIndex >= 0) {
        [_observerArray removeObjectAtIndex:foundIndex];
        return YES;
    }
    return NO;
}

@end

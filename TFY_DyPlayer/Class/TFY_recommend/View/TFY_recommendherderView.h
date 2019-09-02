//
//  TFY_recommendherderView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_recommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@class Data;

@protocol HerderDelegate <NSObject>

@optional
/*功能实现方法*/
-(void)HerderDelegateClick:(NSInteger)index model:(Data *)model;

@end

@interface TFY_recommendherderView : UICollectionReusableView

@property(nonatomic , strong)Data *models;

@property(nonatomic , assign) id <HerderDelegate> delegate;

@property(nonatomic , strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END

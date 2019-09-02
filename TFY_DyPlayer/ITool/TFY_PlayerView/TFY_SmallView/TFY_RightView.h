//
//  TFY_RightView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/21.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PlayerToolsHeader.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TFY_RightDelegate <NSObject>
@optional
/*功能实现方法*/
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface TFY_RightView : UIView

@property(nonatomic , strong)UICollectionView *collectionView;
/**
 *  数组总个数
 */
@property(nonatomic , assign)NSInteger index;
/**
 *  时刻获取播放到第几集
 */
@property(nonatomic , assign)NSInteger arrcount;
/**
 *  视频集点击代理
 */
@property (nonatomic,assign) id <TFY_RightDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

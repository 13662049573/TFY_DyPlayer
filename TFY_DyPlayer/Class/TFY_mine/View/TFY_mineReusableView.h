//
//  TFY_mineReusableView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TFY_mineReusableView;

@protocol HerderDelegate <NSObject>
@optional
/*功能实现方法*/
-(void)HerderDelegateClick:(TFY_mineReusableView *)Views;

-(void)toux_imageView:(TFY_mineReusableView *)herderView;

@end

@interface TFY_mineReusableView : UICollectionReusableView

@property (nonatomic,assign) id <HerderDelegate> delegate;

@property(nonatomic , strong)UIImageView *toux_imageView;

@property(nonatomic , copy)NSString *name_string;
@end

NS_ASSUME_NONNULL_END

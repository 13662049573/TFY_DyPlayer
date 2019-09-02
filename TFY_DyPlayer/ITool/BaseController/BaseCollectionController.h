//
//  BaseCollectionController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * Celltify = @"TFY_recommendCell";
static NSString * herdertify = @"TFY_recommendherderView";
static NSString * foodertify = @"BJZ_MineViewFooderView";

@interface BaseCollectionController : UIViewController

@property(nonatomic , strong)UICollectionView *collectionView;

-(void)flowlayout:(UICollectionViewLayout *)flowlayout registerClass:(nullable Class)cellClass herder_registerClass:(nullable Class)viewClass SuppKind:(NSString *)elementKind fooder_registerClass:(nullable Class)viewClass2 SuppKind:(NSString *)elementKind2;

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  下拉加载
 */
-(void)addharder;
/**
 *  下拉需要加载数据调用这个方法
 */
- (void)loadNewData;
/**
 *  上拉加载
 */
-(void)addfooter;
/**
 *  上拉需要加载数据调用这个方法
 */
-(void)loadfooter;
/**
 *  有数据是否加载显示文字
 */
- (void)setNoMoreData:(BOOL)noMoreData;
/**
 *  登录界面
 */
-(void)stepToLogin;
@end

NS_ASSUME_NONNULL_END

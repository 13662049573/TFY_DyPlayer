//
//  BaseCollectionController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "BaseCollectionController.h"
#import "TFY_RefreshGifHeader.h"
#import "TFY_RefreshGifFooter.h"
#import "TFY_LoginController.h"
@interface BaseCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation BaseCollectionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TFY_CommonUtils BackstatusBarStyle:0];
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"UI"] == NO) {
        if ([className isEqualToString:@"TFY_recommendController"] || [className isEqualToString:@"TFY_KoreandramaController"] || [className isEqualToString:@"TFY_USdramaController"] || [className isEqualToString:@"TFY_mineController"]) {
            
            [[self tfy_tabBarController] setTabBarHidden:NO animated:YES Hidden:NO];
        }
        else{
            [[self tfy_tabBarController] setTabBarHidden:YES animated:YES Hidden:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tfy_colorWithHex:@"ffffff"];
}
-(void)stepToLogin{
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[TFY_LoginController new]];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Celltify forIndexPath:indexPath];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){Width_W,DEBI_width(40)};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){Width_W,DEBI_width(40)};
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [UICollectionReusableView new];
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *herder = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:herdertify forIndexPath:indexPath];
       
        reusableView = herder;
    }
    return reusableView;
}

//设置允许高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//点击结束
- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=(UICollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor tfy_colorWithHex:LCColor_B5];
}
//点击中
- (void)collectionView:(UICollectionView *)colView  didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UICollectionViewCell *cell=(UICollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor tfy_colorWithHex:LCColor_B9]];
}
//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)flowlayout:(UICollectionViewLayout *)flowlayout registerClass:(nullable Class)cellClass herder_registerClass:(nullable Class)viewClass SuppKind:(NSString *)elementKind fooder_registerClass:(nullable Class)viewClass2 SuppKind:(NSString *)elementKind2{
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Width_W, Height_H) collectionViewLayout:flowlayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    
    [collection registerClass:cellClass forCellWithReuseIdentifier:Celltify];
    
    if (viewClass!=nil) {
        [collection registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:herdertify];
    }
    if (viewClass2!=nil) {
        [collection registerClass:viewClass2 forSupplementaryViewOfKind:elementKind2 withReuseIdentifier:foodertify];
    }
    
    self.collectionView = collection;
}

//下拉刷新
-(void)addharder
{
    TFY_RefreshGifHeader *header = [TFY_RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = NO;
//    // 隐藏状态
//    header.stateLabel.hidden = NO;
    
    self.collectionView.mj_header= header;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadNewData{}

-(void)addfooter{
    TFY_RefreshGifFooter *footer=[TFY_RefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadfooter)];
    // 隐藏状态
    footer.stateLabel.hidden = YES;
    
    self.collectionView.mj_footer =footer;
}

-(void)loadfooter{}

- (void)setNoMoreData:(BOOL)noMoreData{
    
    if (noMoreData) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        [self.collectionView.mj_footer resetNoMoreData];
    }
}

@end

//
//  TFY_recommendController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_recommendController.h"
#import "TFY_recommendCell.h"
#import "TFY_recommendherderView.h"


#import "TFY_MoreController.h" //更多控制器
#import "TFY_PlayerVideoController.h"

@interface TFY_recommendController ()<HerderDelegate>


@end

@implementation TFY_recommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐";
    self.models = [TFY_recommendModel new];
    
    UICollectionViewFlowLayout *flowLayout= [TFY_CommonUtils setUICollectionViewFlowLayoutWidths:Width_W/3-4 High:Width_W/2 minHspacing:1.f minVspacing:1.f UiedgeUp:1.f Uiedgeleft:1.f Uiedgebottom:1.f Uiedgeright:1.f Scdirection:YES];
    
    [self flowlayout:flowLayout registerClass:[TFY_recommendCell class] herder_registerClass:[TFY_recommendherderView class] SuppKind:UICollectionElementKindSectionHeader fooder_registerClass:nil SuppKind:@""];
    
    [self addharder];
    //添加视图
    [self.view addSubview:self.collectionView];
    
    [self.collectionView tfy_AutoSize:0 top:0 right:0 bottom:59];
}

-(void)loadNewData{
    RecommendCommand *data = [RecommendCommand new];
    data.vsize = 6;
    [[data.topicCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[TFY_recommendModel class]]) {
            
            self.models = x;
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        [TFY_ProgressHUD showErrorWithStatus:@"网络延迟请稍后尝试!"];
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark --UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.models.data.count;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    Data *vod = self.models.data[section];
    return vod.vod.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){Width_W,DEBI_width(40)};
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return (CGSize){Width_W,DEBI_width(0)};
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    TFY_recommendherderView *herder = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:herdertify forIndexPath:indexPath];
    herder.delegate = self;
    herder.models = self.models.data[indexPath.section];
    herder.indexPath = indexPath;
    return herder;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_recommendCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Celltify forIndexPath:indexPath];
    
    Data *vod = self.models.data[indexPath.section];
    
    Vod *model = vod.vod[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Data *vod = self.models.data[indexPath.section];
    
    Vod *model = vod.vod[indexPath.row];
    if (![TFY_CommonUtils judgeIsEmptyWithString:model.id]) {
        NSArray *arrsqliet = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_ids=%@",model.id]];
        if (arrsqliet.count>0) {
            [arrsqliet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TFY_PlayerVideoModel *models = obj;
                if ([models.tfy_ids isEqualToString:model.id]) {
                    TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
                    vc.currentPlayIndex = [models.tfy_videoId integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [vc VideoID:models.tfy_ids Playertype:PlayertypeStateWatchistor PlayerSeektime:models.tfy_seconds];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
        else{
            TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
            [vc VideoID:model.id Playertype:PlayertypeStateVideo PlayerSeektime:0];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma 头文件代理
-(void)HerderDelegateClick:(NSInteger)index model:(nonnull Data *)model{
    
    TFY_MoreController *vc = [TFY_MoreController new];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}



@end

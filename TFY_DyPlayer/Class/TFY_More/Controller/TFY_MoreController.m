//
//  TFY_MoreController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MoreController.h"
#import "TFY_recommendCell.h"
#import "TFY_PlayerVideoController.h"

@interface TFY_MoreController ()

@end

@implementation TFY_MoreController

-(void)setModel:(Data *)model{
    _model = model;
    
    self.title = _model.name;
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = [TFY_recommendModel new];
    self.array = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flowLayout= [TFY_CommonUtils setUICollectionViewFlowLayoutWidths:Width_W/3-4 High:Width_W/2 minHspacing:1.f minVspacing:1.f UiedgeUp:1.f Uiedgeleft:1.f Uiedgebottom:1.f Uiedgeright:1.f Scdirection:YES];
    
    [self flowlayout:flowLayout registerClass:[TFY_recommendCell class] herder_registerClass:nil SuppKind:@"" fooder_registerClass:nil SuppKind:@""];
    
    [self addharder];
    self.collectionView.frame = CGRectMake(0, 0, Width_W, Height_H-kNavBarHeight);
    //添加视图
    [self.view addSubview:self.collectionView];
}

-(void)loadNewData{
    RecommendCommand *data = [RecommendCommand new];
    data.vsize = self.model.id.integerValue;
    [[data.indexCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[TFY_recommendModel class]]) {
            
            self.models = x;
            
            self.array = [NSMutableArray arrayWithArray:self.models.data];
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        [TFY_ProgressHUD showErrorWithStatus:@"网络延迟请稍后尝试!"];
        [self.collectionView.mj_header endRefreshing];
    }];
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.array.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){Width_W,DEBI_width(0)};
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return (CGSize){Width_W,DEBI_width(0)};
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_recommendCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Celltify forIndexPath:indexPath];
    
    Data *vod = self.array[indexPath.row];
    
    cell.datamodel = vod;
    
    return cell;
    
}

//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Data *vod = self.array[indexPath.row];
    if (![TFY_CommonUtils judgeIsEmptyWithString:vod.id]) {
        NSArray *arrsqliet = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_ids=%@",vod.id]];
        if (arrsqliet.count>0) {
            [arrsqliet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TFY_PlayerVideoModel *models = obj;
                if ([models.tfy_ids isEqualToString:vod.id]) {
                    TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
                    vc.currentPlayIndex = [models.tfy_videoId integerValue];
                    [vc VideoID:models.tfy_ids Playertype:PlayertypeStateWatchistor PlayerSeektime:models.tfy_seconds];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
        else{
            TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
            [vc VideoID:vod.id Playertype:PlayertypeStateVideo PlayerSeektime:0];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end

//
//  TFY_MineFooderReusableView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MineFooderReusableView.h"
#import "TFY_MineFooderCell.h"
#import "TFY_PlayerVideoController.h"

@interface TFY_MineFooderReusableView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic , strong)UICollectionView *collectionView;
@end

@implementation TFY_MineFooderReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        //添加视图
        [self addSubview:self.collectionView];
    }
    return self;
}

-(void)setDataSouce:(NSMutableArray *)dataSouce{
    _dataSouce = dataSouce;
    
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_MineFooderCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TFY_MineFooderCell" forIndexPath:indexPath];
    
    TFY_PlayerVideoModel *modes = self.dataSouce[indexPath.row];
    
    cell.modes = modes;

    return cell;
}

//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TFY_PlayerVideoModel *models = self.dataSouce[indexPath.row];
    TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
    vc.currentPlayIndex = [models.tfy_videoId integerValue];
    [vc VideoID:models.tfy_ids Playertype:PlayertypeStateWatchistor PlayerSeektime:models.tfy_seconds];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [TFY_CommonUtils setUICollectionViewFlowLayoutWidths:Width_W/3-2 High:Width_W/2 minHspacing:1.f minVspacing:1.f UiedgeUp:1.f Uiedgeleft:1.f Uiedgebottom:1.f Uiedgeright:1.f Scdirection:NO];
        //创建一个UICollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Width_W, Width_W/2) collectionViewLayout:flowLayout];
        //设置代理为当前控制器
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[TFY_MineFooderCell class] forCellWithReuseIdentifier:@"TFY_MineFooderCell"];
        
    }
    return _collectionView;
}

@end

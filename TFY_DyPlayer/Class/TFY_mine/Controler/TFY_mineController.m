//
//  TFY_mineController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_mineController.h"
#import "TFY_mineReusableView.h"
#import "TFY_mineModel.h"
#import "TFY_mineViewCell.h"
#import "TFY_mineViewTwoViewCell.h"
#import "TFY_MineFooderReusableView.h"
#import "TFY_ImagePicker.h"

static NSString * Celltify2 = @"TFY_mineViewTwoViewCell";
static NSString * herdertify3 = @"TFY_mineReusableView";
static NSString * herdertify4 = @"TFY_MineFooderReusableView";

@interface TFY_mineController ()<UICollectionViewDataSource,UICollectionViewDelegate,HerderDelegate>
@property(nonatomic , strong)UICollectionView *collectionView;
@property(nonatomic , strong)TFY_mineModel *models;
@property(nonatomic , strong)NSMutableArray *dataSouce;
@end

@implementation TFY_mineController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *arr = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class]];
    
    self.dataSouce = [NSMutableArray arrayWithArray:arr];
    
    [self.collectionView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"我的";
    self.navigationController.tfy_titleColor = [UIColor tfy_colorWithHex:LCColor_B5];
    [self.navigationController tfy_navigationBarTransparent];
    
    self.models = [TFY_mineModel new];
    
    [self dataLoad];
    //添加视图
    [self.view addSubview:self.collectionView];
    
    [self.collectionView tfy_AutoSize:0 top:0 right:0 bottom:59];
}

-(void)dataLoad{
    MineCommand *data = [MineCommand new];
    [[data.dataCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[TFY_mineModel class]]) {
            
            self.models = x;
            
        }
        [self.collectionView reloadData];
    }];
}
#pragma mark --UICollectionView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.models.mineitems.count;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_mineViewTwoViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Celltify2 forIndexPath:indexPath];
    
    Mineitems *modes = self.models.mineitems[indexPath.section];
    
    cell.models = modes;
    
    cell.indexPath = indexPath;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return (CGSize){Width_W,240};
    }
    else{
       return (CGSize){Width_W,0};
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section==2 && self.dataSouce.count>0) {
        return (CGSize){Width_W,Width_W/2};
    }
    else{
      return (CGSize){Width_W,0};
    }
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView =[UICollectionReusableView new];
    if (kind == UICollectionElementKindSectionHeader){
        TFY_mineReusableView *herder = (TFY_mineReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:herdertify3 forIndexPath:indexPath];
        herder.delegate = self;
        reusableView = herder;
    }
    if (kind == UICollectionElementKindSectionFooter){
        TFY_MineFooderReusableView *fooder = (TFY_MineFooderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:herdertify4 forIndexPath:indexPath];
        fooder.dataSouce = self.dataSouce;
        reusableView = fooder;
    }
    return reusableView;
}

//设置允许高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//点击结束
- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[colView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor tfy_colorWithHex:LCColor_B5];
}
//点击中
- (void)collectionView:(UICollectionView *)colView  didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[colView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor tfy_colorWithHex:LCColor_B9];
}
//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Mineitems *modes = self.models.mineitems[indexPath.section];
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:modes.controller]) {
        
        UIViewController *vc = [NSClassFromString(modes.controller) new];
        vc.navigationItem.title = modes.title_str;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//滑动来禁止tableview的上下滑动边际
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (offsetY>=70) {
        self.navigationController.tfy_barBackgroundColor = [UIColor tfy_colorWithHex:LCColor_A1];
    }
    else{
        [self.navigationController tfy_navigationBarTransparent];
    }
}


//代理
-(void)HerderDelegateClick:(TFY_mineReusableView*)Views{
    
    [self stepToLogin];
}

-(void)toux_imageView:(TFY_mineReusableView *)herderView{
    [TFY_ImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image,NSString *imageName) {
        
        if (image!=nil) {
            
            herderView.toux_imageView.image=image;
            
            NSData *data = UIImagePNGRepresentation(image);
            
            [TFY_CommonUtils saveDataValueInUD:data forKey:@"image"];
        }
        
    }];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [TFY_CommonUtils setUICollectionViewFlowLayoutWidths:Width_W High:59 minHspacing:0.f minVspacing:0.f UiedgeUp:0.f Uiedgeleft:0.f Uiedgebottom:0.f Uiedgeright:0.f Scdirection:YES];
        //创建一个UICollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Width_W, Height_H-kNavBarHeight+10) collectionViewLayout:flowLayout];
        //设置代理为当前控制器
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[TFY_mineViewTwoViewCell class] forCellWithReuseIdentifier:Celltify2];
        
        [_collectionView registerClass:[TFY_mineReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:herdertify3];
        [_collectionView registerClass:[TFY_MineFooderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:herdertify4];

    }
    return _collectionView;
}

-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
@end

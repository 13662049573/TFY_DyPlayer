//
//  TFY_RightView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/21.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_RightView.h"

@interface RightViewCell : UICollectionViewCell

@property(nonatomic , assign)NSInteger count;
/**
 *  时刻获取播放到第几集
 */
@property(nonatomic , assign)NSInteger arrcount;
@end

@interface RightViewCell ()

@property(nonatomic , strong)UIView *back_View;

@property(nonatomic , strong)UILabel *count_label;

@end

@implementation RightViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.back_View];
        [self.back_View tfy_AutoSize:5 top:5 right:5 bottom:5];
        
        [self.back_View addSubview:self.count_label];
        [self.count_label tfy_AutoSize:10 top:10 right:10 bottom:10];
    
    }
    return self;
}

-(void)setCount:(NSInteger)count{
    _count = count;
    
    self.count_label.tfy_text([NSString stringWithFormat:@"第%ld集",(long)_count]);
    
}

-(void)setArrcount:(NSInteger)arrcount{
    _arrcount = arrcount;
    
    if (_arrcount == self.count-1) {
        self.count_label.tfy_textcolor(@"F43736", 1);
    }
    else{
        self.count_label.tfy_textcolor(@"ffffff", 1);
    }
    
}

-(UILabel *)count_label{
    if (!_count_label) {
        _count_label = tfy_label();
        _count_label.tfy_textcolor(@"ffffff", 1).tfy_fontSize([UIFont systemFontOfSize:12]).tfy_alignment(1).tfy_adjustsWidth(YES);
    }
    return _count_label;
}

-(UIView *)back_View{
    if (!_back_View) {
        _back_View = [UIView new];
        _back_View.backgroundColor = [UIColor clearColor];
        _back_View.layer.borderWidth = 1;
        _back_View.layer.borderColor = [UIColor whiteColor].CGColor;
        _back_View.layer.cornerRadius = 5;
    }
    return _back_View;
}

@end


static NSString * Celltify = @"RightViewCell";

@interface TFY_RightView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation TFY_RightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"videoImages.bundle/video_right"];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.collectionView];
        [self.collectionView tfy_AutoSize:0 top:10 right:0 bottom:10];
        
    }
    return self;
}


-(void)setIndex:(NSInteger)index{
    _index = index;
    
    [self.collectionView reloadData];
}

-(void)setArrcount:(NSInteger)arrcount{
    _arrcount = arrcount;
    
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.index;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RightViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Celltify forIndexPath:indexPath];
    
    cell.count = indexPath.row+1;
    
    cell.arrcount = self.arrcount;
    return cell;
}
//设置允许高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
    

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
}
    
//点击结束
- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    RightViewCell *cell=(RightViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor= [UIColor clearColor];
}
//点击中
- (void)collectionView:(UICollectionView *)colView  didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    RightViewCell *cell=(RightViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
}
    
    
    
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [TFY_CommonUtils setUICollectionViewFlowLayoutWidths:TFY_PLAYER_ScreenW/6-4 High:60 minHspacing:2 minVspacing:2 UiedgeUp:2 Uiedgeleft:2 Uiedgebottom:2 Uiedgeright:2 Scdirection:YES];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[RightViewCell class] forCellWithReuseIdentifier:Celltify];
    }
    return _collectionView;
}


@end

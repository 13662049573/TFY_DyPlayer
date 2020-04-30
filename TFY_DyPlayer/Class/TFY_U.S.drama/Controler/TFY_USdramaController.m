//
//  TFY_USdramaController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/5.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_USdramaController.h"
#import "TFY_MoreTwoController.h"
#import "TFY_recommendModel.h"
@interface TFY_USdramaController ()

@end

@implementation TFY_USdramaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"美剧";
}

-(void)loadNewData{
    RecommendCommand *data = [RecommendCommand new];
    data.vsize=6;
    data.ids = @"2";
    [[data.typeCommand execute:@1] subscribeNext:^(id  _Nullable x) {
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

-(void)HerderDelegateClick:(NSInteger)index model:(nonnull Data *)model{
    TFY_MoreTwoController *vc = [TFY_MoreTwoController new];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

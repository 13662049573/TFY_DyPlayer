//
//  TFY_MoreTwoController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MoreTwoController.h"

@interface TFY_MoreTwoController ()

@property (nonatomic , assign)NSInteger index;

@end

@implementation TFY_MoreTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 15;
    
    [self addfooter];
}

-(void)loadNewData{
    [self ids:self.model.id index:self.index];
}

-(void)loadfooter{
    self.index += 12;
    
    [self ids:self.model.id index:self.index];
}

-(void)ids:(NSString *)ids index:(NSInteger)index{
    RecommendCommand *command = [RecommendCommand new];
    command.ids = ids;
    command.size = index;
    [[command.cidCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[TFY_recommendModel class]]) {
            
            self.models = x;
        
            if (self.index == 15) {
                self.array = [NSMutableArray arrayWithArray:self.models.data];
                
                [self.collectionView.mj_header endRefreshing];
            }
            else{
                
                self.array = [NSMutableArray arrayWithArray:self.models.data];
                
                [self setNoMoreData:NO];
            }
            [self.collectionView reloadData];
        }
        
    } error:^(NSError * _Nullable error) {
        [TFY_ProgressHUD showErrorWithStatus:@"网络延迟请稍后尝试!"];
        if (self.index == 15) {
            [self.collectionView.mj_header endRefreshing];
        }
        else{
            [self setNoMoreData:YES];
        }
    }];
}

@end

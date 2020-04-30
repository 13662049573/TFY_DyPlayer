//
//  TFY_MycollectionController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_MycollectionController.h"
#import "TFY_CollectionModel.h"
#import "TFY_MycollectionViewCell.h"
#import "TFY_MycollectionViewTwoCell.h"
#import "TFY_PlayerVideoController.h"

@interface TFY_MycollectionController ()
@property(nonatomic , strong)NSMutableArray *dataSouce;
@end

@implementation TFY_MycollectionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addharder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItem(@"取消所有收藏",14,[UIColor whiteColor],self,@selector(rihtClick));
}

-(void)loadNewData{
    NSArray *arr = [TFY_ModelSqlite query:[TFY_CollectionModel class]];
    
    self.dataSouce = [NSMutableArray arrayWithArray:[self compareParkWithArray:arr]];
    if (self.dataSouce.count==0) {
         [TFY_Displayprompt showWithdisplayprompt:self.view back_imageView:@"the_default_graph_successfulorder" WithCGSize:CGSizeMake(295/2, 256/2)];
        [self.tableView.mj_header endRefreshing];
    }
    
    [self performSelector:@selector(herderendRefreshing) withObject:nil afterDelay:1.5];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSouce.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TFY_MycollectionViewCell tfy_CellHeightForIndexPath:indexPath tableVView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *back = [UIView new];
    back.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B7];
    return back;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFY_CollectionModel *models = self.dataSouce[indexPath.section];
    if (indexPath.section%2==0) {
        TFY_MycollectionViewCell *cell = [TFY_MycollectionViewCell infoCellWithTableView:tableView];
        
        cell.models = models;
        
        cell.indexPath = indexPath;
        
        return cell;
    }
    else{
        TFY_MycollectionViewTwoCell *cell = [TFY_MycollectionViewTwoCell infoCellWithTableView:tableView];
        
        cell.models = models;
        
        cell.indexPath = indexPath;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TFY_CollectionModel *models = self.dataSouce[indexPath.section];
    
    if (![TFY_CommonUtils judgeIsEmptyWithString:models.id]) {
        NSArray *arrsqliet = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_ids=%@",models.id]];
        if (arrsqliet.count>0) {
            [arrsqliet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TFY_PlayerVideoModel *data = obj;
                if ([data.tfy_ids isEqualToString:models.id]) {
                    TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
                    vc.currentPlayIndex = [data.tfy_videoId integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [vc VideoID:data.tfy_ids Playertype:PlayertypeStateWatchistor PlayerSeektime:data.tfy_seconds];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
        else{
            TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
            vc.hidesBottomBarWhenPushed = YES;
            [vc VideoID:models.id Playertype:PlayertypeStateVideo PlayerSeektime:0];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//MARK将模型数组按时间降序排序
-(NSArray *)compareParkWithArray:(NSArray *)dataArray
{
    NSArray *array =[dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {//这个是调用系统的方法
        TFY_CollectionModel *object1 = (TFY_CollectionModel *)obj1;//NewModel是我需要排序的Model模型
        TFY_CollectionModel *object2 = (TFY_CollectionModel *)obj2;
        
        NSString *string1 = [TFY_CommonUtils cTimestampFromString:object1.addtime];//将NewModel的时间转换为时间戳
        NSString *string2 = [TFY_CommonUtils cTimestampFromString:object2.addtime];
        
        if ([string1 doubleValue] < [string2 doubleValue]) {
            return NSOrderedDescending;
        } else if ([string1 doubleValue] > [string2 doubleValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return array;//返回的就是按照时间降序的数组啦
}


-(void)herderendRefreshing{
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
}

-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
-(void)rihtClick{
    [TFY_ModelSqlite removeModel:[TFY_CollectionModel class]];
    
    [self addharder];
    
}
@end

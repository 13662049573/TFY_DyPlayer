//
//  TFY_SettingController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SettingController.h"
#import "TFY_SettingModel.h"
#import "TFY_SettingHerderView.h"
#import "TFY_SettingViewCell.h"

@interface TFY_SettingController ()

@property(nonatomic,strong)TFY_SettingModel *models;

@end

@implementation TFY_SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.models = [TFY_SettingModel new];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    [self addharder];
}

-(void)loadNewData{
    SettingCommand *data = [SettingCommand new];
    [[data.settingCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[TFY_SettingModel class]]) {
            self.models = x;
            
            [self.tableView reloadData];
            
            [self tableViewLayout];
            
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

-(void)tableViewLayout{
    [self.tableView tfy_tableViewMaker:^(TFY_TableViewMaker * _Nonnull tableMaker) {
        
        [tableMaker.tfy_sectionCount(self.models.settinggroup.count) tfy_sectionMaker:^(TFY_SectionMaker * _Nonnull sectionMaker) {
            sectionMaker.tfy_headerView(^(){
                TFY_SettingHerderView *herder = [TFY_SettingHerderView new];
                Settinggroup *sectionModel = self.models.settinggroup[[sectionMaker section]];
                herder.models = sectionModel;
                return herder;
                
            });
            sectionMaker.tfy_headerHeight(35);
            
            [sectionMaker.tfy_dataArr(^(void){
                Settinggroup *sectionModel = self.models.settinggroup[[sectionMaker section]];
                return sectionModel.items;
                
            }) tfy_cellMaker:^(TFY_CellMaker * _Nonnull cellMaker) {
                
                cellMaker.tfy_cellClass(TFY_CellClass(TFY_SettingViewCell))
                .tfy_adapter(^(__kindof TFY_SettingViewCell *cell,Items *model,NSIndexPath *indexPath){
                    cell.models = model;
                    
                    cell.indexPath = indexPath;
                })
                .tfy_event(^(__kindof UITableView *tableVView, NSIndexPath *indexPath,id data){
                    
                    if (indexPath.section == 5 && indexPath.row == 4) {
                        [TFY_CommonUtils clearFile];
                        [TFY_ModelSqlite removeAllModel];
                        NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:indexPath.row inSection:5];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [TFY_ProgressHUD showSuccessWithStatus:@"所有数据已清楚!"];
                    }
                    
                })
                .tfy_rowHeight(45);
            }];
        }];
    }];
}

@end

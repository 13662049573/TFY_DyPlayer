//
//  TFY_PersonalinformatiolController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PersonalinformatiolController.h"
#import "TFY_PersonalinformatiolHerderView.h"
#import "TFY_PersonalinformatiolModel.h"
#import "TFY_PersonalinformatiolCell.h"
@interface TFY_PersonalinformatiolController ()
@property(nonatomic , strong)TFY_PersonalinformatiolModel *models;
@end

@implementation TFY_PersonalinformatiolController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataLayout];
    
    [self.view addSubview:self.tableView];
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
}

-(void)dataLayout{
    PersonCommand *data = [PersonCommand new];
    [[data.personCommand execute:@1] subscribeNext:^(id  _Nullable x) {
       
        self.models = x;
        
        [self tableViewLayout];
        
        [self.tableView reloadData];
    }];
}

-(void)tableViewLayout{
    [self.tableView tfy_tableViewMaker:^(TFY_TableViewMaker * _Nonnull tableMaker) {
        
        tableMaker.tfy_tableViewHeaderView(^(){
            TFY_PersonalinformatiolHerderView *herderView = [[TFY_PersonalinformatiolHerderView alloc] initWithFrame:CGRectMake(0, 0, Width_W, 120)];
            return herderView;
        });
        
        [tableMaker tfy_addSectionMaker:^(TFY_SectionMaker * _Nonnull sectionMaker) {
            
            [sectionMaker.tfy_dataArr(TFY_DataArr(self.models.personitems)) tfy_cellMaker:^(TFY_CellMaker * _Nonnull cellMaker) {
                
                cellMaker.tfy_cellClass(TFY_CellClass(TFY_PersonalinformatiolCell))
                .tfy_adapter(^(__kindof TFY_PersonalinformatiolCell *cell,id data,NSIndexPath *indexPath){
                    
                    cell.models = data;
                    
                }).tfy_event(^(__kindof UITableView *tableView,NSIndexPath *indexPath,id data){
                    
                    Personitems *models = data;
                    
                    if (![TFY_CommonUtils judgeIsEmptyWithString:models.controller]) {
                        UIViewController *vc = [NSClassFromString(models.controller) new];
                        vc.navigationItem.title = models.title_str;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }).tfy_rowHeight(50);
            }];
            
        }];
        
    }];
}

-(TFY_PersonalinformatiolModel *)models{
    if (!_models) {
        _models = [TFY_PersonalinformatiolModel new];
    }
    return _models;
}
@end

//
//  TFY_FeedbackController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FeedbackController.h"
#import "TFY_FeedbackModel.h"
#import "TFY_FeedbackFooderView.h"
#import "TFY_FeedbackherderView.h"
#import "TFY_FeedbackCell.h"
@interface TFY_FeedbackController ()
@property(nonatomic , strong)TFY_FeedbackModel *models;
@end

@implementation TFY_FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
    [self.view addSubview:self.tableView];
    
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    [self dataNopublic];
}
-(void)dataNopublic{
    FeedbackData *data = [FeedbackData new];
    [[data.nopublicCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        
        self.models = x;
        
        [self layouttableView];
        
        [self.tableView reloadData];
    }];
}
-(void)layouttableView{
    [self.tableView tfy_tableViewMaker:^(TFY_TableViewMaker * _Nonnull tableMaker) {
        tableMaker.tfy_tableViewHeaderView(^(){
            TFY_FeedbackherderView *herder = [[TFY_FeedbackherderView alloc] initWithFrame:CGRectMake(0, 0, Width_W, 150)];
            return herder;
        });
        tableMaker.tfy_tableViewFooterView(^(){
            TFY_FeedbackFooderView *fooder = [[TFY_FeedbackFooderView alloc] initWithFrame:CGRectMake(0, 0, Width_W, 80)];
            return fooder;
        });
        [tableMaker.tfy_sectionCount(self.models.feedbackItem.count) tfy_sectionMaker:^(TFY_SectionMaker * _Nonnull sectionMaker) {
            
            [sectionMaker.tfy_dataArr(^(){
                
                FeedbackItem *model = self.models.feedbackItem[[sectionMaker section]];
                return model.feedbackitems;
                
            }) tfy_cellMaker:^(TFY_CellMaker * _Nonnull cellMaker) {
                
                cellMaker.tfy_cellClass(TFY_CellClass(TFY_FeedbackCell))
                .tfy_adapter(^(TFY_FeedbackCell *cell,id data, NSIndexPath *indexPath){
                    
                    cell.models = data;
                    
                }).tfy_rowHeight(50);
            }];
        }];
    }];
}

-(TFY_FeedbackModel *)models{
    if (!_models) {
        _models = [TFY_FeedbackModel new];
    }
    return _models;
}
@end

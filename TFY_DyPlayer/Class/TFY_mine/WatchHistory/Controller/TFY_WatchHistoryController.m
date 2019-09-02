//
//  TFY_WatchHistoryController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/9.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_WatchHistoryController.h"
#import "TFY_WatchHistoryCell.h"
#import "TFY_PlayerVideoController.h"
@interface TFY_WatchHistoryController ()
@property(nonatomic , strong)NSMutableArray *dataSouce;

@property(nonatomic , strong)UIView *rightView,*tabbarView;

@property(nonatomic , strong)UIButton *allSelbtn,*deleteBtn,*customView_btn;

@end

@implementation TFY_WatchHistoryController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isNavEditing) [self customView_btnClick:self.customView_btn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self addharder];
    
    [[self tfy_tabBarController] setTabBarHidden:YES animated:YES Hidden:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    
    [self.view addSubview:self.tabbarView];
    self.tabbarView.tfy_LeftSpace(0).tfy_BottomSpace(-100).tfy_RightSpace(0).tfy_Height(100);

}

- (BOOL)isNavEditing
{
    return self.customView_btn.selected;
}

-(void)loadNewData{
    NSArray *arr = [TFY_ModelSqlite query:[TFY_PlayerVideoModel class]];
    
    self.dataSouce = [NSMutableArray arrayWithArray:arr];
    if(self.dataSouce.count==0){
        [TFY_Displayprompt showWithdisplayprompt:self.view back_imageView:@"the_default_graph_successfulorder" WithCGSize:CGSizeMake(295/2, 256/2)];
        [self.tableView.mj_header endRefreshing];
    }
    [self reloadNavRightBtn];
    
    [self performSelector:@selector(herderendRefreshing) withObject:nil afterDelay:1.5];
    
}

-(void)herderendRefreshing{
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFY_WatchHistoryCell *cell = [TFY_WatchHistoryCell infoCellWithTableView:tableView];
    
    cell.models = self.dataSouce[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customView_btn.selected) {
        NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
        if (indexPaths.count > 0) {
            self.deleteBtn.tfy_text([NSString stringWithFormat:@"删除(%lu)", (unsigned long)indexPaths.count]).tfy_backgroundColor(LCColor_A2,1);
            self.deleteBtn.enabled = YES;
        }
        if (indexPaths.count == self.dataSouce.count) {
            self.allSelbtn.tfy_text(@"取消全选");
        }
    }
    else{
        TFY_PlayerVideoModel *models = self.dataSouce[indexPath.row];
        TFY_PlayerVideoController *vc = [TFY_PlayerVideoController new];
        vc.currentPlayIndex = [models.tfy_videoId integerValue];
        [vc VideoID:models.tfy_ids Playertype:PlayertypeStateWatchistor PlayerSeektime:models.tfy_seconds];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//侧滑
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setNeedsLayout];
}
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_PlayerVideoModel *model = self.dataSouce[indexPath.row];
    
    BOOL deletebool =  [TFY_ModelSqlite deletes:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_name='%@'",model.tfy_name]];
    if (deletebool) {
        [self.dataSouce removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self reloadNavRightBtn];
    }
    else{
        [TFY_ProgressHUD showErrorWithStatus:@"数据删除错误!"];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.customView_btn.selected) {
        NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
        NSString *deleteBtnTitle;
        if (indexPaths.count>0) {
            deleteBtnTitle = [NSString stringWithFormat:@"删除(%lu)", (unsigned long)indexPaths.count];
            self.deleteBtn.enabled = YES;
        }
        else{
            deleteBtnTitle = @"删除";
            self.deleteBtn.tfy_backgroundColor(LCColor_A2,0.6);
            self.deleteBtn.enabled = NO;
        }
        self.deleteBtn.tfy_text(deleteBtnTitle);
        if (indexPaths.count < self.dataSouce.count){
            self.allSelbtn.tfy_text(@"全选");
        }
    }
}

-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}

-(UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.customView_btn = [[UIButton alloc] initWithFrame:CGRectMake(9, 0, 40, 40)];
        self.customView_btn.tfy_image(@"nav_deleteBtn", UIControlStateNormal).tfy_image(@"nav_cancelBtn", UIControlStateSelected).tfy_action(self, @selector(customView_btnClick:));
        [_rightView addSubview:self.customView_btn];
    }
    return _rightView;
}

-(void)customView_btnClick:(UIButton *)btn{
    
    if (!btn.selected && self.tableView.isEditing) [self.tableView setEditing:NO animated:YES];
    
    btn.selected = !btn.selected;
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    btn.selected?self.tabbarView.tfy_BottomSpace(0):self.tabbarView.tfy_BottomSpace(-100);;
    
    btn.selected?self.tableView.tfy_BottomSpace(100):self.tableView.tfy_BottomSpace(0);
    
    if (!btn.selected) [self cancelAllSelect];

    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)reloadNavRightBtn
{
    self.customView_btn.hidden = self.dataSouce.count == 0 ? YES : NO;
}
-(void)allSelbtnClick:(UIButton *)btn{
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    if (btn.tag==1) {
        if ([self.allSelbtn.titleLabel.text isEqualToString:@"全选"]) {
            self.allSelbtn.tfy_text(@"取消全选");
            for (int i = 0; i < self.dataSouce.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            self.deleteBtn.tfy_text([NSString stringWithFormat:@"删除(%lu)", (unsigned long)self.dataSouce.count]).tfy_backgroundColor(LCColor_A2,1);
            self.deleteBtn.enabled = YES;
            
        }
        else{
            self.allSelbtn.tfy_text(@"全选");
            // 取消全选
            [self cancelAllSelect];
        }
    }
    if (btn.tag==2) {
        // 删除
        NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
        for (NSIndexPath *indexPath in indexPaths) {
            [indexes addIndex:indexPath.row];
            TFY_PlayerVideoModel *model = self.dataSouce[indexPath.row];
            
           [TFY_ModelSqlite deletes:[TFY_PlayerVideoModel class] where:[NSString stringWithFormat:@"tfy_name='%@'",model.tfy_name]];
            
        }
        [self.dataSouce removeObjectsAtIndexes:indexes];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.dataSouce.count == 0) self.allSelbtn.tfy_text(@"全选");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self customView_btnClick:self.customView_btn];
            [self reloadNavRightBtn];
        });
    }
}

- (void)cancelAllSelect
{
    for (int i = 0; i < self.dataSouce.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    self.deleteBtn.tfy_text(@"删除").tfy_backgroundColor(LCColor_A2,0.6);
    self.deleteBtn.enabled = NO;
}

-(UIView *)tabbarView{
    if (!_tabbarView) {
        _tabbarView = [UIView new];
        _tabbarView.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B7];
        [_tabbarView addSubview:self.allSelbtn];
        self.allSelbtn.tfy_CenterY(0).tfy_size(Width_W/2-70, 50).tfy_LeftSpace(35);
        
        [_tabbarView addSubview:self.deleteBtn];
        self.deleteBtn.tfy_CenterY(0).tfy_size(Width_W/2-70, 50).tfy_RightSpace(35);
    }
    return _tabbarView;
}
-(UIButton *)allSelbtn{
    if (!_allSelbtn) {
        _allSelbtn = tfy_button();
        _allSelbtn.tfy_title(@"全选", LCColor_B5, 15).tfy_action(self, @selector(allSelbtnClick:)).tfy_backgroundColor(LCColor_A2,1).tfy_cornerRadius(10);
        _allSelbtn.tag=1;
    }
    return _allSelbtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = tfy_button();
        _deleteBtn.tfy_title(@"删除", LCColor_B5, 15).tfy_action(self, @selector(allSelbtnClick:)).tfy_backgroundColor(LCColor_A2,0.6).tfy_cornerRadius(10);
        _deleteBtn.tag=2;
        _deleteBtn.enabled = NO;
    }
    return _deleteBtn;
}
@end

//
//  BaseTableViewController.m
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/16.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TFY_RefreshGifHeader.h"
#import "TFY_RefreshGifFooter.h"
#import "TFY_LoginController.h"
@interface BaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TFY_CommonUtils BackstatusBarStyle:0];
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"UI"] == NO) {
        if ([className isEqualToString:@"TFY_recommendController"] || [className isEqualToString:@"TFY_KoreandramaController"] || [className isEqualToString:@"TFY_USdramaController"] || [className isEqualToString:@"TFY_mineController"]) {
            
            [[self tfy_tabBarController] setTabBarHidden:NO animated:YES Hidden:NO];
        }
        else{
            [[self tfy_tabBarController] setTabBarHidden:YES animated:YES Hidden:YES];
        }
    }
}
-(void)stepToLogin{
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[TFY_LoginController new]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tfy_colorWithHex:@"ffffff"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//侧滑删除
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.separatorInset= UIEdgeInsetsMake(0,20,0,20);
        _tableView.separatorColor = [UIColor tfy_ColorWithHexString:@"E8E8E8"];
        _tableView.estimatedRowHeight=0;
        _tableView.rowHeight=UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}
//下拉刷新
-(void)addharder
{
    TFY_RefreshGifHeader *header = [TFY_RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = NO;
//    // 隐藏状态
//    header.stateLabel.hidden = NO;
    
    self.tableView.mj_header= header;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData{}

-(void)addfooter{
    TFY_RefreshGifFooter *footer=[TFY_RefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadfooter)];
    // 隐藏状态
    footer.stateLabel.hidden = YES;
    
    self.tableView.mj_footer =footer;
}

-(void)loadfooter{}

- (void)setNoMoreData:(BOOL)noMoreData{
    
    if (noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        [self.tableView.mj_footer resetNoMoreData];
    }
}
@end

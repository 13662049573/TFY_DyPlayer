//
//  BaseTableViewController.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/16.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UIViewController

@property(nonatomic , strong)UITableView *tableView;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//侧滑删除
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//选择的时候再侧滑
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
/**
 *  下拉加载
 */
-(void)addharder;
/**
 *  下拉需要加载数据调用这个方法
 */
- (void)loadNewData;
/**
 *  上拉加载
 */
-(void)addfooter;
/**
 *  上拉需要加载数据调用这个方法
 */
-(void)loadfooter;
/**
 *  有数据是否加载显示文字
 */
- (void)setNoMoreData:(BOOL)noMoreData;
/**
 *  登录界面
 */
-(void)stepToLogin;
@end

NS_ASSUME_NONNULL_END

//
//  TFY_BaseTableViewDataSource.h
//  TFY_SimplifytableView
//
//  Created by 田风有 on 2019/5/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CellRegisterType) {
    CellRegisterTypeClass = 0,
    CellRegisterTypeXib = 1,
};

/**
 *  行数 高度 返回block
 */
typedef CGFloat (^RowHeightBlock)(NSIndexPath * _Nonnull indexPath);
/**
 *  赋值 cell 数据 行数 返回所需的Block
 */
typedef void (^CellAdapterBlock)(__kindof UITableViewCell *cell, id data, NSIndexPath * _Nonnull indexPath);
/**
 *  点击方法 tableview 行数 数据 x所需block
 */
typedef void (^CellEventBlock)(UITableView *tableView, NSIndexPath * _Nonnull indexPath, id data);

@interface TFY_CellData : NSObject
/**
 *  初始一个tableview
 */
@property(nonatomic , weak)UITableView *tableView;
/**
 *  数据
 */
@property(nonatomic , assign)id data;
/**
 *  高度Block
 */
@property(nonatomic , copy)RowHeightBlock rowHeightBlock;
/**
 *  赋值高度
 */
@property(nonatomic , assign)CGFloat rowHeight;
/**
 *  cell类型
 */
@property(nonatomic , assign)CellRegisterType cellRegisterType;
/**
 *  cell Class 类
 */
@property(nonatomic , strong)Class cell;
/**
 *  独立的赋值参数
 */
@property(nonatomic , copy)NSString *cellidentifier;
/**
 *  赋值的cell block
 */
@property(nonatomic , copy)CellAdapterBlock adapter;
/**
 *  点击方法 cell block
 */
@property(nonatomic , copy)CellEventBlock event;
/**
 *  行数
 */
@property(nonatomic , strong)NSIndexPath *indexPath;
/**
 *  是否自适应高度
 */
@property(nonatomic , assign)BOOL isAutoHeight;
/**
 *  返回cell
 */
-(UITableViewCell *)getReturnCell;

@end

@interface TFY_CellMaker : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;
/**
 *  cell 模型
 */
@property (nonatomic, strong) TFY_CellData *cellData;
/**
 *  获取行数
 */
- (NSIndexPath *)indexPath;
/**
 *  cell 的高度
 */
- (TFY_CellMaker * (^)(CGFloat))tfy_rowHeight;
/**
 *   自动获取高度布局
 */
- (TFY_CellMaker * (^)(void))tfy_autoHeight;
/**
 *  cell 类返回对象block [UItabaleViewCell Class];
 */
- (TFY_CellMaker * (^)(Class))tfy_cellClass;
/**
 *   xib  cell 类返回对象block
 */
- (TFY_CellMaker * (^)(Class))tfy_cellClassXib;
/**
 *   cell data 数据赋值
 */
- (TFY_CellMaker * (^)(id))tfy_data;
/**
 *  cell 同tableView:__kindof UITableViewCell *cell, id data, NSIndexPath * _Nonnull indexPath 这个方法
 */
- (TFY_CellMaker * (^)(CellAdapterBlock))tfy_adapter;
/**
 *  cell 同 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 */
- (TFY_CellMaker * (^)(CellEventBlock))tfy_event;
/**
 *  cell 同tableView:(UITableView *tableView, NSIndexPath * _Nonnull indexPath, id data); 这个方法
 */
- (TFY_CellMaker * (^)(Class,CellAdapterBlock))tfy_cellClassAndAdapter;


@end

/**
 *  数据赋值block
 */
typedef  NSArray * _Nonnull (^GetDataBlock)(void);
/**
 *   组数赋值 block
 */
typedef  NSInteger (^NumberOfRowsBlock)(NSInteger section);
/**
 *   模型block方法
 */
typedef void (^CellMakeBlock)(TFY_CellMaker * _Nonnull cellMaker);

@interface TFY_SectionData : NSObject
/**
 *  是否自定义cell
 */
@property(nonatomic, assign) BOOL isStaticCell;
/**
 *  模型数据
 */
@property(nonatomic, strong) NSMutableArray<TFY_CellData *> * cellDatas;
/**
 * tableView
 */
@property(nonatomic, weak) UITableView * tableView;
/**
 *  模型数据数组
 */
@property (nonatomic, strong) NSArray *modelDatas;
/**
 *  header 头文件字符串
 */
@property(nonatomic, copy) NSString * headerTitle;
/**
 *  footer 头文件字符串
 */
@property(nonatomic, copy) NSString * footerTitle;
/**
 *  header 高度
 */
@property (nonatomic, assign) CGFloat headerHeight;
/**
 *  footer 高度
 */
@property (nonatomic, assign) CGFloat footerHeight;
/**
 *   头部 headerView
 */
@property(nonatomic, strong) UIView * headerView;
/**
 *  尾部 ：footerView
 */
@property(nonatomic, strong) UIView * footerView;
/**
 *  cell 高度
 */
@property(nonatomic, assign) CGFloat rowHeight;
/**
 *  组行
 */
@property (nonatomic, assign) NSUInteger section;
/**
 *  组个数
 */
@property (nonatomic, assign) NSUInteger rowCount;
/**
 *  行个数
 */
@property(nonatomic, copy) NumberOfRowsBlock numberOfRowsBlock;
/**
 *  cell  模型 block
 */
@property(nonatomic, copy) CellMakeBlock cellMakeBlock;
/**
 *  cell 数组 Block
 */
@property(nonatomic, copy) GetDataBlock getDataBlock;
/**
 *  制作一个cell
 */
- (void)doCellMakerBlock;
/**
 *  制作一个cell 的回调
 */
- (void)doAddCellMakerBlock:(CellMakeBlock)cellMakerBlock;

@end

@interface TFY_SectionMaker : NSObject
/**
 *  组数初始化
 */
- (instancetype)initWithTableView:(UITableView *)tableView;
/**
 *  数据
 */
- (TFY_SectionMaker * (^)(GetDataBlock))tfy_dataArr;
/**
 *   返回第几组
 */
- (NSUInteger)section;
/**
 *  头部参数字符串
 */
- (TFY_SectionMaker * (^)(NSString *))tfy_headerTitle;
/**
 *  尾部参数字符串
 */
- (TFY_SectionMaker * (^)(NSString *))tfy_footerTitle;
/**
 *   头部View
 */
- (TFY_SectionMaker * (^)(UIView * (^)(void)))tfy_headerView;
/**
 *  尾部VIIEW
 */
- (TFY_SectionMaker * (^)(UIView * (^)(void)))tfy_footerView;
/**
 *  行高
 */
- (TFY_SectionMaker * (^)(CGFloat)) tfy_rowHeight;
/**
 *   头部高度
 */
- (TFY_SectionMaker * (^)(CGFloat)) tfy_headerHeight;
/**
 *  尾部高度
 */
- (TFY_SectionMaker * (^)(CGFloat)) tfy_footerHeight;
/**
 *   组行数
 */
- (TFY_SectionMaker * (^)(NSInteger))tfy_rowCount;
/**
 *  cellx模型 回调
 */
- (TFY_SectionMaker * (^)(CellMakeBlock))tfy_cellMaker;
/**
 *  添加一个组数据方法
 */
- (TFY_SectionMaker * (^)(CellMakeBlock))tfy_addCellMaker;
/**
 *   cell 模型的回调
 */
- (TFY_SectionMaker *)tfy_cellMaker:(CellMakeBlock)cellMakerBlock;
/**
 *  cell 添加的回调
 */
- (TFY_SectionMaker *)tfy_addCellMaker:(CellMakeBlock)cellMakerBlock;
/**
 *   组数据block
 */
@property(nonatomic, strong) TFY_SectionData * sectionData;

@end

/**
 *  初始cell方法
 */
typedef void (^CellWillDisplayBlock)(UITableView *tableView,UITableViewCell *willDisplayCell,NSIndexPath *indexPath);
/**
 *  编辑cell方法
 */
typedef void (^CommitEditingBlock)(UITableView * tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath * indexPath);
/**
 *  头部滚蛋cell
 */
typedef void (^ScrollViewDidScrollBlock)(UIScrollView *scrollView);
/**
 *  SectionMaker 回调block
 */
typedef void (^SectionMakeBlock)(TFY_SectionMaker * sectionMaker);
/**
 *   行数回调block
 */
typedef NSUInteger (^SectionCountBlock)(UITableView *tableView);
/**
 *  搜索引擎数组block
 */
typedef NSArray<NSString *> *_Nonnull(^sectionIndexBlock)(UITableView *tableView);

@interface TFY_TableData : NSObject
/**
 *  tableview 初始化
 */
-(instancetype)initWithTableView:(UITableView *)tableView;
/**
 *   制作cell 回调 block
 */
- (void)doAddSectionMaker:(SectionMakeBlock)sectionMakerBlock;
/**
 *  制作cell block
 */
- (void)doSectionMakeBlock;
/**
 *   tableview
 */
@property(nonatomic, weak) UITableView * tableView;
/**
 *  组数组
 */
@property(nonatomic, strong) NSMutableArray<TFY_SectionData *> * sectionDatas;
/**
 *  组行数
 */
@property (nonatomic, assign) NSUInteger sectionCount;
/**
 *  数据
 */
@property (nonatomic, strong) NSArray *dataArr;
/**
 *  搜索所需数组
 */
@property (nonatomic, strong) NSArray<NSString *> *sectionIndexArr;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat rowHeight;
/**
 *  组回调
 */
@property (nonatomic, copy)  SectionMakeBlock sectionMakeBlock;
/**
 *  组回调
 */
@property (nonatomic, copy)  SectionCountBlock sectionCountBlock;
/**
 *  搜索BLock
 */
@property(nonatomic, copy) sectionIndexBlock sectionIndexBlock;
/**
 *  字典数据
 */
@property(nonatomic, strong) NSMutableDictionary * otherDelegateBlocksDic;

@end

@interface TFY_TableViewMaker : NSObject
/**
 *  模型初始
 */
@property (nonatomic, strong)TFY_TableData *tableData;
/**
 *  初始方法
 */
- (instancetype)initWithTableView:(UITableView *)tableView;
/**
 *  模型初始方法
 */
- (instancetype)initWithTableData:(TFY_TableData *)tableData;
/**
 *   行高 回调
 */
- (TFY_TableViewMaker * (^)(CGFloat))tfy_heightMaker;
/**
 *  头部回调
 */
- (TFY_TableViewMaker * (^)(UIView * (^)(void)))tfy_tableViewHeaderView;
/**
 *  尾部回调
 */
- (TFY_TableViewMaker * (^)(UIView * (^)(void)))tfy_tableViewFooterView;
/**
 *  组行数回调
 */
- (TFY_TableViewMaker * (^)(NSInteger))tfy_sectionCount;
/**
 *  搜索所需数组
 */
- (TFY_TableViewMaker * (^)(NSArray<NSString *> *))tfy_sectionIndexArr;
/**
 *  组行数回调
 */
- (TFY_TableViewMaker * (^)(SectionCountBlock))tfy_sectionCountBk;
/**
 *   组模型回调
 */
- (TFY_TableViewMaker * (^)(SectionMakeBlock))tfy_sectionMaker;
/**
 *   组是调用方法
 */
- (TFY_TableViewMaker *) tfy_sectionMaker:(SectionMakeBlock)sectionMakeBlock;
/**
 *  添加组
 */
- (TFY_TableViewMaker * (^)(SectionMakeBlock))tfy_addSectionMaker;
/**
 *  添加组回调
 */
- (TFY_TableViewMaker *) tfy_addSectionMaker:(SectionMakeBlock)sectionMakeBlock;
/**
 *  cell 删除回调
 */
- (TFY_TableViewMaker * (^)(CellWillDisplayBlock))tfy_cellWillDisplay;
/**
 *  cell 编辑回调
 */
- (TFY_TableViewMaker * (^)(CommitEditingBlock))tfy_commitEditing;
/**
 *   cell 滚动回调
 */
- (TFY_TableViewMaker * (^)(ScrollViewDidScrollBlock))tfy_scrollViewDidScroll;


@end

@protocol TFY_BaseTableViewDataSourceProtocol<UITableViewDataSource,UITableViewDelegate>
/**
 *  协议方法初始
 */
@property (nonatomic, strong)TFY_TableData *tableData;

@end
/**
 *  实现方法
 */
@interface TFY_BaseTableViewDataSource : NSObject<TFY_BaseTableViewDataSourceProtocol>
/**
 *  协议方法初始
 */
@property (nonatomic, strong)TFY_TableData *tableData;
@end

NS_ASSUME_NONNULL_END

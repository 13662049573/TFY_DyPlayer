//
//  TFY_BaseTableViewDataSource.m
//  TFY_SimplifytableView
//
//  Created by 田风有 on 2019/5/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_BaseTableViewDataSource.h"
#import <objc/runtime.h>
#import "UITableViewCell+TFY_TableViewMaker.h"
#import "UITableView+TFY_TableViewMaker.h"

#define StringSelector(_SEL_) NSStringFromSelector(@selector(_SEL_))

@implementation TFY_CellData

-(UITableViewCell *)getReturnCell{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellidentifier forIndexPath:self.indexPath];
    cell.tableView = self.tableView;
    cell.indexPath = self.indexPath;
    if (_adapter) {
        _adapter(cell,_data,_indexPath);
    }
    return cell;
}


-(NSString *)cellidentifier{
    if (!_cellidentifier) {
        _cellidentifier = NSStringFromClass(_cell);
    }
    return _cellidentifier;
}

-(void)setCell:(Class)cell{
    _cell = cell;
    if (!self.tableView.tableViewRegisterCell[self.cellidentifier]) {//如果没有注册过
        UINib *nib = [UINib nibWithNibName:self.cellidentifier bundle:nil];
        if (self.cellRegisterType==CellRegisterTypeClass) {
            [self.tableView registerClass:[cell class] forCellReuseIdentifier:self.cellidentifier];
        }else{
            [self.tableView registerNib:nib forCellReuseIdentifier:self.cellidentifier];
        }
        
        [self.tableView.tableViewRegisterCell setValue:@(YES) forKey:self.cellidentifier];
    }
}

-(CGFloat)rowHeight{
    if (self.isAutoHeight) {
        
        _rowHeight =  [UITableViewCell CellHeightForIndexPath:_indexPath tableView:self.tableView identifier:self.cellidentifier layoutBlock:^(UITableViewCell * _Nonnull cell) {
            if (self.adapter) {
                self.adapter(cell,self.data,self.indexPath);
            }
        }];
    }
    return _rowHeight+20;
}

@end

@implementation TFY_CellMaker

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        self.cellData.tableView = tableView;
    }
    return self;
    
}

- (NSIndexPath *)indexPath{
    return self.cellData.indexPath;
}

- (TFY_CellMaker * (^)(void))tfy_autoHeight {
    return ^TFY_CellMaker * {
        self.cellData.isAutoHeight = YES;
        return self;
    };
}

- (TFY_CellMaker * (^)(CGFloat))tfy_rowHeight{
    return ^TFY_CellMaker *(CGFloat height){
        self.cellData.rowHeight = height;
        return self;
    };
}

- (TFY_CellMaker * (^)(Class))tfy_cellClass {
    return ^TFY_CellMaker *(Class cell) {
        self.cellData.cellRegisterType = CellRegisterTypeClass;
        self.cellData.cell = cell;
        return self;
    };
}

- (TFY_CellMaker * (^)(Class))tfy_cellClassXib {
    return ^TFY_CellMaker *(Class cell) {
        self.cellData.cellRegisterType = CellRegisterTypeXib;
        self.cellData.cell = cell;
        return self;
    };
}

- (TFY_CellMaker * (^)(id))tfy_data {
    return ^TFY_CellMaker *(id data) {
        self.cellData.data = data;
        return self;
    };
}

- (TFY_CellMaker * (^)(CellAdapterBlock))tfy_adapter {
    return ^TFY_CellMaker *(CellAdapterBlock adapterBlock) {
        self.cellData.adapter = adapterBlock;
        return self;
    };
}

- (TFY_CellMaker * (^)(Class,CellAdapterBlock))tfy_cellClassAndAdapter{
    return ^TFY_CellMaker *(Class cell,CellAdapterBlock adapterBlock) {
        self.cellData.cell = cell;
        self.cellData.adapter = adapterBlock;
        return self;
    };
}
- (TFY_CellMaker * (^)(CellEventBlock))tfy_event {
    return ^TFY_CellMaker *(CellEventBlock event) {
        self.cellData.event = event;
        return self;
    };
}

- (TFY_CellData *)cellData
{
    if (!_cellData) {
        _cellData = [TFY_CellData new];
    }
    return _cellData;
}

@end

@implementation TFY_SectionData
@synthesize rowCount = _rowCount;

-(CGFloat)headerHeight{
    if (_headerHeight==0) {
        _headerHeight = 0.0001;
        if (self.headerView) {
            _headerHeight = _headerView.frame.size.height;
        }
        if (self.headerTitle) {
            _headerHeight = 30;
        }
    }
    return _headerHeight;
}

-(CGFloat)footerHeight{
    if (_footerHeight==0) {
        _footerHeight = 0.0001;
        if (self.footerView) {
            _headerHeight = _footerView.frame.size.height;
        }
        if (self.footerTitle) {
            _headerHeight = 30;
        }
    }
    
    return _footerHeight;
}

-(NSUInteger)rowCount{
    return _rowCount;
}

-(void)setRowCount:(NSUInteger)rowCount{
    _rowCount = rowCount;
}

-(void)setCellMakeBlock:(CellMakeBlock)cellMakeBlock{
    _cellMakeBlock = cellMakeBlock;
}

-(void)doCellMakerBlock{
    if ((self.rowCount>0||self.modelDatas.count>0)&&self.cellMakeBlock) {
        [_cellDatas removeAllObjects];
        TFY_CellMaker * cellMaker = nil;
        NSUInteger count = self.modelDatas.count>0?self.modelDatas.count:self.rowCount;
        for (NSUInteger i = 0; i < count; i++) {
            cellMaker = [[TFY_CellMaker alloc] initWithTableView:self.tableView];
            cellMaker.cellData.indexPath = [NSIndexPath indexPathForRow:i inSection:self.section];
            cellMaker.cellData.data = self.modelDatas[i];
            cellMaker.cellData.rowHeight = self.rowHeight;
            self.cellMakeBlock(cellMaker);
            [self.cellDatas addObject:cellMaker.cellData];
        }
    }
    
}

- (void)doAddCellMakerBlock:(CellMakeBlock)cellMakerBlock{
    if (!self.isStaticCell) {
        self.isStaticCell = YES;
    }
    TFY_CellMaker * cellMaker = nil;
    cellMaker = [[TFY_CellMaker alloc] initWithTableView:self.tableView];
    cellMaker.cellData.indexPath = [NSIndexPath indexPathForRow:self.rowCount inSection:self.section];
    self.rowCount = self.rowCount + 1;
    cellMaker.cellData.rowHeight = self.rowHeight;
    cellMakerBlock(cellMaker);
    [self.cellDatas addObject:cellMaker.cellData];
    
}

-(NSArray *)modelDatas{
    if (self.getDataBlock) {
        _modelDatas = self.getDataBlock();
    }
    return _modelDatas;
}

-(NSMutableArray<TFY_CellData *> *)cellDatas{
    if (!_cellDatas) {
        _cellDatas = [NSMutableArray array];
    }
    return _cellDatas;
}
@end

@implementation TFY_SectionMaker

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        self.sectionData.tableView = tableView;
    }
    return self;
    
}

- (NSUInteger)section{
    return self.sectionData.section;
}

- (TFY_SectionMaker * (^)(NSString *))tfy_headerTitle {
    return ^TFY_SectionMaker *(NSString * title) {
        self.sectionData.headerTitle = title;
        return self;
    };
}

- (TFY_SectionMaker * (^)(NSString *))tfy_footerTitle {
    return ^TFY_SectionMaker *(NSString * title) {
        self.sectionData.footerTitle = title;
        return self;
    };
}

- (TFY_SectionMaker * (^)(CGFloat))tfy_rowHeight{
    return ^TFY_SectionMaker *(CGFloat height){
        self.sectionData.rowHeight = height;
        return self;
    };
}

- (TFY_SectionMaker * (^)(CGFloat))tfy_headerHeight{
    return ^TFY_SectionMaker *(CGFloat height){
        self.sectionData.headerHeight = height;
        return self;
    };
}

- (TFY_SectionMaker * (^)(CGFloat))tfy_footerHeight{
    return ^TFY_SectionMaker *(CGFloat height){
        self.sectionData.footerHeight = height;
        return self;
    };
}


- (TFY_SectionMaker * (^)(UIView * (^)(void)))tfy_headerView {
    return ^TFY_SectionMaker *(UIView * (^view)(void)) {
        self.sectionData.headerView = view();
        return self;
    };
}

- (TFY_SectionMaker * (^)(GetDataBlock))tfy_dataArr{
    return ^TFY_SectionMaker *(GetDataBlock getDataBlock){
        self.sectionData.getDataBlock = getDataBlock;
        return self;
    };
}

- (TFY_SectionMaker * (^)(UIView * (^)(void)))tfy_footerView {
    return ^TFY_SectionMaker *(UIView * (^view)(void)) {
        self.sectionData.footerView = view();
        return self;
    };
}

- (TFY_SectionMaker * (^)(NSInteger))tfy_rowCount{
    return ^TFY_SectionMaker *(NSInteger rowCount){
        self.sectionData.rowCount = rowCount;
        return self;
    };
}

- (TFY_SectionMaker * (^)(CellMakeBlock))tfy_cellMaker{
    return ^TFY_SectionMaker *(CellMakeBlock cellMakerBlock){
        self.sectionData.cellMakeBlock = cellMakerBlock;
        return self;
    };
}
- (TFY_SectionMaker * (^)(CellMakeBlock))tfy_addCellMaker{
    return ^TFY_SectionMaker *(CellMakeBlock cellMakerBlock){
        [self.sectionData doAddCellMakerBlock:cellMakerBlock];
        return self;
    };
}
- (TFY_SectionMaker *)tfy_cellMaker:(CellMakeBlock)cellMakerBlock{
    self.sectionData.cellMakeBlock = cellMakerBlock;
    return self;
}

- (TFY_SectionMaker *)tfy_addCellMaker:(CellMakeBlock)cellMakerBlock{
    [self.sectionData doAddCellMakerBlock:cellMakerBlock];
    return self;
}

- (TFY_SectionData *)sectionData {
    if (! _sectionData) {
        _sectionData = [TFY_SectionData new];
    }
    return _sectionData;
}

@end

@implementation TFY_TableData
@synthesize sectionCount = _sectionCount;
@synthesize sectionIndexArr = _sectionIndexArr;

-(instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

-(NSUInteger)sectionCount{
    
    if (self.sectionCountBlock) {
        [self setSectionCount:self.sectionCountBlock(self.tableView)];
    }
    
    if (0==_sectionCount&&self.sectionDatas.count>0) {
        [self setSectionCount:self.sectionDatas.count];
    }
    
    return _sectionCount;
}

-(void)setSectionCount:(NSUInteger)sectionCount{
    _sectionCount = sectionCount;
}

-(NSMutableArray<TFY_SectionData *> *)sectionDatas{
    if (!_sectionDatas) {
        _sectionDatas = [NSMutableArray array];
    }
    return _sectionDatas;
}

-(NSArray<NSString *> *)sectionIndexArr{
    if (self.sectionIndexBlock) {
        [self setSectionIndexArr:self.sectionIndexBlock(self.tableView)];
    }
    return _sectionIndexArr;
}


-(void)setSectionIndexArr:(NSArray<NSString *> *)sectionIndexArr{
    _sectionIndexArr = sectionIndexArr;
}

-(void)setSectionMakeBlock:(SectionMakeBlock)sectionMakeBlock{
    _sectionMakeBlock = sectionMakeBlock;
}

-(void)doSectionMakeBlock{
    if (self.sectionCount>0&&self.sectionMakeBlock) {
        [_sectionDatas removeAllObjects];
        TFY_SectionMaker * sectionMaker = nil;
        for (NSUInteger i = 0; i<self.sectionCount; i++) {
            sectionMaker = [[TFY_SectionMaker alloc] initWithTableView:self.tableView];
            if (self.rowHeight!=0) {
                sectionMaker.sectionData.rowHeight = self.rowHeight;
            }
            sectionMaker.sectionData.section = i;
            self.sectionMakeBlock(sectionMaker);
            [sectionMaker.sectionData doCellMakerBlock];
            [self.sectionDatas addObject:sectionMaker.sectionData];
        }
    }
}

- (void)doAddSectionMaker:(SectionMakeBlock)sectionMakerBlock{
    
    TFY_SectionMaker * sectionMaker = nil;
    
    sectionMaker = [[TFY_SectionMaker alloc] initWithTableView:self.tableView];
    if (self.rowHeight!=0) {
        sectionMaker.sectionData.rowHeight = self.rowHeight;
    }
    
    sectionMaker.sectionData.section = self.sectionCount;
    
    self.sectionCount = self.sectionCount + 1;
    
    sectionMakerBlock(sectionMaker);
    
    if (!sectionMaker.sectionData.isStaticCell) {
        [sectionMaker.sectionData doCellMakerBlock];
    }
    
    [self.sectionDatas addObject:sectionMaker.sectionData];
    
}

-(NSMutableDictionary *)otherDelegateBlocksDic{
    if (!_otherDelegateBlocksDic) {
        _otherDelegateBlocksDic = [NSMutableDictionary dictionary];
    }
    return _otherDelegateBlocksDic;
}

@end

@implementation TFY_TableViewMaker

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        self.tableData.tableView = tableView;
    }
    return self;
    
}
- (instancetype)initWithTableData:(TFY_TableData *)tableData{
    self = [super init];
    if (self) {
        self.tableData = tableData;
    }
    return self;
    
}

- (TFY_TableViewMaker * (^)(UIView * (^)(void)))tfy_tableViewHeaderView {
    return ^TFY_TableViewMaker *(UIView * (^view)(void)) {
        UIView * headerView =  view();
        [self.tableData.tableView.tableHeaderView layoutIfNeeded];
        self.tableData.tableView.tableHeaderView = headerView;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(UIView * (^)(void)))tfy_tableViewFooterView {
    return ^TFY_TableViewMaker *(UIView * (^view)(void)) {
        UIView * footerView =  view();
        [self.tableData.tableView.tableFooterView layoutIfNeeded];
        self.tableData.tableView.tableFooterView = footerView;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(CGFloat))tfy_heightMaker {
    return ^TFY_TableViewMaker *(CGFloat height) {
        self.tableData.rowHeight = height;
        self.tableData.tableView.rowHeight = height;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(NSInteger))tfy_sectionCount {
    return ^TFY_TableViewMaker *(NSInteger sectionCount) {
        self.tableData.sectionCount = sectionCount;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(NSArray<NSString *> *))tfy_sectionIndexArr{
    return ^TFY_TableViewMaker *(NSArray<NSString *> *sectionIndexArr){
        self.tableData.sectionIndexArr = sectionIndexArr;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(SectionCountBlock))tfy_sectionCountBk{
    return ^TFY_TableViewMaker *(SectionCountBlock sectionCountBlock){
        self.tableData.sectionCountBlock = sectionCountBlock;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(SectionMakeBlock))tfy_sectionMaker{
    return ^TFY_TableViewMaker *(SectionMakeBlock sectionMakeBlock){
        self.tableData.sectionMakeBlock = sectionMakeBlock;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(SectionMakeBlock))tfy_addSectionMaker{
    return ^TFY_TableViewMaker *(SectionMakeBlock sectionMakeBlock){
        [self.tableData doAddSectionMaker:sectionMakeBlock];
        return self;
    };
}

- (TFY_TableViewMaker *)tfy_sectionMaker:(SectionMakeBlock)sectionMakeBlock{
    self.tableData.sectionMakeBlock = sectionMakeBlock;
    return self;
}

- (TFY_TableViewMaker *)tfy_addSectionMaker:(SectionMakeBlock)sectionMakeBlock{
    [self.tableData doAddSectionMaker:sectionMakeBlock];
    return self;
}


- (TFY_TableViewMaker * (^)(CellWillDisplayBlock))tfy_cellWillDisplay{
    return ^TFY_TableViewMaker *(CellWillDisplayBlock cellWillDisplayBlock){
        self.tableData.otherDelegateBlocksDic[StringSelector(tableView:willDisplayCell:forRowAtIndexPath:)] = cellWillDisplayBlock;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(CommitEditingBlock))tfy_commitEditing{
    return ^TFY_TableViewMaker *(CommitEditingBlock commitEditingBlock){
        self.tableData.otherDelegateBlocksDic[StringSelector(tableView:commitEditingStyle:forRowAtIndexPath:)] = commitEditingBlock;
        return self;
    };
}

- (TFY_TableViewMaker * (^)(ScrollViewDidScrollBlock))tfy_scrollViewDidScroll{
    return ^TFY_TableViewMaker *(ScrollViewDidScrollBlock scrollViewDidScrollBlock){
        self.tableData.otherDelegateBlocksDic[StringSelector(scrollViewDidScroll:)] = scrollViewDidScrollBlock;
        return self;
    };
}

- (TFY_TableData *)tableData
{
    if (!_tableData) {
        _tableData = [TFY_TableData new];
    }
    return _tableData;
}

@end


@implementation TFY_BaseTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableData.sectionDatas[(NSUInteger) section].rowCount==0) {
        return self.tableData.sectionDatas[(NSUInteger) section].modelDatas.count;
    }
    return self.tableData.sectionDatas[(NSUInteger) section].rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].footerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.tableData.sectionDatas[(NSUInteger) section].footerHeight;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.tableData.sectionIndexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    
    TFY_SectionData *sectionData = self.tableData.sectionDatas[section];
    
    TFY_CellData *cellData = sectionData.cellDatas[index];
    
    return cellData.rowHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    
    TFY_CellData *cellData = self.tableData.sectionDatas[section].cellDatas[index];
    
    return [cellData getReturnCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TFY_CellData *cellData = self.tableData.sectionDatas[section].cellDatas[index];
    
    if (cellData.event) {
        cellData.event(tableView,indexPath,cellData.data);
    }
}


@end

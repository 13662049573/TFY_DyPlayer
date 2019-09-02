//
//  UITableView+TFY_TableViewMaker.m
//  TFY_SimplifytableView
//
//  Created by 田风有 on 2019/5/29.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITableView+TFY_TableViewMaker.h"
#import <objc/runtime.h>

#import "TFY_BaseTableViewDataSource.h"


void HDExchangeImplementations(Class class, SEL newSelector, SEL oldSelector) {
    Method oldMethod = class_getInstanceMethod(class, newSelector);
    Method newMethod = class_getInstanceMethod(class, oldSelector);
    method_exchangeImplementations(oldMethod, newMethod);
};

@implementation UITableView (TFY_TableViewMaker)

+ (void)load {
    
    SEL selectors[] = {
        @selector(reloadData),
        @selector(insertSections:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:),
        @selector(reloadSections:withRowAnimation:),
        @selector(moveSection:toSection:),
        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
        @selector(moveRowAtIndexPath:toIndexPath:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"tfy_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        HDExchangeImplementations(self, originalSelector, swizzledSelector);
    }
}

- (void)tfy_reloadData{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_reloadData];
}

- (void)tfy_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)tfy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tfy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tfy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tfy_moveSection:(NSInteger)section toSection:(NSInteger)newSection{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_moveSection:section toSection:newSection];
}

- (void)tfy_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_reloadSections:sections withRowAnimation:animation];
}


- (void)tfy_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_insertSections:sections withRowAnimation:animation];
}

- (void)tfy_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self.tfy_TableViewDataSource.tableData doSectionMakeBlock];
    [self tfy_insertSections:sections withRowAnimation:animation];
}

- (TFY_BaseTableViewDataSource *)tfy_TableViewDataSource {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setTfy_TableViewDataSource:(TFY_BaseTableViewDataSource *)tfy_TableViewDataSource{
    objc_setAssociatedObject(self,@selector(tfy_TableViewDataSource),tfy_TableViewDataSource,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = tfy_TableViewDataSource;
    self.dataSource = tfy_TableViewDataSource;
}

- (NSMutableDictionary *)tableViewRegisterCell
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(tableViewRegisterCell));
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self setTableViewRegisterCell:dic];
    }
    return dic;
}

- (void)setTableViewRegisterCell:(NSMutableDictionary *)tableViewRegisterCell{
    objc_setAssociatedObject(self, @selector(tableViewRegisterCell), tableViewRegisterCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UITableView *)tfy_tableViewMaker:(void (^)(TFY_TableViewMaker *))tableViewMakerBlock{
    TFY_TableViewMaker * tableViewmaker = [[TFY_TableViewMaker alloc] initWithTableView:self];
    tableViewMakerBlock(tableViewmaker);
    Class DataSourceClass = [TFY_BaseTableViewDataSource class];
    if (tableViewmaker.tableData.otherDelegateBlocksDic[NSStringFromSelector(@selector(tableView:commitEditingStyle:forRowAtIndexPath:))]) {
        class_addMethod(DataSourceClass,@selector(tableView:commitEditingStyle:forRowAtIndexPath:),(IMP)commitEditing,"v@:@@@");
    }
    
    if (tableViewmaker.tableData.otherDelegateBlocksDic[NSStringFromSelector(@selector(scrollViewDidScroll:))]) {
        class_addMethod(DataSourceClass,@selector(scrollViewDidScroll:),(IMP)scrollViewDidScroll,"v@:@");
    }
    
    if (tableViewmaker.tableData.otherDelegateBlocksDic[NSStringFromSelector(@selector(tableView:willDisplayCell:forRowAtIndexPath:))]) {
        class_addMethod(DataSourceClass,@selector(tableView:willDisplayCell:forRowAtIndexPath:),(IMP)cellWillDisplay,"v@:@@@");
    }
    
    id<TFY_BaseTableViewDataSourceProtocol> dataSource = (id<TFY_BaseTableViewDataSourceProtocol>) [DataSourceClass  new];
    [tableViewmaker.tableData doSectionMakeBlock];
    dataSource.tableData = tableViewmaker.tableData;
    self.tfy_TableViewDataSource = dataSource;
    return self;
}

@end

static void commitEditing(id self, SEL cmd, UITableView *tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath * indexPath)
{
    TFY_BaseTableViewDataSource * ds = self;
    CommitEditingBlock block = ds.tableData.otherDelegateBlocksDic[NSStringFromSelector(cmd)];
    if(block) {
        block(tableView,editingStyle,indexPath);
    }
}

static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView) {
    TFY_BaseTableViewDataSource * ds = self;
    ScrollViewDidScrollBlock block = ds.tableData.otherDelegateBlocksDic[NSStringFromSelector(cmd)];
    if(block) {
        block(scrollView);
    }
};

static void cellWillDisplay(id self, SEL cmd, UITableView *tableView,UITableViewCell *willDisplayCell,NSIndexPath *indexPath){
    TFY_BaseTableViewDataSource * ds = self;
    CellWillDisplayBlock block = ds.tableData.otherDelegateBlocksDic[NSStringFromSelector(cmd)];
    if(block) {
        block(tableView,willDisplayCell,indexPath);
    }
}


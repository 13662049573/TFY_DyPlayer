//
//  TFY_QuickregistrationController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_QuickregistrationController.h"
#import "TFY_QuickregistrationModel.h"
#import "TFY_QuickregistrationHerderView.h"
#import "TFY_QuickregistrationFooderView.h"
#import "TFY_QuickregistrationCell.h"
@interface TFY_QuickregistrationController ()
@property (nonatomic , strong)TFY_QuickregistrationModel *models;

@property (nonatomic , strong)TFY_QuickregistrationFooderView *fooderView;

@property(nonatomic , copy)NSString *phone;

@property(nonatomic , copy)NSString *passwolrd;

@property(nonatomic , copy)NSString *code;


@end

@implementation TFY_QuickregistrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快速注册";
    
    self.navigationItem.leftBarButtonItem = tfy_barbtnItem().tfy_imageItem(@"arrrow_iocn_my",self,@selector(popview));
    
    self.models = [TFY_QuickregistrationModel new];
    TFY_PLAYER_WS(myslef);
    self.fooderView = [[TFY_QuickregistrationFooderView alloc] initWithFrame:CGRectMake(0, 0, Width_W, 120)];
    self.fooderView.carryoutBlock = ^{
        myslef.quickregistrationBlock(myslef.phone, myslef.code, myslef.passwolrd);
        [myslef.navigationController popViewControllerAnimated:YES];
    };
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
    
    [self quickregistrationData];
    
    [self registLoginEvent];
}
-(void)popview{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)quickregistrationData{
    QuickCommand *command = [QuickCommand new];
    [[command.quickCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[TFY_QuickregistrationModel class]]) {
            self.models = x;
        }
        [self.tableView reloadData];
        
        [self tableViewLayout];
    }];
}

-(void)tableViewLayout{
    [self.tableView tfy_tableViewMaker:^(TFY_TableViewMaker * _Nonnull tableMaker) {
        
        tableMaker.tfy_tableViewHeaderView(^(){
            TFY_QuickregistrationHerderView *herderView = [[TFY_QuickregistrationHerderView alloc] initWithFrame:CGRectMake(0, 0, Width_W, Width_W*3/4)];
            herderView.vc = self;
            return herderView;
        });
        tableMaker.tfy_tableViewFooterView(^(){
            return self.fooderView;
        });
        [tableMaker tfy_addSectionMaker:^(TFY_SectionMaker * _Nonnull sectionMaker) {
            
            [sectionMaker.tfy_dataArr(TFY_DataArr(self.models.quickitems)) tfy_cellMaker:^(TFY_CellMaker * _Nonnull cellMaker) {
                
                cellMaker.tfy_cellClass(TFY_CellClass(TFY_QuickregistrationCell))
                .tfy_adapter(^(__kindof TFY_QuickregistrationCell *cell,id data,NSIndexPath *indexPath){
                    TFY_PLAYER_WS(myslef);
                    cell.phonefiledBlock = ^(NSString * _Nonnull text) {
                        myslef.phone = text;
                    };
                    cell.passwordfiledBlock = ^(NSString * _Nonnull text) {
                        myslef.passwolrd = text;
                    };
                    cell.codefiledBlock = ^(NSString * _Nonnull text) {
                        myslef.code = text;
                    };
                    cell.models = data;
                    
                    cell.indexPath = indexPath;
                    
                }).tfy_rowHeight(50);
            }];
            
        }];
        
    }];
}

-(void)registLoginEvent{
    
    RAC(self,fooderView.buttombool) = [RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self,passwolrd),RACObserve(self,code)]
                                                      reduce:^id(NSString *bankCardNo,NSString *bankNameStr,NSString *codes){
      
      BOOL enable = (bankCardNo.length >= 11 && bankNameStr.length > 0 && codes.length>5);
      return @(enable);
      
  }];
}
@end

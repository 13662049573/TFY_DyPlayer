//
//  TFY_PlayerVideoController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/8.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_PlayerVideoController.h"
#import "TFY_PlayerVideoherderView.h"
#import "TFY_PlayerVideo_Model.h"
#import "TFY_PlayerVideoCell.h"

#import "TFY_PlayerToolsHeader.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface TFY_PlayerVideoController ()<HerderDelegate>

@property (nonatomic, strong) TFY_PlayerController *player;
@property (nonatomic, strong) UIImageView *imageViews;
@property (nonatomic, strong) TFY_PlayerControllerView *controlView;

@property(nonatomic , strong)TFY_PlayerVideo_Model *models;

@property(nonatomic , strong)TFY_PlayerVideoherderView *herderView;

@property(nonatomic , strong)NSMutableArray *urlArray;

@property(nonatomic , copy)NSString *ids;

@property(nonatomic , assign)TFY_PlayerVideState type;

@property(nonatomic , assign)NSInteger seekpalyertime;

@property(nonatomic , assign)NSTimeInterval delay;

//收藏模型
@property(nonatomic , strong)TFY_CollectionModel *collectionModel;
@end

@implementation TFY_PlayerVideoController


-(void)VideoID:(NSString *)ids Playertype:(TFY_PlayerVideState)type PlayerSeektime:(NSInteger)time{
    self.ids = [ids copy];
    
    self.type = type;
    
    if (time > 0) {
        self.seekpalyertime = time;
    }
    
    [self.tableView reloadData];
}

-(void)setCurrentPlayIndex:(NSInteger)currentPlayIndex{
    _currentPlayIndex = currentPlayIndex;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = NO;
    
    [[self tfy_tabBarController] setTabBarHidden:YES animated:YES Hidden:YES];
    
    [self AppDelegateenablePortrait:YES lockedScreen:NO];
    
    [self collectionSqlite];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
     self.player.viewControllerDisappear = YES;
    
    [VideoCommand ModelSqliteData:self.player Playertype:self.type];
    
    [self AppDelegateenablePortrait:NO lockedScreen:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageViews];
    self.imageViews.tfy_LeftSpace(0).tfy_TopSpace(0).tfy_RightSpace(0).tfy_Height(TFY_PLAYER_ScreenW*9/16);
    
    self.player = [TFY_PlayerController playerWithPlayerManagercontainerView:self.imageViews];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    //开启多视频连续播放
    self.player.continuouslybool = YES;
//    //键盘开启转向
    self.player.forceDeviceOrientation = YES;
    
    TFY_PLAYER_WS(myself);
    self.player.playvideocontinuously = ^(TFY_PlayerController *player, TFY_PlayerVideoModel * _Nonnull model) {
        
        myself.controlView.currentPlayIndex = player.currentPlayIndex;
        
        [myself.controlView showTitle:model.tfy_name coverURLString:kVideoCover fullScreenMode:FullScreenModeLandscape];
    };
    
    self.tableView.tableHeaderView = self.herderView;
    [self.view addSubview:self.tableView];
    
    self.tableView.tfy_LeftSpace(0).tfy_TopSpaceToView(0, self.imageViews).tfy_RightSpace(0).tfy_BottomSpace(0);
    
    [self show_url_layoue:self.ids];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"Killbackground" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        [VideoCommand ModelSqliteData:self.player Playertype:self.type];
    }];
    
    [self addDeviceOrientationObserver];
}

-(void)show_url_layoue:(NSString *)ids{
    VideoCommand *command = [VideoCommand new];
    command.ids = ids;
    [[command.showCommand execute:@1] subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[TFY_PlayerVideo_Model class]]) {
            
            self.models = x;
            
            self.title = self.models.data.name;
            
            self.urlArray = [NSMutableArray array];
        
            [self.models.data.zu enumerateObjectsUsingBlock:^(Zu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [obj.ji enumerateObjectsUsingBlock:^(Ji * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TFY_PlayerVideoModel *modes = [TFY_PlayerVideoModel new];
                    modes.tfy_name = [NSString stringWithFormat:@"%@ %@",self.models.data.name,obj.name];
                    modes.tfy_url = obj.purl;
                    modes.tfy_videoId = [NSString stringWithFormat:@"%ld",(long)obj.id];
                    modes.tfy_pic = self.models.data.pic;
                    modes.tfy_ids = ids;
                    
                    [self.urlArray addObject:modes];
                    
                }];
            }];
            self.player.assetUrlMododels = self.urlArray;
            self.controlView.videoCount = self.urlArray.count;
            [self.player playTheIndex:self.currentPlayIndex];
        }
        
        [self tableViewLayout];
        
    } error:^(NSError * _Nullable error) {
        [TFY_ProgressHUD showErrorWithStatus:@"网络延迟请稍后尝试!"];
    }];
    
    if (self.seekpalyertime > 0) {
        [self performSelector:@selector(seekpalyertimeClick) withObject:nil afterDelay:1.2];
    }
}

- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)AppDelegateenablePortrait:(BOOL)enablebool lockedScreen:(BOOL)lockedScreen{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.enablePortrait = enablebool;
    delegate.lockedScreen = lockedScreen;
}

-(void)handleDeviceOrientationChange{
    if (self.player.lockedScreen) {
        [self AppDelegateenablePortrait:YES lockedScreen:YES];
    }
    else{
       [self AppDelegateenablePortrait:YES lockedScreen:NO];
    }
}
-(void)tableViewLayout{
    [self.tableView tfy_tableViewMaker:^(TFY_TableViewMaker * _Nonnull tableMaker) {
        
        tableMaker.tfy_tableViewHeaderView(^(){
            self.herderView.frame = CGRectMake(0, 0, Width_W, [TFY_PlayerVideoherderView heerderCGFlot:self.models.data.text]);
            self.herderView.models = self.models.data;
            self.herderView.hidden = NO;
            return self.herderView;
        });
        
        [tableMaker tfy_addSectionMaker:^(TFY_SectionMaker * _Nonnull sectionMaker) {
            
            [sectionMaker.tfy_dataArr(TFY_DataArr(self.urlArray)) tfy_cellMaker:^(TFY_CellMaker * _Nonnull cellMaker) {
               
                cellMaker.tfy_cellClass(TFY_CellClass(TFY_PlayerVideoCell))
                .tfy_adapter(^(__kindof TFY_PlayerVideoCell *cell,id data,NSIndexPath *indexPath){
                    
                    cell.models = data;
                    
                }).tfy_event(^(__kindof UITableView *tableView,NSIndexPath *indexPath,id data){
                    TFY_PlayerVideoModel *convermodel = data;
                    
                    [self.player playTheIndex:[convermodel.tfy_videoId integerValue]];
                    
                }).tfy_rowHeight(120);
            }];
            
        }];
        
    }];
}

//收藏代理返回
-(void)CollectionDelegateClick:(BOOL)selected{
    CollectionCommand *data = [CollectionCommand new];
    data.ids = self.ids;
    [data CollectionDelegateClick:selected];
}

//检测是否收藏过本视频
-(void)collectionSqlite{
    CollectionCommand *data = [CollectionCommand new];
    data.ids = self.ids;
    TFY_PLAYER_WS(myself);
    [data collectionSqlite:^(bool selectedbool) {
        myself.herderView.selected_btn = selectedbool;
    }];
}

- (TFY_PlayerControllerView *)controlView {
    if (!_controlView) {
        _controlView = [[TFY_PlayerControllerView alloc] init];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
        //返回
        TFY_PLAYER_WS(myself);
        _controlView.backBtnClickCallback = ^{
            [myself.navigationController popViewControllerAnimated:YES];
        };
    }
    return _controlView;
}

-(UIImageView *)imageViews{
    if (!_imageViews) {
        _imageViews = tfy_imageView();
        [_imageViews tfy_setImageWithURLString:kVideoCover placeholder:[UIImage imageNamed:@"zhnaweitu"]];
    }
    return _imageViews;
}

-(TFY_PlayerVideoherderView *)herderView{
    if (!_herderView) {
        _herderView = [TFY_PlayerVideoherderView new];
        _herderView.delegate = self;
        _herderView.hidden = YES;
    }
    return _herderView;
}

-(TFY_PlayerVideo_Model *)models{
    if (!_models) {
        _models = [TFY_PlayerVideo_Model new];
    }
    return _models;
}

-(TFY_CollectionModel *)collectionModel{
    if (!_collectionModel) {
        _collectionModel = [TFY_CollectionModel new];
    }
    return _collectionModel;
}

-(void)seekpalyertimeClick{
    [self.player seekToTime:self.seekpalyertime completionHandler:^(BOOL finished) {
        [self.player.currentPlayerManager play];
    }];
}

@end

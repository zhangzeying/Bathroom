//
//  MallViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallViewController.h"
#import "CategoryView.h"
#import "BathroomService.h"
#import "MallTableCell.h"
#import "MallHeaderView.h"
#import "MallService.h"
#import "GoodsCategoryModel.h"
#import "GoodsCategoryViewController.h"
#import "MallGoodsViewController.h"
#import "ActivityGoodsModel.h"
#import "GoodsInfoViewController.h"
#import "ActivityGoodsDetailModel.h"
@interface MallViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 网络请求对象 */
@property(nonatomic,strong)MallService *service;
/** 商品类别数组 */
@property(nonatomic,strong)NSMutableArray *categoryArr;
/** 热门商品数组 */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** <##> */
@property(nonatomic,strong)dispatch_group_t group;
@end

@implementation MallViewController

- (MallService *)service {
    
    if (_service == nil) {
        
        _service = [[MallService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)categoryArr {
    
    if (_categoryArr == nil) {
        
        _categoryArr = [NSMutableArray array];
    }
    
    return _categoryArr;
}

- (NSMutableArray *)goodsArr {
    
    if (_goodsArr == nil) {
        
        _goodsArr = [NSMutableArray array];
    }
    
    return _goodsArr;
}

- (dispatch_group_t )group {
    
    if (_group == nil) {
        
        _group = dispatch_group_create();
    }
    
    return _group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"商城" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self initView];
}

- (void)initView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 220;
    table.showsVerticalScrollIndicator = NO;
    MallHeaderView *mallHeaderView = [MallHeaderView instanceHeaderView];
    mallHeaderView.width = ScreenW;
    mallHeaderView.height = 30;
    table.tableHeaderView = mallHeaderView;
    [self.view addSubview:table];
    self.table = table;
    CategoryView *headerView = [[CategoryView alloc]init];
    headerView.frame = CGRectMake(0, 0, ScreenW, 180);
    headerView.categoryType = Mall;
    __weak typeof (self)weakSelf = self;
    
    headerView.categoryViewBlock = ^(GoodsCategoryModel *model){
        
        if (model.index == 7) {
            
            GoodsCategoryViewController *goodsCategoryVC = [[GoodsCategoryViewController alloc]init];
            goodsCategoryVC.categoryArr = self.categoryArr;
            goodsCategoryVC.hidesBottomBarWhenPushed = YES;
            goodsCategoryVC.categoryArr = self.categoryArr;
            [weakSelf.navigationController pushViewController:goodsCategoryVC animated:YES];
            return;
        }
        
        MallGoodsViewController *mallGoodsVC = [[MallGoodsViewController alloc]init];
        mallGoodsVC.model = model;
        mallGoodsVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:mallGoodsVC animated:YES];
    };
    
    [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
        
        [categoryArr removeObjectAtIndex:0];
        weakSelf.categoryArr = categoryArr;
        headerView.categoryArr = categoryArr;
    }];
    
    table.tableHeaderView = headerView;
    table.backgroundColor = [UIColor whiteColor];
    
    [self setupRefresh];
    
    [self.service getPackageList:^(ActivityGoodsModel *model) {
        
        weakSelf.goodsArr = model.list;
        [weakSelf.table reloadData];
    }];

    
}

- (void)setupRefresh {
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.table.mj_header = header;
}

- (void)loadNewData {

    __weak typeof(self) weakSelf = self;
    dispatch_group_async(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
            
            weakSelf.categoryArr = categoryArr;
            [weakSelf.table reloadData];
        }];
        
    });
    
    dispatch_group_async(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.service getPackageList:^(ActivityGoodsModel *model) {
            
            weakSelf.goodsArr = model.list;
            [weakSelf.table reloadData];
        }];
    });
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.table.mj_header endRefreshing];
    });

}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MallTableCell *cell = [MallTableCell cellWithTableView:tableView];
    cell.model = self.goodsArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ActivityGoodsDetailModel *model = self.goodsArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

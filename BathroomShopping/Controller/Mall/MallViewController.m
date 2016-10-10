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
#import "MallService.h"
#import "GoodsCategoryModel.h"
#import "GoodsCategoryViewController.h"
#import "MallGoodsViewController.h"
#import "ActivityGoodsModel.h"
#import "GoodsInfoViewController.h"
#import "MallPackageModel.h"
#import "CustomRefreshHeader.h"
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
    
    UIView *headerView = [[UIView alloc]init];
    
    CategoryView *categoryView = [[CategoryView alloc]init];
    categoryView.frame = CGRectMake(0, 0, ScreenW, 180);
    categoryView.categoryType = Mall;
    __weak typeof (self)weakSelf = self;
    
    categoryView.categoryViewBlock = ^(GoodsCategoryModel *model){
        
        if (model.index == 7) {
            
            GoodsCategoryViewController *goodsCategoryVC = [[GoodsCategoryViewController alloc]init];
            goodsCategoryVC.categoryArr = self.categoryArr;
            goodsCategoryVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:goodsCategoryVC animated:YES];
            return;
        }
        
        MallGoodsViewController *mallGoodsVC = [[MallGoodsViewController alloc]init];
        mallGoodsVC.model = model;
        mallGoodsVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:mallGoodsVC animated:YES];
    };
    
    [headerView addSubview:categoryView];
    __block CategoryView *categoryV = categoryView;
    [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
        
        [categoryArr removeObjectAtIndex:0];
        weakSelf.categoryArr = categoryArr;
        categoryV.categoryArr = categoryArr;
    }];
   
    
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, CGRectGetMaxY(categoryView.frame), ScreenW, 30);
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"特色好货";
    titleLbl.textColor = CustomColor(51, 51, 51);
    titleLbl.font = [UIFont systemFontOfSize:13];
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(0, 0, titleLbl.width, titleLbl.height);
    titleLbl.centerY = titleView.height / 2;
    titleLbl.centerX = titleView.width / 2;
    [titleView addSubview:titleLbl];
    
    UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame) - 15 - 70, 0, 70, 1)];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    leftLine.centerY = titleLbl.centerY;
    [titleView addSubview:leftLine];

    UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLbl.frame) + 15, 0, 70, 1)];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    rightLine.centerY = titleLbl.centerY;
    [titleView addSubview:rightLine];
    
    [headerView addSubview:titleView];
    
    headerView.width = ScreenW;
    headerView.height = categoryView.height + titleView.height;
    
    [self.view addSubview:table];
    self.table = table;
    
    
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
    CustomRefreshHeader *header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];    
    self.table.mj_header = header;
}

- (void)loadNewData {

    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(self.group);
    [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
        
        if (categoryArr != nil) {
            
            weakSelf.categoryArr = categoryArr;
            [weakSelf.table reloadData];
        }

        dispatch_group_leave(weakSelf.group);
    }];
    
    dispatch_group_enter(self.group);
    [self.service getPackageList:^(ActivityGoodsModel *model) {
        
        if (model != nil) {
            
            weakSelf.goodsArr = model.list;
            [weakSelf.table reloadData];
        }
        
        dispatch_group_leave(weakSelf.group);
    }];
    
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

    MallPackageModel *model = self.goodsArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:nil packageId:model.id];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

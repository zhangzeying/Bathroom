//
//  GoodsCategoryViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsCategoryViewController.h"
#import "GoodsCategoryTableCell.h"
#import "GoodsViewController.h"
#import "GoodsCategoryModel.h"
@interface GoodsCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>
/** categoryTable */
@property (nonatomic, weak)UITableView *categoryTable;
@end

@implementation GoodsCategoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"卫浴";
}

/**
 * 创建类别table
 */
- (void)setupCategoryTable {

    UITableView *categoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW * 0.3, ScreenH) style:UITableViewStylePlain];
    categoryTable.delegate = self;
    categoryTable.dataSource = self;
    categoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:categoryTable];
    categoryTable.rowHeight = 45;
    self.categoryTable = categoryTable;
    [categoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

/**
 * 将右边的商品以子控制器添加进来
 */
- (void)setupChildGoodVC {

    GoodsViewController *goodsVC = [[GoodsViewController alloc]init];
    [self addChildViewController:goodsVC];

    [self.view addSubview:goodsVC.view];
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.categoryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GoodsCategoryTableCell *cell = [GoodsCategoryTableCell cellWithTableView:tableView];
    GoodsCategoryModel *model = self.categoryArr[indexPath.row];
    cell.categoryLbl.text = model.name;
    
    return cell;
}

#pragma mark --- UITableViewDelegate ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     //把选择的行滚动到最上方
     [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)setCategoryArr:(NSMutableArray *)categoryArr {

    _categoryArr = categoryArr;
    [self setupCategoryTable];
    [self setupChildGoodVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

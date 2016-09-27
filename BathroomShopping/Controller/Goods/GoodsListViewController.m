//
//  GoodsListViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableCell.h"
@interface GoodsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品清单";
    
}

- (void)initView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 130;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListTableCell *cell = [GoodsListTableCell cellWithTableView:tableView];
    cell.model = self.goodsArr[indexPath.row];
    return cell;
}

- (void)setGoodsArr:(NSMutableArray *)goodsArr {

    _goodsArr = goodsArr;
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

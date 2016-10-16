//
//  OrderDetailViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailGoodsTableCell.h"
#import "OrderDetailHeaderView.h"
#import "OrderDetailFooterView.h"
@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
}

- (void)initTable {

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 60)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 110;
    tableView.backgroundColor = CustomColor(240, 242, 245);
    [self.view addSubview:tableView];
    
    OrderDetailHeaderView *header = [OrderDetailHeaderView instanceHeaderView];
    header.height = 140;
    tableView.tableHeaderView = header;
    
    OrderDetailFooterView *footer = [OrderDetailFooterView instanceFooterView];
    footer.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame), ScreenW, 60);
    [self.view addSubview:footer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailGoodsTableCell *cell = [OrderDetailGoodsTableCell cellWithTableView:tableView];
    return cell;
}

- (void)setGoodsArr:(NSMutableArray *)goodsArr {

    _goodsArr = goodsArr;
    [self initTable];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

//
//  OrderViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableCell.h"
#import "OrderService.h"
#import "ErrorView.h"
@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)OrderService *service;
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation OrderViewController

- (OrderService *)service {
    
    if (_service == nil) {
        
        _service = [[OrderService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initView {

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CustomColor(243, 243, 243);
    tableView.rowHeight = 210;
    tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderTableCell *cell = [OrderTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)setOrderType:(OrderType)orderType {

    _orderType = orderType;
    if (self.orderType == NoPayOrder) {//未付款
        
        self.navigationItem.title = @"未付款";
        
    }else if (self.orderType == NoReceiveOrder) {
    
        self.navigationItem.title = @"待收货";
        
    }else {
    
        self.navigationItem.title = @"全部订单";
    }
    
    [self initView];
}

- (void)setDataArr:(NSMutableArray *)dataArr {

    _dataArr = dataArr;
    if (dataArr.count == 0) {
        
        [self.tableView removeFromSuperview];
        ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
        errorView.warnStr = @"您还没有相关的订单哦！";
        errorView.imgName = @"sys_xiao8";
        errorView.btnTitle = @"";
        [self.view addSubview:errorView];
        
    }else {
    
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

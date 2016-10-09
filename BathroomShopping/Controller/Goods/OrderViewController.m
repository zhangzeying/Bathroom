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
#import "CustomRefreshHeader.h"
@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)OrderService *service;
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
/** <##> */
@property(nonatomic,strong)NSArray *titleArr;
/** <##> */
@property (nonatomic, weak)UIView *indicatorView;
/** 记录选中的title */
@property(nonatomic,strong)UIButton *selectedBtn;
/** <##> */
@property (nonatomic, weak)UILabel *line;
/** <##> */
@property (nonatomic, weak)UIView *scrollTitleView;
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property (nonatomic, strong)ErrorView *errorView;
@end

@implementation OrderViewController

- (ErrorView *)errorView {
    
    if (_errorView == nil) {
        
        _errorView = [[ErrorView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame), ScreenW, ScreenH - CGRectGetMaxY(self.line.frame))];
        _errorView.warnStr = @"您还没有相关的订单哦！";
        _errorView.imgName = @"sys_xiao8";
        _errorView.btnTitle = @"";
        [self.view addSubview:_errorView];
    }
    
    return _errorView;
}

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (OrderService *)service {
    
    if (_service == nil) {
        
        _service = [[OrderService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.titleArr = @[@"全部",@"待付款",@"待收货",@"待发货"];
}

- (void)initTitleView {
    
    UIView *scrollTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 66, ScreenW, 30)];
    [self.view addSubview:scrollTitleView];
    self.scrollTitleView = scrollTitleView;
    
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(0, CGRectGetMaxY(scrollTitleView.frame), ScreenW, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self.view addSubview:line];
    self.line = line;
    
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = NavgationBarColor;
    indicatorView.height = 2;
    indicatorView.y = scrollTitleView.height - 2;
    [scrollTitleView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    CGFloat btnW = scrollTitleView.width / self.titleArr.count;
    CGFloat btnH = scrollTitleView.height;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:NavgationBarColor forState:UIControlStateDisabled];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollTitleView addSubview:btn];
    }
}

#pragma mark --- UIButtonClick ---
- (void)titleClick:(UIButton *)sender {
    
    self.selectedBtn.enabled = YES;
    sender.enabled = NO;
    self.selectedBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = sender.titleLabel.width;
        self.indicatorView.centerX = sender.centerX;
    }];
    
    switch (sender.tag) {
        case 0:
            [self getOrderList:@"all"];
            break;
        case 1:
            [self getOrderList:@"nopay"];
            break;
        case 2:
            [self getOrderList:@"send"];
            break;
        case 3:
            [self getOrderList:@"payed"];
            break;
        default:
            break;
    }
}

- (void)initTableView {

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame), ScreenW, ScreenH - CGRectGetMaxY(self.line.frame)) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CustomColor(238, 238, 238);
    tableView.rowHeight = 204;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self setupRefresh];
}

- (void)setupRefresh {
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    CustomRefreshHeader *header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
}

- (void)loadNewData {

    switch (self.selectedBtn.tag) {
        case 0:
            [self getOrderList:@"all"];
            break;
        case 1:
            [self getOrderList:@"nopay"];
            break;
        case 2:
            [self getOrderList:@"send"];
            break;
        case 3:
            [self getOrderList:@"payed"];
            break;
        default:
            break;
    }
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
    [self initTitleView];
    [self initTableView];
    UIButton *btn;
    if (self.orderType == NoPayOrder) {//未付款
        
        btn = self.scrollTitleView.subviews[2];
        [self getOrderList:@"nopay"];
        
    }else if (self.orderType == NoReceiveOrder) {
    
        btn = self.scrollTitleView.subviews[3];
        [self getOrderList:@"send"];
        
    }else {
    
        btn = self.scrollTitleView.subviews[1];
        [self getOrderList:@"all"];
    }
    
    btn.enabled = NO;
    self.selectedBtn = btn;
    [btn.titleLabel sizeToFit];
    self.indicatorView.width = btn.titleLabel.width;
    self.indicatorView.centerX = btn.centerX;
    
    
}

/**
 * 获取订单
 */
- (void)getOrderList:(NSString *)orderType {
    
    __weak typeof (self)weakSelf = self;
    [self.service getOrder:orderType completion:^(NSMutableArray *dataArr) {
        
        weakSelf.dataArr = dataArr;
        if (weakSelf.tableView != nil) {
            
            [weakSelf.tableView removeFromSuperview];
            weakSelf.tableView = nil;
        }
        
        if (dataArr.count == 0) {
            
            weakSelf.errorView.hidden = NO;
            
        }else {
            
            self.errorView.hidden = YES;
            [weakSelf initTableView];
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

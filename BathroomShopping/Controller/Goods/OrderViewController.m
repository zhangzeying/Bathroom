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

typedef NS_ENUM(NSInteger, LoadType){
    PullDown, //下拉刷新
    PullUp, //上拉加载更多
    Normal //正常加载
};

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
@property(assign,nonatomic)NSInteger total;
/** <##> */
@property (nonatomic, strong)ErrorView *errorView;
/** 页码 */
@property(assign,nonatomic)NSInteger offset;
/** 记录操作之前的页码 */
@property(assign,nonatomic)NSInteger lastOffset;
/** <##> */
@property(assign,nonatomic)LoadType loadType;
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
    
    self.offset = 0;
    self.loadType = Normal;
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
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadNewData {

    self.lastOffset = self.offset;
    self.offset = 0;
    self.loadType = PullDown;
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

- (void)loadMoreData {

    self.offset++;
    self.loadType = PullUp;
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
    if (self.dataArr.count == self.total) {//没有更多数据了
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    self.tableView.mj_footer.hidden = self.dataArr.count == 0;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderTableCell *cell = [OrderTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)setOrderType:(OrderType)orderType {

    _orderType = orderType;
    self.offset = 0;
    self.loadType = Normal;
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
    if (self.loadType == Normal) {
        
        [SVProgressHUD show];
    }
    [self.service getOrder:orderType offset:self.offset completion:^(NSMutableArray *dataArr,NSInteger total) {
        if (self.loadType == Normal) {
            
            [SVProgressHUD dismiss];
        }
        if (total != -1) { //加载成功
         
             weakSelf.total = total;
            if (self.loadType == PullDown) {//下拉刷新
                
                [weakSelf.dataArr removeAllObjects];
                weakSelf.dataArr = dataArr;
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                
            }else if(self.loadType == PullUp) {//上拉加载更多
                
                [weakSelf.dataArr addObjectsFromArray:dataArr];
                if (weakSelf.dataArr.count >= self.total) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                [weakSelf.tableView reloadData];
                
            }else {
            
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
            }
            
           
            
        }else {//加载失败
        
            if (self.loadType == PullDown) {//下拉刷新
                
                self.offset = self.lastOffset;
                [weakSelf.tableView.mj_header endRefreshing];
                
            }else if(self.loadType == PullUp) {
            
                self.offset--;
                [weakSelf.tableView.mj_footer endRefreshing];
                
            }else {
            
                
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

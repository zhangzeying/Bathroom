//
//  MineViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MineHeaderView.h"
#import "CustomButton.h"
#import "MineTableViewCell.h"
#import "FileNameDefine.h"
#import "OrderViewController.h"
#import "OrderService.h"
#define hspace 10
#define cartCountH 15
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, MineHeaderViewDelegate>
@property(nonatomic,strong)NSArray *titleArr;
/** <##> */
@property(nonatomic,strong)OrderService *service;
/** <##> */
@property(nonatomic,strong)NSMutableArray *nopayOrderArr;
/** <##> */
@property(nonatomic,strong)NSMutableArray *noReceiveOrderArr;
/** <##> */
@property(nonatomic,strong)UILabel *nopayCountLbl;
/** <##> */
@property(nonatomic,strong)UILabel *noReceiveCountLbl;
/** <##> */
@property (nonatomic, weak)MineHeaderView *headerView;
@end

@implementation MineViewController

- (OrderService *)service {
    
    if (_service == nil) {
        
        _service = [[OrderService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)nopayOrderArr {
    
    if (_nopayOrderArr == nil) {
        
        _nopayOrderArr = [NSMutableArray array];
    }
    
    return _nopayOrderArr;
}

- (NSMutableArray *)noReceiveOrderArr {
    
    if (_noReceiveOrderArr == nil) {
        
        _noReceiveOrderArr = [NSMutableArray array];
    }
    
    return _noReceiveOrderArr;
}

- (UILabel *)nopayCountLbl {
    
    if (_nopayCountLbl == nil) {
        
        _nopayCountLbl = [[UILabel alloc] init];
        _nopayCountLbl.textAlignment = NSTextAlignmentCenter;
        _nopayCountLbl.font = [UIFont systemFontOfSize:9];
        _nopayCountLbl.textColor = [UIColor whiteColor];
        [self layoutCountLbl];
        _nopayCountLbl.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
        _nopayCountLbl.layer.masksToBounds = YES;
        CustomButton *nopayBtn = [self.headerView viewWithTag:1];
        [nopayBtn addSubview:_nopayCountLbl];
    }
    return _nopayCountLbl;
}

- (UILabel *)noReceiveCountLbl {
    
    if (_noReceiveCountLbl == nil) {
        
        _noReceiveCountLbl = [[UILabel alloc] init];
        _noReceiveCountLbl.textAlignment = NSTextAlignmentCenter;
        _noReceiveCountLbl.font = [UIFont systemFontOfSize:9];
        _noReceiveCountLbl.textColor = [UIColor whiteColor];
        [self layoutCountLbl];
        _noReceiveCountLbl.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
        _noReceiveCountLbl.layer.masksToBounds = YES;
        CustomButton *noReceiveBtn = [self.headerView viewWithTag:2];
        [noReceiveBtn addSubview:_noReceiveCountLbl];
    }
    return _noReceiveCountLbl;
}


- (void)layoutCountLbl {
    
    [_nopayCountLbl sizeToFit];
    CustomButton *nopayBtn = [self.headerView viewWithTag:1];
    NSInteger length = _nopayCountLbl.text.length;
    CGFloat extra = length > 1 ? 8 : 0;
    CGFloat width = MAX(cartCountH, (_nopayCountLbl.frame.size.width+extra));
    _nopayCountLbl.frame = CGRectMake(CGRectGetMaxX(nopayBtn.imageView.frame) - 5, CGRectGetMidY(nopayBtn.imageView.frame) - 15, width, cartCountH);
    _nopayCountLbl.layer.cornerRadius = cartCountH / 2;
    
    [_noReceiveCountLbl sizeToFit];
    CustomButton *noReceiveBtn = [self.headerView viewWithTag:2];
    NSInteger length1 = _noReceiveCountLbl.text.length;
    CGFloat extra1 = length1 > 1 ? 8 : 0;
    CGFloat width1 = MAX(cartCountH, (_noReceiveCountLbl.frame.size.width+extra1));
    _noReceiveCountLbl.frame = CGRectMake(CGRectGetMaxX(noReceiveBtn.imageView.frame) - 5, CGRectGetMidY(noReceiveBtn.imageView.frame) - 15, width1, cartCountH);
    _noReceiveCountLbl.layer.cornerRadius = cartCountH / 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.titleArr = @[@"商品预约",@"商品收藏",@"关于我们",@"设置"];
    [self setupTable];
    
    [self getOrderList];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)setupTable {

    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
    
    // --- 创建table的头部视图UI
    MineHeaderView *headerView = [MineHeaderView instanceHeaderView];
    headerView.delegate = self;
    headerView.width = ScreenW;

    NSArray *btnTitleArr = @[@"待付款",@"待收货"];
    NSArray *btnImage = @[@"wait_pay_icon",@"wait_get_icon"];
    CGFloat btnW = (ScreenW * 0.75 - hspace * 3) / btnTitleArr.count;
    CGFloat btnH = 60;
    CGFloat btnY = CGRectGetMaxY(headerView.line.frame);
    for (int i = 0; i < btnTitleArr.count; i++) {
        
        CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
        btn.centerOffset = 15;
        btn.isCheckLogin = YES;
        [btn setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [btn setTitleColor:CustomColor(102, 102, 102) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        CGFloat btnX = i * btnW + 10 * (i + 1);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [headerView addSubview:btn];
    }
    UILabel *line1 = [[UILabel alloc]init];
    CGFloat line1X = ScreenW * 0.75;
    line1.frame = CGRectMake(line1X, btnY, 0.8, btnH);
    line1.backgroundColor = CustomColor(235, 235, 235);
    [headerView addSubview:line1];
    
    UIButton *myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myOrderBtn.frame = CGRectMake(CGRectGetMaxX(line1.frame) + 5, btnY, ScreenW - CGRectGetMaxX(line1.frame), btnH);
    [myOrderBtn setTitleColor:CustomColor(102, 102, 102) forState:UIControlStateNormal];
    myOrderBtn.isCheckLogin = YES;
    [myOrderBtn setImage:[UIImage imageNamed:@"order_arrow_icon"] forState:UIControlStateNormal];
    [myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [myOrderBtn addTarget:self action:@selector(myOrderClick) forControlEvents:UIControlEventTouchUpInside];
    CGSize myOrderBtnSize = [myOrderBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [myOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [myOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, myOrderBtnSize.width, 0, -myOrderBtnSize.width)];
    myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:myOrderBtn];
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.frame = CGRectMake(0, CGRectGetMaxY(myOrderBtn.frame), ScreenW, 0.8);
    line2.backgroundColor = CustomColor(235, 235, 235);
    [headerView addSubview:line2];
    headerView.height = CGRectGetMaxY(line2.frame) + 20;
    
    table.tableHeaderView = headerView;
    self.headerView = headerView;
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 50;
    [self.view addSubview:table];
}

#pragma mark --- MineHeaderViewDelegate ---
/**
 * 登录
 */
- (void)login {
    
    LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
    [self presentViewController:loginNav animated:YES completion:nil];
}

/**
 * 账户管理
 */
- (void)infomation {

    Class cls = NSClassFromString(@"UserManageViewController");
    UIViewController *vc = [[cls alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MineTableViewCell *cell = [MineTableViewCell cellWithTableView:tableView];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --- UITableViewDelegate ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {//设置
        
        Class cls = NSClassFromString(@"SettingViewController");
        UIViewController *vc = [[cls alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){//我的收藏

        if (![[CommUtils sharedInstance] isLogin]) {
            
            LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
            [self presentViewController:loginNav animated:YES completion:nil];
            
        }else {
        
            Class cls = NSClassFromString(@"MyLikedViewController");
            UIViewController *vc = [[cls alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 0) {//我的预约
    
        if (![[CommUtils sharedInstance] isLogin]) {
            
            LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
            [self presentViewController:loginNav animated:YES completion:nil];
            
        }else {
            
            Class cls = NSClassFromString(@"MyAppointViewController");
            UIViewController *vc = [[cls alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 2) {//设置
        
        Class cls = NSClassFromString(@"AboutViewController");
        UIViewController *vc = [[cls alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

/**
 * 获取订单
 */
- (void)getOrderList {

    __weak typeof (self)weakSelf = self;
    if ([[CommUtils sharedInstance] isLogin]) {
        
        [self.service getOrder:@"nopay" completion:^(NSMutableArray *dataArr) {
            
            weakSelf.nopayOrderArr = dataArr;
            weakSelf.nopayCountLbl.text = [NSString stringWithFormat:@"%ld",dataArr.count];
            if (dataArr.count == 0) {
                
                weakSelf.nopayCountLbl.hidden = YES;
                
            }else {
                
                [weakSelf layoutCountLbl];
                weakSelf.nopayCountLbl.hidden = NO;
            }
            
        }];
        
        [self.service getOrder:@"send" completion:^(NSMutableArray *dataArr) {
            
            weakSelf.noReceiveOrderArr = dataArr;
            weakSelf.noReceiveCountLbl.text = [NSString stringWithFormat:@"%ld",dataArr.count];
            
            if (dataArr.count == 0) {
                
                weakSelf.noReceiveCountLbl.hidden = YES;
                
            }else {
                
                [weakSelf layoutCountLbl];
                weakSelf.noReceiveCountLbl.hidden = NO;
            }
        }];
    }
}

#pragma mark --- UIButtonClick ---
- (void)btnClick:(UIButton *)sender {

    if (sender.tag == 1) {//待付款
        
        OrderViewController *orderVC = [[OrderViewController alloc]init];
        orderVC.orderType = NoPayOrder;
        orderVC.dataArr = self.nopayOrderArr;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        

    }else {//待收货
    
        OrderViewController *orderVC = [[OrderViewController alloc]init];
        orderVC.orderType = NoReceiveOrder;
        orderVC.dataArr = self.noReceiveOrderArr;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)myOrderClick {

    OrderViewController *orderVC = [[OrderViewController alloc]init];
    orderVC.orderType = MyOrder;
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

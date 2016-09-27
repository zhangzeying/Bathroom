//
//  AddressManageViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressManageTableCell.h"
#import "AddReceiverViewController.h"
#import "MineService.h"
#import "ReceiverAddressModel.h"
#import "ErrorView.h"
@interface AddressManageViewController ()<UITableViewDelegate, UITableViewDataSource, AddressManageDelegate>
/** <##> */
@property(nonatomic,strong)NSMutableArray *addressArr;
/** <##> */
@property(nonatomic,strong)MineService *service;
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** <##> */
@property (nonatomic, weak)ErrorView *errorView;
@end

@implementation AddressManageViewController

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)addressArr {
    
    if (_addressArr == nil) {
        
        _addressArr = [NSMutableArray array];
    }
    
    return _addressArr;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"AddAddressSuccess" object:nil];
    self.navigationItem.title = @"地址管理";
    self.view.backgroundColor = CustomColor(240, 242, 245);
    
    [self onLoad];
}

- (void)onLoad {

    __weak typeof (self)weakSelf = self;
    
    [self.service getAddressList:^(NSMutableArray *addressArr) {
        
        weakSelf.addressArr = addressArr;
        if (addressArr.count == 0) {
            
            [weakSelf initErrorView];
            
        }else {
            
           
            [weakSelf initView];
        }
    }];
}
- (void)initView {

    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 64 - 38 - 13 - 10) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 140;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    self.table = table;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor redColor];
    addBtn.frame = CGRectMake(20, ScreenH - 38 - 13, ScreenW - 40, 38);
    [addBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addReceiverClick) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:addBtn];
}

/**
 * error view
 */
- (void)initErrorView {
    
    ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
    errorView.warnStr = @"您还没有收货地址哦！";
    errorView.btnTitle = @"新建地址";
    errorView.imgName = @"sys_xiao8";
    [errorView setTarget:self action:@selector(addReceiverClick)];
    self.errorView = errorView;
    [self.view addSubview:errorView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AddressManageTableCell *cell = [AddressManageTableCell cellWithTableView:tableView];
    cell.delegate = self;
    ReceiverAddressModel *model = self.addressArr[indexPath.row];
    cell.model = model;
    return cell;
}

/**
 * 新建收货人
 */
- (void)addReceiverClick {

    AddReceiverViewController *addReceiverVC = [[AddReceiverViewController alloc]init];
    addReceiverVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addReceiverVC animated:YES];
}

/**
 * 新加了地址刷新数据
 */
- (void)reloadData {

    if (self.errorView != nil) {
        
        [self.errorView removeFromSuperview];
        self.errorView = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self onLoad];
        });
        
    }else {
    
        __weak typeof (self)weakSelf = self;
        [self.service getAddressList:^(NSMutableArray *addressArr) {
            
            weakSelf.addressArr = addressArr;
            [weakSelf.table reloadData];
        }];
    }
    
}


#pragma mark --- AddressManageDelegate ---
/**
 * 删除地址
 */
- (void)deleteAddress:(ReceiverAddressModel *)model {

    __weak typeof (self)weakSelf = self;
    [self.service deleteAddress:model.id completion:^{
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功！" maskType:SVProgressHUDMaskTypeBlack];
        [weakSelf.addressArr removeObject:model];
        [weakSelf.table reloadData];
    }];
    
}

/**
 * 编辑地址
 */
- (void)editAddress:(ReceiverAddressModel *)model {

    AddReceiverViewController *addReceiverVC = [[AddReceiverViewController alloc]init];
    addReceiverVC.model = model;
    [self.navigationController pushViewController:addReceiverVC animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

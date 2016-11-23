//
//  AddressListViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListTableCell.h"
#import "MineService.h"
@interface AddressListViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** 我的地址网络请求对象 */
@property(nonatomic,strong)MineService *mineService;
@end

@implementation AddressListViewController

- (MineService *)mineService {
    
    if (_mineService == nil) {
        
        _mineService = [[MineService alloc]init];
    }
    
    return _mineService;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    __weak typeof (self)wSelf = self;
    [self.mineService getAddressList:^(NSMutableArray *addressModelArr) {
    
        wSelf.addressArr = addressModelArr;
        [wSelf.table reloadData];
    }];
    self.navigationItem.title = @"收货地址";
    [self initView];
}

- (void)initView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 90;
    [self.view addSubview:table];
    self.table = table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressListTableCell *cell = [AddressListTableCell cellWithTableView:tableView];
    cell.model = self.addressArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAddressInfo" object:self.addressArr[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

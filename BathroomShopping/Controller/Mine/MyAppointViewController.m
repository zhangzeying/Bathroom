//
//  MyAppointViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MyAppointViewController.h"
#import "MineService.h"
#import "AppointModel.h"
#import "MyAppointTableCell.h"
#import "ErrorView.h"
@interface MyAppointViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property(nonatomic,strong)MineService *service;
/** <##> */
@property (nonatomic, weak)UITableView *table;

@end

@implementation MyAppointViewController

#pragma mark --- LazyLoad ---

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";
    [self initView];
    __weak typeof (self)weakSelf = self;
    [self.service getAppointList:^(NSMutableArray *dataArr) {
        
        if (dataArr.count == 0) {
            
            [weakSelf.table removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"暂无预约的商品哦！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [weakSelf.view addSubview:errorView];
            
        }else {
            
            weakSelf.dataArr = dataArr;
            [weakSelf.table reloadData];
        }
    }];
}

- (void)initView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 130;
    [self.view addSubview:table];
    self.table = table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAppointTableCell *cell = [MyAppointTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    //设置删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消预约" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
       
        
    }];
    
    return @[deleteRowAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

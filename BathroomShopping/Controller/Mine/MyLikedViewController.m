//
//  MyLikedViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MyLikedViewController.h"
#import "MineService.h"
#import "MyLikedTableCell.h"
#import "GoodsDetailModel.h"
#import "GoodsService.h"
#import "ErrorView.h"
@interface MyLikedViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property(nonatomic,strong)MineService *service;
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** <##> */
@property(nonatomic,strong)GoodsService *goodsService;
@end

@implementation MyLikedViewController

#pragma mark --- LazyLoad ---
- (GoodsService *)goodsService {
    
    if (_goodsService == nil) {
        
        _goodsService = [[GoodsService alloc]init];
    }
    return _goodsService;
}

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
    self.navigationItem.title = @"我的收藏";
    [self initView];
    __weak typeof (self)weakSelf = self;
    [self.service getLikedGoodsList:^(NSMutableArray *dataArr) {
        
        if (dataArr.count == 0) {
            
            [weakSelf.table removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"暂无收藏的商品哦！";
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
    table.rowHeight = 150;
    [self.view addSubview:table];
    self.table = table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyLikedTableCell *cell = [MyLikedTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    //设置删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        GoodsDetailModel *model = self.dataArr[indexPath.row];
        [weakSelf.goodsService unLikedGoods:model.id completion:^{
            
            [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
            [weakSelf.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
        
    }];
    
    return @[deleteRowAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

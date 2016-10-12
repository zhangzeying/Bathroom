//
//  MallGoodsViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/26/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallGoodsViewController.h"
#import "GoodsCategoryModel.h"
#import "BathroomService.h"
#import "ActivityGoodsModel.h"
#import "MallTableCell.h"
#import "ErrorView.h"
#import "ActivityGoodsDetailModel.h"
#import "GoodsInfoViewController.h"
@interface MallGoodsViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <##> */
@property(nonatomic,strong)BathroomService *service;
/** 热门商品数组 */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property (nonatomic, weak)UITableView *table;
@end

@implementation MallGoodsViewController

- (BathroomService *)service {
    
    if (_service == nil) {
        
        _service = [[BathroomService alloc]init];
    }
    
    return _service;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 150;
    [self.view addSubview:table];
    self.table = table;
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MallTableCell *cell = [MallTableCell cellWithTableView:tableView];
    cell.model = self.goodsArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityGoodsDetailModel *model = self.goodsArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id packgeModel:nil];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setModel:(GoodsCategoryModel *)model {
    
    self.navigationItem.title = model.name;
    __weak typeof (self)weakSelf = self;
    [self.service getGoodsByCategory:model.code completion:^(ActivityGoodsModel *model) {
        
        if (model.list.count == 0) {
            
            [weakSelf.table removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"此类别下没有商品哦！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [weakSelf.view addSubview:errorView];
            
        }else {
            
            weakSelf.goodsArr = model.list;
            [weakSelf.table reloadData];
        }
        
    }];
}

@end

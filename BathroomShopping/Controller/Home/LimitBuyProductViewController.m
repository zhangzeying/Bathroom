

//
//  LimitBuyProductViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LimitBuyProductViewController.h"
#import "LimitBuyTableCell.h"
#import "GoodsInfoViewController.h"
@interface LimitBuyProductViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property (nonatomic, weak)UITableView *table;
@end

@implementation LimitBuyProductViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 79 - 64 - 10) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 150;
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    self.table = table;
}

-(void)viewDidLayoutSubviews
{
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LimitBuyTableCell *cell = [LimitBuyTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    if (self.index == 0) {
        
        cell.stateType = Buying;
        
    }else {
    
        cell.stateType = WillBuy;
    }
    __weak typeof (self)weakSelf = self;
    cell.limitBuyBlock = ^(NSString *productId){
    
        GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:productId packgeModel:nil];
        goodsInfoVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:goodsInfoVC animated:YES];
    };
    return cell;
}

- (void)setDataArr:(NSMutableArray *)dataArr {

    _dataArr = dataArr;
    [self.table reloadData];
}

- (void)setIndex:(NSInteger)index {

    _index = index;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end

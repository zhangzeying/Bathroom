//
//  OrderDetailViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailGoodsTableCell.h"
#import "OrderDetailHeaderView.h"
#import "OrderDetailFooterView.h"
#import "OrderModel.h"
#import "OrderService.h"
@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
/** <##> */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property(nonatomic,strong)OrderService *service;
@end

@implementation OrderDetailViewController

- (OrderService *)service {
    
    if (_service == nil) {
        
        _service = [[OrderService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)goodsArr {
    
    if (_goodsArr == nil) {
        
        _goodsArr = [NSMutableArray array];
    }
    
    return _goodsArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
}

- (void)initTable {

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CustomColor(240, 242, 245);
    [self.view addSubview:tableView];
    
    if ([self.model.paystatus isEqualToString:@"n"]) {
        
        tableView.height -= 60;
        OrderDetailFooterView *footer = [OrderDetailFooterView instanceFooterView];
        footer.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame), ScreenW, 60);
        [self.view addSubview:footer];
        __weak typeof (self)wSelf = self;
        footer.footerViewBlock = ^(NSString *btnType) {
            
            if ([btnType isEqualToString:@"pay"]) {//去支付
                
                
            }else {//取消订单
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定取消订单吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.delegate = wSelf;
                [alertView show];
            }
        };
        
    }
    
    OrderDetailHeaderView *header = [OrderDetailHeaderView instanceHeaderView];
    header.model = self.model;
    header.height = [self.model.remark isEqualToString:@"一元抢购"] ? 50 : 140;
    tableView.tableHeaderView = header;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? self.goodsArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        OrderDetailGoodsTableCell *cell = [OrderDetailGoodsTableCell cellWithTableView:tableView];
        cell.model = self.goodsArr[indexPath.row];
        return cell;
        
    }else {
    
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *titleLbl = [[UILabel alloc]init];
        titleLbl.text = @"商品总额";
        [titleLbl sizeToFit];
        titleLbl.x = 15;
        titleLbl.centerY = cell.height / 2;
        titleLbl.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLbl];
        
        UILabel *priceLbl = [[UILabel alloc]init];
        
        priceLbl.text = [NSString stringWithFormat:@"¥%.2f",self.model.amount];
        [priceLbl sizeToFit];
        priceLbl.x = ScreenW - priceLbl.width;
        priceLbl.centerY = cell.height / 2;
        priceLbl.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:priceLbl];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.section == 0 ? 90 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    } else {
        return 10.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (void)setModel:(OrderModel *)model {

    _model = model;
    self.goodsArr = model.orders;
    [self initTable];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        __weak typeof (self)wSelf = self;
        [self.service cancelOrder:self.model.id completion:^{
            
            [wSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

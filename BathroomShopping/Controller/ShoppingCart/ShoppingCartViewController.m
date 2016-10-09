//
//  ShoppingCartViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCellTableViewCell.h"
#import "ShoppingCartFooterView.h"
#import "GoodsService.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartDetailModel.h"
#import "FillOrderViewController.h"
#import "GoodsSpecModel.h"
#import "AppointGoodsViewController.h"
#import "LoginViewController.h"
#import "ErrorView.h"
@interface ShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate, ShoppingCartDelegate, UIActionSheetDelegate>
/** 网络请求对象 */
@property(nonatomic,strong)GoodsService *service;
/** <##> */
@property(nonatomic,strong)ShoppingCartModel *model;
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** <##> */
@property (nonatomic, weak)ShoppingCartFooterView *footerView;
/** <##> */
@property (nonatomic, weak)UIButton *editBtn;
/** <##> */
@property(nonatomic,strong)NSDictionary *params;
/** 记录要删除的数据 */
@property(nonatomic,strong)NSMutableArray *deleteArr;
/** <##> */
@property(assign,nonatomic)double total;
@end

@implementation ShoppingCartViewController

#pragma mark --- LazyLoad ---
- (GoodsService *)service {
    
    if (_service == nil) {
        
        _service = [[GoodsService alloc]init];
    }
    return _service;
}

- (NSMutableArray *)deleteArr {
    
    if (_deleteArr == nil) {
        
        _deleteArr = [NSMutableArray array];
    }
    
    return _deleteArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
    self.navigationItem.title = @"购物车";
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.width = 70;
    editBtn.height = 30;
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.editBtn = editBtn;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCart) name:@"order" object:nil];
}

#pragma mark --- CreatUI ---
- (void)initUI {

    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 60) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 100;
    [self.view addSubview:table];
    self.table = table;
    
    ShoppingCartFooterView *footerView = [ShoppingCartFooterView instanceFooterView];
    footerView.frame = CGRectMake(0, CGRectGetMaxY(table.frame), ScreenW, 60);
    __weak typeof (self)weakSelf = self;
    self.footerView = footerView;
     [self numerationPrice];
    //结算按钮点击事件
    footerView.calculateBlock = ^(){
        
        if (weakSelf.editBtn.selected) {
            
            NSMutableArray *dataArr = [weakSelf.model.productList mutableCopy];
            BOOL flag = YES;
            NSMutableString *productIDStr = [[NSMutableString alloc]initWithCapacity:10];
            NSMutableString *buySpecIDStr = [[NSMutableString alloc]initWithCapacity:10];
            [self.deleteArr removeAllObjects];
            for (int i = 0; i < dataArr.count; i++) {
                
                ShoppingCartDetailModel *detailModel = dataArr[i];
                if (detailModel.isChecked) {
                    
                    flag = NO;
                    if (productIDStr.length == 0) {
                        
                        [productIDStr appendString:detailModel.id];
                    }else {
                    
                        [productIDStr appendString:[NSString stringWithFormat:@",%@",detailModel.id]];
                    }
                    if (buySpecIDStr.length == 0) {
                        
                        [buySpecIDStr appendString:detailModel.buySpecInfo.id];
                        
                    }else {
                        
                        [buySpecIDStr appendString:[NSString stringWithFormat:@",%@",detailModel.buySpecInfo.id]];
                    }
                    
                    [self.deleteArr addObject:detailModel];
                }
            }
            
            if (flag) {
                
                [SVProgressHUD showErrorWithStatus:@"您还没有选择商品哦！" maskType:SVProgressHUDMaskTypeBlack];
                
            }else {
            
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确认要删除这%ld种商品吗？",(long)self.deleteArr.count] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                
                self.params = @{@"productID":[productIDStr copy],
                                @"buySpecID":[buySpecIDStr copy],
                                @"token":[[CommUtils sharedInstance] fetchToken]?:@""};

            }
            
        }else {
        
            if ([[CommUtils sharedInstance] isLogin]) {
                
                NSMutableArray *selectArr = @[].mutableCopy;
                for (ShoppingCartDetailModel *detailModel in weakSelf.model.productList) {
                    
                    if (detailModel.isChecked) {
                        
                        [selectArr addObject:detailModel];
                    }
                }
                
                if (selectArr.count == 0) {
                    
                    [SVProgressHUD showErrorWithStatus:@"您还没有选择商品哦！" maskType:SVProgressHUDMaskTypeBlack];
                    
                }else {
                    
                    FillOrderViewController *fillOrderVC = [[FillOrderViewController alloc]init];
                    fillOrderVC.goodsArr = selectArr;
                    fillOrderVC.totalPrice = self.total;
                    fillOrderVC.pageType = selectArr.count > 1 ? MoreGoods : OneGoods;
                    [weakSelf.navigationController pushViewController:fillOrderVC animated:YES];
                }
                
            }else {
            
                LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
                [self presentViewController:loginNav animated:YES completion:nil];
            }
            
        }
        
    };
    
    //全选按钮点击事件
    footerView.checkBlock = ^(BOOL flag){
    
        for (ShoppingCartDetailModel *detailModel in weakSelf.model.productList) {
            
            detailModel.isChecked = flag;
        }
        
        [weakSelf numerationPrice];
        [weakSelf.table reloadData];
        
    };
    
    [self.view addSubview:footerView];
    
    if ([[CommUtils sharedInstance] isLogin]) {
        
        //获取购物车清单
        [self.service getCartList:^(ShoppingCartModel *model) {
            
            if (model.productList.count == 0) {
                
                [weakSelf.table removeFromSuperview];
                [weakSelf.footerView removeFromSuperview];
                ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
                errorView.warnStr = @"购物车空空如也！";
                errorView.imgName = @"sys_xiao8";
                errorView.btnTitle = @"";
                [weakSelf.view addSubview:errorView];
                
            }else {
                
                weakSelf.model = model;
                weakSelf.footerView.model = model;
                [weakSelf.table reloadData];
            }
            
        }];
        
    }else {
    
        NSMutableArray *dataArr = [ShoppingCartDetailModel getCartList];
        if (dataArr.count == 0) {
            
            [self.table removeFromSuperview];
            [self.footerView removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"购物车空空如也！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [self.view addSubview:errorView];
            
        }else {
        
            ShoppingCartModel *cModel = [[ShoppingCartModel alloc]init];
            cModel.productList = dataArr;
            self.model = cModel;
            self.footerView.model = cModel;
            [self.table reloadData];
        }
        
    }
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ShoppingCartCellTableViewCell *cell = [ShoppingCartCellTableViewCell cellWithTableView:tableView];
    ShoppingCartDetailModel *detailmodel = self.model.productList[indexPath.row];
    cell.detailModel = detailmodel;
    cell.delegate = self;
    return cell;
}

#pragma mark --- ShoppingCartDelegate ---
- (void)check:(ShoppingCartDetailModel *)model {
    
    if (model.isChecked == NO) {
        
        self.footerView.checkBox.selected = NO;
        
    }else {
    
        BOOL flag = YES;
        for (ShoppingCartDetailModel *detailmodel in self.model.productList) {
            
            if (!detailmodel.isChecked) {
                
                flag = NO;
                break;
            }
        }
        
        self.footerView.checkBox.selected = flag;
    }
    
    [self numerationPrice];
    [self.table reloadData];
}

/**
 * 点击每一行删除按钮
 */
- (void)cartDelete:(UITableViewCell *)cell model:(ShoppingCartDetailModel *)model{

    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    if ([[CommUtils sharedInstance] isLogin]) {
        
        NSDictionary *param = @{@"productID":model.id,
                                @"buySpecID":model.buySpecInfo.id,
                                @"token":[[CommUtils sharedInstance] fetchToken]};
        __weak typeof (self)weakSelf = self;
        [self.service deleteCart:param completion:^{
            
            [weakSelf.model.productList removeObjectAtIndex:indexPath.row];
            [weakSelf.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.table reloadData];
            [weakSelf numerationPrice];
        }];
        
    }else {
    
        if ([ShoppingCartDetailModel deleteCartById:model.id specId:model.buySpecInfo.id]) {
            
            [self.model.productList removeObjectAtIndex:indexPath.row];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.table reloadData];
        }
    }
}

/**
 * 改变购买数量，重新计算价格
 */
- (void)changeBuyCount {

    [self numerationPrice];
}

/**
 * 预约商品
 */
- (void)appoint:(ShoppingCartDetailModel *)model {

    AppointGoodsViewController *appointGoodsVC = [[AppointGoodsViewController alloc]initWithModel:model];
    appointGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:appointGoodsVC animated:YES];
}

#pragma mark --- UIButtonClick ---
- (void)editClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.footerView.isEditing = sender.selected;
}

/**
 * 计算总价
 */
- (void)numerationPrice {
    
    double totalPrice = 0.0;
    for (int i = 0; i < self.model.productList.count; i++) {
        ShoppingCartDetailModel *model = [self.model.productList objectAtIndex:i];
        if (model.isChecked) {
            
            totalPrice = totalPrice + model.buyCount * model.nowPrice;
        }
    }

    self.total = totalPrice;
    self.footerView.totalMoney = totalPrice;
}

- (void)clearCart {

    __weak typeof (self)weakSelf = self;
    if ([[CommUtils sharedInstance] isLogin]) {
        
        //获取购物车清单
        [self.service getCartList:^(ShoppingCartModel *model) {
            
            if (model.productList.count == 0) {
                
                [weakSelf.table removeFromSuperview];
                [weakSelf.footerView removeFromSuperview];
                ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
                errorView.warnStr = @"购物车空空如也！";
                errorView.imgName = @"sys_xiao8";
                errorView.btnTitle = @"";
                [weakSelf.view addSubview:errorView];
                
            }else {
                
                weakSelf.model = model;
                weakSelf.footerView.model = model;
                [weakSelf.table reloadData];
            }
            
        }];
        
    }else {
        
        NSMutableArray *dataArr = [ShoppingCartDetailModel getCartList];
        if (dataArr.count == 0) {
            
            [self.table removeFromSuperview];
            [self.footerView removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"购物车空空如也！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [self.view addSubview:errorView];
            
        }else {
            
            ShoppingCartModel *cModel = [[ShoppingCartModel alloc]init];
            cModel.productList = dataArr;
            self.model = cModel;
            self.footerView.model = cModel;
            [self.table reloadData];
        }
        
    }
}

#pragma mark --- UIActionSheetDelegate ---
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        
        if ([[CommUtils sharedInstance] isLogin]) {
            
            __weak typeof (self)weakSelf = self;
            [self.service deleteCart:self.params completion:^{
                
                for (ShoppingCartDetailModel *detailModel in self.deleteArr) {
                    
                    [weakSelf.model.productList removeObject:detailModel];
                }
                [weakSelf numerationPrice];
                [weakSelf.table reloadData];
            }];
            
        }else {
            
            if ([ShoppingCartDetailModel deleteAllCart]) {
                
                for (ShoppingCartDetailModel *detailModel in self.deleteArr) {
                    
                    [self.model.productList removeObject:detailModel];
                }
                [self numerationPrice];
                [self.table reloadData];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

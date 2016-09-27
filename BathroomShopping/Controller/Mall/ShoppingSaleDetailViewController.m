//
//  ShoppingSaleDetailViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingSaleDetailViewController.h"
#import "HotGoodsCollectionCell.h"
#import "ActivityGoodsDetailModel.h"
#import "GoodsInfoViewController.h"
#import "ErrorView.h"
#import "HomeService.h"
#import "ActivityGoodsModel.h"
static NSString *ID = @"ID";
@interface ShoppingSaleDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** <##> */
@property (nonatomic, weak)UICollectionView *collect;
/** <##> */
@property(nonatomic,strong)HomeService *service;
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property(nonatomic,strong)dispatch_group_t group;
@end

@implementation ShoppingSaleDetailViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100) / 100.0 green:arc4random_uniform(100) / 100.0 blue:arc4random_uniform(100) / 100.0 alpha:1.0];
//}

- (dispatch_group_t )group {
    
    if (_group == nil) {
        
        _group = dispatch_group_create();
    }
    
    return _group;
}

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (HomeService *)service {
    
    if (_service == nil) {
        
        _service = [[HomeService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40 - 64 - 10) collectionViewLayout:layout];
    collect.showsVerticalScrollIndicator = NO;
    UINib *cellNib = [UINib nibWithNibName:@"HotGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:cellNib forCellWithReuseIdentifier:ID];
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collect];
    self.collect = collect;
    [self setupRefresh];
}

/**
 * 创建上拉加载更多
 */
- (void)setupRefresh {
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.collect.mj_header = header;
    
    self.collect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collect.mj_footer.hidden = YES;
}

- (void)loadNewData {

    __weak typeof(self) weakSelf = self;
    dispatch_group_async(self.group, dispatch_get_global_queue(0,0), ^{
        
        NSDictionary *params = @{@"id":self.categoryId};
        [self.service getPerferenceProductList:params completion:^(ActivityGoodsModel *model) {
            
            weakSelf.dataArr = model.list;
            if (weakSelf.dataArr.count == 0) {
                
                [self.collect removeFromSuperview];
                ErrorView *errorView = [[ErrorView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
                errorView.warnStr = @"此类别下没有商品哦！";
                errorView.imgName = @"sys_xiao8";
                errorView.btnTitle = @"";
                [weakSelf.view addSubview:errorView];
                
            }else {
                
                [weakSelf.collect reloadData];
            }
        }];
    });
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.collect.mj_header endRefreshing];
    });
}

- (void)loadMoreData {

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    ActivityGoodsDetailModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityGoodsDetailModel *model = self.dataArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark --- UICollectionViewDelegateFlowLayout ---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(ScreenW / 2, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCategoryId:(NSString *)categoryId {

    _categoryId = categoryId;
    NSDictionary *params = @{@"id":categoryId};
    __weak typeof (self)weakSelf = self;
    [self.service getPerferenceProductList:params completion:^(ActivityGoodsModel *model) {
        
        weakSelf.dataArr = model.list;
        if (weakSelf.dataArr.count == 0) {
            
            [self.collect removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            errorView.warnStr = @"此类别下没有商品哦！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [self.view addSubview:errorView];
            
        }else {
            
            [weakSelf.collect reloadData];
        }
    }];
}

@end

//
//  MallViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallViewController.h"
#import "CategoryView.h"
#import "BathroomService.h"
#import "HotGoodsCollectionCell.h"
#import "MallService.h"
#import "GoodsCategoryModel.h"
#import "GoodsCategoryViewController.h"
#import "MallGoodsViewController.h"
#import "ActivityGoodsModel.h"
#import "GoodsInfoViewController.h"
#import "MallPackageModel.h"
#import "CustomRefreshHeader.h"
#import "BathroomHeaderCell.h"
#import "HotGoodsHeaderView.h"
static NSString *ID = @"hotCell";
static NSString *HeaderID = @"hotHeader";
static NSString *BathroomHeaderID = @"mallHeaderID";
@interface MallViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 网络请求对象 */
@property(nonatomic,strong)MallService *service;
/** 商品类别数组 */
@property(nonatomic,strong)NSMutableArray *categoryArr;
/** 热门商品数组 */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/**  */
@property (nonatomic, weak)UICollectionView *collect;
/** <##> */
@property(nonatomic,strong)dispatch_group_t group;
@end

@implementation MallViewController

- (MallService *)service {
    
    if (_service == nil) {
        
        _service = [[MallService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)categoryArr {
    
    if (_categoryArr == nil) {
        
        _categoryArr = [NSMutableArray array];
    }
    
    return _categoryArr;
}

- (NSMutableArray *)goodsArr {
    
    if (_goodsArr == nil) {
        
        _goodsArr = [NSMutableArray array];
    }
    
    return _goodsArr;
}

- (dispatch_group_t )group {
    
    if (_group == nil) {
        
        _group = dispatch_group_create();
    }
    
    return _group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"商城" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self initView];
}

- (void)initView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.showsVerticalScrollIndicator = NO;
    UINib *cellNib = [UINib nibWithNibName:@"HotGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:cellNib forCellWithReuseIdentifier:ID];
    
    UINib *headerNib = [UINib nibWithNibName:@"HotGoodsHeaderView" bundle: [NSBundle mainBundle]];
    [collect registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    [self.view addSubview:collect];
    self.collect = collect;
    [collect registerClass:[BathroomHeaderCell class] forCellWithReuseIdentifier:BathroomHeaderID];
    
    __weak typeof (self)weakSelf = self;
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor whiteColor];
    [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
        
        weakSelf.categoryArr = categoryArr;
        [collect reloadData];
    }];
    
    [self.service getPackageList:^(ActivityGoodsModel *model) {
        
        weakSelf.goodsArr = model.list;
        [collect reloadData];
    }];
    
    [self setupRefresh];
    
}

- (void)setupRefresh {
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    CustomRefreshHeader *header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collect.mj_header = header;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    }else {
        
        return self.goodsArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        BathroomHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BathroomHeaderID forIndexPath:indexPath];
        cell.vc = self;
        cell.categoryArr = self.categoryArr;
        return cell;
        
    }else {
        
        HotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.packageModel = self.goodsArr[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        MallPackageModel *model = self.goodsArr[indexPath.row];
        GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id packgeModel:nil];
        goodsInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HotGoodsHeaderView *hotHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderID forIndexPath:indexPath];
        hotHeaderView.titleLbl.text = @"特色好货";
        reusableview = hotHeaderView;
    }
    
    return reusableview;
}

#pragma mark --- UICollectionViewDelegateFlowLayout ---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(ScreenW, 180);
        
    }else {
        
        return CGSizeMake(ScreenW / 2, 150);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return CGSizeZero;
        
    }else {
        
        return CGSizeMake(ScreenW, 40);
    }
}

- (void)loadNewData {

    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(self.group);
    [self.service getGoodsCategory:^(NSMutableArray *categoryArr) {
        
        if (categoryArr != nil) {
            
            weakSelf.categoryArr = categoryArr;
            [weakSelf.collect reloadData];
        }

        dispatch_group_leave(weakSelf.group);
    }];
    
    dispatch_group_enter(self.group);
    [self.service getPackageList:^(ActivityGoodsModel *model) {
        
        if (model != nil) {
            
            weakSelf.goodsArr = model.list;
            [weakSelf.collect reloadData];
        }
        
        dispatch_group_leave(weakSelf.group);
    }];
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.collect.mj_header endRefreshing];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

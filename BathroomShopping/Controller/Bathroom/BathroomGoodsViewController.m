//
//  BathroomGoodsViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BathroomGoodsViewController.h"
#import "HotGoodsCollectionCell.h"
#import "ActivityGoodsDetailModel.h"
#import "BathroomService.h"
#import "GoodsCategoryModel.h"
#import "ActivityGoodsModel.h"
#import "ErrorView.h"
#import "GoodsInfoViewController.h"
static NSString *ID = @"ID";
@interface BathroomGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 热门商品数组 */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property(nonatomic,strong)BathroomService *service;
/** <##> */
@property (nonatomic, weak)UICollectionView *collect;
@end

@implementation BathroomGoodsViewController

- (NSMutableArray *)goodsArr {
    
    if (_goodsArr == nil) {
        
        _goodsArr = [NSMutableArray array];
    }
    
    return _goodsArr;
}

- (BathroomService *)service {
    
    if (_service == nil) {
        
        _service = [[BathroomService alloc]init];
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
    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.showsVerticalScrollIndicator = NO;
    UINib *cellNib = [UINib nibWithNibName:@"HotGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:cellNib forCellWithReuseIdentifier:ID];
    collect.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collect];
    self.collect = collect;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.goodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    ActivityGoodsDetailModel *model = self.goodsArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ActivityGoodsDetailModel *model = self.goodsArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id packageId:nil];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark --- UICollectionViewDelegateFlowLayout ---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(ScreenW / 2, 150);
}

- (void)setModel:(GoodsCategoryModel *)model {

    self.navigationItem.title = model.name;
    __weak typeof (self)weakSelf = self;
    [self.service getGoodsByCategory:model.code completion:^(ActivityGoodsModel *model) {
        
        if (model.list.count == 0) {
            
            [weakSelf.collect removeFromSuperview];
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"此类别下没有商品哦！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [weakSelf.view addSubview:errorView];
            
        }else {
        
            weakSelf.goodsArr = model.list;
            [weakSelf.collect reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

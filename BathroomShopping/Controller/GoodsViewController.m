//
//  GoodsViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCollectionViewCell.h"
#import "GoodsCollectionHeaderView.h"
#import "BathroomService.h"
#import "ActivityGoodsModel.h"
#import "ErrorView.h"
#import "GoodsInfoViewController.h"
#import "ActivityGoodsDetailModel.h"
static NSString *ID = @"goodsCell";
static NSString *headerID = @"goodsHeader";

@interface GoodsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
/** <##> */
@property(nonatomic,strong)BathroomService *service;
/** <##> */
@property (nonatomic, weak)UICollectionView *goodsCollection;
/** <##> */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property (nonatomic, weak)ErrorView *errorView;
@end

@implementation GoodsViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view = [[UIView alloc]initWithFrame:CGRectMake(ScreenW * 0.3, 0, ScreenW * 0.7, ScreenH)];
    [self setupGoodsCollection];
}

#pragma mark --- CreatUI ---
- (void)setupGoodsCollection {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);//设置边距
    //cell间距
    layout.minimumInteritemSpacing = 5;
    //cell行距
    layout.minimumLineSpacing = 5.0f;
    CGFloat space = 5;
    CGFloat itemW = (int)((self.view.width - 3 * space) / 2);
    layout.itemSize = CGSizeMake(itemW, itemW + 10);
    
    
    UICollectionView *goodsCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, ScreenH - 64) collectionViewLayout:layout];
    UINib *nib = [UINib nibWithNibName:@"GoodsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [goodsCollection registerNib:nib forCellWithReuseIdentifier:ID];
    
    goodsCollection.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//    UINib *headerNib = [UINib nibWithNibName:@"GoodsCollectionHeaderView" bundle: [NSBundle mainBundle]];
    
//    [goodsCollection registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    goodsCollection.showsVerticalScrollIndicator = NO;
    goodsCollection.delegate = self;
    goodsCollection.dataSource = self;
    [self.view addSubview:goodsCollection];
    goodsCollection.backgroundColor = CustomColor(242, 242, 242);
    
    self.goodsCollection = goodsCollection;
}


#pragma mark --- UICollectionViewDataSource ---
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 4;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.goodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.goodsArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ActivityGoodsDetailModel *model = self.goodsArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark --- UICollectionViewDelegate ---
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        
//        GoodsCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
//        reusableview = headerView;
//    }
//    return reusableview;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//    CGSize size = {ScreenW,40};
//    return size;
//}

- (void)setCode:(NSString *)code {

    __weak typeof (self)weakSelf = self;
    [self.service getGoodsByCategory:code completion:^(ActivityGoodsModel *model) {
        
        if (model.list.count == 0) {
            
            [weakSelf.goodsCollection removeFromSuperview];
            [weakSelf.errorView removeFromSuperview];
            weakSelf.goodsCollection = nil;
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, ScreenH - 64)];
            errorView.warnStr = @"此类别下没有商品哦！";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [weakSelf.view addSubview:errorView];
            weakSelf.errorView = errorView;
            
        }else {
            
            [weakSelf.errorView removeFromSuperview];
            weakSelf.goodsArr = model.list;
            if (weakSelf.goodsCollection != nil) {
                
                [weakSelf.goodsCollection reloadData];
                
            }else {
                
                [weakSelf setupGoodsCollection];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

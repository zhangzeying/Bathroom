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

static NSString *ID = @"goodsCell";
static NSString *headerID = @"goodsHeader";

@interface GoodsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation GoodsViewController

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
    layout.minimumInteritemSpacing = 0;
    //cell行距
    layout.minimumLineSpacing = 5.0f;
    CGFloat space = 5;
    CGFloat itemW = (int)((self.view.width - 4 * space) / 3);
    layout.itemSize = CGSizeMake(itemW, itemW + 10);
    
    
    UICollectionView *goodsCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, ScreenH - 64) collectionViewLayout:layout];
    UINib *nib = [UINib nibWithNibName:@"GoodsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [goodsCollection registerNib:nib forCellWithReuseIdentifier:ID];
    
    UINib *headerNib = [UINib nibWithNibName:@"GoodsCollectionHeaderView" bundle: [NSBundle mainBundle]];
    
    [goodsCollection registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    goodsCollection.showsVerticalScrollIndicator = NO;
    goodsCollection.delegate = self;
    goodsCollection.dataSource = self;
    [self.view addSubview:goodsCollection];
    goodsCollection.backgroundColor = CustomColor(242, 242, 242);
}


#pragma mark --- UICollectionViewDataSource ---
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.goodNameLbl.text = @"11";
    cell.goodNameLbl.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark --- UICollectionViewDelegate ---
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        GoodsCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        reusableview = headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = {ScreenW,40};
    return size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

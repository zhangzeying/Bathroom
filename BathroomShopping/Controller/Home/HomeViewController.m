//
//  HomeViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomSearchBar.h"
#import "HomeService.h"
#import "NewsModel.h"
#import "ActivityGoodsCollectionCell.h"
#import "HotGoodsCollectionCell.h"
#import "ActivityGoodsModel.h"
#import "GoodsCollectionHeaderView.h"
#import "HotGoodsHeaderView.h"
#import "ActivityGoodsHeaderView.h"
#import "ActivityGoodsDetailModel.h"
#import "OneMoneySaleViewController.h"
#import "GoodsInfoViewController.h"
#import "BSRefreshHeader.h"
#import "HomeHeaderCell.h"
#import "LimitTimeBuyModel.h"
#import "ShoppingSaleViewController.h"
static NSString *preferenID = @"preferenCell";
static NSString *limitTimeID = @"limitTimeCell";
static NSString *oneMoneyID = @"oneMoneyCell";
static NSString *preferenHeaderID = @"preferenHeaderID";
static NSString *limitTimeHeaderID = @"limitTimeHeaderID";
static NSString *oneMoneyHeaderID = @"oneMoneyHeaderID";
static NSString *hotID = @"hotCell";
static NSString *hotHeaderID = @"hotHeader";
static NSString *homeHeaderID = @"homeHeader";

@interface HomeViewController ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActivityGoodsHeaderDelegate>
/** 网络请求(获取首页滚动消息) */
@property(nonatomic,strong)HomeService *homeService;
/** 活动组合数据模型 */
@property(nonatomic,strong)ActivityGoodsModel *activityGoodsModel;
/** 热门商品数组 */
@property(nonatomic,strong)NSMutableArray *hotGoodsArr;
/** tableview */
@property (nonatomic, weak)UICollectionView *collect;
/** <##> */
@property(nonatomic,strong)dispatch_group_t group;
/** <##> */
@property (nonatomic, weak)CustomSearchBar *searchBar;
@end

@implementation HomeViewController

#pragma mark --- LazyLoad ---
- (HomeService *)homeService {
    
    if (_homeService == nil) {
        
        _homeService = [[HomeService alloc]init];
    }
    
    return _homeService;
}

- (NSMutableArray *)hotGoodsArr {
    
    if (_hotGoodsArr == nil) {
        
        _hotGoodsArr = [NSMutableArray array];
    }
    
    return _hotGoodsArr;
}

- (dispatch_group_t )group {
    
    if (_group == nil) {
        
        _group = dispatch_group_create();
    }
    
    return _group;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CustomSearchBar *searchBar = [CustomSearchBar searchBar];
    searchBar.delegate = self;
    searchBar.width = 250;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navigationItem_left_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.searchBar.userInteractionEnabled = YES;
}

#pragma mark --- CreatUI ---
- (void)initUI {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) collectionViewLayout:layout];
    collect.showsVerticalScrollIndicator = NO;
    UINib *preferenCellNib = [UINib nibWithNibName:@"ActivityGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:preferenCellNib forCellWithReuseIdentifier:preferenID];
    
    UINib *oneMoneyCellNib = [UINib nibWithNibName:@"ActivityGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:oneMoneyCellNib forCellWithReuseIdentifier:oneMoneyID];
    
    UINib *limitTimeCellNib = [UINib nibWithNibName:@"ActivityGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:limitTimeCellNib forCellWithReuseIdentifier:limitTimeID];
    
    UINib *hotCellNib = [UINib nibWithNibName:@"HotGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [collect registerNib:hotCellNib forCellWithReuseIdentifier:hotID];
    
    UINib *preferenHeaderNib = [UINib nibWithNibName:@"ActivityGoodsHeaderView" bundle: [NSBundle mainBundle]];
    [collect registerNib:preferenHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:preferenHeaderID];
    
    UINib *limitTimeHeaderNib = [UINib nibWithNibName:@"ActivityGoodsHeaderView" bundle: [NSBundle mainBundle]];
    [collect registerNib:limitTimeHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:limitTimeHeaderID];
    
    UINib *oneMoneyHeaderNib = [UINib nibWithNibName:@"ActivityGoodsHeaderView" bundle: [NSBundle mainBundle]];
    [collect registerNib:oneMoneyHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:oneMoneyHeaderID];
    
    UINib *hotHeaderNib = [UINib nibWithNibName:@"HotGoodsHeaderView" bundle: [NSBundle mainBundle]];
    [collect registerNib:hotHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotHeaderID];
    [self.view addSubview:collect];
    
    [collect registerClass:[HomeHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeHeaderID];
    
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor whiteColor];
    
    self.collect = collect;
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.homeService getActivityGoodsList:^(ActivityGoodsModel *activityGoodsModel) {
        
        weakSelf.activityGoodsModel = activityGoodsModel;
        [weakSelf.collect reloadData];
    }];
    
    [self.homeService getHotGoodsList:^(NSMutableArray *hotGoodsArr) {
        
        weakSelf.hotGoodsArr = hotGoodsArr;
        [weakSelf.collect reloadData];
    }];
    
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

/**
 * 下拉刷新
 */
- (void)loadNewData {

    [self onLoad];
}

/**
 * 上拉加载更多
 */
- (void)loadMoreData {

    
}

- (void)onLoad {

    __weak typeof(self) weakSelf = self;
    dispatch_group_async(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.homeService getActivityGoodsList:^(ActivityGoodsModel *activityGoodsModel) {
            
            weakSelf.activityGoodsModel = activityGoodsModel;
            [weakSelf.collect reloadData];
        }];
    });
    
    dispatch_group_async(self.group, dispatch_get_global_queue(0,0), ^{
        
        [self.homeService getHotGoodsList:^(NSMutableArray *hotGoodsArr) {
            
            weakSelf.hotGoodsArr = hotGoodsArr;
            [weakSelf.collect reloadData];
        }];
    });
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
       
        [self.collect.mj_header endRefreshing];
    });
}

#pragma mark --- UITextFieldDelegate ---
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    Class class = NSClassFromString(@"GoodsSearchViewController");
    UIViewController *vc = [[class alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    textField.userInteractionEnabled = NO;
    return NO;
}

#pragma mark --- UITableViewDataSource ---

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    }else if (section == 1) {
        
        return self.activityGoodsModel.perference.count;
        
    }else if (section == 2) {
    
        return self.activityGoodsModel.oneYuan.count;
        
    }else if (section == 3) {
    
        return self.activityGoodsModel.buyModel.products.count;
        
    }else {
    
//        self.collect.mj_footer.hidden = self.hotGoodsArr.count == 0;
        return self.hotGoodsArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//轮播图
        
        return nil;
        
    }else if (indexPath.section == 1) {//商城特惠
        
        ActivityGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:preferenID forIndexPath:indexPath];
        ActivityGoodsDetailModel *model = self.activityGoodsModel.perference[indexPath.row];
        model.activityType = Perference;
        cell.model = model;
        return cell;
        
    }else if (indexPath.section == 2) {//一元抢购
        
        ActivityGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneMoneyID forIndexPath:indexPath];
        ActivityGoodsDetailModel *model = self.activityGoodsModel.oneYuan[indexPath.row];
        model.activityType = OneYuan;
        cell.model = model;
        return cell;
        
    }else if (indexPath.section == 3) {//限时抢购
        
        ActivityGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:limitTimeID forIndexPath:indexPath];
        ActivityGoodsDetailModel *model = self.activityGoodsModel.buyModel.products[indexPath.row];
        model.activityType = Buy;
        cell.model = model;
        return cell;
        
    }else {//热门商品
    
        HotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotID forIndexPath:indexPath];
        ActivityGoodsDetailModel *model = self.hotGoodsArr[indexPath.row];
        cell.model = model;
        return cell;
        
    }
}

#pragma mark --- UICollectionViewDelegate ---
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *goodsId;
    switch (indexPath.section) {
        case 1:
        {
            ActivityGoodsDetailModel *model = self.activityGoodsModel.perference[indexPath.row];
            goodsId = model.id;
        }
            break;
        case 2:
        {
            ActivityGoodsDetailModel *model = self.activityGoodsModel.oneYuan[indexPath.row];
            goodsId = model.id;
        }
            break;
        case 3:
        {
            ActivityGoodsDetailModel *model = self.activityGoodsModel.buyModel.products[indexPath.row];
            goodsId = model.id;
        }
            break;
        case 4:
        {
            ActivityGoodsDetailModel *model = self.hotGoodsArr[indexPath.row];
            goodsId = model.id;
        }
            break;
        default:
            break;
    }
    
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:goodsId];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 1) {//商城特惠
            
            ActivityGoodsHeaderView *activityHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:preferenHeaderID forIndexPath:indexPath];
            activityHeaderView.delegate = self;
            ActivityGoodsDetailModel *model = self.activityGoodsModel.perference[indexPath.row];
            model.activityType = Perference;
            activityHeaderView.model = model;
            reusableview = activityHeaderView;
            
        }else if (indexPath.section == 2) {//一元抢购
            
            ActivityGoodsHeaderView *activityHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:oneMoneyHeaderID forIndexPath:indexPath];
            activityHeaderView.delegate = self;
            ActivityGoodsDetailModel *model = self.activityGoodsModel.oneYuan[indexPath.row];
            model.activityType = OneYuan;
            activityHeaderView.model = model;
            reusableview = activityHeaderView;
            
        }else if (indexPath.section == 3) {//限时抢购
            
            ActivityGoodsHeaderView *activityHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:limitTimeHeaderID forIndexPath:indexPath];
            activityHeaderView.delegate = self;
            ActivityGoodsDetailModel *model = self.activityGoodsModel.buyModel.products[indexPath.row];
            model.activityType = Buy;
            activityHeaderView.model = model;
            activityHeaderView.buyModel = self.activityGoodsModel.buyModel;
            reusableview = activityHeaderView;
            
        }else if (indexPath.section == 4) {//热门商品
            
            HotGoodsHeaderView *hotHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:hotHeaderID forIndexPath:indexPath];
            reusableview = hotHeaderView;
            
        }else if (indexPath.section == 0) {//热门商品
            
            HomeHeaderCell *homeHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:homeHeaderID forIndexPath:indexPath];
            reusableview = homeHeaderView;
        }
    }
    
    return reusableview;
}


#pragma mark --- UICollectionViewDelegateFlowLayout ---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 4) {
        
        return CGSizeMake(ScreenW / 2, 150);
        
    }else if (indexPath.section == 0) {
        
        return CGSizeZero;
        
    }else {
    
        return CGSizeMake(ScreenW / 3, 150);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && self.activityGoodsModel.perference.count != 0) {
        
         return CGSizeMake(ScreenW, 40);
        
    }else if (section == 2 && self.activityGoodsModel.oneYuan.count != 0) {
    
        return CGSizeMake(ScreenW, 40);
        
    }else if (section == 3 && self.activityGoodsModel.buyModel.products.count != 0) {
    
        return CGSizeMake(ScreenW, 40);
        
    }else if (section == 4 && self.hotGoodsArr.count != 0) {
    
        return CGSizeMake(ScreenW, 40);
        
    }else if (section == 0) {
    
        return CGSizeMake(ScreenW, 185);
    }
    
    return CGSizeZero;
}

#pragma mark --- ActivityGoodsHeaderDelegate ---
- (void)more:(NSInteger)activityType {

    switch (activityType) {
        case 0:
        {
            ShoppingSaleViewController *shoppingSaleVC = [[ShoppingSaleViewController alloc]init];
            shoppingSaleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shoppingSaleVC animated:YES];
            break;
        }
        case 1:
        {
            OneMoneySaleViewController *oneMoneySaleVC = [[OneMoneySaleViewController alloc]init];
            oneMoneySaleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:oneMoneySaleVC animated:YES];
            break;
        }
        case 2:
        {
            Class cls = NSClassFromString(@"LimitTimeBuyViewController");
            UIViewController *vc = [[cls alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

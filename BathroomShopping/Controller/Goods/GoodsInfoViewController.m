//
//  GoodsInfoViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/26/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "ScrollTitleView.h"
#import "CustomButton.h"
#import "GoodsRefreshFooter.h"
#import "GoodsInfoDetailViewController.h"
#import "GoodsService.h"
#import "PageScrollView.h"
#import "GoodsDetailModel.h"
#import "GoodsInfoTableCell.h"
#import "GoodsActivityTableCell.h"
#import "GoodsRecommendTableCell.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartDetailModel.h"
#import "SpecificationTableCell.h"
#import "AddressView.h"
#import "GoodsSpecView.h"
#import "GoodsSpecModel.h"
#import "GoodsAddressTableCell.h"
#import "Animate.h"
#import "LoginViewController.h"
#import "ShoppingCartInfoDB.h"
#import "TriangleView.h"
#import "AppointGoodsViewController.h"
#import "UserInfoModel.h"
#import "PackageDetailModel.h"
#import "MallPackageModel.h"
#import "PackageSpecModel.h"
typedef NS_ENUM(NSInteger ,PopViewType){
    
    SpecView, //规格view
    ActivityView, //活动View
    SelectAddressView //地址view
};

#define cartCountH 15
@interface GoodsInfoViewController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, GoodsInfoDetailDelegate, UIAlertViewDelegate, CAAnimationDelegate,ScrollTitleViewDelegate>
/** 中间内容scrollview */
@property (nonatomic, weak)UIScrollView *contentScrollView;
/** table */
@property (nonatomic, weak)UITableView *tableView;
/** 右上角购物车按钮 */
@property (nonatomic, weak)UIButton *cartBtn;
/** 加入购物车按钮 */
@property (nonatomic, weak)UIButton *addCartBtn;
/** layer */
@property(nonatomic,strong)CALayer *layer;
/** 商品图片 */
@property (nonatomic, strong)UIImageView *goodsImage;
/** 网络请求对象 */
@property(nonatomic,strong)GoodsService *service;
/** 商品ID */
@property(nonatomic,copy)NSString *goodsId;
/** <##> */
@property(nonatomic,strong)MallPackageModel *packgeModel;
/** 底部背景View */
@property (nonatomic, weak)UIView *bottomView;
/** 轮播图view */
@property (nonatomic, weak)PageScrollView *pageScrollView;
/** 商品信息数据模型 */
@property(nonatomic,strong)GoodsDetailModel *goodsDetailModel;
/** 套餐详情数据模型 */
@property(nonatomic,strong)PackageDetailModel *packageDetailModel;
/** 购物车数据模型 */
@property(nonatomic,strong)ShoppingCartModel *cartModel;
/** 选择地址view */
@property(nonatomic,strong)AddressView *addressView;
/** 遮罩view */
@property(nonatomic,strong)UIView *maskView;
/** 购物车里的商品数量 */
@property(nonatomic,strong)UILabel *cartCount;
/** 规格View */
@property(nonatomic,strong)GoodsSpecView *goodsSpecView;
/** <##> */
@property(nonatomic,assign)PopViewType popViewType;
/** 推荐商品数组 */
@property(nonatomic,strong)NSMutableArray *recommendGoodsArr;
/** <##> */
@property (nonatomic, weak)CustomButton *likeBtn;
/** <##> */
@property (nonatomic, weak)GoodsInfoDetailViewController *goodsInfoDetailVC;
/** <##> */
@property (nonatomic, weak)ScrollTitleView *titleView;
/** <##> */
@property (nonatomic, weak)UIImageView *detailImage;
@end

@implementation GoodsInfoViewController
#pragma mark --- LazyLoad ---
- (GoodsService *)service {
    
    if (_service == nil) {
        
        _service = [[GoodsService alloc]init];
    }
    return _service;
}

- (GoodsSpecView *)goodsSpecView {
    
    if (_goodsSpecView == nil) {
        
        _goodsSpecView = [[GoodsSpecView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH * 3 / 4)];
        _goodsSpecView.currentIndex = 0;
        
        if (self.packgeModel == nil) {
            
            _goodsSpecView.goodsType = SingleGood;
            _goodsSpecView.imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.goodsDetailModel.picture];
            _goodsSpecView.specModelArr = self.goodsDetailModel.specList;
            
        }else {
        
            _goodsSpecView.goodsType = Package;
            _goodsSpecView.price = self.packageDetailModel.totalPrice;
            _goodsSpecView.imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.packgeModel.picture];
            _goodsSpecView.specModelArr = self.packageDetailModel.specAllList;
        }
        
        __weak typeof (self)weakSelf = self;
        _goodsSpecView.goodsSpecViewBlock = ^(){
        
            [weakSelf dismiss];
        };
    }
    return _goodsSpecView;
}

//- (AddressView *)addressView {
//    
//    if (_addressView == nil) {
//        
//        _addressView = [[AddressView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH * 2 / 3)];
//        __weak typeof (self)weakSelf = self;
//        _addressView.addressViewBlock = ^(){
//            
//            [weakSelf dismiss];
//        };
//    }
//    return _addressView;
//}

- (UIView *)maskView {
    
    if (_maskView == nil) {
        
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0f;
        
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (UILabel *)cartCount {
    
    if (_cartCount == nil) {
        
        _cartCount = [[UILabel alloc] init];
        _cartCount.textAlignment = NSTextAlignmentCenter;
        _cartCount.font = [UIFont systemFontOfSize:9];
        _cartCount.textColor = [UIColor whiteColor];
        [self layoutCartCount];
        _cartCount.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
        _cartCount.layer.masksToBounds = YES;

        [self.cartBtn addSubview:_cartCount];
    }
    return _cartCount;
}

- (void)layoutCartCount {

    [_cartCount sizeToFit];
    NSInteger length = _cartCount.text.length;
    CGFloat extra = length > 1 ? 8 : 0;
    CGFloat width = MAX(cartCountH, (_cartCount.frame.size.width+extra));
    _cartCount.frame = CGRectMake(CGRectGetMaxX(self.cartBtn.imageView.frame) - 7, CGRectGetMidY(self.cartBtn.imageView.frame) - 22, width, cartCountH);
    _cartCount.layer.cornerRadius = cartCountH / 2;
}

- (CALayer *)layer {
    
    if (_layer == nil) {
        
        _layer = [[CALayer alloc] init];
    }
    return _layer;
}

- (UIImageView *)goodsImage {
    
    if (_goodsImage == nil) {
        
        _goodsImage = [[UIImageView alloc]init];
        _goodsImage.frame = CGRectMake(0, ScreenH, 50, 50);
        _goodsImage.centerX = self.addCartBtn.centerX;
        [self.view addSubview:_goodsImage];
    }
    
    return _goodsImage;
}

- (NSMutableArray *)recommendGoodsArr {
    
    if (_recommendGoodsArr == nil) {
        
        _recommendGoodsArr = [NSMutableArray array];
    }
    
    return _recommendGoodsArr;
}

- (instancetype)initWithGoodsId:(NSString *)goodsId packgeModel:(MallPackageModel *)packgeModel {
    
    self = [super init];
    if (self) {
        
        self.goodsId = goodsId;
        self.packgeModel = packgeModel;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    // 当是侧滑手势的时候设置scrollview需要此手势失效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [self.contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
            break;
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setImage:[UIImage imageNamed:@"goodsinfo_rightnav_icon"] forState:UIControlStateNormal];
//    btn1.width = 40;
//    btn1.height = 44;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    self.navigationItem.rightBarButtonItem = item;
    
    [self setupTitleView];
    
    [self setupScrollView];
    
    [self setupContentView];
    
    [self setupBottomView];
    
    [self setupRefresh];
    
    [self setupGoodsDetailView];
    
    __weak typeof (self)weakSelf = self;
    if (self.goodsId != nil) {
        
        [self.service getGoodsDetailInfo:self.goodsId completion:^(GoodsDetailModel *goodsDetailModel) {
            
            weakSelf.goodsDetailModel = goodsDetailModel;
            [weakSelf.tableView reloadData];
            
            NSMutableArray *imageArr = @[].mutableCopy;
            NSDictionary *dict = goodsDetailModel.productImageList[0];
            for (int i = 0; i < dict.count; i++) {
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, dict[[NSString stringWithFormat:@"image%zd",i+1]]];
                [imageArr addObject:imageUrl];
            }
            
            weakSelf.goodsInfoDetailVC.imageUrl = imageArr[0];
            weakSelf.pageScrollView.imageUrlArr = imageArr;
            weakSelf.likeBtn.selected = goodsDetailModel.favorite;
            
            UserInfoModel *userModel = [[CommUtils sharedInstance] fetchUserInfo];
            if (userModel.isshow) {
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.goodsDetailModel.picture];
                [weakSelf.detailImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
                
            }else {
                
                weakSelf.detailImage.image = [UIImage imageNamed:@"sys_xiao8"];
                weakSelf.detailImage.contentMode = UIViewContentModeScaleAspectFit;
            }
            
            //        [weakSelf.service getRecommendGoodsList:goodsDetailModel.catalogID completion:^(NSMutableArray *recommendGoodsArr) {
            //
            //            weakSelf.recommendGoodsArr = recommendGoodsArr;
            //            
            //            [weakSelf.tableView reloadData];
            //        }];
            
        }];
        
    }else {
    
        [self.service getPackageDetailInfo:self.packgeModel.id completion:^(PackageDetailModel *packageDetailModel) {
            
            weakSelf.packageDetailModel = packageDetailModel;
            weakSelf.packageDetailModel.totalPrice = weakSelf.packgeModel.totalPrice;
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, weakSelf.packgeModel.picture];
            weakSelf.pageScrollView.imageUrlArr = @[imageUrl];
            weakSelf.goodsInfoDetailVC.imageUrl = imageUrl;
            UserInfoModel *userModel = [[CommUtils sharedInstance] fetchUserInfo];
            if (userModel.isshow) {
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.packgeModel.picture];
                [weakSelf.detailImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
                
            }else {
                
                weakSelf.detailImage.image = [UIImage imageNamed:@"sys_xiao8"];
                weakSelf.detailImage.contentMode = UIViewContentModeScaleAspectFit;
            }
            [weakSelf.tableView reloadData];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    __weak typeof (self)weakSelf = self;
    if ([[CommUtils sharedInstance] isLogin]) {
        
        [self.service getCartList:^(ShoppingCartModel *cartModel) {
            
            weakSelf.cartModel = cartModel;
            NSInteger count = cartModel.cartCount;
            for (ShoppingCartDetailModel *detailModel in cartModel.pgCartList) {
                
                count += detailModel.buyCount;
            }

            weakSelf.cartCount.text = [NSString stringWithFormat:@"%ld",(long)count];
            if (count == 0) {
                
                weakSelf.cartCount.hidden = YES;
                
            }else {

                [weakSelf layoutCartCount];
                weakSelf.cartCount.hidden = NO;
            }
        }];
        
    }else {
    
        self.cartCount.text = [NSString stringWithFormat:@"%ld",(long)[ShoppingCartDetailModel getCartGoodsNumber]];
        if ([ShoppingCartDetailModel getCartGoodsNumber] == 0) {
            
            self.cartCount.hidden = YES;
            
        }else {
            
            [self layoutCartCount];
            self.cartCount.hidden = NO;
        }
    }

}

- (void)setupTitleView {

    if (self.titleView != nil) {
        
        self.titleView = nil;
        self.navigationItem.titleView = nil;
    }
    
    ScrollTitleView *titleView = [[ScrollTitleView alloc]init];
    titleView.width = 200;
    titleView.height = 44;
    titleView.delegate = self;
    titleView.titleArr = [NSMutableArray arrayWithArray:@[@"商品",@"详情"]];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
}

/**
 * 创建内容scrollview
 */
- (void)setupScrollView {
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 2 * ScreenH - 64)];
    contentScrollView.backgroundColor = CustomColor(243, 243, 243);
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    self.contentScrollView.contentSize = CGSizeMake(2 * ScreenW, 0);
}

/**
 * 创建商品信息的tableview
 */
- (void)setupContentView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64 - 50) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CustomColor(243, 243, 243);
    [self.contentScrollView addSubview:tableView];
    self.tableView = tableView;
    
    //轮播图
    PageScrollView *pageScrollView = [[PageScrollView alloc]initWithIsStartTimer:NO];
    pageScrollView.height = 200;
    pageScrollView.width = ScreenW;
    tableView.tableHeaderView = pageScrollView;
    self.pageScrollView = pageScrollView;
    
    UIImageView *detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW, 0, ScreenW, ScreenH - 64 - 50)];
    [self.contentScrollView addSubview:detailImage];
    self.detailImage = detailImage;
    
}

/**
 * 创建商品详情
 */
- (void)setupGoodsDetailView {
    
    GoodsInfoDetailViewController *goodsInfoDetailVC = [[GoodsInfoDetailViewController alloc]init];
    goodsInfoDetailVC.view.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH - 50);
    goodsInfoDetailVC.delegate = self;
    [self addChildViewController:goodsInfoDetailVC];
    [self.contentScrollView addSubview:goodsInfoDetailVC.view];
    self.goodsInfoDetailVC = goodsInfoDetailVC;
}

/**
 *创建刷新控件
 */
- (void)setupRefresh {
    
    self.tableView.mj_footer = [GoodsRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUp)];
}

/**
 * 上拉加载商品详情
 */
- (void)pullUp {

    [self.tableView.mj_footer endRefreshing];
    [UIView animateWithDuration:0.4 animations:^{
        
       self.contentScrollView.transform = CGAffineTransformTranslate(self.contentScrollView.transform, 0, -(ScreenH + 50));
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"商品详情";
    }];
    self.titleView.index = 2;
    self.contentScrollView.contentSize = CGSizeMake(0, 0);
}

/**
 * 下拉返回
 */
- (void)pullDown {

    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.contentScrollView.transform = CGAffineTransformIdentity;
        self.navigationItem.title = nil;
        
    } completion:^(BOOL finished) {
        
        [self setupTitleView];
    }];
    
    self.titleView.index = 1;
    self.contentScrollView.contentSize = CGSizeMake(2 * ScreenW, 0);
}

/**
 * 创建底部工具条
 */
- (void)setupBottomView {
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    line.frame = CGRectMake(0, ScreenH - 50, ScreenW, 0.5);
    [self.view addSubview:line];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), ScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    CustomButton *shareBtn = [[CustomButton alloc]init];
    shareBtn.frame = CGRectMake(0, 5, ScreenW / 6, bottomView.height);
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:CustomColor(153, 153, 153) forState:UIControlStateNormal];
    shareBtn.centerOffset = 10;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [bottomView addSubview:shareBtn];
    
    CustomButton *appointBtn = [[CustomButton alloc]init];
    appointBtn.frame = CGRectMake(CGRectGetMaxX(shareBtn.frame), 5, ScreenW / 6, bottomView.height);
    [appointBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [appointBtn setTitle:@"预约" forState:UIControlStateNormal];
    [appointBtn setTitleColor:CustomColor(153, 153, 153) forState:UIControlStateNormal];
    appointBtn.centerOffset = 10;
    appointBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [appointBtn addTarget:self action:@selector(appointClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appointBtn];
    
    CustomButton *likeBtn = [[CustomButton alloc]init];
    likeBtn.frame = CGRectMake(CGRectGetMaxX(appointBtn.frame), 6, ScreenW / 6, bottomView.height);
    [likeBtn setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateSelected];
    [likeBtn setImage:[UIImage imageNamed:@"not_like_icon"] forState:UIControlStateNormal];
    [likeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [likeBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.isCheckLogin = YES;
    [likeBtn setTitleColor:CustomColor(153, 153, 153) forState:UIControlStateNormal];
    likeBtn.centerOffset = 9;
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [bottomView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    appointBtn.hidden = self.packgeModel != nil;
    likeBtn.hidden = self.packgeModel != nil;
    shareBtn.hidden = self.packgeModel != nil;
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cartBtn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    cartBtn.frame = CGRectMake(CGRectGetMaxX(likeBtn.frame), 0, ScreenW / 6, bottomView.height);
    [cartBtn addTarget:self action:@selector(cartClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cartBtn];
    self.cartBtn = cartBtn;
    
    UIButton *addCartBtn = [[UIButton alloc]init];
    addCartBtn.frame = CGRectMake(ScreenW * 2 / 3, 0, ScreenW / 3, bottomView.height);
    [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addCartBtn.backgroundColor = CustomColor(252, 21, 32);
    addCartBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addCartBtn addTarget:self action:@selector(addCartClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addCartBtn];
    self.addCartBtn = addCartBtn;
}


#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.packgeModel == nil) {
        
        return self.goodsDetailModel == nil ? 0 : 3;
        
    }else {
    
        return self.packageDetailModel == nil ? 0 : 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.packgeModel == nil) {
        
        if (indexPath.row == 0) {
            
            return self.goodsDetailModel.cellHeight;
            
        }else if (indexPath.row == 1) {
            
            return 50;
            
        }else if (indexPath.row == 2){
            
            return 50;
            
        }else {
            
            return [GoodsRecommendTableCell getCellHeight:self.recommendGoodsArr];
            
        }
        
    }else {
    
        if (indexPath.row == 0) {
            
            return self.packageDetailModel.cellHeight;
            
        }else if (indexPath.row == 1) {
            
            return 50;
            
        }else if (indexPath.row == 2){
            
            return 50;
            
        }else {
            
            return [GoodsRecommendTableCell getCellHeight:self.recommendGoodsArr];
            
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.packgeModel == nil) {
        
        if (indexPath.row == 0) {
            
            GoodsInfoTableCell *cell = [GoodsInfoTableCell cellWithTableView:tableView];
            cell.model = self.goodsDetailModel;
            return cell;
            
        }else if (indexPath.row == 1){//规格cell
            
            SpecificationTableCell *cell = [SpecificationTableCell cellWithTableView:tableView];
            GoodsSpecModel *model = self.goodsDetailModel.specList[self.goodsSpecView.currentIndex];
            if (model.specColor.length == 0 && model.specSize.length == 0) {
                
                cell.specStr = [NSString stringWithFormat:@"%ld个",(long)self.goodsSpecView.buyNumber];
                
            }else {
                
                cell.specStr = [NSString stringWithFormat:@"%@%@，%ld个",model.specColor?:@"",model.specSize?:@"",(long)self.goodsSpecView.buyNumber];
            }
            
            return cell;
            
            
        }else if (indexPath.row == 2){//活动cell
            
            GoodsActivityTableCell *cell = [GoodsActivityTableCell cellWithTableView:tableView];
            return cell;
            
        }else {//推荐商品cell
            
            GoodsRecommendTableCell *cell = [GoodsRecommendTableCell cellWithTableView:tableView];
            cell.recommendGoodsArr = self.recommendGoodsArr;
            return cell;
        }
        
    }else {
    
        if (indexPath.row == 0) {
            
            GoodsInfoTableCell *cell = [GoodsInfoTableCell cellWithTableView:tableView];
            cell.packageModel = self.packageDetailModel;
            return cell;
            
        }else if (indexPath.row == 1){//规格cell
            
            SpecificationTableCell *cell = [SpecificationTableCell cellWithTableView:tableView];
            
            PackageSpecModel *model = self.packageDetailModel.specAllList[self.goodsSpecView.currentIndex];
            
            if (model.specDesc.length == 0) {
                
                cell.specStr = [NSString stringWithFormat:@"%ld个",(long)self.goodsSpecView.buyNumber];
                
            }else {
                
                cell.specStr = [NSString stringWithFormat:@"%@，%ld个",model.specDesc,(long)self.goodsSpecView.buyNumber];
            }
            
            return cell;
            
            
        }else if (indexPath.row == 2){//活动cell
            
            GoodsActivityTableCell *cell = [GoodsActivityTableCell cellWithTableView:tableView];
            return cell;
            
        }else {//推荐商品cell
            
            GoodsRecommendTableCell *cell = [GoodsRecommendTableCell cellWithTableView:tableView];
            cell.recommendGoodsArr = self.recommendGoodsArr;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.goodsSpecView];
    if (indexPath.row == 1) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.layer.transform = [Animate firstStepTransform];
            self.maskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.view.layer.transform = [Animate secondStepTransform];
                self.goodsSpecView.transform = CGAffineTransformTranslate(self.goodsSpecView.transform, 0, -ScreenH * 3 / 4.0f);
            }];
        }];
        self.popViewType = SpecView;
    }
    
//    else if (indexPath.row == 3) {
//        
//        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.addressView];
//        [UIView animateWithDuration:0.2 animations:^{
//            self.navigationController.view.layer.transform = [Animate firstStepTransform];
//            self.maskView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.navigationController.view.layer.transform = [Animate secondStepTransform];
//                self.addressView.transform = CGAffineTransformTranslate(self.addressView.transform, 0, -ScreenH * 2 / 3.0f);
//            }];
//        }];
//        self.popViewType = SelectAddressView;
//    }
}

#pragma mark --- UIButtonClick ---
/**
 * 进入购物车页面
 */
- (void)cartClick {
    
    Class cls = NSClassFromString(@"ShoppingCartViewController");
    UIViewController *vc = [[cls alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 添加到购物车
 */
- (void)addCartClick:(UIButton *)sender {

    if (self.packgeModel == nil) {
        
        GoodsSpecModel *model = self.goodsDetailModel.specList[self.goodsSpecView.currentIndex];
        if (model.specStock < self.goodsSpecView.buyNumber) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"当前商品库存不足，是否需要预约商品？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        
        sender.userInteractionEnabled = NO;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.goodsDetailModel.picture];
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        CGPoint startPoint = [self.bottomView convertPoint:self.addCartBtn.center toView:self.view];
        CGPoint endPoint = [self.bottomView convertPoint:self.cartBtn.center toView:self.view];
        self.layer.frame = CGRectMake(startPoint.x, startPoint.y, 20, 20);
        self.layer.contents = (id)self.goodsImage.layer.contents;
        [self.view.layer addSublayer:self.layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path addQuadCurveToPoint:CGPointMake(endPoint.x, endPoint.y) controlPoint:CGPointMake(ScreenW * 2 / 3 + 20,ScreenH - 180)];
        
        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeBoth;
        animation.duration = 0.6;
        animation.delegate = self;
        animation.path = path.CGPath;
        [self.layer addAnimation:animation forKey:@"animation"];
        if ([[CommUtils sharedInstance] isLogin]) {//如果登录
            
            __weak typeof (self)weakSelf = self;
            NSDictionary *params = @{@"productID":self.goodsId ,
                                     @"buyCount":@(self.goodsSpecView.buyNumber),
                                     @"buySpecID":model.id,
                                     @"token":[[CommUtils sharedInstance] fetchToken]};
            [self.service addCart:params goodsType:@"0" completion:^{
                
                weakSelf.cartCount.hidden = NO;
                weakSelf.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
            }];
            
        }else {//如果未登录存本地
            
            ShoppingCartDetailModel *cartDetailModel = [ShoppingCartDetailModel getCartModelById:self.goodsId specId:model.id];
            if (cartDetailModel != nil) {//如果存在某个商品，更新数量
                
                cartDetailModel.buyCount += self.goodsSpecView.buyNumber;
                if ([ShoppingCartDetailModel updateCartModel:cartDetailModel]) {
                    
                    self.cartCount.hidden = NO;
                    self.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
                }
                
            }else {//如果不存在，新增记录
                
                ShoppingCartDetailModel *detailModel = [[ShoppingCartDetailModel alloc]init];
                detailModel.id = self.goodsDetailModel.id;
                detailModel.name = self.goodsDetailModel.name;
                detailModel.picture = self.goodsDetailModel.picture;
                detailModel.buyCount = self.goodsSpecView.buyNumber;
                detailModel.nowPrice = model.specPrice;
                detailModel.buySpecInfo = model;
                if ([ShoppingCartDetailModel saveCartModelToDB:detailModel]) {
                    
                    self.cartCount.hidden = NO;
                    self.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
                }
            }
        }
        
    }else {
    
        PackageSpecModel *model = self.packageDetailModel.specAllList[self.goodsSpecView.currentIndex];
        if (model.minStock < self.goodsSpecView.buyNumber) {
            
            [SVProgressHUD showErrorWithStatus:@"当前套餐库存不足！" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        
        sender.userInteractionEnabled = NO;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.packgeModel.picture];
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        CGPoint startPoint = [self.bottomView convertPoint:self.addCartBtn.center toView:self.view];
        CGPoint endPoint = [self.bottomView convertPoint:self.cartBtn.center toView:self.view];
        self.layer.frame = CGRectMake(startPoint.x, startPoint.y, 20, 20);
        self.layer.contents = (id)self.goodsImage.layer.contents;
        [self.view.layer addSublayer:self.layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path addQuadCurveToPoint:CGPointMake(endPoint.x, endPoint.y) controlPoint:CGPointMake(ScreenW * 2 / 3 + 20,ScreenH - 180)];
        
        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeBoth;
        animation.duration = 0.6;
        animation.delegate = self;
        animation.path = path.CGPath;
        [self.layer addAnimation:animation forKey:@"animation"];
        if ([[CommUtils sharedInstance] isLogin]) {//如果登录
            
            __weak typeof (self)weakSelf = self;
            NSDictionary *params = @{@"packageID":self.packgeModel.id ,
                                     @"buyCount":@(self.goodsSpecView.buyNumber),
                                     @"proIDs":model.productIds,
                                     @"desIDs":model.specIds,
                                     @"token":[[CommUtils sharedInstance] fetchToken]};
            [self.service addCart:params goodsType:@"1" completion:^{
                
                weakSelf.cartCount.hidden = NO;
                weakSelf.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
            }];
            
        }else {//如果未登录存本地
            
//            ShoppingCartDetailModel *cartDetailModel = [ShoppingCartDetailModel getCartModelById:self.goodsId specId:model.id];
//            if (cartDetailModel != nil) {//如果存在某个商品，更新数量
//                
//                cartDetailModel.buyCount += self.goodsSpecView.buyNumber;
//                if ([ShoppingCartDetailModel updateCartModel:cartDetailModel]) {
//                    
//                    self.cartCount.hidden = NO;
//                    self.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
//                }
//                
//            }else {//如果不存在，新增记录
//                
//                ShoppingCartDetailModel *detailModel = [[ShoppingCartDetailModel alloc]init];
//                detailModel.id = self.goodsDetailModel.id;
//                detailModel.name = self.goodsDetailModel.name;
//                detailModel.picture = self.goodsDetailModel.picture;
//                detailModel.buyCount = self.goodsSpecView.buyNumber;
//                detailModel.nowPrice = model.specPrice;
//                detailModel.buySpecInfo = model;
//                if ([ShoppingCartDetailModel saveCartModelToDB:detailModel]) {
//                    
//                    self.cartCount.hidden = NO;
//                    self.cartCount.text = [NSString stringWithFormat:@"%ld",(long)([self.cartCount.text integerValue] + self.goodsSpecView.buyNumber)];
//                }
//            }
        }
    }
}

/**
 * 收藏商品
 */
- (void)likeClick:(UIButton *)sender {

    __weak typeof (self)weakSelf = self;
    if (sender.selected) {//如果已经收藏状态了，那么执行取消收藏
        
        [self.service unLikedGoods:self.goodsId completion:^{
            
            sender.selected = NO;
            self.goodsDetailModel.favCount -= 1;
            [weakSelf.tableView reloadData];
            
        }];
        
    }else {
        
        [self.service likedGoods:self.goodsId completion:^{
            
            sender.selected = YES;
            self.goodsDetailModel.favCount += 1;
            [weakSelf.tableView reloadData];
        }];
    }
    
}

/**
 * 预约商品
 */
- (void)appointClick {
    
    if (![[CommUtils sharedInstance] isLogin]) {
        
        LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }else {
    
        GoodsSpecModel *specModel = self.goodsDetailModel.specList[self.goodsSpecView.currentIndex];
        ShoppingCartDetailModel *model = [[ShoppingCartDetailModel alloc]init];
        model.id = self.goodsDetailModel.id;
        model.name = self.goodsDetailModel.name;
        model.picture = self.goodsDetailModel.picture;
        model.buyCount = self.goodsSpecView.buyNumber;
        model.nowPrice = [self.goodsDetailModel.nowPrice doubleValue];
        model.buySpecInfo = specModel;
        AppointGoodsViewController *appointGoodsVC = [[AppointGoodsViewController alloc]initWithModel:model];
        appointGoodsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:appointGoodsVC animated:YES];
    }
}

- (void)dismiss {

    if (self.goodsSpecView.goodsType == SingleGood) {
        
        GoodsSpecModel *model = self.goodsDetailModel.specList[self.goodsSpecView.currentIndex];
        NSString *str = model == nil ? [NSString stringWithFormat:@"%ld个",self.goodsSpecView.buyNumber] : [NSString stringWithFormat:@"%@%@，%ld个",model.specColor,model.specSize,self.goodsSpecView.buyNumber];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadSpecValue" object:str];
        
        
    }else {
    
        PackageSpecModel *model = self.packageDetailModel.specAllList[self.goodsSpecView.currentIndex];
        NSString *str = model == nil ? [NSString stringWithFormat:@"%ld个",self.goodsSpecView.buyNumber] : [NSString stringWithFormat:@"%@，%ld个",model.specDesc,self.goodsSpecView.buyNumber];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadSpecValue" object:str];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.layer.transform = [Animate firstStepTransform];
        if (self.popViewType == SpecView) {
            
            self.goodsSpecView.transform = CGAffineTransformIdentity;
            
        }else if (self.popViewType == SelectAddressView) {
        
             self.addressView.transform = CGAffineTransformIdentity;
        }
       
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.layer.transform = CATransform3DIdentity;
            self.maskView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [self.maskView removeFromSuperview];
            if (self.popViewType == SpecView) {
                
                [self.goodsSpecView removeFromSuperview];
                
            }else if (self.popViewType == SelectAddressView) {
                
                [self.addressView removeFromSuperview];
                self.addressView = nil;
            }
            
        }];
    }];
}



#pragma mark --- 动画结束 ---
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self.addCartBtn.userInteractionEnabled = YES;
    [self.layer removeFromSuperlayer];
    self.layer = nil;
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [self.cartBtn.layer addAnimation:shakeAnimation forKey:nil];
    
}

#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置的索引
    NSInteger index = offsetX / width;
    self.titleView.index = index + 1;
}


#pragma mark --- UIAlertViewDelegate ---
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self appointClick];
    }
}

#pragma mark --- ScrollTitleViewDelegate ---
- (void)scroll:(NSInteger)index {

    [self.contentScrollView setContentOffset:CGPointMake(index * ScreenW, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

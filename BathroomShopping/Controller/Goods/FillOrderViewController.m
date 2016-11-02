//
//  FillOrderViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/29/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "FillOrderViewController.h"
#import "GoodsService.h"
#import "DeliveryModel.h"
#import "MineService.h"
#import "ReceiverAddressModel.h"
#import "CalculateViewController.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
#import "GoodsListViewController.h"
#import "ErrorView.h"
#import "AddressListViewController.h"
@interface FillOrderViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 配送方式网络请求对象 */
@property(nonatomic,strong)GoodsService *goodsService;
/** 我的地址网络请求对象 */
@property(nonatomic,strong)MineService *mineService;
/** 配送方式模型数组 */
@property(nonatomic,strong)NSMutableArray *deliveryModelArr;
/** 我的地址模型数组 */
@property(nonatomic,strong)NSMutableArray *addressModelArr;
/** 配送方式 */
@property (nonatomic, weak)UILabel *wayLbl;
/** 运费 */
@property(nonatomic, weak)UILabel *mailPriceLbl;
/** 收货人姓名 */
@property (nonatomic, weak)UILabel *nameLbl;
/** <##> */
@property (nonatomic, weak)UILabel *phoneLbl;
/** <##> */
@property (nonatomic, weak)UILabel *addressLbl;
/** <##> */
@property (nonatomic, weak)UILabel *defaultLbl;

@property(nonatomic,strong)dispatch_group_t group;
/** 留言输入框 */
@property (nonatomic, weak)UITextField *remarkTxt;
/** <##> */
@property(nonatomic,strong)UIPickerView *pickerView;
/** <##> */
@property(nonatomic,strong)UIView *maskView;
/** <##> */
@property (nonatomic, weak)UILabel *totalPriceLbl;
/** <##> */
@property (nonatomic, weak)ErrorView *errorView;
/** <##> */
@property(nonatomic,strong)ReceiverAddressModel *selectModel;
@end

@implementation FillOrderViewController

- (dispatch_group_t)group {
    
    if (_group == nil) {
        _group = dispatch_group_create();
    }
    return _group;
}

- (GoodsService *)goodsService {
    
    if (_goodsService == nil) {
        
        _goodsService = [[GoodsService alloc]init];
    }
    
    return _goodsService;
}


- (MineService *)mineService {
    
    if (_mineService == nil) {
        
        _mineService = [[MineService alloc]init];
    }
    
    return _mineService;
}

- (NSMutableArray *)deliveryModelArr {
    
    if (_deliveryModelArr == nil) {
        
        _deliveryModelArr = [NSMutableArray array];
    }
    
    return _deliveryModelArr;
}


- (NSMutableArray *)addressModelArr {
    
    if (_addressModelArr == nil) {
        
        _addressModelArr = [NSMutableArray array];
    }
    
    return _addressModelArr;
}

//创建pickerView
- (UIPickerView *)pickerView
{
    
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 200)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        //是否要显示选中的指示器(默认值是NO)
        _pickerView.showsSelectionIndicator = NO;
        
    }
    
    return _pickerView;
}

- (UIView *)maskView {
    
    if (_maskView == nil) {
        
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5f;
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"AddAddressSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddressInfo:) name:@"reloadAddressInfo" object:nil];
    self.navigationItem.title = @"填写订单";
    self.view.backgroundColor = CustomColor(240, 243, 246);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initView {

    // ----------  顶部地址 ----------
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scroll];
    scroll.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    UIView *topBgView = [[UIView alloc]init];
    topBgView.width = ScreenW;
    topBgView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:topBgView];
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressViewClick)];
    addressTap.numberOfTapsRequired = 1;
    [topBgView addGestureRecognizer:addressTap];
    
    ReceiverAddressModel *addressModel = self.addressModelArr[0];
    addressModel.isSelected = YES;
    self.selectModel = addressModel;
    UILabel *nameLbl = [[UILabel alloc]init];
    nameLbl.font = [UIFont systemFontOfSize:16];
    nameLbl.text = addressModel.name;
    [nameLbl sizeToFit];
    nameLbl.frame = CGRectMake(30, 15, nameLbl.width, nameLbl.height);
    [topBgView addSubview:nameLbl];
    self.nameLbl = nameLbl;
    
    UILabel *phoneLbl = [[UILabel alloc]init];
    phoneLbl.text = addressModel.mobile;
    [phoneLbl sizeToFit];
    phoneLbl.font = [UIFont systemFontOfSize:16];
    phoneLbl.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame) + 15, 0, phoneLbl.width, phoneLbl.height);
    phoneLbl.centerY = nameLbl.centerY;
    [topBgView addSubview:phoneLbl];
    self.phoneLbl = phoneLbl;
    
    UILabel *defaultLbl = [[UILabel alloc]init];
//    defaultLbl.text = @"默认";
    defaultLbl.textColor = [UIColor whiteColor];
    defaultLbl.backgroundColor = [UIColor redColor];
    defaultLbl.font = [UIFont systemFontOfSize:13];
    [defaultLbl sizeToFit];
    defaultLbl.frame = CGRectMake(CGRectGetMaxX(phoneLbl.frame) + 8, 0, defaultLbl.width, defaultLbl.height);
    defaultLbl.centerY = nameLbl.centerY;
    [topBgView addSubview:defaultLbl];
    self.defaultLbl = defaultLbl;
    
    UIImageView *arrowImg = [[UIImageView alloc]init];
    arrowImg.image = [UIImage imageNamed:@"arrow_icon"];
    arrowImg.frame = CGRectMake(ScreenW - 7 - 10, 0, 7, 13);
    [topBgView addSubview:arrowImg];
    
    UILabel *addressLbl = [[UILabel alloc]init];
    addressLbl.numberOfLines = 0;
    addressLbl.text = [[NSString stringWithFormat:@"%@%@",addressModel.pcadetail,addressModel.address] stringByReplacingOccurrencesOfString:@" " withString:@""];
    addressLbl.textColor = [UIColor darkGrayColor];
    addressLbl.font = [UIFont systemFontOfSize:14];
    addressLbl.x = 30;
    addressLbl.y = CGRectGetMaxY(nameLbl.frame) + 10;
    addressLbl.width = ScreenW - 30 - arrowImg.width - 10 - 5;
    CGFloat labelHeight = [addressLbl sizeThatFits:CGSizeMake(addressLbl.frame.size.width, MAXFLOAT)].height;
    NSInteger count = MIN(labelHeight / addressLbl.font.lineHeight, 2);
    addressLbl.height = count * addressLbl.font.lineHeight;
    [topBgView addSubview:addressLbl];
    self.addressLbl = addressLbl;
    
    UIImageView *locationImg = [[UIImageView alloc]init];
    locationImg.image = [UIImage imageNamed:@"location_icon"];
    locationImg.frame = CGRectMake(0, addressLbl.y, 19, 19);
    locationImg.centerX = CGRectGetMinX(addressLbl.frame) / 2;
    [topBgView addSubview:locationImg];
    
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(0,CGRectGetMaxY(addressLbl.frame) + 20, ScreenW, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [topBgView addSubview:line];
    topBgView.height = CGRectGetMaxY(line.frame);
    arrowImg.centerY = topBgView.centerY;
    
    // ---------- 中间商品 ----------
    
    UIView *middleView = [[UIView alloc]init];
    middleView.width = ScreenW;
    middleView.y = CGRectGetMaxY(topBgView.frame) + 12;
    middleView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:middleView];
    
    if (self.pageType == OneSale) {//一元抢购
        
        ShoppingCartDetailModel *detailModel = self.goodsArr[0];
        middleView.height = 44;
        UILabel *nameLbl = [[UILabel alloc]init];
        nameLbl.text = [NSString stringWithFormat:@"商品名称：%@",detailModel.name];
        [nameLbl sizeToFit];
        nameLbl.textColor = [UIColor darkGrayColor];
        nameLbl.frame = CGRectMake(10, 0, ScreenW - 20, middleView.height);
        nameLbl.font = [UIFont systemFontOfSize:15];
        [middleView addSubview:nameLbl];
        
    }else if (self.pageType == OneGoods) {//只有一个商品
    
        
        ShoppingCartDetailModel *detailModel = self.goodsArr[0];
        UIImageView *goodsImg = [[UIImageView alloc]init];
        goodsImg.x = 10;
        goodsImg.y = 15;
        goodsImg.width = 70;
        goodsImg.height = 80;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
        [goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        [middleView addSubview:goodsImg];
        middleView.height = goodsImg.height + 15 * 2;
        
        UILabel *nameLbl = [[UILabel alloc]init];
        nameLbl.x = CGRectGetMaxX(goodsImg.frame) + 10;
        nameLbl.y = goodsImg.y;
        nameLbl.text = detailModel.name;
        nameLbl.font = [UIFont systemFontOfSize:14];
        [nameLbl sizeToFit];
        nameLbl.width = ScreenW - nameLbl.x - 10;
        [middleView addSubview:nameLbl];
        
        UILabel *numberLbl = [[UILabel alloc]init];
        numberLbl.x = nameLbl.x;
        numberLbl.y = CGRectGetMaxY(nameLbl.frame) + 15;
        numberLbl.text = [NSString stringWithFormat:@"数量:×%ld",(long)detailModel.buyCount];
        numberLbl.font = [UIFont systemFontOfSize:10];
        numberLbl.textColor = [UIColor darkGrayColor];
        [numberLbl sizeToFit];
        [middleView addSubview:numberLbl];
        
        UILabel *specLbl = [[UILabel alloc]init];
        specLbl.x = CGRectGetMaxX(numberLbl.frame) + 15;
        specLbl.y = numberLbl.y;
        
        
        specLbl.font = [UIFont systemFontOfSize:10];
        specLbl.textColor = [UIColor darkGrayColor];
        
        
        UILabel *priceLbl = [[UILabel alloc]init];
        priceLbl.x = nameLbl.x;
        priceLbl.y = CGRectGetMaxY(numberLbl.frame) + 15;
        
        priceLbl.font = [UIFont systemFontOfSize:12];
        priceLbl.textColor = [UIColor redColor];
       
        
        if (detailModel.isPackage) {
            
            specLbl.text = [NSString stringWithFormat:@"规格:%@",detailModel.specDesc];
            priceLbl.text = [NSString stringWithFormat:@"¥%.2f",detailModel.packagePice];
            
        }else {
            
            specLbl.text = [NSString stringWithFormat:@"规格:%@%@",detailModel.buySpecInfo.specColor,detailModel.buySpecInfo.specSize];
            priceLbl.text = [NSString stringWithFormat:@"¥%.2f",detailModel.nowPrice];
        }
        
        [specLbl sizeToFit];
        [middleView addSubview:specLbl];
        
        [priceLbl sizeToFit];
        [middleView addSubview:priceLbl];
        
    }else {//有多个商品
    
        middleView.height = 90;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsViewClick)];
        tap.numberOfTapsRequired = 1;
        [middleView addGestureRecognizer:tap];
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, middleView.width - 120, middleView.height)];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [middleView addSubview:scroll];
        
        NSInteger totalCount = 0;
        for (int i = 0; i < self.goodsArr.count; i++) {
            
            ShoppingCartDetailModel *detailModel = self.goodsArr[i];
            UIImageView *goodsImg = [[UIImageView alloc]init];
            CGFloat goodsImgW = 60;
            CGFloat goodsImgX = i * (15 + goodsImgW);
            goodsImg.frame = CGRectMake(goodsImgX, 15, 60, 60);
            [scroll addSubview:goodsImg];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
            [goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            totalCount += detailModel.buyCount;
        }
        
        scroll.contentSize = CGSizeMake(CGRectGetMaxX([scroll.subviews lastObject].frame), 0);
        
        
        UIImageView *arrowImg = [[UIImageView alloc]init];
        arrowImg.image = [UIImage imageNamed:@"arrow_icon"];
        arrowImg.frame = CGRectMake(ScreenW - 7 - 10, 0, 7, 13);
        arrowImg.centerY = middleView.height / 2;
        [middleView addSubview:arrowImg];
        
        UILabel *middleNumberLbl = [[UILabel alloc]init];
        middleNumberLbl.x = CGRectGetMaxX(scroll.frame) + 20;
        
        middleNumberLbl.text = [NSString stringWithFormat:@"共%ld件",(long)totalCount];
        middleNumberLbl.font = [UIFont systemFontOfSize:10];
        middleNumberLbl.textColor = [UIColor darkGrayColor];
        [middleNumberLbl sizeToFit];
        middleNumberLbl.centerY = arrowImg.centerY;
        middleNumberLbl.width = ScreenW - middleNumberLbl.x - 10 - arrowImg.width - 10;
        middleNumberLbl.textAlignment = NSTextAlignmentRight;
        [middleView addSubview:middleNumberLbl];
    }
    
    // ---------- 配送方式 ----------
    UIView *deliveryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame) + 12,ScreenW, 44)];
    deliveryView.backgroundColor = [UIColor whiteColor];
    deliveryView.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    deliveryView.layer.borderWidth = 0.5;
    [scroll addSubview:deliveryView];
    UILabel *deliveryLbl = [[UILabel alloc]init];
    deliveryLbl.text = @"配送方式";
    [deliveryLbl sizeToFit];
    deliveryLbl.textColor = [UIColor darkGrayColor];
    deliveryLbl.frame = CGRectMake(10, 0, deliveryLbl.width, deliveryView.height);
    deliveryLbl.font = [UIFont systemFontOfSize:14];
    
    [deliveryView addSubview:deliveryLbl];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 1;
    [deliveryView addGestureRecognizer:tap];
    
    UIImageView *arrowImg1 = [[UIImageView alloc]init];
    arrowImg1.image = [UIImage imageNamed:@"arrow_icon"];
    arrowImg1.frame = CGRectMake(ScreenW - 7 - 10, 0, 7, 13);
    arrowImg1.centerY = deliveryLbl.centerY;
    [deliveryView addSubview:arrowImg1];
    
    DeliveryModel *deliverymodel = self.deliveryModelArr[0];
    
    UILabel *wayLbl = [[UILabel alloc]init];
    CGFloat wayLblX = CGRectGetMaxX(deliveryLbl.frame) + 10;
    wayLbl.frame = CGRectMake(wayLblX, 0, ScreenW - wayLblX - arrowImg1.width - 10 - 10, deliveryView.height);
    wayLbl.font = [UIFont systemFontOfSize:14];
    wayLbl.textColor = [UIColor darkGrayColor];
    wayLbl.textAlignment = NSTextAlignmentRight;
    wayLbl.text = deliverymodel.name;
    [deliveryView addSubview:wayLbl];
    self.wayLbl = wayLbl;
    
    UIView *remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(deliveryView.frame) + 12, ScreenW, 44)];
    remarkView.backgroundColor = [UIColor whiteColor];
    remarkView.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    remarkView.layer.borderWidth = 0.5;
    [scroll addSubview:remarkView];
    
    UITextField *remarkTxt = [[UITextField alloc]init];
    remarkTxt.frame = CGRectMake(10, 7, ScreenW - 10 - 10, 30);
    remarkTxt.placeholder = @"选填：给商家留言（45字以内）";
    remarkTxt.font = [UIFont systemFontOfSize:14];
    [remarkView addSubview:remarkTxt];
    self.remarkTxt = remarkTxt;
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(remarkView.frame) + 12, ScreenW, 0)];
    priceView.backgroundColor = [UIColor whiteColor];
    priceView.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    priceView.layer.borderWidth = 0.5;
    [scroll addSubview:priceView];
    
    UILabel *priceTitleLbl = [[UILabel alloc]init];
    priceTitleLbl.text = @"商品金额";
    [priceTitleLbl sizeToFit];
    priceTitleLbl.font = [UIFont systemFontOfSize:14];
    priceTitleLbl.frame = CGRectMake(8, 12, priceTitleLbl.width, priceTitleLbl.height);
    [priceView addSubview:priceTitleLbl];
    
    
    UILabel *priceLbl = [[UILabel alloc]init];
    priceLbl.textColor = [UIColor redColor];
    priceLbl.font = [UIFont systemFontOfSize:14];
    if (self.pageType == OneSale) {
        
        priceLbl.text = @"￥1.00";
        
    }else {
    
        double totalMoney = self.totalPrice;
        priceLbl.text = [NSString stringWithFormat:@"¥%.2f", totalMoney];
        
    }
    
    [priceLbl sizeToFit];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.frame = CGRectMake(ScreenW - 8 - priceLbl.width, priceTitleLbl.y, priceLbl.width, priceLbl.height);
    [priceView addSubview:priceLbl];
    
    
    
    UILabel *mailTitleLbl = [[UILabel alloc]init];
    mailTitleLbl.text = @"运费";
    [mailTitleLbl sizeToFit];
    mailTitleLbl.font = [UIFont systemFontOfSize:14];
    mailTitleLbl.frame = CGRectMake(priceTitleLbl.x,CGRectGetMaxY(priceTitleLbl.frame) + 12, mailTitleLbl.width, mailTitleLbl.height);
    [priceView addSubview:mailTitleLbl];
    
    UILabel *mailPriceLbl = [[UILabel alloc]init];
    mailPriceLbl.text = [NSString stringWithFormat:@"+ ￥%.2f",deliverymodel.fee];
    mailPriceLbl.textAlignment = NSTextAlignmentRight;
    mailPriceLbl.textColor = [UIColor redColor];
    [mailPriceLbl sizeToFit];
    mailPriceLbl.font = [UIFont systemFontOfSize:14];
    mailPriceLbl.frame = CGRectMake(ScreenW - 8 - mailPriceLbl.width, mailTitleLbl.y, mailPriceLbl.width, mailPriceLbl.height);
    [priceView addSubview:mailPriceLbl];
    self.mailPriceLbl = mailPriceLbl;
    
    priceView.height = CGRectGetMaxY(mailTitleLbl.frame) + 12;
    
    
    // ------- 底部view -------
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - 50, ScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.frame = CGRectMake(0,0, ScreenW, 0.5);
    line1.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [bottomView addSubview:line1];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    orderBtn.backgroundColor = [UIColor redColor];
    orderBtn.frame = CGRectMake(ScreenW - 85, 0, 85, bottomView.height);
    [bottomView addSubview:orderBtn];
    
    UILabel *totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl.frame = CGRectMake(20, 0, ScreenW - 20 - orderBtn.width - 8, bottomView.height);
    totalPriceLbl.textColor = [UIColor redColor];
    totalPriceLbl.font = [UIFont systemFontOfSize:14];
    totalPriceLbl.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:totalPriceLbl];
    self.totalPriceLbl = totalPriceLbl;
    if (self.pageType == OneSale) {
        
        totalPriceLbl.text = @"实付款：¥ 1.00";
        
    }else {
    
        double totalMoney = self.totalPrice + deliverymodel.fee;
        totalPriceLbl.text = [NSString stringWithFormat:@"实付款：¥ %.2f", totalMoney];
    }
    
    scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(priceView.frame) + 5);
}

/**
 * error view
 */
- (void)initErrorView {

    ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
    errorView.warnStr = @"您还没有收货地址哦！";
    errorView.btnTitle = @"新建地址";
    errorView.imgName = @"sys_xiao8";
    [errorView setTarget:self action:@selector(addAddress)];
    self.errorView = errorView;
    [self.view addSubview:errorView];
}

#pragma mark --- settter ---
- (void)setPageType:(PageType)pageType {

    _pageType = pageType;
    
    [self onLoad];
    
}

- (void)onLoad {

    __weak typeof (self)weakSelf = self;
    
    dispatch_group_enter(self.group);
    [self.goodsService getDelivery:^(NSMutableArray *deliveryModelArr) {
        dispatch_group_leave(weakSelf.group);
        weakSelf.deliveryModelArr = deliveryModelArr;
        
    }];
    
    dispatch_group_enter(self.group);
    [self.mineService getAddressList:^(NSMutableArray *addressModelArr) {
        
        dispatch_group_leave(weakSelf.group);
        weakSelf.addressModelArr = addressModelArr;
    }];
    
    //当所有请求都执行完
    dispatch_group_notify(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^(){
            
            if (weakSelf.addressModelArr.count == 0) {
                
                [weakSelf initErrorView];
                
            }else {
                
                [weakSelf initView];
            }
            
            
        });
        
    });
}

- (void)submitClick {

    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10];
    NSMutableString *packageIdstr = [[NSMutableString alloc] initWithCapacity:10];
    for (int i = 0; i < self.goodsArr.count; i++) {
        
        ShoppingCartDetailModel *detailMode = self.goodsArr[i];
        if (!detailMode.isPackage) {
            
            if (i == 0) {
                
                [str appendString:detailMode.id];
                
            }else {
                
                [str appendString:[NSString stringWithFormat:@",%@",detailMode.id]];
            }
        }
    }
    
    NSInteger index = 1;
    for (int i = 0; i < self.goodsArr.count; i++) {
        
        ShoppingCartDetailModel *detailMode = self.goodsArr[i];
        if (detailMode.packageId != nil && ![detailMode.packageId isEqualToString:@""] && detailMode.isPackage) {
            
            if (index == 1) {
                
                [packageIdstr appendString:detailMode.packageId];
                
            }else {
                
                [packageIdstr appendString:[NSString stringWithFormat:@",%@",detailMode.packageId]];
            }
            
            index++;
        }
    }

    ReceiverAddressModel *addressModel = self.addressModelArr[0];
    addressModel.isSelected = YES;
    DeliveryModel *deliverymodel = self.deliveryModelArr[0];
    CalculateViewController *calculateVC = [[CalculateViewController alloc]init];
    calculateVC.isOneMoneyLottery = self.pageType == OneSale;
    if (self.pageType != OneSale) {
        
        NSDictionary *params = @{@"expressCode":deliverymodel.code,
                                 @"otherRequirement":self.remarkTxt.text?:@"",
                                 @"productIds":[str copy]?:@"",
                                 @"selectAddressID":addressModel.id,
                                 @"token":[[CommUtils sharedInstance] fetchToken],
                                 @"packageIdArr":[packageIdstr copy]?:@""};
        
        calculateVC.params = params;
    }
    
    [self.navigationController pushViewController:calculateVC animated:YES];
}

- (void)setGoodsArr:(NSMutableArray *)goodsArr {

    _goodsArr = goodsArr;
}

- (void)setTotalPrice:(double)totalPrice {

    _totalPrice = totalPrice;
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.deliveryModelArr.count;
}

//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    DeliveryModel *model = self.deliveryModelArr[row];
    return model.name;
}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    [self.maskView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.pickerView.y += 200;
        
    } completion:^(BOOL finished) {
        
        [self.pickerView removeFromSuperview];
    }];
    
    DeliveryModel *model = self.deliveryModelArr[row];
    self.wayLbl.text = model.name;
    if (self.pageType != OneSale) {
        
        self.mailPriceLbl.text = [NSString stringWithFormat:@"+ ￥%.2f",model.fee];
        
        double totalMoney = self.totalPrice + model.fee;
        self.totalPriceLbl.text = [NSString stringWithFormat:@"实付款：¥ %.2f", totalMoney];
    }
    
    
}

- (void)tapClick {

    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    [UIView animateWithDuration:0.5 animations:^{
       
        self.pickerView.y -= 200;
    }];
}

- (void)goodsViewClick {

    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc]init];
    goodsListVC.hidesBottomBarWhenPushed = YES;
    goodsListVC.goodsArr = self.goodsArr;
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

- (void)addressViewClick {

    AddressListViewController *addressListVC = [[AddressListViewController alloc]init];
    addressListVC.addressArr = self.addressModelArr;
    addressListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressListVC animated:YES];
}

- (void)addAddress {

    Class cls = NSClassFromString(@"AddReceiverViewController");
    UIViewController *vc = [[cls alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismiss {
    
    [self.maskView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.pickerView.y += 200;
        
    } completion:^(BOOL finished) {
        
        [self.pickerView removeFromSuperview];
    }];
}

- (void)reload {

    if (self.errorView != nil) {
        
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self onLoad];
    });
}

- (void)reloadAddressInfo:(NSNotification *)sender {

    ReceiverAddressModel *model = (ReceiverAddressModel *)sender.object;
    model.isSelected = YES;
    self.selectModel.isSelected = NO;
    self.selectModel = model;
    self.nameLbl.text = model.name;
    [self.nameLbl sizeToFit];
    self.phoneLbl.text = model.mobile;
    self.phoneLbl.x = CGRectGetMaxX(self.nameLbl.frame) + 15;
    self.defaultLbl.x = CGRectGetMaxX(self.phoneLbl.frame) + 8;
    self.addressLbl.text = [NSString stringWithFormat:@"%@%@",model.pcadetail,model.address];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end

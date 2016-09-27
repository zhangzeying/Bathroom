//
//  AppointGoodsViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AppointGoodsViewController.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
#import "GoodsService.h"
#import "NSString+Extension.h"
@interface AppointGoodsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appointBtnTop;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@property (weak, nonatomic) IBOutlet UIView *numberBgView;
@property (weak, nonatomic) IBOutlet UITextField *numberTxt;
@property (weak, nonatomic) IBOutlet UIView *appointTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *appointBtn;
/** <##> */
@property(nonatomic,strong)ShoppingCartDetailModel *detailModel;
/** <##> */
@property(nonatomic,strong)GoodsService *service;
@end

@implementation AppointGoodsViewController

- (GoodsService *)service {
    
    if (_service == nil) {
        
        _service = [[GoodsService alloc]init];
    }
    
    return _service;
}

- (instancetype)initWithModel:(ShoppingCartDetailModel *)detailModel
{
    self = [super init];
    if (self) {
        
        self.detailModel = detailModel;
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"预约详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.appointBtn.backgroundColor = CustomColor(102, 159, 237);
    self.view.backgroundColor = CustomColor(247, 248, 249);
    
    if (self.detailModel != nil) {//如果是预约
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, self.detailModel.picture];
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        self.nameLbl.text = [NSString stringWithFormat:@"%@",self.detailModel.name];
        self.specLbl.text = [NSString stringWithFormat:@"%@%@",self.detailModel.buySpecInfo.specColor,self.detailModel.buySpecInfo.specSize];
        [self.appointBtn setTitle:@"预约" forState:UIControlStateNormal];
        self.appointTimeBgView.hidden = YES;
        self.appointBtnTop.constant = -45;
        self.viewHeight.constant = CGRectGetMaxY(self.appointBtn.frame) - 35;
        [self.numberTxt becomeFirstResponder];
        
    }else {//如果是查看预约
    
        [self.appointBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        self.appointTimeBgView.hidden = NO;
        self.appointBtnTop.constant = 15;
        self.viewHeight.constant = CGRectGetMaxY(self.appointBtn.frame) + 10;
    }
}

/**
 * 预约按钮点击事件
 */
- (IBAction)appointClick:(id)sender {
    
    if (![self.numberTxt.text isPureInt] || [self.numberTxt.text integerValue] < 1) {
        
        [SVProgressHUD showErrorWithStatus:@"数量请输入大于等于1的整数" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.detailModel != nil) {//预约
        
        NSDictionary *params = @{@"productID":self.detailModel.id,
                                 @"buySpecID":self.detailModel.buySpecInfo.id,
                                 @"reserveNum":self.numberTxt.text,
                                 @"token":[[CommUtils sharedInstance] fetchToken]};
        __weak typeof (self)weakSelf = self;
        [self.service appointGoods:params completion:^{
           
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end

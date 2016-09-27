//
//  AddReceiverViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddReceiverViewController.h"
#import "AddReceiverTableCell.h"
#import "Animate.h"
#import "SelectAddressView.h"
#import "MineService.h"
#import "AddressModel.h"
#import "ReceiverAddressModel.h"


typedef NS_ENUM(NSInteger ,OperatorType){
    
    AddAddress, //新增地址
    UpdateAddress //修改地址
};

@interface AddReceiverViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)NSArray *titleArr;
/** <##> */
@property (nonatomic, weak)UITableView *table;
/** 遮罩view */
@property(nonatomic,strong)UIView *maskView;
/** <##> */
@property(nonatomic,strong)UIView *addressView;
/** <##> */
@property(nonatomic,strong)MineService *service;
/** 选择的省市区模型数组 */
@property(nonatomic,strong)NSMutableArray *addressArr;
/** 操作类型 */
@property(assign,nonatomic)OperatorType opetatorType;

@end

@implementation AddReceiverViewController

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

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

- (UIView *)addressView {
    
    if (_addressView == nil) {
        
        _addressView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH + 64, ScreenW, ScreenH * 2 / 3)];
        _addressView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLbl = [[UILabel alloc]init];
        titleLbl.text = @"所在地区";
        titleLbl.textColor = CustomColor(193, 193, 193);
        [titleLbl sizeToFit];
        titleLbl.frame = CGRectMake(0, 15, titleLbl.width, titleLbl.height);
        titleLbl.centerX = self.view.width / 2;
        titleLbl.font = [UIFont systemFontOfSize:14];
        [_addressView addSubview:titleLbl];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.frame = CGRectMake(self.view.width - 10 - 19, 10, 19, 19);
        closeBtn.centerY = titleLbl.centerY;
        [_addressView addSubview:closeBtn];
        
        CGFloat selectAddressViewY = CGRectGetMaxY(titleLbl.frame) + 12;
        SelectAddressView *selectAddressView = [[SelectAddressView alloc]initWithFrame:CGRectMake(0, selectAddressViewY, ScreenW, _addressView.height - selectAddressViewY)];
        __weak typeof (self)weakSelf = self;
        selectAddressView.selectAddressViewBlock = ^(NSMutableArray *addressArr){
        
        
            AddReceiverTableCell *cell3 = (AddReceiverTableCell *)[self.table viewWithTag:102];
            UITextField *areaTxt = cell3.contentTxt;
            AddressModel *privinceModel = addressArr[0];
            AddressModel *cityModel = addressArr[1];
            AddressModel *districtModel = addressArr[2];
            areaTxt.text = [NSString stringWithFormat:@"%@%@%@",privinceModel.name,cityModel.name,districtModel.name];
            weakSelf.addressArr = addressArr;
            [weakSelf dismiss];
        };
        [_addressView addSubview:selectAddressView];

        
    }
    return _addressView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.addressArr = [NSMutableArray array];
    self.navigationItem.title = @"新建收货人";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleArr = @[@"收货人：",@"联系方式：",@"所在地区：",@"详细地址："];
    [self initView];
}

- (void)initView {

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(0, ScreenH - 30 - 15, 150, 35);
    saveBtn.centerX = self.view.centerX;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    saveBtn.backgroundColor = [UIColor redColor];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - CGRectGetMinX(saveBtn.frame) - 15 - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 40;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AddReceiverTableCell *cell = [AddReceiverTableCell cellWithTableView:tableView];
    cell.titleLbl.text = self.titleArr[indexPath.row];
    if (indexPath.row == 2) {
        
        cell.arrowImg.hidden = NO;
        cell.contentTxt.userInteractionEnabled = NO;
        cell.contentTxt.text = self.model == nil ? @"" : self.model.pcadetail;
        
    }else if (indexPath.row == 3) {//地址
        
        cell.contentTxt.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"街道、楼牌号等" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        cell.contentTxt.text = self.model == nil ? @"" : self.model.address;
        
    }else if (indexPath.row == 1) {//联系方式
        
        cell.contentTxt.keyboardType = UIKeyboardTypePhonePad;
        cell.contentTxt.text = self.model == nil ? @"" : self.model.mobile;
        
    }else if (indexPath.row == 0) {//收货人呢

        cell.contentTxt.text = self.model == nil ? @"" : self.model.name;
    }
   
    cell.tag = indexPath.row + 100;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2) {
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.addressView];
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.layer.transform = [Animate firstStepTransform];
            self.maskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.view.layer.transform = [Animate secondStepTransform];
                self.addressView.transform = CGAffineTransformTranslate(self.addressView.transform, 0, -ScreenH * 3 / 4.0f);
            }];
        }];
        
    }
}

- (void)closeClick {

    [self dismiss];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.layer.transform = [Animate firstStepTransform];
        self.addressView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.layer.transform = CATransform3DIdentity;
            self.maskView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self.maskView removeFromSuperview];
            [self.addressView removeFromSuperview];
            self.addressView = nil;
        }];
    }];
    
}

- (void)saveClick {

    AddReceiverTableCell *cell1 = (AddReceiverTableCell *)[self.table viewWithTag:100];
    UITextField *receiverTxt = cell1.contentTxt;
    
    AddReceiverTableCell *cell2 = (AddReceiverTableCell *)[self.table viewWithTag:101];
    UITextField *phoneTxt = cell2.contentTxt;
    
    AddReceiverTableCell *cell3 = (AddReceiverTableCell *)[self.table viewWithTag:102];
    UITextField *areaTxt = cell3.contentTxt;
    
    AddReceiverTableCell *cell4 = (AddReceiverTableCell *)[self.table viewWithTag:103];
    UITextField *addressTxt = cell4.contentTxt;
    
    if (receiverTxt.text.length == 0 || phoneTxt.text.length == 0 || areaTxt.text.length == 0 || addressTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写完所有信息!" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }
    if (![[CommUtils sharedInstance] checkPhoneNum:phoneTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确！" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }else {
        
        NSDictionary *params = nil;
        if (self.opetatorType == AddAddress) {
            
            AddressModel *privinceModel = self.addressArr[0];
            AddressModel *cityModel = self.addressArr[1];
            AddressModel *districtModel = self.addressArr[2];
            params = @{@"province":privinceModel.code,
                       @"city":cityModel.code,
                       @"area":districtModel.code,
                       @"name":receiverTxt.text,
                       @"address":addressTxt.text,
                       @"mobile":phoneTxt.text,
                       @"token":[[CommUtils sharedInstance]fetchToken]};
            
        }else {
        
            if (self.addressArr.count != 0) {
                
                AddressModel *privinceModel = self.addressArr[0];
                AddressModel *cityModel = self.addressArr[1];
                AddressModel *districtModel = self.addressArr[2];
                
                params = @{@"province":privinceModel.code,
                           @"city":cityModel.code,
                           @"area":districtModel.code,
                           @"name":receiverTxt.text,
                           @"address":addressTxt.text,
                           @"mobile":phoneTxt.text,
                           @"token":[[CommUtils sharedInstance]fetchToken],
                           @"id":self.model.id};
            }else {
            
                params = @{@"province":self.model.province,
                           @"city":self.model.city,
                           @"area":self.model.area,
                           @"name":receiverTxt.text,
                           @"address":addressTxt.text,
                           @"mobile":phoneTxt.text,
                           @"token":[[CommUtils sharedInstance]fetchToken],
                           @"id":self.model.id};
            }
            
        }
        __weak typeof (self)weakSelf = self;
        [self.service saveAddress:params completion:^{
            
            if (weakSelf.opetatorType == AddAddress) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加成功！" maskType:SVProgressHUDMaskTypeBlack];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAddressSuccess" object:nil];
                
                
            }else {
            
                [SVProgressHUD showSuccessWithStatus:@"修改成功！" maskType:SVProgressHUDMaskTypeBlack];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }];
    }
}

- (void)setModel:(ReceiverAddressModel *)model {

    _model = model;
    self.opetatorType = UpdateAddress;
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

//
//  LoginViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/1/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginAndRegisterService.h"
#import "UserInfoModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *fogetPasswordBtn;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
/** 网络请求对象 */
@property(nonatomic,strong)LoginAndRegisterService *service;

@end

@implementation LoginViewController

#pragma mark --- LazyLoad ---
- (LoginAndRegisterService *)service {
    
    if (_service == nil) {
        
        _service = [[LoginAndRegisterService alloc]init];
    }
    
    return _service;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLogin) name:@"registerSuccess" object:nil];
    self.title = @"登录";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIImage *accountImg = [UIImage imageNamed:@"account_icon"];
    CGFloat accountIconW = accountImg.size.width;
    CGFloat accountIconH = accountImg.size.height;
    UIImageView *accountIcon = [[UIImageView alloc]init];
    accountIcon.image = accountImg;
    accountIcon.frame = CGRectMake(CGRectGetMinX(self.accountTxt.frame) - accountIconW - 10, CGRectGetMaxY(self.line1.frame) - accountIconH - 10, accountIconW, accountIconH);
    [self.view addSubview:accountIcon];
    
    UIImage *passwordImg = [UIImage imageNamed:@"password_icon"];
    CGFloat passwordIconW = passwordImg.size.width;
    CGFloat passwordIconH = passwordImg.size.height;
    UIImageView *passwordIcon = [[UIImageView alloc]init];
    passwordIcon.image = passwordImg;
    passwordIcon.frame = CGRectMake(CGRectGetMinX(self.passwordTxt.frame) - passwordIconW - 8, CGRectGetMaxY(self.line2.frame) - passwordIconH - 10, passwordIconW, passwordIconH);
    [self.view addSubview:passwordIcon];
    
    self.loginBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.loginBtn.layer.borderWidth = 0.5;
    
    self.line1.backgroundColor = CustomColor(235, 235, 235);
    self.line2.backgroundColor = CustomColor(235, 235, 235);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"login_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    UserInfoModel *model = [[CommUtils sharedInstance] fetchUserInfo];
    if (model.account.length > 0) {
        
        self.accountTxt.text = model.account;
    }
    
}

#pragma mark --- UIButtonClick ---
/**
 * 登录
 */
- (IBAction)loginClick:(id)sender {
    
    if (self.accountTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入用户名" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }else if (self.passwordTxt.text.length == 0) {
    
        [SVProgressHUD showErrorWithStatus:@"请输入密码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    __weak typeof (self)weakSelf = self;
    [SVProgressHUD show];
    [self.service login:self.accountTxt.text password:self.passwordTxt.text completion:^(){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
        [SVProgressHUD dismiss];
        [weakSelf backClick];
        
    }];
}

/**
 * 忘记密码
 */
- (IBAction)fogetPwdClick:(id)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/**
 * 返回
 */
- (void)backClick {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)autoLogin {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
    [self backClick];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end

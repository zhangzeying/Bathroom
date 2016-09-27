//
//  RegisterViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginAndRegisterService.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTxt;
@property (weak, nonatomic) IBOutlet UITextField *verifyTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
/** 网络请求对象 */
@property(nonatomic,strong)LoginAndRegisterService *service;
@end

@implementation RegisterViewController

#pragma mark --- LazyLoad ---
- (LoginAndRegisterService *)service {
    
    if (_service == nil) {
        
        _service = [[LoginAndRegisterService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"login_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.title = @"注册";
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
    passwordIcon.frame = CGRectMake(CGRectGetMinX(self.accountTxt.frame) - passwordIconW - 8, CGRectGetMaxY(self.line2.frame) - passwordIconH - 10, passwordIconW, passwordIconH);
    [self.view addSubview:passwordIcon];
    
    self.line1.backgroundColor = CustomColor(235, 235, 235);
    self.line2.backgroundColor = CustomColor(235, 235, 235);
    self.line3.backgroundColor = CustomColor(235, 235, 235);
    self.registerBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.registerBtn.layer.borderWidth = 0.5;
    self.registerBtn.layer.cornerRadius = 5;
    self.verifyBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.verifyBtn.layer.borderWidth = 0.5;
    self.verifyBtn.layer.cornerRadius = 5;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)backClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 获取验证码
 */
- (IBAction)getVerifyClick:(id)sender {
    
    if (self.accountTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (![[CommUtils sharedInstance] checkPhoneNum:self.accountTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    
    __weak typeof (self)weakSelf = self;
    [self.service getVerifyCode:self.accountTxt.text completion:^{
        
        [weakSelf startTime];
    }];
}

/**
 * 注册
 */
- (IBAction)registerClick:(id)sender {
    
    if (self.accountTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }else if (self.passwordTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入密码" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }else if (self.verifyTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" maskType:SVProgressHUDMaskTypeBlack];
        return;
        
    }else if (![[CommUtils sharedInstance] checkPhoneNum:self.accountTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    __weak typeof (self)weakSelf = self;
    [self.service registerUser:self.accountTxt.text password:self.passwordTxt.text vcode:self.verifyTxt.text completion:^{
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerSuccess" object:nil];
        [weakSelf backClick];
        
    }];
}

/**
 * 简单来说，dispatch source是一个监视某些类型事件的对象。当这些事件发生时，它自动将一个block放入一个dispatch queue的执行例程中
 */
- (void)startTime {
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.verifyBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.verifyBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

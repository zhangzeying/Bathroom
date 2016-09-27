


//
//  AboutViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/26/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AboutViewController.h"
#import "MineService.h"
@interface AboutViewController ()
/** <##> */
@property(nonatomic,strong)MineService *service;
@end

@implementation AboutViewController

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    UILabel *introduceLbl = [[UILabel alloc]init];
    introduceLbl.numberOfLines = 0;
    introduceLbl.textColor = [UIColor darkGrayColor];
    introduceLbl.frame = CGRectMake(20, 0, ScreenW - 40, ScreenH);
    [self.view addSubview:introduceLbl];
    __block UILabel *contentLbl = introduceLbl;
    [self.service getAboutContent:^(NSString *content) {
        
         contentLbl.text = @"随便购网是整合线下厂家(批发商)对接零售商的新型专业建材行业的app平台，随着经济的发展，建材行业持续进入爆发期，真正的价格优势不是面对终端消费者，反而是无数个经销商，信息的不对称性，传播的速度缓慢，大建材行业的网络松散型等等导致零售商没有迅速了解自己行业的产品将会发生什么，价格如何，所谓的新款产品是否真正的足够新，包括大建材范畴内别的行业客户如何连带自己的资源等等问题，随便购就可以解决这些难点，因为我们构建的是厂家(批发商)和经销商对接的资源，加入随便购，随随便便购购购。";
    }];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

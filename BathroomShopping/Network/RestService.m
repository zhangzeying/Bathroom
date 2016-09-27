//
//  RestService.m
//  HeXin
//
//  Created by zzy on 9/30/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import "RestService.h"

@implementation RestService
+ (id)sharedService {

    static RestService *_sharedService = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedService = [[self alloc] init];
    });
    
    return _sharedService;
}

- (NSString *)getUrl: (NSString *)resource {

    return [NSString stringWithFormat:@"%@%@", baseurl, resource];
    
}


//get请求
- (void)afnetworkingGet:(NSString *)str :(completionHandler)completion{

    
    NSString *url = [self getUrl:str];
    NSLog(@"%@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
//    [manager.requestSerializer setValue:[[CommUtils sharedInstance] fetchToken] forHTTPHeaderField:@"cookie"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSLog(@"%@",responseObject);
         completion(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         NSLog(@"失败");
         completion(error,NO);
         return;
    }];
    
}

//post请求
- (void)afnetworkingPost:(NSString *)str parameters: (NSDictionary *)parameters completion:(completionHandler)completion{
    
    NSString *url = [self getUrl:str];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
    
    [manager.requestSerializer setValue:[[CommUtils sharedInstance] fetchToken] forHTTPHeaderField:@"cookie"];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        switch (error.code) {
            case -1004:
                [SVProgressHUD showErrorWithStatus:@"服务器异常" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case -1001:
                [SVProgressHUD showErrorWithStatus:@"网络请求超时" maskType:SVProgressHUDMaskTypeBlack];
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"网络连接发生错误" maskType:SVProgressHUDMaskTypeBlack];
                break;
        }
        BSLog(@"%@",error);
        completion(error,NO);
        return;
    }];
}

- (void)checkNetWorkState {

    //创建网络监听管理者对象
    //开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
                BSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                BSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                BSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                BSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
}




@end

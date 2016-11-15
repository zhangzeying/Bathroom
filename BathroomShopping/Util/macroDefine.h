//
//  macroDefine.h
//  BathroomShopping
//
//  Created by zzy on 7/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#ifdef BSDEBUG
//打印日志
#define BSLog(format, ...) NSLog(format,##__VA_ARGS__)

#else

#define BSLog(format, ...)

#endif

/**
 * 处于开发阶段
 */
#ifdef BSDEBUG

#define baseurl @"http://139.224.227.184:8080/jeeshop"
//获取轮播图
#define kAPIPageScrollList @"/app/api/indexImg/query"
//获取首页滚动新闻
#define kAPINewsList @"/app/api/news/list"
//获取活动商品
#define kAPIActivityGoods @"/app/api/activity/index"
//获取首页热门商品
#define kAPIHomeHotGoods @"/app/api/product/getHotProductsByCatalogCode/all"
//获取卫浴的热门商品
#define kAPIBathroomHotGoods @"/app/api/product/getHotProductsByCatalogCode/weiyu"
//热门搜索
#define kAPIHotSearch @"/app/api/activity/hotProductList"
//获取推荐商品
#define kAPIRecommendGoods(code) [NSString stringWithFormat:@"%@/%@",@"/app/api/product/getHotProductsByCatalogCode",code]
//获取一元抢购商品列表
#define kAPIOneSaleList @"/app/api/activity/oneYuanProductList"
//登录
#define kAPILogin @"/app/api/account/doLogin"
//注册
#define kAPIRegister @"/app/api/account/doRegister"
//商品分类
#define kAPIGoodsCategory @"/app/api/catalog/getAllCatalogs"
//根据类别code获取商品
#define kAPIGetProductsByCode(code) [NSString stringWithFormat:@"%@/%@",@"/app/api/product/getProductsByCatalogCode",code]
//获取商品详情
#define kAPIGoodsDetailInfo(goodsId) [NSString stringWithFormat:@"%@/%@",@"/app/api/product",goodsId]
//获取购物车清单
#define kAPICartList @"/app/api/cart/cart"
//添加商品到购物车
#define kAPIAddCart @"/app/api/cart/addToCart"
//添加套餐到购物车
#define kAPIAddCartForPackage @"/app/api/cart/addPgToCart"
//上传未登录的购物车
#define kAPIUploadCart @"/app/api/cart/addToCartForLogin"
//删除购物车商品
#define kAPIDeleteCart @"/app/api/cart/delete"
//删除购物车套餐
#define kAPIDeletePackageCart @"/app/api/cart/delPgToCart"
//更新购物车数量
#define kAPIUpdateCartCount @"/app/api/cart/updateCount"
//更新购物车套餐数量
#define kAPIUpdatePackageCartCount @"/app/api/cart/updatePgCartCount"
//收藏商品
#define kAPILikedGoods @"/app/api/product/addToFavorite"
//取消收藏商品
#define kAPIUnlikedGoods @"/app/api/product/cancelFavorite"
//获取我的收藏
#define kAPIGetLikedGoodsList @"/app/api/account/favorite"
//中奖名单
#define kAPILotteryUser @"/app/api/oneYuanBuy/selectWinningList"
//一元抢购抽奖
#define kAPIOneSaleLottery @"/app/api/oneYuanBuy/placeOrder"
//关键词搜索
#define kAPIKeywordSearch @"/app/api/product/search"
//获取省份
#define kAPIProvince @"/app/api/account/province"
//根据省份code获取城市
#define kAPICity @"/app/api/account/selectCitysByProvinceCode"
//根据省份code+城市code获取区（县）信息
#define kAPIDistrict @"/app/api/account/selectAreaListByCityCode"
//预约商品
#define kAPIAppointGoods @"/reserve/insertReserve"
//查询预约
#define kAPIGetAppoint  @"/reserve/getRserveInfo"
//取消预约
#define kAPICancelAppoint @"/reserve/updateRserve"
//上传头像
#define kAPIUploadAvator @"http://123.56.186.181:8080/jeeshop/app/api/account/headPortrait"
//修改个人资料
#define kAPIUpdateUserInfo @"/app/api/account/updateBaseInfo"
//修改密码
#define kAPIUpdatePwd @"/app/api/account/resetPwd"
//保存收货地址
#define kAPISaveAddress @"/app/api/account/saveAddress"
//获取我的地址列表
#define kAPIAddressList @"/app/api/account/address"
//删除地址
#define kAPIDeleteAddress @"/app/api/account/deleteAddress"
//获取套餐列表
#define kAPIPackageList @"/app/api/package/selectList"
//获取套餐详情
#define kAPIPackageDetail @"/app/api/package/detail"
//下订单
#define kAPIOrder @"/app/api/order/pay"
//获取配送方式
#define kAPIDelivery @"/app/api/cart/express"
//生成微信订单
#define kAPIWXPay @"/app/api/order/wxprepay"
//生成支付宝订单
#define kAPIAlipay @"/app/api/order/pay"
//获取验证码
#define kAPIGetVerifyCode @"/app/api/sms/send"
//获取订单（type：all:个人全部订单 nopay:未付款 payed:已付款（未发货） send:已发货（未签收）sign:已签收（已完成））
#define kAPIGetOrder(type) [NSString stringWithFormat:@"%@/%@",@"/app/api/account/orders",type]
//获取限时抢购的时间节点
#define kAPILimitTime @"/app/api/activity/getLimitTimeBuyPeriod"
//根据时间节点获取限时抢购商品
#define kAPILimitTimeBuyProduct @"/app/api/activity/getLimitTimeBuyProductList"
//获取用户权限
#define kAPIGetUserRoot @"/app/api/account/isShow"
//生成一元抢购抽奖订单q
#define kAPIPayOneYuan @"/app/api/order/payOneYuan"
//获取特惠商城分类
#define kAPIPerferenceActivity @"/app/api/activity/perferenceActivity"
//获取特惠商城分类对应的商品
#define kAPIPerferenceProductList @"/app/api/activity/perferenceProductList"
//获取关于我们的内容
#define kAPIGetAboutContent @"/app/api/account/aboutOurs"
//取消订单
#define kAPICancelOrder @"/app/api/order/cancle"
/**
 * 处于发布阶段
 */
#else

#define baseurl @""
//获取轮播图
#define kAPIPageScrollList @""
//获取首页滚动新闻
#define kAPINewsList @""
//获取活动商品
#define kAPIActivityGoods @""
//获取购物车清单
#define kAPICartList @""
//登录
#define kAPILogin @""
//注册
#define kAPIRegister @""
//商品分类
#define kAPIGoodsCategory @""
//获取首页热门商品
#define kAPIHomeHotGoods @""
//获取卫浴的热门商品
#define kAPIBathroomHotGoods @""
#endif /* macroDefine_h */

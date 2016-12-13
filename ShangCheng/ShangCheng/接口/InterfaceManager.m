//
//  InterfaceManager.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/31.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "InterfaceManager.h"

@interface InterfaceManager ()
@property (nonatomic,strong)NSString *mainUrl;
@property (nonatomic,strong)NSString *baseUrl;


@end

@implementation InterfaceManager
+ (InterfaceManager *)shareInstance {
    static InterfaceManager *interfaceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceManager = [[InterfaceManager alloc] init];
    });
    return interfaceManager;

}

- (NSString *)mainUrl {
    //托管服务器
//    return @"http://api.nzw0.com:8001/";
    //本地
    return @"http://192.168.0.233:5260/";
}

- (NSString *)baseUrl {
    return [NSString stringWithFormat:@"%@api",self.mainUrl];
}

#pragma mark - 产品 -


//首页产品
- (NSString *)homeProductURLWithCnum:(NSString *)cnum withRnum:(NSString *)rnum {
    return [NSString stringWithFormat:@"%@/ProductHomePage?cnum=%@&rnum=%@",self.baseUrl,cnum,rnum];
}

//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/Product?id=%@",self.baseUrl,productID];
    
}

//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/ProductStandard?id=%@",self.baseUrl,productID];
}


#pragma mark - 购物车 -
- (NSString *)shoppingCarBaseURL {
    return [NSString stringWithFormat:@"%@/ShoppingCart",self.baseUrl];
}

- (NSString *)shoppingAdd:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@",self.baseUrl,productID];
}
//获得购物车的产品
- (NSString *)getShoppingCarProductUrlWithUserId:(NSString *)userId {
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@",self.baseUrl,userId];
}

//删除购物车中的某些产品
- (NSString *)deleteShoppingCarProductUrlWithShoppingCarID:(NSString *)shoppingCarID withSecret:(NSString *)secret {
//    return [NSString stringWithFormat:@"%@/ShoppingCart",self.baseUrl];
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@&m=%@",self.baseUrl,shoppingCarID,secret];
}

//预订单
- (NSString *)orderPreviewUrl {
    return [NSString stringWithFormat:@"%@/OrderPreview",self.baseUrl];
}

#pragma mark - 订单 -
//优惠券
- (NSString *)getCouponListWithUserId:(NSString *)userID {
    return [NSString stringWithFormat:@"%@/coupon?id=%@",self.baseUrl,userID];
}

//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST {
    return [NSString stringWithFormat:@"%@/couponcalc",self.baseUrl];
}


//订单列表 -1全部、0,1B,1A待付款、1,进行中、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize {

    return [NSString stringWithFormat:@"%@/OrderGenerated?id=%@&product=%@&code=%@&status=%@&pageindex=%@&pagesize=%@",self.baseUrl,userID,product,code,orderStatus,pageIndex,pageSize];
}

//生成订单
- (NSString *)creatOrderPOSTUrl {
    return [NSString stringWithFormat:@"%@/OrderGenerated",self.baseUrl];
}

#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTUrl {
    return [NSString stringWithFormat:@"%@/userlogin",self.baseUrl];
}

//获取验证码
- (NSString *)mobileCodePOST {
    return [NSString stringWithFormat:@"%@/Verification",self.baseUrl];
}

//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code {
    return [NSString stringWithFormat:@"%@/Verification?tel=%@&code=%@",self.baseUrl,mobileNumber,code];
}
//注册接口
- (NSString *)registerPOSTUrl {
    return [NSString stringWithFormat:@"%@/User",self.baseUrl];
}


@end

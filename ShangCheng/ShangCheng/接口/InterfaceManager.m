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
    return @"http://api.nzw0.com:8001/";
    //本地
//    return @"http://192.168.0.233:5260/";

}

- (NSString *)baseUrl {
    return [NSString stringWithFormat:@"%@api",self.mainUrl];
}

#pragma mark - 首页 -
//今日特价
- (NSString *)todayActivityBase {
    return [NSString stringWithFormat:@"%@/TodayActivity",self.baseUrl];
    
}


#pragma mark - 产品 -
//首页产品
- (NSString *)homeProductURLWithCnum:(NSString *)cnum withRnum:(NSString *)rnum {
    return [NSString stringWithFormat:@"%@/ProductHomePage?cnum=%@&rnum=%@",self.baseUrl,cnum,rnum];
}

//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID withIsst:(NSString *)isst {
    return [NSString stringWithFormat:@"%@/Product?id=%@&isst=%@&isfo=1",self.baseUrl,productID,isst];
    
}

//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/ProductStandard?id=%@",self.baseUrl,productID];
}

//产品分类树
- (NSString *)productClassTree {
    return [NSString stringWithFormat:@"%@/ProductCategory?col=p_type",self.baseUrl];
}

//模糊查询产品信息
- (NSString *)fuzzySearchProductInfoWithCode:(NSString *)code withName:(NSString *)name withAreaid:(NSString *)areaId withPd:(NSString *)pd withSuppliername:(NSString *)suppliername withLevel:(NSString *)level withStatus:(NSString *)status withPrice:(NSString *)price withDate:(NSString *)date withPageindex:(NSInteger )pageIndex withPageSize:(NSString *)pageSize {
    return [NSString stringWithFormat:@"%@/Product?code=%@&name=%@&areaid=%@&pd=%@&suppliername=%@&level=%@&status=%@&price=%@&date=%@&pageindex=%ld&pagesize=%@",self.baseUrl,code,name,areaId,pd,suppliername,level,status,price,date,pageIndex,pageSize];
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
//优惠券Base
- (NSString *)couponBase {
    return  [NSString stringWithFormat:@"%@/coupon",self.baseUrl];
}
//优惠券
- (NSString *)getCouponListWithUserId:(NSString *)userID {
    return [NSString stringWithFormat:@"%@/coupon?id=%@",self.baseUrl,userID];
}

//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST {
    return [NSString stringWithFormat:@"%@/couponcalc",self.baseUrl];
}


//订单列表 -1全部、0,1B,1A待付款、1,进行中、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize {

    return [NSString stringWithFormat:@"%@/OrderGenerated?id=%@&product=%@&code=%@&status=%@&pageindex=%ld&pagesize=%ld",self.baseUrl,userID,product,code,orderStatus,pageIndex,pageSize];
}

//生成订单
- (NSString *)creatOrderPOSTUrl {
    return [NSString stringWithFormat:@"%@/OrderGenerated",self.baseUrl];
}

//取消订单
- (NSString *)cancelOrderWithOrderID:(NSString *)orderId {
    return [NSString stringWithFormat:@"%@/CancelOrder?id=%@",self.baseUrl,orderId];
}
//取消子订单
- (NSString *)cancelSonOrderPOST {
    return [NSString stringWithFormat:@"%@/CancelOrder",self.baseUrl];
}

//物流信息
- (NSString *)logisticsWithOrderId:(NSString *)orderId withType:(NSString *)type {
    return [NSString stringWithFormat:@"%@/OrderTracking?id=%@&type=%@",self.baseUrl,orderId,type];
}


#pragma mark - 支付 -
//支付前验证
- (NSString *)paybeforeVerifyPOST {
    return [NSString stringWithFormat:@"%@/OrderPaymentVerify",self.baseUrl];
}
//支付宝获取签名
- (NSString *)AliPaySignPOST {
    return [NSString stringWithFormat:@"%@/Alipay",self.baseUrl];
}

//用户确认支付
- (NSString *)userConfirmPayPOST {
    return [NSString stringWithFormat:@"%@/UserConfirmPay",self.baseUrl];
}

//支付后，后台验证 
- (NSString *)orderPaymentVerifyWithPayid:(NSString *)payId {
    return [NSString stringWithFormat:@"%@/OrderPaymentVerify?pid=%@",self.baseUrl,payId];
}

#pragma mark - 个人中心  充值 -
- (NSString *)userRechargeBase {
    return [NSString stringWithFormat:@"%@/UserRecharge",self.baseUrl];
}
#pragma mark - 个人中心 意见反馈 -
- (NSString *)userFeedBackBase {
    return [NSString stringWithFormat:@"%@/GuestBook",self.baseUrl];
}


#pragma mark - 个人信息 -
//查询个人余额
- (NSString *)searchUserAmountWithUserID:(NSString *)userID {
    return [NSString stringWithFormat:@"%@/UserAmount?id=%@",self.baseUrl,userID];
}

//收货地址列表
- (NSString *)receiveAddressWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId {
    return [NSString stringWithFormat:@"%@/Receive?id=%@",self.baseUrl,userIdOrReceiveId];
}

//收货地址
- (NSString *)receiveAddressBase {
    return [NSString stringWithFormat:@"%@/Receive",self.baseUrl];

}

//评论
- (NSString *)userOrderReviewBase {
    return [NSString stringWithFormat:@"%@/UserOrderReview",self.baseUrl];
}


//收藏base
- (NSString *)favoriteBase {
    return [NSString stringWithFormat:@"%@/Favorite",self.baseUrl];
}
//获取收藏列表
- (NSString *)myFavoriteListWithUserId:(NSString *)userid {
    return [NSString stringWithFormat:@"%@?id=%@",[self favoriteBase],userid];
}

//流水账查询
- (NSString *)userAccountBase {
    return [NSString stringWithFormat:@"%@/UserAccount",self.baseUrl];
}

//提现和提现记录
- (NSString *)AgentCashBase {
    return [NSString stringWithFormat:@"%@/AgentCash",self.baseUrl];
}


//修改密码
- (NSString *)motifyPasswordBase {
    return [NSString stringWithFormat:@"%@/UserModifyPWD",self.baseUrl];
}

//个人中心 我的钱包数据
- (NSString *)userDataBase {
    return [NSString stringWithFormat:@"%@/userdata",self.baseUrl];
}
#pragma mark - 我的代理 -
//基本代理数据
- (NSString *)myAgentDataBase {
    return [NSString stringWithFormat:@"%@/AgentData",self.baseUrl];
}

//人员列表数据
- (NSString *)myAgentPeopleListBase {
    return [NSString stringWithFormat:@"%@/AgentUser",self.baseUrl];
}
//订单列表数据
- (NSString *)myAgentOrderListBase {
    return [NSString stringWithFormat:@"%@/AgentOrder",self.baseUrl];

}


#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTAndPUTUrl {
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
//用户Base接口
- (NSString *)userBase {
    return [NSString stringWithFormat:@"%@/User",self.baseUrl];
}
//代理商注册
- (NSString *)AgentMerchantsBase {
    return [NSString stringWithFormat:@"%@/AgentMerchants",self.baseUrl];
}


#pragma mark - 其他 -
//地区信息
- (NSString *)getAreaTree {
    return [NSString stringWithFormat:@"%@/area?tree=",self.baseUrl];
}


@end

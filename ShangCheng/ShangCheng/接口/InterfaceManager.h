//
//  InterfaceManager.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/31.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceManager : NSObject

+ (InterfaceManager *)shareInstance;

#pragma mark - 产品 -
- (NSString *)productBaseURL;
//首页产品 cnum是热销产品的个数，rnum是推荐产品的个数
- (NSString *)homeProductURLWithCnum:(NSString *)cnum withRnum:(NSString *)rnum;
//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID;
//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID;
#pragma mark - 购物车 -
//购物车基本url
- (NSString *)shoppingCarBaseURL;
//增加或减少
- (NSString *)shoppingAdd:(NSString *)productID;

//获得购物车的产品
- (NSString *)getShoppingCarProductUrlWithUserId:(NSString *)userId;
//删除购物车中的某些产品
- (NSString *)deleteShoppingCarProductUrlWithShoppingCarID:(NSString *)shoppingCarID withSecret:(NSString *)secret;
- (NSString *)orderPreviewUrl;
#pragma mark - 订单 -
//优惠卷
- (NSString *)getCouponListWithUserId:(NSString *)userID;
//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST;

//订单列表 -1全部、0,1B,1A待付款、1,进行中、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize;
//生成订单
- (NSString *)creatOrderPOSTUrl;
//取消订单
- (NSString *)cancelOrderWithOrderID:(NSString *)orderId;

#pragma mark - 支付 -
//支付前验证
- (NSString *)paybeforeVerifyPOST;

//支付宝获取签名
- (NSString *)AliPaySignPOST ;

#pragma mark - 个人信息 -
//查询个人余额
- (NSString *)searchUserAmountWithUserID:(NSString *)userID;
//收货地址列表
- (NSString *)receiveAddressWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId;
//收货地址
- (NSString *)receiveAddressBase;

#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTAndPUTUrl ;
//获取验证码
- (NSString *)mobileCodePOST ;
//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code;
//注册接口
- (NSString *)registerPOSTUrl;
#pragma mark - 其他 -
//地区信息
- (NSString *)getAreaTree;



@end

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

#pragma mark - 首页 -
//今日特价
- (NSString *)todayActivityBase ;



#pragma mark - 产品 -
//- (NSString *)productBaseURL;
//首页产品 cnum是热销产品的个数，rnum是推荐产品的个数
- (NSString *)homeProductURLWithCnum:(NSString *)cnum withRnum:(NSString *)rnum;
//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID withIsst:(NSString *)isst;
//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID;

//产品分类树
- (NSString *)productClassTree;

//模糊查询产品信息
- (NSString *)fuzzySearchProductInfoWithCode:(NSString *)code withName:(NSString *)name withAreaid:(NSString *)areaId withPd:(NSString *)pd withSuppliername:(NSString *)suppliername withLevel:(NSString *)level withStatus:(NSString *)status withPrice:(NSString *)price withDate:(NSString *)date withPageindex:(NSInteger )pageIndex withPageSize:(NSString *)pageSize ;

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
//优惠券Base
- (NSString *)couponBase;
//优惠卷
- (NSString *)getCouponListWithUserId:(NSString *)userID;
//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST;

//订单列表 -1全部、0,1B,1A待付款、1,进行中、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize;
//生成订单
- (NSString *)creatOrderPOSTUrl;
//取消父订单
- (NSString *)cancelOrderWithOrderID:(NSString *)orderId;
//取消子订单
- (NSString *)cancelSonOrderPOST;

//物流信息
- (NSString *)logisticsWithOrderId:(NSString *)orderId withType:(NSString *)type;

#pragma mark - 支付 -
//支付前验证
- (NSString *)paybeforeVerifyPOST;

//支付宝获取签名
- (NSString *)AliPaySignPOST ;

//用户确认支付
- (NSString *)userConfirmPayPOST;

//支付后，后台验证
- (NSString *)orderPaymentVerifyWithPayid:(NSString *)payId;

#pragma mark - 个人中心  充值 -
- (NSString *)userRechargeBase;

#pragma mark - 个人中心 意见反馈 -
- (NSString *)userFeedBackBase;



#pragma mark - 个人信息 -
//查询个人余额
- (NSString *)searchUserAmountWithUserID:(NSString *)userID;
//收货地址列表
- (NSString *)receiveAddressWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId;
//收货地址
- (NSString *)receiveAddressBase;

//评论
- (NSString *)userOrderReviewBase;

//收藏base
- (NSString *)favoriteBase;
//获取收藏列表
- (NSString *)myFavoriteListWithUserId:(NSString *)userid;

//流水账查询
- (NSString *)userAccountBase;
//提现和提现记录
- (NSString *)AgentCashBase;

//修改密码
- (NSString *)motifyPasswordBase;

//个人中心 我的钱包数据
- (NSString *)userDataBase;

#pragma mark - 我的代理 -
//基本代理数据
- (NSString *)myAgentDataBase;

//人员列表数据
- (NSString *)myAgentPeopleListBase;
//订单列表数据
- (NSString *)myAgentOrderListBase;

#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTAndPUTUrl ;
//获取验证码
- (NSString *)mobileCodePOST ;
//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code;
//用户Base接口
- (NSString *)userBase;

//代理商注册
- (NSString *)AgentMerchantsBase;



#pragma mark - 其他 -
//地区信息
- (NSString *)getAreaTree;



@end

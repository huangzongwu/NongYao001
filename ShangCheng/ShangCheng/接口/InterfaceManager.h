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

#pragma mark - 订单 -
//订单列表 -1全部、0,1B,1A待付款、1,进行中、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withOrderStatus:(NSString *)orderStatus withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize;


#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTUrl ;
//获取验证码
- (NSString *)mobileCodePOST ;
//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code;

//注册接口
- (NSString *)registerPOSTUrl;
@end

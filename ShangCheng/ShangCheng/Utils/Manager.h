//
//  Manager.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/27.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"
#import "InterfaceManager.h"
#import "MemberInfoModel.h"
#import "ShoppingCarModel.h"
#import "ProductDetailModel.h"
#import "ProductClassModel.h"
#import "ProductFormatModel.h"
#import "SupOrderModel.h"
#import "CouponModel.h"
#import "AlertManager.h"
#import "SonOrderModel.h"
typedef void(^SuccessResult)(id successResult);
typedef void(^FailResult)(NSString *failResultStr);

@interface Manager : NSObject
//个人用户
@property (nonatomic,strong)MemberInfoModel *memberInfoModel;

//首页数据源
@property (nonatomic,strong)NSMutableDictionary *homeDataSourceDic;

//购物车的商品数据源
@property (nonatomic,strong)NSMutableArray *shoppingCarDataSourceArr;
//购物车是否全选
@property (nonatomic,assign)BOOL isAllSelectForShoppingCar;

//订单列表的数据源 : 1-全部、2-待付款、3-进行中、4-已完成
@property (nonatomic,strong)NSMutableDictionary *orderListDataSourceDic;


+ (Manager *)shareInstance;

#pragma mark - 产品 -
//首页产品 cnum是热销产品的个数，rnum是推荐产品的个数
- (void)httpHomeProductWithCnum:(NSString *)cnum withRnum:(NSString *)rnum withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult;
//获取产品详情
- (void)httpProductDetailInfoWithProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessDetailResult:(SuccessResult)successDetailResult withFailDetailResult:(FailResult)failDetailResult;
//获取产品的所有规格
- (void)httpProductAllFarmatInfoWithProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessFarmatResult:(SuccessResult)successFarmatResult withFailFarmatResult:(FailResult)failFarmatResult;

#pragma mark - 购物车 -
//将产品加入购物车
- (void)httpProductToShoppingCarWithProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessToShoppingCarResult:(SuccessResult)successToShoppingCarResult withFailToShoppingCarResult:(FailResult)failToShoppingCarResult;

//判断是否全选
- (void)isAllSelectForShoppingCarAction ;

//得到购物车网络数据
- (void)httpShoppingCarDataWithUserId:(NSString *)userId WithSuccessResult:(SuccessResult)shoppingCarSuccessResult withFailResult:(FailResult)failResult ;

//删除购物车的内容
- (void)deleteShoppingCarWithProductIndexSet:(NSMutableIndexSet *)productIndexSet WithSuccessResult:(SuccessResult)deleteSuccessResult withFailResult:(FailResult)deleteFailResult ;

//更改购物车产品的数量。isAdd为YES是增加，isAdd为No是减少
- (void)addOrLessShoppingCarProductCountWithShoppingModel:(ShoppingCarModel *)shoppingModel withIsAddOrLess:(BOOL)isAdd withAddOrLessSuccessResult:(SuccessResult)addOrLessSuccessResult withaddOrLessFailResult:(FailResult)addOrLessFailResult;

//计算购物车选择的金额
- (float)selectProductTotalPrice;

//立即支付，进入预订单
- (void)httpOrderPreviewWithShoppingCarIDArr:(NSMutableArray *)shoppingCarIDArr withPreviewSuccessResult:(SuccessResult)previewSuccessResult withPreviewFailResult:(FailResult)previewFailResult;


#pragma mark - 订单 -
//优惠券列表
- (void)httpCouponListWithUserID:(NSString *)userID withCouponSuccessResult:(SuccessResult )couponSuccessResult withCouponFailResult:(FailResult)couponFailResult;

//计算优惠券的金额
- (void)httpComputeCouponMoneyWithUserID:(NSString *)userID withCouponID:(NSString *)couponID withShoppingCarIDArr:(NSArray *)shoppingCarIDArr withComputeMoneySuccessResult:(SuccessResult)computeMoneySuccessResult withComputeMoneyFailResult:(FailResult)computeMoneyFailResult;


//订单列表。 pageIndex页数,pageSize多少数据
- (void)getOrderListDataWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withWhichTableView:(NSString *)whichTableView withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize downPushRefresh:(BOOL)downPushRefresh withUpPushReload:(BOOL)upPushReload withOrderListSuccessResult:(SuccessResult)orderListSuccessResult withOrderListFailResult:(FailResult)orderListFailResult ;

//生成订单
- (void)creatOrderWithUserID:(NSString *)userID withReceivedID:(NSString *)receivedID withTotalAmount:(NSString *)totalAmount withDiscount:(NSString *)discount withCouponId:(NSString *)couponId withArr:(NSMutableArray *)itemArr withOrderSuccessResult:(SuccessResult)orderSuccessResult withOrderFailResult:(FailResult)orderFailResult;

//取消订单
- (void)cancelOrderWithUserID:(NSString *)userID wiOrderID:(NSString *)orderID withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult)cancelFailResult;
#pragma mark - 支付 -
//支付前验证
- (void)paybeforeVerifyWithUserId:(NSString *)userID withTotalAmount:(NSString *)totalAmount withBalance:(NSString *)balance withPayAmount:(NSString *)payAmount withOrderIdArr:(NSArray *)orderIdArr withVerifySuccessBlock:(SuccessResult )verifySuccessBlock withVerfityFailBlock:(FailResult)verfityFailBlock;
#pragma mark - 个人信息 -
//获取个人信息的余额
- (void)searchUserAmount:(NSString *)userId withAmountSuccessBlock:(SuccessResult )amountSuccessBlock withAmountFailBlock:(FailResult)amountFailBlcok;

#pragma mark - 登录注册 -
//登录
- (void)loginActionWithUserID:(NSString *)userID withPassword:(NSString *)password withLoginSuccessResult:(SuccessResult )loginSuccessResult withLoginFailResult:(FailResult)loginFailResult;
//MD5加密
- (NSString *)digest:(NSString *)sourceStr ;
//判断现在是否是登录状态
- (BOOL)isLoggedInStatus;
//读取本地的个人信息
- (BOOL)readMemberInfoModelFromLocation ;

//退出登录
- (void)logOffAction;
//获取手机验证码
- (void)httpMobileCodeWithMobileNumber:(NSString *)mobileNumber withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult;
//检验手机验证码
- (void)httpCheckMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult;
//注册功能
- (void)httpRegisterWithMobileNumber:(NSString *)mobileNumber withPassword:(NSString *)password withUserType:(NSString *)usertType withAreaId:(NSString *)areaId withRegisterSuccess:(SuccessResult )registerSuccessResult withRegisterFailResult:(FailResult)registerFailResult;



#pragma mark - 其他 -
//获取当前时间
- (NSString *)getNowTimeStr; 



@end

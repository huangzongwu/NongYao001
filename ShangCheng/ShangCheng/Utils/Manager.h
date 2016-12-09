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
#import "AlertManager.h"
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

#pragma mark - 订单 -
//订单列表。 pageIndex页数,pageSize多少数据
- (void)getOrderListDataWithUserID:(NSString *)userID withOrderStatus:(NSString *)orderStatus withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize downPushRefresh:(BOOL)downPushRefresh withUpPushReload:(BOOL)upPushReload withOrderListSuccessResult:(SuccessResult)orderListSuccessResult withOrderListFailResult:(FailResult)orderListFailResult;


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
@end

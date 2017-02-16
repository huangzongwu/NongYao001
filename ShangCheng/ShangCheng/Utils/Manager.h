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
#import "ReceiveAddressModel.h"
#import "ClassModel.h"
#import "FuzzySearchModel.h"
#import "MyCommentListModel.h"
#import "MyFavoriteListModel.h"
#import "MyTradeRecordModel.h"
#import "MyAgentPeopleModel.h"
#import "MyAgentOrderModel.h"
typedef void(^SuccessResult)(id successResult);
typedef void(^FailResult)(NSString *failResultStr);

@interface Manager : NSObject
//个人用户
@property (nonatomic,strong)MemberInfoModel *memberInfoModel;

//首页数据源
@property (nonatomic,strong)NSMutableDictionary *homeDataSourceDic;
//产品分类树
@property (nonatomic,strong)NSMutableArray *productClassTreeArr;

//购物车的商品数据源
@property (nonatomic,strong)NSMutableArray *shoppingCarDataSourceArr;
//购物车是否全选
@property (nonatomic,assign)BOOL isAllSelectForShoppingCar;

//订单列表的数据源 : 1-全部、2-待付款、3-进行中、4-已完成
@property (nonatomic,strong)NSMutableDictionary *orderListDataSourceDic;

//收货地址数组
@property (nonatomic,strong)NSMutableArray *receiveAddressArr;

//地区信息数组
@property (nonatomic,strong)NSArray *areaArr;

//我的评论列表
@property (nonatomic,strong)NSMutableArray *myCommentArr;

//我的收藏列表
@property (nonatomic,strong)NSMutableArray *myFavoriteArr;

//我的提现记录--时间key
@property (nonatomic,strong)NSMutableArray *cashDateKeyArr;
//我的体现记录--详情字典
@property (nonatomic,strong)NSMutableDictionary *cashDetailDic;
//我的交易记录--时间key
@property (nonatomic,strong)NSMutableArray *tradeDateKeyArr;
//我的交易记录--详情字典
@property (nonatomic,strong)NSMutableDictionary *tradeDetailDic;

//我的代理数据 1收益 2订单 3代理商人数 4订单详情 5代理商详情
@property (nonatomic,strong)NSMutableDictionary *myAgentDic;

//个人中心 我的钱包数据
@property (nonatomic,strong)NSMutableDictionary *myWalletDic;

+ (Manager *)shareInstance;

#pragma mark - 产品 -
//首页产品 cnum是热销产品的个数，rnum是推荐产品的个数
- (void)httpHomeProductWithCnum:(NSString *)cnum withRnum:(NSString *)rnum withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult;
//获取产品详情
- (void)httpProductDetailInfoWithProductID:(NSString *)productId withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessDetailResult:(SuccessResult)successDetailResult withFailDetailResult:(FailResult)failDetailResult;
//获取产品的所有规格
//- (void)httpProductAllFarmatInfoWithProductID:(NSString *)productId  withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessFarmatResult:(SuccessResult)successFarmatResult withFailFarmatResult:(FailResult)failFarmatResult;

//产品分类树
- (void)httpProductClassTreeWithClassTreeSuccess:(SuccessResult)classTreeSuccess withClassTreeFali:(FailResult)classTreeFail;

//模糊查询产品信息
- (void)httpFuzzySearchProductInfoWithFuzzyModel:(FuzzySearchModel *)fuzzySearchModel withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail;


#pragma mark - 购物车 -
//将产品加入购物车
- (void)httpProductToShoppingCarWithFormatId:(NSString *)sidStr withProductCount:(NSString *)countStr withSuccessToShoppingCarResult:(SuccessResult)successToShoppingCarResult withFailToShoppingCarResult:(FailResult)failToShoppingCarResult ;

//判断是否全选
- (void)isAllSelectForShoppingCarAction ;
//判断是否有选择产品
- (BOOL)isSelectAnyOneProduct;
//所有选择的产品的总件数
- (NSInteger )isSelectProductCount;

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
- (void)getOrderListDataWithUserID:(NSString *)userID withProduct:(NSString *)product withCode:(NSString *)code withWhichTableView:(NSString *)whichTableView withPageIndex:(NSString *)pageIndex withPageSize:(NSString *)pageSize withUpPushReload:(BOOL)upPushReload withOrderListSuccessResult:(SuccessResult)orderListSuccessResult withOrderListFailResult:(FailResult)orderListFailResult ;

//生成订单
- (void)creatOrderWithUserID:(NSString *)userID withReceivedID:(NSString *)receivedID withTotalAmount:(NSString *)totalAmount withDiscount:(NSString *)discount withCouponId:(NSString *)couponId withArr:(NSMutableArray *)itemArr withOrderSuccessResult:(SuccessResult)orderSuccessResult withOrderFailResult:(FailResult)orderFailResult;

//取消父订单
- (void)cancelSupOrderWithUserID:(NSString *)userID wiOrderID:(NSString *)orderID withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult)cancelFailResult;

//取消子订单
- (void)cancelSonOrderWithUserId:(NSString *)userid withOrderID:(NSString *)orderID withCancelMessage:(NSString *)cancelMessage withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult )cancelFailResult;

//查询订单
- (void)searchOrderInfoWithOrderID:(NSString *)orderId ;

//物流信息
- (void)orderLogisticsWithOrderId:(NSString *)orderID withSuccessLogisticsBlock:(SuccessResult )successLogisticsBlock withFailLogisticsBlock:(FailResult)failLogisticsBlock;



#pragma mark - 支付 -
//支付前验证
- (void)paybeforeVerifyWithUserId:(NSString *)userID withTotalAmount:(NSString *)totalAmount withBalance:(NSString *)balance withPayAmount:(NSString *)payAmount withOrderIdArr:(NSArray *)orderIdArr withPayType:(NSString *)payType withVerifySuccessBlock:(SuccessResult )verifySuccessBlock withVerfityFailBlock:(FailResult)verfityFailBlock ;

//支付宝获取签名 dataStr是待签名的字符串
- (void)aliPaySignDataStr:(NSString *)dataStr withSignSuccessResult:(SuccessResult)signSuccessResult withSignFailResult:(FailResult)signFailResult;

//用户确认支付
- (void)userConfirmPayWithUserID:(NSString *)userID withRID:(NSString *)rid withPayCode:(NSString *)payCode withPayType:(NSString *)payType withTotalamount:(NSString *)totalAmount withBalance:(NSString *)balance withPayAmount:(NSString *)payAmount withBank:(NSString *)bank withItemArr:(NSArray *)itemArr withUserConfirmPaySuccess:(SuccessResult)paySuccess withPayFail:(FailResult)payFail ;

//支付后，去后台验证
- (void)afterPayOrderPaymentVerifyWithPayId:(NSString *)payId withPaymentVerifySuccess:(SuccessResult )paymentVerifySuccess withPaymentVerifyFail:(FailResult)paymentVerifyFail;

#pragma mark - 个人信息 之 余额 -
//个人中心我的钱包数据
- (void)httpMyWalletWithUserId:(NSString *)userId withMyWalletSuccess:(SuccessResult )walletSuccess withMyWalletFail:(FailResult)walletFail;

//获取个人信息的余额
- (void)searchUserAmount:(NSString *)userId withAmountSuccessBlock:(SuccessResult )amountSuccessBlock withAmountFailBlock:(FailResult)amountFailBlcok;
#pragma mark - 个人信息 之 收货地址 -
//获取收货地址列表
- (void)receiveAddressListWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId withAddressListSuccess:(SuccessResult)addressListSuccessBlock withAddressListFail:(FailResult)addressListFailBlock;
//获取已经选择的收货地址
- (ReceiveAddressModel *)selectedReceiveAddressModel;

//修改某个收货地址
- (void)motifyReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withMotifySuccess:(SuccessResult )motifySuccess withMotifyFail:(FailResult)motifyFail;
//添加收货地址
- (void)addReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withUserId:(NSString *)userid withAddReceiveAddressSuccess:(SuccessResult )addReceiveAddressSuccess withAddReceiveAddressFail:(FailResult)addReceiveAddressFail ;

//设置默认地址
- (void)defaultReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDefaultSuccess:(SuccessResult )defaultSuccess withDefaultFail:(FailResult)defaultFail;

//删除地址
- (void)deleteReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDeleteAddressSuccess:(SuccessResult)deleteAddressSuccess withDeleteAddressFail:(FailResult)deleteAddressFail;


#pragma mark - 评价 -
//订单评论
- (void)orderCommentWithUserid:(NSString *)userId withOrderId:(NSString *)orderId withStarLevel:(NSString *)starLevel withContent:(NSString *)content withCommentSuccessBlock:(SuccessResult)commentSuccessBock withCommentFailBlock:(FailResult)commentFailBlock;

//个人中心--我的评价
- (void)myCommentListWithUserId:(NSString *)userId withIsUpdate:(BOOL)isUpdate withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withMyCommentSuccessBlock:(SuccessResult )commentSuccessBlock withMyCommentFailBlock:(FailResult)commentFailBlock ;


#pragma mark - 收藏 -
//添加到收藏
- (void)httpAddFavoriteWithUserId:(NSString *)userId withFormatId:(NSString *)formatId withAddFavoriteSuccess:(SuccessResult )addFavoriteSuccess withAddFavoriteFail:(FailResult )addFavoriteFail;

//收藏列表
- (void)httpMyFavoriteListWithUserId:(NSString *)userId withMyFavoriteSuccess:(SuccessResult )favoriteSuccess withMyFavoriteFail:(FailResult )favoriteFail;

//删除收藏产品
- (void)httpDeleteFavoriteProductWithFavoriteArr:(NSMutableArray *)deleteFavoriteArr withDeleteFavoriteSuccess:(SuccessResult)favoriteSuccess withDeleteFavoriteFail:(FailResult)favoriteFail;

//流水账查询  id=&iscash=&sdt=&edt=&pageindex=1&pagesize=10
- (void)httpSearchUserAccountListWithUserId:(NSString *)userId withIsCash:(NSString *)iscash withSdt:(NSString *)sdt withEdt:(NSString *)edt withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger)pageSize withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail;

#pragma mark - 修改个人资料 -
- (void)httpMotifyMemberInfoWithUserID:(NSString *)userID withUsername:(NSString *)userName withEmail:(NSString *)email withMobile:(NSString *)mobile withQQ:(NSString *)qq withAreaId:(NSString *)areaId WithMotifyMemberSuccess:(SuccessResult )motifySuccess withMotifyMemberFail:(FailResult)motifyFail;
//修改密码
- (void)httpMotifyPasswordWithUserId:(NSString *)userId withPassword:(NSString *)password withMotifyPasswordSuccess:(SuccessResult )motifyPasswordSuccess withMotifyPasswordFail:(FailResult )motifyPasswordFail;
#pragma mark - 我的代理 -
//我的代理基本数据
- (void)httpMyAgentBaseDataWithUserId:(NSString *)userId withMyAgentSuccess:(SuccessResult )myAgentSuccess withMyagentFail:(FailResult )myAgentFail;
//我的代理 人员数据
- (void)httpMyAgentPeopleListDataWithUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail ;
//我的代理 订单数据
- (void)httpMyAgentOrderListDataWithUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail ;


#pragma mark - 登录注册 -
//密码登录
- (void)loginActionWithUserID:(NSString *)userID withPassword:(NSString *)password withLoginSuccessResult:(SuccessResult )loginSuccessResult withLoginFailResult:(FailResult)loginFailResult;
//验证码登录
- (void)loginActionWithMobile:(NSString *)mobile withMobileCode:(NSString *)mobileCode withLoginSuccessResult:(SuccessResult)loginSuccessResult withLoginFailResult:(FailResult)loginFailResult;

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

//获取地区信息
- (void)httpAreaTreeWithSuccessAreaInfo:(SuccessResult )successAreaInfo withFailAreaInfo:(FailResult)failAreaInfo ;
//从字符串中得到年月日等信息
- (NSDateComponents *)dateStrToDateAndComponentWithDatestr:(NSString *)dateStr;
@end

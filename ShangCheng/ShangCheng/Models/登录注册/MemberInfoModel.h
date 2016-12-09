//
//  MemberInfoModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject<NSCoding>

@property (nonatomic,strong)NSString *u_id;//用户id
@property (nonatomic,strong)NSString *u_login_id;//登录账号
@property (nonatomic,strong)NSString *userPassword;//登录密码，接口没有，自己需要赋值
@property (nonatomic,strong)NSString *u_r_id;//角色id
@property (nonatomic,strong)NSString *u_type;//用户类型
@property (nonatomic,strong)NSString *u_typename;//用户类型
@property (nonatomic,strong)NSString *u_truename;//真名

@property (nonatomic,strong)NSString *capitalcode;//省的编号
@property (nonatomic,strong)NSString *capitalname;//省名
@property (nonatomic,strong)NSString *citycode;//城市编号
@property (nonatomic,strong)NSString *cityname;//城市名
@property (nonatomic,strong)NSString *countycode;//县城标号
@property (nonatomic,strong)NSString *countyname;//县城名字

@property (nonatomic,strong)NSString *u_status;//用户状态
@property (nonatomic,strong)NSString *u_statusname;//用户状态名


@property (nonatomic,strong)NSString *u_email;//邮箱
@property (nonatomic,strong)NSString *u_qq;//qq
@property (nonatomic,strong)NSString *u_mobile;//手机号

@property (nonatomic,strong)NSString *u_amount;//金额
@property (nonatomic,strong)NSString *u_payword;//支付密码
@property (nonatomic,strong)NSString *u_amount_avail;//可用余额
@property (nonatomic,strong)NSString *u_amount_frozen;//冻结余额
@property (nonatomic,strong)NSString *token;//token
//@property (nonatomic,strong)NSString *rversion;



- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;
@end

//
//  MyAgentOrderModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentOrderModel : NSObject
@property (nonatomic,strong)NSString *p_id;
@property (nonatomic,strong)NSString *p_code;
@property (nonatomic,strong)NSString *p_time_create;
@property (nonatomic,strong)NSString *p_buyer_user_id;
@property (nonatomic,strong)NSString *u_truename;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *u_area_id;
@property (nonatomic,strong)NSString *p_money_agent;
@property (nonatomic,strong)NSString *p_o_price_total;
@property (nonatomic,strong)NSString *p_count;
@property (nonatomic,strong)NSString *p_num;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSArray *item;
@property (nonatomic,strong)NSString *rn;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

//
//  ProductDetailModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"
@interface ProductDetailModel : NSObject
//产品基本信息
@property (nonatomic,strong)ProductModel *productModel;
//产品分类
@property (nonatomic,strong)NSString *p_typevalue1;
//产品编码
@property (nonatomic,strong)NSString *p_pid;
//有效成分
@property (nonatomic,strong)NSString *p_ingredient;
//起订数量
@property (nonatomic,strong)NSString *p_standard_qty;
//PD证
@property (nonatomic,strong)NSString *p_registration;
//产品标准证
@property (nonatomic,strong)NSString *p_certificate;
//生产许可证
@property (nonatomic,strong)NSString *p_license;
//时间
@property (nonatomic,strong)NSString *p_time_create;
//防治对象
@property (nonatomic,strong)NSString *p_treatment;
//产品状态码
@property (nonatomic,strong)NSString *p_status;
//产品状态说明
@property (nonatomic,strong)NSString *statusvalue;

//产品所有的规格数组
@property (nonatomic,strong)NSMutableArray *productFarmatArr;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;






@end

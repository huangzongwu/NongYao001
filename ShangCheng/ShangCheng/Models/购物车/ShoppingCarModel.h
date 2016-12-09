//
//  ShoppingCarModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/21.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"
@interface ShoppingCarModel : NSObject
//购物车商品id,主键
@property (nonatomic,strong)NSString *c_id;

//商品模型
@property (nonatomic,strong)ProductModel *shoppingCarProduct;
//商品的数量
@property (nonatomic,assign)NSString *c_number;
//商品状态（01正常 02下架）
@property (nonatomic,strong)NSString *c_type;
//总价，即单价*数量
@property (nonatomic,strong)NSString *totalprice;
//商品是否被选中
@property (nonatomic,assign)BOOL isSelectedShoppingCar;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;

@end

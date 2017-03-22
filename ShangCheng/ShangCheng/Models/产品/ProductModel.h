//
//  ProductModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject<NSCoding>
//农药id
@property (nonatomic,strong)NSString *productID;
//农药的图片链接
@property (nonatomic,strong)NSString *productImageUrlstr;
//农药的名字
@property (nonatomic,strong)NSString *productTitle;
//农药的生产公司
@property (nonatomic,strong)NSString *productCompany;
//农药的规格id
@property (nonatomic,strong)NSString *productFormatID;
//农药的规格
@property (nonatomic,strong)NSString *productFormatStr;
//农药的价格
@property (nonatomic,strong)NSString *productPrice;
//是否是活动产品
@property (nonatomic,assign)BOOL isSaleProduct;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;

@end

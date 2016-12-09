//
//  ProductModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    //首页
    if ([key isEqualToString:@"p_id"]) {
        self.productID = value;
    }
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrlstr = value;
    }
    if ([key isEqualToString:@"p_name"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"f_name"]) {
        self.productCompany = value;
    }
    if ([key isEqualToString:@"p_standard"]) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"p_price"]) {
        self.productPrice = value;
    }

    //---------------------------------------------------
    //产品详情
    if ([key isEqualToString:@"p_id"]) {
        self.productID = value;
    }
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrlstr = value;
    }
    if ([key isEqualToString:@"p_title"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"suppliername"]) {
        self.productCompany = value;
    }
    if ([key isEqualToString:@"p_s_id"]) {
        self.productFormatID = value;
    }
    if ([key isEqualToString:@"p_standard"]) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"p_price"]) {
        self.productPrice = value;
    }

    
    
    //-----------------------------------------------
    //购物车
    if ([key isEqualToString:@"c_p_id"]) {
        self.productID = value;
    }
    if ([key isEqualToString:@"c_title"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"c_manufacturer"]) {
        self.productCompany = value;
    }
    if ([key isEqualToString:@"c_s_id"]) {
        self.productFormatID = value;
    }
    if ([key isEqualToString:@"p_st"]) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"unitprice"]) {
        self.productPrice = value;
    }
    
}

@end

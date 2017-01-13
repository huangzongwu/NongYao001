//
//  FuzzySearchModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "FuzzySearchModel.h"

@implementation FuzzySearchModel
//自定义初始化方法
- (id)initWithCode:(NSString *)code
              name:(NSString *)name
            areaid:(NSString *)areaid
                pd:(NSString *)pd
      suppliername:(NSString *)suppliername
             level:(NSString *)level
            status:(NSString *)status
             price:(NSString *)price
              date:(NSString *)date {
    
    self = [super init];
    if (self) {
        self.code = code;
        self.name = name;
        self.areaid = areaid;
        self.pd = pd;
        self.suppliername = suppliername;
        self.level = level;
        self.status = status;
        self.price = price;
        self.date = date;
    }
    return self;
}

//便利构造器
+ (id)itemWithCode:(NSString *)code
              name:(NSString *)name
            areaid:(NSString *)areaid
                pd:(NSString *)pd
      suppliername:(NSString *)suppliername
             level:(NSString *)level
            status:(NSString *)status
             price:(NSString *)price
              date:(NSString *)date {
    return [[FuzzySearchModel alloc] initWithCode:code name:name areaid:areaid pd:pd suppliername:suppliername level:level status:status price:price date:date];
}

@end

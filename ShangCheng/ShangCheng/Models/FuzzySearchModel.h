//
//  FuzzySearchModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuzzySearchModel : NSObject
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *areaid;
@property (nonatomic,strong)NSString *pd;
@property (nonatomic,strong)NSString *suppliername;
@property (nonatomic,strong)NSString *level;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *date;

//自定义初始化方法
- (id)initWithCode:(NSString *)code
              name:(NSString *)name
            areaid:(NSString *)areaid
                pd:(NSString *)pd
      suppliername:(NSString *)suppliername
             level:(NSString *)level
            status:(NSString *)status
             price:(NSString *)price
              date:(NSString *)date;

//便利构造器
+ (id)itemWithCode:(NSString *)code
              name:(NSString *)name
            areaid:(NSString *)areaid
                pd:(NSString *)pd
      suppliername:(NSString *)suppliername
             level:(NSString *)level
            status:(NSString *)status
             price:(NSString *)price
              date:(NSString *)date;
@end

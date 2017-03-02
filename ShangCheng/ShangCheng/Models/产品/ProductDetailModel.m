//
//  ProductDetailModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailModel.h"
#import "ProductFormatModel.h"
@implementation ProductDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"item"]) {
        self.productFarmatArr = [NSMutableArray array];
        for (NSDictionary *itemDic in value) {
            ProductFormatModel *formatModel = [[ProductFormatModel alloc] init];
            [formatModel setValuesForKeysWithDictionary:itemDic];
            formatModel.seletctCount = [formatModel.s_min_quantity integerValue];
            [self.productFarmatArr addObject:formatModel];
        }
    }
}

@end

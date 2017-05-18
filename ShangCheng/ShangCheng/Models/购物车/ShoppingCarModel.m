//
//  ShoppingCarModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/21.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"c_activity_id"]) {
        if ([value isEqualToString:@"0"]) {
            self.isActivity = NO;
        }else {
            self.isActivity = YES;
        }
    }
}

@end

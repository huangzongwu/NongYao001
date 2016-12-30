//
//  ReceiveAddressModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveAddressModel : NSObject<NSMutableCopying>
@property (nonatomic,strong)NSString *receiverID;
@property (nonatomic,strong)NSString *receiverName;
@property (nonatomic,strong)NSString *receiveMobile;
@property (nonatomic,strong)NSString *receiveTel;
@property (nonatomic,strong)NSString *areaID;
@property (nonatomic,strong)NSString *capitalname;
@property (nonatomic,strong)NSString *cityname;
@property (nonatomic,strong)NSString *countyname;
@property (nonatomic,strong)NSString *receiveAddress;

@property (nonatomic,assign)BOOL defaultAddress;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end

//
//  OrderDetailFootOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailFootOneTableViewCell.h"

@implementation OrderDetailFootOneTableViewCell
- (void)updateOrderDetailFootOneCell:(SonOrderModel *)tempSonOrderModel {
    //总价
    self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"￥%@",tempSonOrderModel.o_price_total];
    
    //状态为0、1A、1B的没有按钮
    if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1A"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
        self.buttonOne.hidden = YES;
        self.buttonOne.hidden = YES;
        self.buttonOne.hidden = YES;
    }else if ([tempSonOrderModel.o_status isEqualToString:@"9"]) {
        //已完成9 有两个按钮
        self.buttonOne.hidden = NO;
        self.buttonTwo.hidden = NO;
        self.buttonThree.hidden = YES;
    }else if ()
    
    
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

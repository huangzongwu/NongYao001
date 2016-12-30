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
    /*待收货和已完成 有两个按钮
     待收货，1物流2确认收货
     已完成，1立即评价2详情
     */
    if ([tempSonOrderModel.o_status isEqualToString:@"5A"] || [tempSonOrderModel.o_status isEqualToString:@"5"] || [tempSonOrderModel.o_status isEqualToString:@"9"]) {
        self.buttonOne.hidden = NO;
        self.buttonTwo.hidden = NO;
        
        //已完成
        if ([tempSonOrderModel.o_status isEqualToString:@"9"]) {
            [self.buttonOne setTitle:@"立即评价" forState:UIControlStateNormal];
            [self.buttonTwo setTitle:@"订单详情" forState:UIControlStateNormal];
        }else {
            //待收货
            [self.buttonOne setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.buttonTwo setTitle:@"物流信息" forState:UIControlStateNormal];

        }
    }else {
        
        //待支付、待确认、待发货 都是一个按钮
        self.buttonOne.hidden = NO;
        self.buttonTwo.hidden = YES;

        //待支付，待确认：  取消订单
        if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1A"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
            [self.buttonOne setTitle:@"取消订单" forState:UIControlStateNormal];
        }else {
            [self.buttonOne setTitle:@"订单详情" forState:UIControlStateNormal];
        }

        
    }    
    
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

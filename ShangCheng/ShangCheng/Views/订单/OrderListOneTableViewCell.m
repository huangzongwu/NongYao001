//
//  OrderListOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListOneTableViewCell.h"

@implementation OrderListOneTableViewCell
- (void)updateOrderLIstOneCellWithModel:(SupOrderModel *)model {
    
    self.orderNumberLabel.text = model.p_code;
    //待付款
    if ([model.p_status isEqualToString:@"0"] || [model.p_status isEqualToString:@"1B"] ) {
        self.orderStateLabel.text = @"待付款";
    }
    //待确认（属于待付款）
    if ([model.p_status isEqualToString:@"1A"]) {
        self.orderStateLabel.text = @"待确认";
    }
    //进行中
    if ([model.p_status isEqualToString:@"1"] ) {
        self.orderStateLabel.text = @"进行中";
    }
    //已完成
    if ([model.p_status isEqualToString:@"9"]) {
        self.orderStateLabel.text = @"已完成";
    }
    
    self.productCountLabel.text = [NSString stringWithFormat:@"共%ld件商品", model.subOrderArr.count];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.p_o_price_total];
    
    
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

//
//  OrderDetailOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailOneTableViewCell.h"

@implementation OrderDetailOneTableViewCell

- (void)updateOrderDetailOneCellWithSonOrder:(SonOrderModel *)tempSonOrderModel {
    
    self.orderNumberLabel.text = tempSonOrderModel.o_code;
    //待付款和待确认状态这个地方显示总价，其余都是状态
    if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1A"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
        self.statusAndTotalPriceLabel.text = [NSString stringWithFormat:@"￥%@",tempSonOrderModel.o_price_total ];
    }else {
        self.statusAndTotalPriceLabel.text = tempSonOrderModel.statusvalue;
    }
    
//    self.orderImageView;
    self.orderTitleLabel.text = tempSonOrderModel.p_name;
    self.orderCompanyLabel.text = @"";
    self.orderFormatAndCountLabel.text = [NSString stringWithFormat:@"规格:%@  数量:%@",tempSonOrderModel.productst,tempSonOrderModel.o_num];
    self.orderUnitPriceLabel.text = tempSonOrderModel.o_price;
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

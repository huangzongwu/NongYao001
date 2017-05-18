//
//  OrderListFootOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListFootOneTableViewCell.h"

@implementation OrderListFootOneTableViewCell
//去支付
- (IBAction)orderPayAction:(IndexButton *)sender {
    
    NSLog(@"%ld",sender.indexForButton.section);
    
    self.footOneButtonBlock(sender.indexForButton, @"orderPay");
}



//取消订单
- (IBAction)cancelOrderAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    
    self.footOneButtonBlock(sender.indexForButton, @"cancelOrder");}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

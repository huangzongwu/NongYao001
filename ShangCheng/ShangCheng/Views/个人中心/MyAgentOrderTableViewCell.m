//
//  MyAgentOrderTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentOrderTableViewCell.h"

@implementation MyAgentOrderTableViewCell
- (void)updateMyAgentOrderCellWithAgentModel:(MyAgentOrderModel *)tempModel {
    

    self.orderNameLabel.text = tempModel.u_truename;
    NSString *currentPhoneStr = [tempModel.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.orderPhoneLabel.text = currentPhoneStr;
    self.orderAddressLabel.text = @"未知";
    self.orderAgentMoneyLabel.text = tempModel.p_money_agent;
    
    self.orderOneImageView.hidden = YES;
    self.orderTwoImageView.hidden = YES;
    self.orderThreeImageView.hidden = YES;
    self.orderFourImageView.hidden = YES;
    self.orderFiveImageView.hidden = YES;
    switch ([tempModel.p_count integerValue]) {
        case 1:
        {
            self.orderOneImageView.hidden = NO;
            
        }
            break;
        case 2:
        {
            self.orderOneImageView.hidden = NO;
            self.orderTwoImageView.hidden = NO;
        }
            break;
        case 3:
        {
            self.orderOneImageView.hidden = NO;
            self.orderTwoImageView.hidden = NO;
            self.orderThreeImageView.hidden = NO;
        }
            break;
        case 4:
        {
            self.orderOneImageView.hidden = NO;
            self.orderTwoImageView.hidden = NO;
            self.orderThreeImageView.hidden = NO;
            self.orderFourImageView.hidden = NO;
        }
            break;
        case 5:
        {
            self.orderOneImageView.hidden = NO;
            self.orderTwoImageView.hidden = NO;
            self.orderThreeImageView.hidden = NO;
            self.orderFourImageView.hidden = NO;
            self.orderFiveImageView.hidden = NO;
        }
            break;
     
        default:
            break;
    }
    
    
    self.orderTimeLabel.text = tempModel.p_time_create;
    self.orderTotalMoneyLabel.text = [NSString stringWithFormat:@"共%@件商品,总金额:￥%@",tempModel.p_num,tempModel.p_o_price_total];
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

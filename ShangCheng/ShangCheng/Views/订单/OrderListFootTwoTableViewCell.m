//
//  OrderListFootTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListFootTwoTableViewCell.h"

@implementation OrderListFootTwoTableViewCell
- (IBAction)orderDetailInfo:(IndexButton *)sender {
    
    self.footTwoButtonBlock(sender.indexForButton);
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
